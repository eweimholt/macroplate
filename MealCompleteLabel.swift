//
//  MealCompleteLabel.swift
//  macroplate
//
//  Created by Elise Weimholt on 10/1/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//
import Foundation
import UIKit

class MealCompleteLabel: UILabel{
    //initialization for swift
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    
    //initialization for storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
        
    }
    
    static let colorA = UIColor.init(displayP3Red: 125/255, green: 234/255, blue: 221/255, alpha: 1) //7deadd
    static let colorB = UIColor.init(displayP3Red: 99/255, green: 197/255, blue: 188/255, alpha: 1) //primary //63c5bc
    static let colorC = UIColor.init(displayP3Red: 50/255, green: 186/255, blue: 232/255, alpha: 1) //32bae8
    static let colorD = UIColor.init(displayP3Red: 49/255, green: 128/255, blue: 194/255, alpha: 1) //3180c2
    static let colorE = UIColor.darkGray //UIColor.init(displayP3Red: 36/255, green: 101/255, blue: 151/255, alpha: 1) //246597
    
    func setupLabel()  {
        text = "Meal Log Complete"
        font = UIFont(name: "AvenirNext-Bold", size: 24)
        textColor = UIColor.init(displayP3Red: 99/255, green: 197/255, blue: 188/255, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .center
        numberOfLines = 2
        //backgroundColor = .cyan
       
    }
    
}
