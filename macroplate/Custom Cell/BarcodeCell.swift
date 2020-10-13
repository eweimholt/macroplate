//
//  BarcodePostCell.swift
//  macroplate
//
//  Created by Elise Weimholt on 9/16/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import Firebase

protocol BarcodeCellDelegate {
    //commands that we give to PostViewController
    func didExpandCleanPost(date: String?, timestamp: TimeInterval?, calories: String?, carbs: String?, protein: String?, fat: String?, state : String?, postId : String?, healthDataEvent: String?, isPlateEmpty: String?)
    
    func didDeletePost(index: Int)
    
    func addAfterMeal(index: Int, postId : String?)
}

class BarcodePostCell: UICollectionViewCell {
    
    static let colorA = UIColor.init(displayP3Red: 125/255, green: 234/255, blue: 221/255, alpha: 1) //7deadd
    static let colorB = UIColor.init(displayP3Red: 99/255, green: 197/255, blue: 188/255, alpha: 1) //primary //63c5bc
    static let colorC = UIColor.init(displayP3Red: 50/255, green: 186/255, blue: 232/255, alpha: 1) //32bae8
    static let colorD = UIColor.init(displayP3Red: 49/255, green: 128/255, blue: 194/255, alpha: 1) //3180c2
    static let colorE = UIColor.init(displayP3Red: 36/255, green: 101/255, blue: 151/255, alpha: 1) //246597
    static let colorF = UIColor.darkGray
    
    var delegate: BarcodeCellDelegate?
    var index: IndexPath?
    var date: String?
    var timestamp: TimeInterval?
    var name : String?
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
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.round(corners: UIRectCorner.bottomLeft, radius: 50)
        imageView.layer.cornerRadius = 20
        //imageView.isUserInteractionEnabled = true
        return imageView
    }()

    var headerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        //button.layer.cornerRadius = 15
        button.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.0)
        button.setTitleColor(colorB, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 18)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    var nameButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.0)
        button.setTitleColor(colorB, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext", size: 16)
        button.contentHorizontalAlignment = .left
        //button.backgroundColor = .lightGray
        return button
    }()
    
    var postButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitle("Pending", for: .normal)
        button.backgroundColor = .green
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 24)
        return button
    }()
    
    var deleteButton: UIButton = {
        let dButton = UIButton()
        dButton.translatesAutoresizingMaskIntoConstraints = false
        dButton.clipsToBounds = true
        dButton.setTitleColor(.white, for: .normal)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .large)
        let cImage = UIImage(systemName: "x.circle", withConfiguration: config)?.withTintColor(colorB, renderingMode: .alwaysOriginal)
        dButton.setImage(cImage, for: .normal)
        dButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        return dButton
    }()
    
    var editButton: UIButton = {
        let dButton = UIButton()
        dButton.translatesAutoresizingMaskIntoConstraints = false
        dButton.clipsToBounds = true
        dButton.backgroundColor = .orange
        dButton.setTitleColor(.white, for: .normal)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold, scale: .large)
        let cImage = UIImage(systemName: "pencil", withConfiguration: config)?.withTintColor(colorB, renderingMode: .alwaysOriginal)
        dButton.setImage(cImage, for: .normal)
        dButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        return dButton
    }()
    
    var completeMealLabel = MealCompleteLabel()
    
    let cleanPlateImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image =  UIImage(named: "plate_blue")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(headerButton)
        contentView.addSubview(completeMealLabel)
        contentView.addSubview(postImage)
        contentView.addSubview(postButton)
        contentView.addSubview(deleteButton)
        contentView.addSubview(nameButton)

        
        postImage.image = UIImage(named: "barcode.png")
        print("Barcode postId is: ", postId)

        postButton.addTarget(self, action: #selector(expandPost), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deletePost), for: .touchUpInside)
        
        setup()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func expandPost() {

        if let calories = calories, let carbs = carbs, let protein = protein, let fat = fat, let state = state, let postId = postId, let healthDataEvent = healthDataEvent, let isPlateEmpty = isPlateEmpty, let timestamp = timestamp {
            if date == nil {
                delegate?.didExpandCleanPost(date: "", timestamp: timestamp, calories: calories, carbs: carbs, protein: protein, fat: fat, state : state, postId: postId, healthDataEvent: healthDataEvent, isPlateEmpty: isPlateEmpty)
            } else {
                delegate?.didExpandCleanPost(date: date, timestamp: timestamp, calories: calories, carbs: carbs, protein: protein, fat: fat, state : state, postId: postId, healthDataEvent: healthDataEvent, isPlateEmpty: isPlateEmpty)
            }
        } else {
            print("nil abort avoided :) in BarcodeCell")
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
extension BarcodePostCell {
    fileprivate func setup() {
        
       // let screenSize: CGRect = UIScreen.main.bounds
        
        let cellWidth = contentView.frame.width
        let cellHeight = contentView.frame.height
        
        let imageWidth = cellWidth*0.40
        let headerHeight = CGFloat(35)
        let headerElementHeight = headerHeight - 5
        let padding = CGFloat(15)
        //BEFORE IMAGE
        postImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: headerHeight + padding*0.6).isActive = true
        postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
        postImage.heightAnchor.constraint(equalToConstant: imageWidth).isActive = true
        postImage.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        
        postButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        postButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        postButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        postButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding*0.5).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: headerElementHeight).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: headerElementHeight).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true

        headerButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding*0.5).isActive = true
        headerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
        headerButton.heightAnchor.constraint(equalToConstant: headerElementHeight).isActive = true
        headerButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -padding).isActive = true
        
        nameButton.topAnchor.constraint(equalTo: postImage.bottomAnchor).isActive = true
        nameButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
        nameButton.heightAnchor.constraint(equalToConstant: headerElementHeight).isActive = true
        nameButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
    
        
        completeMealLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: headerHeight + padding).isActive = true
        completeMealLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
        completeMealLabel.heightAnchor.constraint(equalToConstant: headerElementHeight*3).isActive = true
        completeMealLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  cellWidth*0.50).isActive = true

    }
}

