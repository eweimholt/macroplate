//
//  UserButton.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/7/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit

class UserButton: UIButton {
//initialization for swift
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    
    //initialization for storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
        
    }
    
    func setupButton()  {
        setTitleColor(.white, for: .normal)
        backgroundColor     = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
        titleLabel?.font    = UIFont(name: "AvenirNext-Bold", size: 20)
        layer.cornerRadius  = 20
        layer.borderWidth   = 0.0
        layer.borderColor   = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
       
    }
}
