//
//  cleanPostCell.swift
//  macroplate
//
//  Created by Elise Weimholt on 9/16/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import Firebase

/*protocol CleanPostCellDelegate {
    //commands that we give to PostViewController
    func didExpandPost(image: UIImage, date: String?, userText: String?, calories: String?, carbs: String?, protein: String?, fat: String?,state : String?, postId : String?, healthDataEvent: String?)
    func didDeletePost(index: Int)
    
    func addAfterMeal(index: Int, postId : String?)
}*/

class CleanPostCell: UICollectionViewCell {
    
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
    var isPlateEmpty : String?
    
    
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
        dButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        return dButton
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(postImage)
            
        contentView.addSubview(postButton)
        postButton.addTarget(self, action: #selector(expandPost), for: .touchUpInside)

            
        contentView.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deletePost), for: .touchUpInside)
        
       setup()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func expandPost() {

        if let userTextInput = userTextInput, let _ = postImage.image, let calories = calories, let carbs = carbs, let protein = protein, let fat = fat, let state = state, let postId = postId, let healthDataEvent = healthDataEvent, let isPlateEmpty = isPlateEmpty {
            if date == nil {
                delegate?.didExpandPost(image: postImage.image!, date: "", userText: userTextInput, calories: calories, carbs: carbs, protein: protein, fat: fat, state : state, postId: postId, healthDataEvent: healthDataEvent, isPlateEmpty: isPlateEmpty)
            } else {
                delegate?.didExpandPost(image: postImage.image!, date: date, userText: userTextInput, calories: calories, carbs: carbs, protein: protein, fat: fat, state : state, postId: postId, healthDataEvent: healthDataEvent, isPlateEmpty: isPlateEmpty)
            }
        } else {
            print("nil abort avoided :) ")
        }
    }
    
    @IBAction func addAfterMeal() {
        delegate?.addAfterMeal(index: index!.row, postId: postId)
    }
    
    @IBAction func deletePost() {
        delegate?.didDeletePost(index: index!.row)
    }

}

// MARK: Helper
extension CleanPostCell {
    fileprivate func setup() {
        
       // let screenSize: CGRect = UIScreen.main.bounds
        
        //let cellWidth = contentView.frame.width
       // let cellHeight = contentView.frame.height
        
        //let imageWidth = cellWidth
        
        //BEFORE IMAGE
        postImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        postImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        postImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        postButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        postButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        postButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        postButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        
    }
}

