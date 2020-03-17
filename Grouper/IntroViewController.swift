//
//  IntroViewController.swift
//  Grouper
//
//  Created by Olivia Corrodi on 12/2/17.
//  Copyright © 2017 Olivia Corrodi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

class IntroViewController: UIViewController {
    
    var defaults: UserDefaults = UserDefaults.standard
    var isUserLoggedIn = false
    
    
    @IBOutlet weak var studentLoginButton: UIButton!

    @IBAction func loginButtonPressed(_ sender: Any) {
        print("next button tappeed")
        defaults.set(true, forKey: "isStudent")
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        authUI.delegate = self
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    
    @IBOutlet weak var teacherLoginButton: UIButton!
    
    @IBAction func loginTeacherButtonPressed(_ sender: Any) {
        print("next button tappeed")
        defaults.set(false, forKey: "isStudent")
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        authUI.delegate = self
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }

    
    
    override func viewDidLoad() {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        self.navigationController?.navigationBar.tintColor = UIColor .black
        self.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        //        self.navigationController?.navigationBar.isHidden = true
        
        
        if defaults.value(forKey: "loggedIn") == nil {
            defaults.set(isUserLoggedIn, forKey: "loggedIn")
        }
        else {
            isUserLoggedIn = defaults.value(forKey: "loggedIn")! as! Bool
            print(isUserLoggedIn)
        }
        
        if isUserLoggedIn {
            navigationController?.navigationBar.isHidden = false
            
            //weak holds a weak reference, UI must be done in main thread
            DispatchQueue.main.async { [weak self] in
                self?.performSegue(withIdentifier: "toMain", sender: nil)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMain" {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension IntroViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        
        if let error = error {
            print("Error signing in: \(error.localizedDescription)")
            return
        }
        
        guard let user = user else { return }
        
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let existingUser = User(snapshot: snapshot) {
                //existing user
                print("\(#function): user exists already.")
                
            } else {
                //new user
                userRef.updateChildValues(["uid" : user.uid, "email" : user.email])
            }
        })
        
        defaults.set(true, forKey: "loggedIn")
        performSegue(withIdentifier: "toMain", sender: nil)
    }
}

