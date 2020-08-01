//
//  LoginViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 6/6/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //TODO Set up Firebase
        /*self.storage = Storage.storage()
        self.auth = Auth.auth()
        self.database = Firestore.firestore()*/
        
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        
        
        //hide error label
        errorLabel.alpha = 0
        resetPasswordButton.alpha = 0
        
        //style elements
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleFilledButton(loginButton)
        
    }

    func validateFields() -> String? {
        
        //check that all fields are filled in
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        //Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //returns true if password is good based on utilities function
        if Utilities.isPasswordValid(cleanedPassword) == false {
            //Password isn't secure enough
            return "Password needs: 8 characters, a special character, and a number."
            
        }
        
        return nil
    }

    
    @IBAction func loginButton(_ sender: Any) {
        //TODO: Validate Text Fields
        let error = validateFields()
        
        if error != nil {
            // there's something wrong with the fields, show error message
            showError(error!)
            print("error - invalidated field")
        }
        else {
            //Create cleaned versions of the data
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Signing in the User
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    //Couldn't sign in
                    self.errorLabel.text = error!.localizedDescription
                    self.showError(self.errorLabel.text!)
                   // self.errorLabel.alpha = 1
                    
                }
                else {
                    //User has signed in successfully
                    self.transitionToHome()
                    
                }
            
            }
        }
    }
        
     
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        resetPasswordButton.alpha = 1
            
    }
    
    func transitionToHome() {
        
        //explained at 1:11:00 on https://www.youtube.com/watch?v=1HN7usMROt8&t=94s
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        //swap out root view controller for the home one, once the signup is successful
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }

}
