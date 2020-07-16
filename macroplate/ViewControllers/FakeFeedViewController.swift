//
//  FakeFeedViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/16/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit

class FakeFeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "meals2")
        let backImageView = UIImageView(frame: CGRect(x: 7, y: 130, width: 400, height: 650))
        backImageView.image = backgroundImage
        view.addSubview(backImageView)

    }
    


}
