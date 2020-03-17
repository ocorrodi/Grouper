//
//  ClassesTableViewController.swift
//  Grouper
//
//  Created by Olivia Corrodi on 12/2/17.
//  Copyright © 2017 Olivia Corrodi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseAuthUI

class ClassesTableViewController: UITableViewController {
    var defaults: UserDefaults = UserDefaults.standard
    var user = Auth.auth().currentUser
    var classes: [Class] = []
    var classes2: [Class] = []
    var member = Member(year: 9,ability: [0,0,0,0,0], name:"")
    var index: Int = 0

    override func viewWillAppear(_ animated: Bool) {
        self.getClasses(completion: { (classes) in
            self.classes = classes
            
            self.tableView.reloadData()
        })
        self.tableView.reloadData()
    }
    @IBAction func addButtonPressed(_ sender: Any) {
        if (defaults.value(forKey: "isStudent") as! Bool == false) {
            let alertController = UIAlertController(title: "Add Class", message: "please enter the name and code for this class", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "done", style: .default, handler: {
                alert -> Void in
                let newClassTextField = alertController.textFields![0] as UITextField
                let classCodeTextField = alertController.textFields![1] as UITextField
                if let className = newClassTextField.text, let classCode = classCodeTextField.text {
                    let ref = Database.database().reference().child("users").child(self.user!.uid).child("classes").childByAutoId()
                    let autoID = ref.key
                    let dummyMember = Member(year: 9, ability: [0,0,0,0,0], name: "dummy")
                    let ref2 = Database.database().reference().child("classes").child(autoID)
                    ref.updateChildValues(["name" : className, "code" : classCode, "members" : [dummyMember.name : ["year" : dummyMember.year, "math" : dummyMember.ability[0], "english" : dummyMember.ability[1], "science" : dummyMember.ability[2], "creativity" : dummyMember.ability[3], "organization" : dummyMember.ability[4]]]])
                    ref2.updateChildValues(["name" : className, "code" : classCode, "members" : [dummyMember.name : ["year" : dummyMember.year, "math" : dummyMember.ability[0], "english" : dummyMember.ability[1], "science" : dummyMember.ability[2], "creativity" : dummyMember.ability[3], "organization" : dummyMember.ability[4]]]])
                    self.getClasses(completion: { (classes) in
                        self.classes = classes
                        
                        self.tableView.reloadData()
                    })

                }
                self.getClasses(completion: { (classes) in
                    self.classes = classes
                    
                    self.tableView.reloadData()
                })

            })
            let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: {
                alert -> Void in
                alertController.dismiss(animated: true, completion: nil)
            })
                
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            alertController.addTextField { (textField: UITextField) -> Void in
                }
            alertController.addTextField { (textField: UITextField) -> Void in
                }
                self.present(alertController, animated: true, completion: nil)

        }
        else {
            let alertController2 = UIAlertController(title: "Join class", message: "Please enter the class code", preferredStyle: .alert)
            
            let doneAction = UIAlertAction(title: "Done", style: .default, handler: { alert -> Void in
                let enterCodeTextField = alertController2.textFields![0] as UITextField
                if let classCodeEntered = enterCodeTextField.text {
                    self.getClasses2(completion: { (classes) in
                        self.classes2 = classes
                    })
                    for class2 in self.classes2 {
                        if class2.code == classCodeEntered {
                            let ref3 = Database.database().reference().child("users").child(self.user!.uid).child("classes").childByAutoId()
                            ref3.updateChildValues(["name" : class2.name, "code" : class2.name])
                            let ref4 = ref3.child("members")
                            for member in class2.members {
                                ref4.updateChildValues([(self.user?.displayName)! : ["year" : member.year, "math" : member.ability[0], "english" : member.ability[1], "science" : member.ability[2], "creativity" : member.ability[3], "organization" : member.ability[4]]])
                                self.getClasses(completion: { (classes) in
                                    self.classes = classes
                                    
                                    self.tableView.reloadData()
                                })

                            }

                        }
                    }
                }
            })

            let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: {
                alert -> Void in
                    alertController2.dismiss(animated: true, completion: nil)
            })
            alertController2.addAction(doneAction)
            alertController2.addAction(cancelAction)
            alertController2.addTextField { (textField: UITextField) -> Void in
                self.present(alertController2, animated: true, completion: nil)
            }
        }
    }
 
    func getClasses(completion: @escaping ([Class]) -> Void) {
        let ref = Database.database().reference().child("users").child(user!.uid).child("classes")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let valueDictionary = snapshot.value as? NSDictionary as? [String : Any] {
                var classesToPass = [Class] ()
                for (key,value) in valueDictionary {
                    var dictionary = value as! [String : Any]
                    let code = dictionary["code"] as? String
                    let uid = key
                    var members2: [Member] = []
                    let members = dictionary["members"] as! [String : [String : Any]]
                    for (key, value) in members {
                        let member3 = Member(year: value["year"] as! Int, ability: [value["math"] as! Float,value["English"] as! Float, value["science"] as! Float, value["creativity"] as! Float, 0], name: key)
                        members2.append(member3)
                    }
                    let name = dictionary["name"]
                    let class1 = Class(code: code!, members: members2, id: uid, name: name as! String)
                    classesToPass.append(class1)
                }
                return completion(classesToPass)
            }
            
        })
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //classTapped = classes[indexPath.row]
        performSegue(withIdentifier: "toAssignments", sender: self)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAssignments" {
            let destinationVC = segue.destination as! AssignmentsTableViewController
            destinationVC.classSelected = classes
            destinationVC.index = index
        }
        else {
            let destinationVC = segue.destination as!  ProfileViewController
            destinationVC.member2 = member
        }
    }
    func getClasses2(completion: @escaping ([Class]) -> Void) {
        let ref = Database.database().reference().child("classes")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let valueDictionary = snapshot.value as? NSDictionary as? [String : Any] {
                var classesToPass = [Class] ()
                for (key,value) in valueDictionary {
                    var dictionary = value as! [String : Any]
                    let code = dictionary["code"] as? String
                    let uid = key
                    var members2: [Member] = []
                    let members = dictionary["members"] as! [String : [String : Any]]
                    for (key, value) in members {
                        let member3 = Member(year: value["year"] as! Int,ability: [value["math"] as! Float, value["english"] as! Float, value["science"] as! Float, value["creativity"] as! Float, value["organization"] as! Float], name: key)
                        members2.append(member3)
                    }
                    let name = dictionary["name"]
                    let class1 = Class(code: code!, members: members2, id: uid, name: name as! String)
                    classesToPass.append(class1)
                }
                return completion(classesToPass)
            }
            
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getClasses(completion: { (classes) in
            self.classes = classes
            self.tableView.reloadData()
        })
        self.tableView.reloadData()


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        self.getClasses(completion: { (classes) in
            self.classes = classes
        })
        return classes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath) as! UITableViewCell
        let index = indexPath.row
        let individualClass = classes[index]
        cell.textLabel?.text = individualClass.name
        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
