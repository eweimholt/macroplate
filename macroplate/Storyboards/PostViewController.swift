//
//  PostViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/28/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    var carbs : String?
    var protein : String?
    var fat : String?
    var calories : String?
    
    var state : String? 
    
    let postImageView : UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 35, y: 40, width: 350, height: 350))
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    // post image
    var postImage:UIImage?
    
    var date : UITextView = {
        let textView = UITextView()
        textView.textAlignment = .center
        textView.font    = UIFont(name: "AvenirNext-Regular", size: 14)
        textView.textColor = .lightGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var userLabel : UITextView = {
        let textView = UITextView()
        textView.textAlignment = .center
        textView.font    = UIFont(name: "AvenirNext-Regular", size: 18)
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var caloriesText : UITextView = {
        let textView = UITextView()
        textView.textAlignment = .center
        textView.font    = UIFont(name: "AvenirNext-Regular", size: 18)
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let pendingView : UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 35, y: 410, width: 350, height: 320))
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 20
        return imageView
    }()

    let annotatedView : UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 35, y: 410, width: 350, height: 320))
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .green
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(postImageView)
        postImageView.image = postImage
        
        if state == "Pending" {
            self.view.addSubview(pendingView)
            //print(state!)
        } else {
            self.view.addSubview(annotatedView)
            //print(state!)
        }
        
        
        self.view.addSubview(date)
        self.view.addSubview(userLabel)
        self.view.addSubview(caloriesText)
        setUpLayout()
        


    }
    
    private func setUpLayout() {

        date.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        date.topAnchor.constraint(equalTo: view.topAnchor, constant: 450).isActive = true
        date.widthAnchor.constraint(equalToConstant: 170).isActive = true
        date.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        userLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        userLabel.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 20).isActive = true
        //userLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        //userLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        userLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        caloriesText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        caloriesText.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 20).isActive = true
        //caloriesText.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        //caloriesText.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        caloriesText.widthAnchor.constraint(equalToConstant: 300).isActive = true
        caloriesText.heightAnchor.constraint(equalToConstant: 30).isActive = true

    
        
    }

    
}
