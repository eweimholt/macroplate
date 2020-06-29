//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//
//  (6.6.2020 EW) - modify the regular expression of the isPasswordValid method 

import Foundation
import UIKit

class Utilities {

    //create color dictionaries
    static let primaryUIColor = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)

    
    static func styleTextField(_ textfield:UITextField) {

        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = primaryUIColor.cgColor
        //UIColor.init(red: 100/255, green: 196/255, blue: 188/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleLabel(_ label:UILabel) {

        // Create the background
        let background = CALayer()
        background.frame = CGRect(x: 0, y: label.frame.height - 2, width: label.frame.width - 175, height: 2)
        background.backgroundColor = primaryUIColor.cgColor
        // Add the line to the text field
        label.layer.addSublayer(background)
        /*label.backgroundColor = primaryUIColor
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.cornerRadius = 10.0*/
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = primaryUIColor
            //UIColor.init(red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
        //rgb(100, 196, 188) flowaste main color
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
        
    }
    
    
    //uses a regular expression to check the security of the user password
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}
