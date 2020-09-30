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
    func didExpandPost(image: UIImage, date: String?, timestamp: TimeInterval?, userText: String?, calories: String?, carbs: String?, protein: String?, fat: String?,state : String?, postId : String?, healthDataEvent: String?, isPlateEmpty: String?)
    func didDeletePost(index: Int)
    
    func addAfterMeal(index: Int, postId : String?)
    
    func didSelectCleanPlate()
}

class PostCell: UICollectionViewCell {
    
    var delegate: PostCellDelegate?
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
        imageView.layer.cornerRadius = 20
        //imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var postButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.20)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 24)
        return button
    }()
    
    /*let indicator : UIButton = {
        let cButton = UIButton()
        cButton.setTitleColor(.darkGray, for: .normal) // You can change the TitleColor
        cButton.setTitle("Complete your meal log:", for: .normal)
        cButton.translatesAutoresizingMaskIntoConstraints = false
        cButton.contentHorizontalAlignment = .center
        //let cImage = UIImage(systemName: "seal")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
        //cButton.setImage(cImage, for: .normal)
        //cButton.backgroundColor = UIColor.orange
        cButton.clipsToBounds = true
        cButton.layer.cornerRadius = 15
        return cButton
    }()*/
    
    /*let completeMealLabel : UIButton = {
        let cButton = UIButton()
        cButton.setTitleColor(.darkGray, for: .normal) // You can change the TitleColor
        cButton.setTitle("Complete your meal log:", for: .normal)
        cButton.translatesAutoresizingMaskIntoConstraints = false
        cButton.contentHorizontalAlignment = .center
        //let cImage = UIImage(systemName: "seal")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
        //cButton.setImage(cImage, for: .normal)
        //cButton.backgroundColor = UIColor.orange
        cButton.clipsToBounds = true
        cButton.layer.cornerRadius = 15
        return cButton
    }()*/

    
    var completeMealLabel = MealCompleteLabel()
    
    var mealLogText: UILabel = {
        let label = UILabel()
        label.text = "Complete your meal log:"
        label.font = UIFont(name: "AvenirNext", size: 18)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 2
        //label.backgroundColor = .cyan
        return label
    }()

    var headerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        //button.layer.cornerRadius = 15
        button.backgroundColor = .cyan//UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.0)
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
    
    let cleanPlateButton : UIButton = {
        let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        cButton.setTitle("I finished my plate.", for: .normal)
        cButton.setTitleColor(.black, for: .normal) // You can change the TitleColor
        cButton.translatesAutoresizingMaskIntoConstraints = false
        
        //let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .large)
        cButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal)
        cButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: UIControl.State.selected)
        return cButton
    }()

    let leftoversButton : UIButton = {
        let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        cButton.setTitle("I had leftovers.", for: .normal)
        cButton.setTitleColor(.black, for: .normal) // You can change the TitleColor
        cButton.translatesAutoresizingMaskIntoConstraints = false
        cButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal)
        cButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: UIControl.State.selected)
        return cButton
    }()

    let cleanPlateImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image =  UIImage(named: "cleanplate")
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        //contentView.addSubview(afterButton)
        //afterButton.addTarget(self, action: #selector(addAfterMeal), for: .touchUpInside)

        contentView.addSubview(postImage)
        
        

        //contentView.addSubview(completeMealLabel)
        contentView.addSubview(mealLogText)
        contentView.addSubview(postButton)
        postButton.addTarget(self, action: #selector(expandPost), for: .touchUpInside)

            
        contentView.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deletePost), for: .touchUpInside)
        contentView.addSubview(headerButton)
        
        contentView.addSubview(cleanPlateButton)
        contentView.addSubview(leftoversButton)
        cleanPlateButton.addTarget(self, action: #selector(btn_box(sender:)), for: .touchUpInside)
        leftoversButton.addTarget(self, action: #selector(btn_leftovers(sender:)), for: .touchUpInside)

        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func btn_box(sender: UIButton) {

        if cleanPlateButton.isSelected == true {
            cleanPlateButton.isSelected = false
            leftoversButton.isSelected = true
            mealIsNotComplete()
            
        }
        else {
            cleanPlateButton.isSelected = true
            leftoversButton.isSelected = false
            mealIsComplete()
            //delegate?.didSelectCleanPlate()
            
        }
    }
    
    @IBAction func btn_leftovers(sender: UIButton) {
        if leftoversButton.isSelected == true {
            leftoversButton.isSelected = false
            cleanPlateButton.isSelected = true
            mealIsComplete()
            //delegate?.didSelectCleanPlate()

        }
        else {
            leftoversButton.isSelected = true
            cleanPlateButton.isSelected = false
            mealIsNotComplete()
        }
    }

    func mealIsNotComplete () {
        self.addSubview(mealLogText)
        completeMealLabel.removeFromSuperview()

        self.addSubview(afterButton)
        afterButton.addTarget(self, action: #selector(addAfterMeal), for: .touchUpInside)
        
        let headerHeight = CGFloat(35)
        let headerElementHeight = headerHeight - 5
        let padding = CGFloat(15)
        
        let cellWidth = contentView.frame.width
        let imageWidth = cellWidth*0.40
        
        afterButton.topAnchor.constraint(equalTo: leftoversButton.bottomAnchor, constant: 10).isActive = true
        afterButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellWidth*0.50).isActive = true
        afterButton.trailingAnchor.constraint(equalTo: leftoversButton.trailingAnchor).isActive = true
        afterButton.bottomAnchor.constraint(equalTo: postImage.bottomAnchor).isActive = true
        //afterButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //afterButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        mealLogText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: headerHeight).isActive = true
        mealLogText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
        mealLogText.heightAnchor.constraint(equalToConstant: headerElementHeight).isActive = true
        mealLogText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  imageWidth + padding).isActive = true

        //update Firebase
        let plateIsEmpty = self.cleanPlateButton.isSelected.description
        updateFirebaseSecondMeal(value: plateIsEmpty)
    }
    
    func mealIsComplete () {
        let headerHeight = CGFloat(35)
        let headerElementHeight = headerHeight - 5
        let padding = CGFloat(15)
        
        let cellWidth = contentView.frame.width
        let imageWidth = cellWidth*0.40
        
        addSubview(completeMealLabel)
        completeMealLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: headerHeight).isActive = true
        completeMealLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
        completeMealLabel.heightAnchor.constraint(equalToConstant: headerElementHeight*3).isActive = true
        completeMealLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  cellWidth*0.50).isActive = true
        
        //completeMealLabel.text = "Meal Log Complete"
        //completeMealLabel.font = UIFont(name: "AvenirNext-Bold", size: 28)
        
        mealLogText.removeFromSuperview()
        leftoversButton.removeFromSuperview()
        cleanPlateButton.removeFromSuperview()
        afterButton.removeFromSuperview()
        addSubview(cleanPlateImage)
        
        
        cleanPlateImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: headerElementHeight*4).isActive = true
        cleanPlateImage.centerXAnchor.constraint(equalTo: completeMealLabel.centerXAnchor).isActive = true
        cleanPlateImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cleanPlateImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //update Firebase
        let plateIsEmpty = self.cleanPlateButton.isSelected.description
        updateFirebaseSecondMeal(value: plateIsEmpty)
    }
    
    func updateFirebaseSecondMeal(value: String) {
        //To Do: set the default of plateIsEmpty to true.
        
        //if the leftovers button is tapped, set plateIsEmpty to false
        //var plateisEmptyState:[String : Any]?
        
        let db = Firestore.firestore()
        //let uid = Auth.auth().currentUser!.uid
        //var docId : String?
        
        // get docid from a query looking at the uid
        db.collection("posts").document(postId!).updateData([
            "plateIsEmpty" : value
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("plateIsEmpty set to: ", value)
                //let mealsVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.mealsViewController) as? MealsViewController
               //mealsVC.mealsCollectionView.reloadData()
            }
        }
    }

    @IBAction func expandPost() {
        if let userTextInput = userTextInput, let _ = postImage.image, let calories = calories, let carbs = carbs, let protein = protein, let fat = fat, let state = state, let postId = postId, let healthDataEvent = healthDataEvent, let isPlateEmpty = isPlateEmpty, let timestamp = timestamp {
            
            if date == nil {
                delegate?.didExpandPost(image: postImage.image!, date: "", timestamp: timestamp, userText: userTextInput, calories: calories, carbs: carbs, protein: protein, fat: fat, state : state, postId: postId, healthDataEvent: healthDataEvent, isPlateEmpty: isPlateEmpty)
            } else {
                delegate?.didExpandPost(image: postImage.image!, date: date, timestamp: timestamp, userText: userTextInput, calories: calories, carbs: carbs, protein: protein, fat: fat, state : state, postId: postId, healthDataEvent: healthDataEvent, isPlateEmpty: isPlateEmpty)
            }
        } else {
            print("nil abort avoided :) ")
        }
    }
    
    @IBAction func addAfterMeal() {
        //delegate?.addAfterMeal(index: index!.row)
        if let postId = postId {
            delegate?.addAfterMeal(index: index!.row, postId: postId)
        }
        else {
            print("nil abort avoided")
        }
    }
    
    @IBAction func deletePost() {
        delegate?.didDeletePost(index: index!.row)
    }
}

// MARK: Helper
extension PostCell {
    fileprivate func setup() {
        
       // let screenSize: CGRect = UIScreen.main.bounds
        
        let headerHeight = CGFloat(35)
        let headerElementHeight = headerHeight - 5
        let padding = CGFloat(15)
        
        let cellWidth = contentView.frame.width
        let cellHeight = contentView.frame.height
        
        let imageWidth = cellWidth*0.40

        //BEFORE IMAGE
        postImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: headerHeight).isActive = true
        postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
        postImage.heightAnchor.constraint(equalToConstant: imageWidth).isActive = true
        postImage.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        //postImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
        //postImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -imageWidth).isActive = true
        
        postButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: headerHeight).isActive = true
        postButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: imageWidth).isActive = true
        postButton.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        //postButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
        //postButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -imageWidth).isActive = true
        
        deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: headerElementHeight).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: headerElementHeight).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
        
        mealLogText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: headerHeight).isActive = true
        mealLogText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
        mealLogText.heightAnchor.constraint(equalToConstant: headerElementHeight).isActive = true
        mealLogText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  imageWidth + padding).isActive = true
        
        cleanPlateButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: headerHeight + headerElementHeight + 10).isActive = true
        cleanPlateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: imageWidth).isActive = true
        cleanPlateButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cleanPlateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
        
        leftoversButton.topAnchor.constraint(equalTo: cleanPlateButton.bottomAnchor).isActive = true
        leftoversButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  imageWidth - 32).isActive = true
        leftoversButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        leftoversButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
        
        headerButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        headerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
        headerButton.heightAnchor.constraint(equalToConstant: headerElementHeight).isActive = true
        headerButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -padding).isActive = true
        //headerButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        

        

    }
}

