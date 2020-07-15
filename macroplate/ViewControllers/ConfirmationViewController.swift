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
        label.font = UIFont.systemFont(ofSize: 36)
        label.textColor = .black
        //label.layer.masksToBounds = true
        //label.layer.cornerRadius = 30
        //label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.text = "Check back in a few days to see your results!"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
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
    
    let backButton : UIButton = {
       let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        cButton.setTitle("Back", for: .normal)
        cButton.setTitleColor(.blue, for: .normal) // You can change the TitleColor
        cButton.translatesAutoresizingMaskIntoConstraints = false
       return cButton
    }()

      let doneButton : UIButton = {
         let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
          cButton.setTitle("Done", for: .normal)
          cButton.setTitleColor(.blue, for: .normal) // You can change the TitleColor
          cButton.translatesAutoresizingMaskIntoConstraints = false
         return cButton
      }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        view.addSubview(backButton)
        doneButton.addTarget(self, action: #selector(goToFeed), for: .touchUpInside)
        view.addSubview(doneButton)
        view.addSubview(confirmLabel)
        view.addSubview(messageLabel)
        
        mailButton.setBackgroundImage(mailImage, for: .normal)
        view.addSubview(mailButton)

        
  
        
        
        // Do any additional setup after loading the view.
        setUpLayout()
    }

    
    private func setUpLayout() {
        confirmLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        confirmLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        confirmLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: confirmLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        messageLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        mailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mailButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -500).isActive = true
        mailButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        mailButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
  
    }
    
    @IBAction func goBack(_ sender: Any) {
        print("goBack")
        transitionToImageVC()
    }
    
    @IBAction func goToFeed(_ sender: Any) {
        print("goToFeed")
        transitionToFeed()
    }
    
    func transitionToImageVC() {

        let imageViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.imageViewController) as? ImageViewController
        
        //swap out root view controller for the feed one
        view.window?.rootViewController = imageViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToFeed() {

        let feedViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.feedViewController) as? FeedViewController
        
        //swap out root view controller for the feed one
        view.window?.rootViewController = feedViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    
}
