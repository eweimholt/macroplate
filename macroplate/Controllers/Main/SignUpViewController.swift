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
import FirebaseFirestore

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!

    
    let backButton : UIButton = {
        let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        cButton.setTitle("Back", for: .normal)
        cButton.setTitleColor(.white, for: .normal) // You can change the TitleColor
        cButton.translatesAutoresizingMaskIntoConstraints = false
        return cButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        //backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        //view.addSubview(backButton)
        
        //setup background gradient
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background_gradient.png")?.draw(in: self.view.bounds)

        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }else{
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
         }
        
        // Do any additional setup after loading the view.

        setUpElements()
    }
    
    @IBAction func goBack(_ sender: Any) {
        transitionToRoot()
    }
    
    func transitionToRoot() {
        let viewController = storyboard?.instantiateViewController(identifier: "rootVC" ) as? ViewController
        
        //swap out root view controller for the home one
        view.window?.rootViewController = viewController
        //view.window?.makeKeyAndVisible()
        view.window?.isHidden = false
        
    }
    
    func setUpElements() {
        
       /* backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 60).isActive = true*/
        
        //Hide error label
        errorLabel.alpha = 0
        
        //style elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
  
        Utilities.styleSetupButton(signUpButton)
    }
    
    //Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns an error message as a string.
    func validateFields() -> String? {
        
        //check that all fields are filled in
        if  firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  ||
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
            let dateJoined = Date()
            
            //Create the User
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //check for errors
                if err != nil {
                    //there was an error
                    self.showError(err?.localizedDescription ?? "error creating user")
                    print("error creating USER")
                    print("\(String(describing: err?.localizedDescription))")
                }
                else {
                    //user was created successfully, store in database
                    
                    //update user namefield 37:00 at https://www.youtube.com/watch?v=AsSZulMc7sk
                    let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                    changeRequest.displayName = self.firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    changeRequest.commitChanges(completion: nil)
                    
                    //initialize an instance of Cloud Firestore:
                    let db = Firestore.firestore()
                    
                    //var ref: DocumentReference? = nil
                    let ref = db.collection("users")
                    let docId = ref.document().documentID
                    
                    let userData = [
                        "firstname": firstName,
                        "lastname": lastName,
                        "email": email,
                        "uid": result!.user.uid,
                        "did": docId,
                        "dateJoined" : dateJoined,
                        "permissionGranted" : "false"]  as [String : Any]
   
                    db.collection("users").document(docId).setData(userData) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(docId)")
                        }
                    }

                    //get entire collection
                    /*db.collection("users").getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                            }
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

