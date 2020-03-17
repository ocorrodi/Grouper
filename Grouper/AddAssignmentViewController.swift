//
//  AddAssignmentViewController.swift
//  Grouper
//
//  Created by Olivia Corrodi on 12/2/17.
//  Copyright © 2017 Olivia Corrodi. All rights reserved.
//

import UIKit

class AddAssignmentViewController: UIViewController {
    
    var students: [Member] = []
    var numGroups = 0
    @IBOutlet weak var assignmentName: UITextField!
    var param = [false,false,false,false,false]
    @IBAction func segmentedControlChange(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                param[0] = true
            case 1:
                param[1] = true
            case 2:
                param[2] = true
            case 3:
                param[3] = true
            case 4:
                param[4] = true
            default:
                param[0] = true
            
            
        }
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    @IBAction func makeGroups(_ sender: Any) {
        performSegue(withIdentifier: "makeGroups", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! GroupsTableViewController
        destinationVC.studentsPerGroup = Int(numPeoplePerGroup.text!)!
        destinationVC.param = param
        destinationVC.name = assignmentName.text!
        
    }
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var numPeoplePerGroup: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of var resources that cavare recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
