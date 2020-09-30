//
//  ConfirmationViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/12/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

class ConfirmationViewController: UIViewController {
 
    let confirmLabel : UILabel = {
        let label = UILabel()
        label.text = "Photo Submitted"
        label.font = UIFont(name: "AvenirNext-Bold", size: 36)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.text = "Check back in a few days to see your results!"
        label.font = UIFont(name: "AvenirNext", size: 18)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    let mailImage : UIImage = {
        let config = UIImage.SymbolConfiguration(pointSize: 5, weight: .regular, scale: .large)
        let cImage = UIImage(systemName: "envelope.badge", withConfiguration: config)?.withTintColor(UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1), renderingMode: .alwaysOriginal)
        return cImage!
    }()
    
    //initialize buttons
    let mailButton : UIButton = {
       let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        cButton.translatesAutoresizingMaskIntoConstraints = false
       return cButton
    }()

    let doneButton : UIButton = {
        let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        cButton.setTitle("Ok", for: .normal)
        cButton.titleLabel?.font = UIFont(name: "AvenirNext", size: 18)
        cButton.setTitleColor(.white, for: .normal) // You can change the TitleColor
        cButton.backgroundColor = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
        cButton.translatesAutoresizingMaskIntoConstraints = false
        return cButton
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.addTarget(self, action: #selector(goToFeed), for: .touchUpInside)
        view.addSubview(doneButton)
        view.addSubview(confirmLabel)
        view.addSubview(messageLabel)
        
        mailButton.setBackgroundImage(mailImage, for: .normal)
        view.addSubview(mailButton)
        view.backgroundColor = .white

        setUpLayout()
        
        Utilities.styleFilledButton(doneButton)
    }

    
    private func setUpLayout() {
        
        mailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mailButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        mailButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        mailButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        confirmLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmLabel.topAnchor.constraint(equalTo: mailButton.bottomAnchor, constant: 20).isActive = true
        confirmLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        confirmLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: confirmLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        messageLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    
    @IBAction func goBack(_ sender: Any) {
        transitionToImageVC()
    }
    
    @IBAction func goToFeed(_ sender: Any) {
        transitionToHome()
    }
    
    func transitionToImageVC() {

        let imageViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.imageViewController) as? ImageViewController
        
        //swap out root view controller for the feed one
        view.window?.rootViewController = imageViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToHome() {

        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        //swap out root view controller for the home one
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    
}
