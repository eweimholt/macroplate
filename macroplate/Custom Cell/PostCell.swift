//
//  PostCell.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/25/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit

protocol PostCellDelegate {
    //commands that we give to PostViewController
    func didExpandPost(image: UIImage, date: String?, userText: String?, calories: String?, carbs: String?, protein: String?, fat: String?,state : String? )
    
    
    func didDeletePost(index: Int)
    
}

class PostCell: UICollectionViewCell {
    
    var delegate: PostCellDelegate?
    var index: IndexPath?
    var date: String?
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
        dButton.layer.cornerRadius = 10
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
        
        //contentView.addSubview(deleteButton)
        //postButton.addTarget(self, action: #selector(deletePost), for: .touchUpInside)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func expandPost() {

        if let userTextInput = userTextInput {
            delegate?.didExpandPost(image: postImage.image!, date: date!, userText: userTextInput, calories: calories, carbs: carbs, protein: protein, fat: fat, state : state)
        } else {
            delegate?.didExpandPost(image: postImage.image!, date: date!, userText: "nothing", calories: calories, carbs: carbs, protein: protein, fat: fat, state : state)
        }


    }
    
    @IBAction func deletePost() {
        delegate?.didDeletePost(index: index!.row)
        
    }
  
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
        
        /*deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:315).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -315).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true*/
        
        
    }
}

