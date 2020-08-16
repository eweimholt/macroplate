//
//  PostCell.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/25/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

protocol PostCellDelegate {
    //commands that we give to PostViewController
    func didExpandPost(image: UIImage, date: String?, userText: String?, calories: String?, carbs: String?, protein: String?, fat: String?,state : String?, postId : String?, healthDataEvent: String?)
    
    
    func didDeletePost(index: Int)
    
    //func didHoldPost(index: Int)
    
}

class PostCell: UICollectionViewCell {
    
    var delegate: PostCellDelegate?
    var index: IndexPath?
    var date: String?
    var timestamp: TimeInterval?
    var userTextInput : String?
    var name : String?
    var pathToImage : String?
    var userId : String?
    var postId : String?
    
    var carbs : String?
    var protein : String?
    var fat : String?
    var calories : String?

    var state : String?
    var healthDataEvent : String?
    
    
    let postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        //imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var postButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitle("Pending", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.20)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 24)
        return button
    }()
    
    var deleteButton: UIButton = {
        let dButton = UIButton()
        dButton.translatesAutoresizingMaskIntoConstraints = false
        dButton.setTitle("X", for: .normal)
        dButton.clipsToBounds = true
        dButton.layer.cornerRadius = 15
        dButton.backgroundColor = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
        dButton.setTitleColor(.white, for: .normal)
        dButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20)
        return dButton
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(postImage)
        
        contentView.addSubview(postButton)
        postButton.addTarget(self, action: #selector(expandPost), for: .touchUpInside)
        //postButton.addTarget(self, action: #selector(postHold), for: .touchDragInside)
        
        contentView.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deletePost), for: .touchUpInside)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func expandPost() {

        if let userTextInput = userTextInput, let _ = postImage.image, let calories = calories, let carbs = carbs, let protein = protein, let fat = fat, let state = state, let postId = postId, let healthDataEvent = healthDataEvent {
            
            if date == nil {
            delegate?.didExpandPost(image: postImage.image!, date: "", userText: userTextInput, calories: calories, carbs: carbs, protein: protein, fat: fat, state : state, postId: postId, healthDataEvent: healthDataEvent)
            } else {
            delegate?.didExpandPost(image: postImage.image!, date: date, userText: userTextInput, calories: calories, carbs: carbs, protein: protein, fat: fat, state : state, postId: postId, healthDataEvent: healthDataEvent)
            }
        } else {
            print("nil abort avoided :) ")
        }

    }
    
    @IBAction func deletePost() {
        delegate?.didDeletePost(index: index!.row)
    }
    
    /*@IBAction func postHold() {
        delegate?.didHoldPost(index: index!.row)
    }*/

  
}

// MARK: Helper
extension PostCell {
    fileprivate func setup() {
        postImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        postImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        postImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        //postImage.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        postButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        postButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        postButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        postButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        //postButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:265).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -265).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        
    }
}

