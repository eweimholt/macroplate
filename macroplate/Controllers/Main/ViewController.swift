//
//  ViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 6/6/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit
//import FBSDKLoginKit

class ViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    let logoView : UIImageView = {
        let lView = UIImageView() //frame: CGRect(x: 35, y: 35, width: 300, height: 300))
        lView.translatesAutoresizingMaskIntoConstraints = false
        lView.clipsToBounds = true
        //camView.layer.cornerRadius = 10
        return lView
    }()

    let logoImage : UIImage = {
        let lImage = UIImage(named: "platemate_white")
        return lImage!
    }()
    
    let betaLabel : UILabel = {
        let label = UILabel()
        label.text = "BETA"
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    
        
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
        
        logoView.image = logoImage
        self.view.addSubview(logoView)
        self.view.addSubview(betaLabel)
        
        setUpElements()
    }

    func setUpElements() {
        
        Utilities.styleSetupButton(signUpButton)
        Utilities.styleSetupButton(loginButton)

        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
        logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        logoView.widthAnchor.constraint(equalToConstant: 500).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        betaLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 135).isActive = true
        betaLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 430).isActive = true
        betaLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        betaLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    /*@IBAction func signUpTapped(_ sender: Any) {
        goToSignUp()
    }
    
    
    func goToSignUp() {
        print("signup tapped")
        let signupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "signupVC") as! SignUpViewController
        DispatchQueue.main.async {
            //self.present(signupVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(signupVC, animated: true)
            print("signup presented")
        }
        
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        goToLogin()
    }
    
    func goToLogin() {
        print("login tapped")
        
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "loginVC") as! LoginViewController
        DispatchQueue.main.async {
            print("login presented")
            self.present(loginVC, animated: true, completion: nil)
            //self.navigationController?.pushViewController(loginVC, animated: true)
        }
        
    }*/
    
}

