//
//  standardButton.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/5/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//  Custom UIButton Class by

import UIKit

class StandardButton: UIButton {
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
        setTitle("Button", for: .normal)
        backgroundColor     = .darkGray
        titleLabel?.font    = UIFont(name: "AvenirNext-Bold", size: 30)
        layer.cornerRadius  = 25
        layer.borderWidth   = 0.0
        layer.borderColor   = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
       
    }
    
}
