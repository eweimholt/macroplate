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
    
    var userEmail : String? = nil
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var resetPasswordButton: UIButton!
    
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
        
        //backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        //view.addSubview(backButton)
        
        setUpElements()
    }
    
    
    
    func setUpElements() {
        
        /*backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 60).isActive = true*/
  
        //hide error label
        errorLabel.alpha = 0
        resetPasswordButton.alpha = 0
        
        //style elements
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleSetupButton(loginButton)
        Utilities.styleSetupButton(resetPasswordButton)
        
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
        
        //set email text
        userEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
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
            userEmail = email
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
    
    @IBAction func resetPasswordTapped(_ sender: Any) {

        Auth.auth().sendPasswordReset(withEmail: self.userEmail!) { error in
            // ...
        }
        print("reset email sent to \(String(describing: userEmail))")
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
    
    @IBAction func goBack(_ sender: Any) {
        transitionToRoot()
    }
    
    func transitionToRoot() {
        

        let viewController = storyboard?.instantiateViewController(identifier: "rootVC" ) as? ViewController
        
        //swap out root view controller for the home one
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
        
    }
    
}
    

