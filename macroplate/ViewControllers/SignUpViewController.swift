//
//  SignUpViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 6/6/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
        print("elements are set up")
        //validateFields()
    }
    
    func setUpElements() {
        
        //Hide error label
        errorLabel.alpha = 0
        
        //style elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }

    //Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns an error message as a string.
    func validateFields() -> String? {
        
        //check that all fields are filled in
        if  firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            print("Good job")
            return "Please fill in all fields."
        }
        
        //Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        print("cleaned password")
        //returns true if password is good based on utilities function
        if Utilities.isPasswordValid(cleanedPassword) == false {
            //Password isn't secure enough
            return "Password needs: 8 characters, a special character, and a number."
            
        }
        
        return nil
    }
 
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        //Validate the fields
        let error = validateFields()
        
        if error != nil {
            // there's something wrong with the fields, show error message
            showError(error!)
            print("error - invalidated field")
        }
        else {
            //Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Create the User
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //check for errors
                if err != nil {
                    //there was an error
                    self.showError(err?.localizedDescription ?? "error creating user")
                    print("error creating USER")
                }
                else {
                    //user was created successfully, store in database
                    
                    //initialize an instance of Cloud Firestore:
                    let db = Firestore.firestore()
                    
                    let newUser = db.collection("users").document()
                    
                    newUser.setData([
                            "firstname":firstName,
                            "lastname":lastName,
                            "email":email,
                            "uid": result!.user.uid,
                            "did": newUser.documentID
                            ]) { (error) in
                        
                        if error != nil {
                            //Show error message
                            self.showError("error saving user data")
                            //print("error saving user data")
                        }
                    }

                    
                    /*               db.collection("users").addDocument(data: [
                                 "firstname":firstName,
                                 "lastname":lastName,
                                 "email":email,
                                 "uid": result!.user.uid
                                 "did":
                                 ]) { (error) in
                             
                             if error != nil {
                                 //Show error message
                                 self.showError("error saving user data")
                                 print("error saving user data")
                             }
                         }*/
                }
            }
            //Transition to home screen
            self.transitionToHome()
        }
    }

    func showError(_ message:String) {
    
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    func transitionToHome() {
        
        //explained at 1:11:00 on https://www.youtube.com/watch?v=1HN7usMROt8&t=94s
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        //swap out root view controller for the home one, once the signup is successful
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}

