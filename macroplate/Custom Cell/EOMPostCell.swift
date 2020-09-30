//
//  EOMPostCell.swift
//  macroplate
//
//  Created by Elise Weimholt on 9/25/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import Firebase

protocol EOMPostCellDelegate {
    //commands that we give to PostViewController
    func didExpandEOMPost(image: UIImage, EOMImage: UIImage, date: String?, timestamp: TimeInterval?, userText: String?, calories: String?, carbs: String?, protein: String?, fat: String?,state : String?, postId : String?, healthDataEvent: String?, isPlateEmpty: String?)
    func didDeletePost(index: Int)
}

class EOMPostCell: UICollectionViewCell {
    
    var delegate: EOMPostCellDelegate?
    var index: IndexPath?
    var date: String?
    var timestamp: TimeInterval?
    var userTextInput : String?
    var name : String?
    var pathToImage : String?
    var pathToEOMImage : String?
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
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = CGColor.init(gray: 1, alpha: 1)
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    let EOMImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    var postButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        //button.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.20)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 24)
        return button
    }()
    
    let indicator : UIButton = {
        let cButton = UIButton()
        cButton.setTitleColor(.white, for: .normal) // You can change the TitleColor
        cButton.setTitle("Pending", for: .normal)
        cButton.translatesAutoresizingMaskIntoConstraints = false
        cButton.contentHorizontalAlignment = .center
        let cImage = UIImage(systemName: "seal.fill")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
        cButton.setImage(cImage, for: .normal)
        cButton.backgroundColor = UIColor.orange
        cButton.clipsToBounds = true
        cButton.layer.cornerRadius = 15
        return cButton
    }()

    var headerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        //button.layer.cornerRadius = 15
        button.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.0)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 18)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    var afterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitle("Pending", for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.20)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 32)
        return button
    }()
    
    var deleteButton: UIButton = {
        let dButton = UIButton()
        dButton.translatesAutoresizingMaskIntoConstraints = false
        dButton.clipsToBounds = true
        dButton.setTitleColor(.white, for: .normal)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .large)
        let cImage = UIImage(systemName: "x.circle", withConfiguration: config)?.withTintColor(UIColor.darkGray, renderingMode: .alwaysOriginal)
        dButton.setImage(cImage, for: .normal)
        dButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        return dButton
    }()
    
    /*let completeMealLabel : UIButton = {
        let cButton = UIButton()
        cButton.setTitleColor(.gray, for: .normal) // You can change the TitleColor
        cButton.setTitle("Meal Log Complete", for: .normal)
        cButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        //cButton.setFont(
        cButton.translatesAutoresizingMaskIntoConstraints = false
        cButton.contentHorizontalAlignment = .center
        //let cImage = UIImage(systemName: "seal")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
        //cButton.setImage(cImage, for: .normal)
        //cButton.backgroundColor = UIColor.orange
        cButton.clipsToBounds = true
        cButton.layer.cornerRadius = 15
        return cButton
    }()*/
    
    /*let completeMealLabel : UILabel = {
        let label = UILabel()
        label.text = "Meal Log Complete"
        label.font = UIFont(name: "AvenirNext-Bold", size: 28)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        //label.backgroundColor = .cyan
        return label
    }()*/
    
    var completeMealLabel = MealCompleteLabel()
    
    let leftoverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.layer.borderWidth = 1.5
        //imageView.layer.borderColor = CGColor.init(gray: 1, alpha: 1)
        //imageView.layer.cornerRadius = 20
        imageView.image =  UIImage(named: "leftovers")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(headerButton)
        //contentView.addSubview(indicator)
        contentView.addSubview(completeMealLabel)
        contentView.addSubview(leftoverImage)

        contentView.addSubview(EOMImage)
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
        if let userTextInput = userTextInput, let _ = postImage.image, let _ = EOMImage.image, let calories = calories, let carbs = carbs, let protein = protein, let fat = fat, let state = state, let postId = postId, let healthDataEvent = healthDataEvent, let isPlateEmpty = isPlateEmpty {
            
            if date == nil {
                delegate?.didExpandEOMPost(image: postImage.image!, EOMImage: EOMImage.image!, date: "", timestamp: TimeInterval(), userText: userTextInput, calories: calories, carbs: carbs, protein: protein, fat: fat, state : state, postId: postId, healthDataEvent: healthDataEvent, isPlateEmpty: isPlateEmpty)
                print("Timestamp is likely nil")
            } else {
                delegate?.didExpandEOMPost(image: postImage.image!, EOMImage: EOMImage.image!, date: date, timestamp: timestamp, userText: userTextInput, calories: calories, carbs: carbs, protein: protein, fat: fat, state : state, postId: postId, healthDataEvent: healthDataEvent, isPlateEmpty: isPlateEmpty)
            }
        } else {
            print("nil abort avoided :) ")
        }
    }
    
    @IBAction func deletePost() {
        delegate?.didDeletePost(index: index!.row)
    }
    
    /*@IBAction func tapEOMPhoto() {
        delegate?.didTapEOMPhoto(index: index!.row)
    }*/

}

// MARK: Helper
extension EOMPostCell {
    fileprivate func setup() {
        
        //let headerHeight = CGFloat(Constants.headerHeight)
        //let headerElementHeight = CGFloat(Constants.headerElementHeight)
        //let padding = CGFloat(Constants.padding)
        
        let headerHeight = CGFloat(35)
        let headerElementHeight = headerHeight - 5
        let padding = CGFloat(15)

        
        let cellWidth = contentView.frame.width
        //let cellHeight = contentView.frame.height - headerHeight
        
        let imageWidth = cellWidth*0.40
        
        //BEFORE IMAGE
        postImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: headerHeight).isActive = true
        postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
        postImage.heightAnchor.constraint(equalToConstant: imageWidth).isActive = true
        postImage.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        
        postButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        postButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        postButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
        postButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: headerElementHeight).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: headerElementHeight).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
        
        //AFTER IMAGE
        EOMImage.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellWidth*0.5).isActive = true
        EOMImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
        EOMImage.heightAnchor.constraint(equalToConstant: imageWidth).isActive = true
        EOMImage.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        
        headerButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        headerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
        headerButton.heightAnchor.constraint(equalToConstant: headerElementHeight).isActive = true
        //headerButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        headerButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -padding).isActive = true
        
        /*indicator.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 105).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: headerElementHeight).isActive = true
        indicator.leadingAnchor.constraint(equalTo: headerButton.trailingAnchor, constant: 10).isActive = true*/
        
        completeMealLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: headerHeight).isActive = true
        completeMealLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
        completeMealLabel.heightAnchor.constraint(equalToConstant: headerElementHeight*3).isActive = true
        completeMealLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  cellWidth*0.50).isActive = true
        
        leftoverImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: headerElementHeight*4).isActive = true
        //leftoverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  cellWidth*0.50).isActive = true
        leftoverImage.centerXAnchor.constraint(equalTo: completeMealLabel.centerXAnchor).isActive = true
        leftoverImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        leftoverImage.heightAnchor.constraint(equalToConstant: 37.5).isActive = true
        //leftoverImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
        //leftoverImage.heightAnchor.constraint(equalToConstant: headerElementHeight*3).isActive = true
        

    }
}


