//
//  PostViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/28/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    let postImageView : UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 55, y: 175, width: 300, height: 300))
        imageView.translatesAutoresizingMaskIntoConstraints = true
        return imageView
    }()
    
    // post image
    var postImage:UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(postImageView)
        postImageView.image = postImage

    }

}
