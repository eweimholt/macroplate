//
//  SubNutritionTableCell.swift
//  macroplate
//
//  Created by Elise Weimholt on 10/10/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import Foundation
import UIKit

class SubNutritionCell : UITableViewCell {
    
    var subNutrition : Nutrition? {
        didSet {
            subNutritionNameLabel.text = subNutrition?.nutritionTitle
            subNutritionNameLabel.textColor = subNutrition?.nutritionColor
            subNutritionQuantity.textColor = subNutrition?.nutritionColor
            subNutritionUnitLabel.textColor = subNutrition?.nutritionColor
            subNutritionUnitLabel.text = subNutrition?.nutritionUnit
            subNutritionQuantity.text = subNutrition?.nutritionValue.stringValue
        }
    }

    let subNutritionNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        //lbl.backgroundColor = .green
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    let subNutritionUnitLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        //lbl.text
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        //lbl.backgroundColor = .green
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    var subNutritionQuantity : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        //label.text = "1"
        label.textColor = .black
        //label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //addSubview(productImage)
        contentView.addSubview(subNutritionNameLabel)
        contentView.addSubview(subNutritionUnitLabel)
        contentView.addSubview(subNutritionQuantity)

        let height = CGFloat(40)

        subNutritionNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
        subNutritionNameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        subNutritionNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        subNutritionNameLabel.heightAnchor.constraint(equalToConstant: height).isActive = true

        subNutritionQuantity.leadingAnchor.constraint(equalTo: subNutritionNameLabel.trailingAnchor).isActive = true
        subNutritionQuantity.widthAnchor.constraint(equalToConstant: 60).isActive = true
        subNutritionQuantity.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        subNutritionQuantity.heightAnchor.constraint(equalToConstant: height).isActive = true

        subNutritionUnitLabel.leadingAnchor.constraint(equalTo: subNutritionQuantity.trailingAnchor).isActive = true
        subNutritionUnitLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        subNutritionUnitLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        subNutritionUnitLabel.heightAnchor.constraint(equalToConstant: height).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

