//
//  ProfileViewController.swift
//  Grouper
//
//  Created by Olivia Corrodi on 12/2/17.
//  Copyright © 2017 Olivia Corrodi. All rights reserved.
//

import UIKit
import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseAuthUI


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var mathRating: UITextField!

    @IBOutlet weak var englishRating: UITextField!
    
    @IBOutlet weak var creativityRating: UITextField!
    
    @IBOutlet weak var scienceRating: UITextField!
    
    @IBOutlet weak var organizationRating: UITextField!
    let user = Auth.auth().currentUser
    var email = ""
    var member2 = Member(year: 9, ability: [0,0,0,0,0], name: "")
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        let name = user?.displayName
        member2 = Member(year: 9, ability: [Float(mathRating.text!)!, Float(englishRating.text!)!, Float(scienceRating.text!)!, Float(creativityRating.text!)!,Float(organizationRating.text!)!], name: name!)
        performSegue(withIdentifier: "done", sender: self)
    }

        override func viewDidLoad() {
            super.viewDidLoad()
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
            view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ClassesTableViewController
        destinationVC.member = member2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
