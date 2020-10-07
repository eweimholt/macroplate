//
//  Constants.swift
//  macroplate
//
//  Created by Elise Weimholt on 6/6/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Storyboard {
        
        static let homeViewController = "HomeVC"
        static let feedViewController = "FeedVC"
        static let imageViewController = "ImageVC"
        static let confirmationViewController = "ConfirmVC"
        static let postViewController = "PostVC"
        static let mealsViewController = "MealsVC"
        static let secondImageViewController = "SecondImageVC"
        
    }
    
    struct UserDefaults {
        static let currentUser = "currentUser"
    }
    
    static let dateFormatAs = "MMM dd, h a"//"MM/dd/yy, HH:mm"
    
   
    
    //post variables
    static let headerElementHeight = 30
    static let headerHeight = headerElementHeight + 5
    static let padding = 15
    
    //COLORS
    struct UIColor {
        //static let primaryColor = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
    }
    
}
