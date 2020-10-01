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
    
    func setupLabel()  {
        text = "Meal Log Complete"
        font = UIFont(name: "AvenirNext-Bold", size: 28)
        textColor = .lightGray
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .center
        numberOfLines = 2
        //backgroundColor = .cyan
       
    }
    
}
