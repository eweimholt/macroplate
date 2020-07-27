//
//  PostCell.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/25/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    
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
            button.setTitle("Pending", for: .normal)
            button.clipsToBounds = true
            button.layer.cornerRadius = 20
            button.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.30)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 24)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(postImage)
        contentView.addSubview(postButton)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

  
    }
}


extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?,  left: NSLayoutXAxisAnchor?,  right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingBottom: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
