//
//  LoginViewController.swift
//  ParsyChat
//
//  Created by Ritik Raina on 11/13/19.
//  Copyright © 2019 rraina. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        if (usernameField.text?.isEmpty)! || (passwordField.text?.isEmpty)! {
            // Alert controller for missing username/password fields
            let alertController = UIAlertController(title:"Missing Fields Required", message: "Please enter a username and password.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
            alertController.addAction(OKAction)
            present(alertController, animated: true)
        }
        else {
            // initialize a user object
            let newUser = PFUser()
            
            // set user properties
            newUser.username = usernameField.text
            newUser.password = passwordField.text
            
            // call sign up function on the object
            newUser.signUpInBackground { (success: Bool, error: Error?) in
                if let error = error {
                    // Alert controller for error encountered
                    let alertController = UIAlertController(title:"Error Encountered", message: error.localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true)
                }
                else {
                    print("User Registered successfully")
                    // manually segue to logged in view
                }
            }
        }
        
    }
    
    @IBAction func login(_ sender: Any) {

        if (usernameField.text?.isEmpty)! || (passwordField.text?.isEmpty)! {
            // Alert controller for missing username/password fields
            let alertController = UIAlertController(title:"Missing Fields Required", message: "Please enter a username and password.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
            alertController.addAction(OKAction)
            present(alertController, animated: true)
        }
        else {
            let username = usernameField.text ?? ""
            let password = passwordField.text ?? ""
            PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
                if let error = error {
                    // Alert controller for error encountered
                    let alertController = UIAlertController(title:"Error Encountered", message: error.localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true)
                 }
                else {
                    print("User logged in successfully")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    // display view controller that needs to shown after successful login
                }
              }
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
