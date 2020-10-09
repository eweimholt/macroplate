//
//  NutritionTableCell.swift
//  macroplate
//
//  Created by Elise Weimholt on 9/30/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import Foundation
import UIKit
class NutritionCell : UITableViewCell {
    
    var nutrition : Nutrition? {
        didSet {
            nutritionNameLabel.text = nutrition?.nutritionTitle
            nutritionUnitLabel.text = nutrition?.nutritionUnit
            nutritionQuantity.text = nutrition?.nutritionValue
        }
    }
    
    
    let nutritionNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    let nutritionUnitLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()

    var nutritionQuantity : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "1"
        label.textColor = .white
        return label
        
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //addSubview(productImage)
        addSubview(nutritionNameLabel)
        addSubview(nutritionUnitLabel)
        addSubview(nutritionQuantity)


        
        nutritionNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        nutritionNameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nutritionNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        nutritionNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        nutritionQuantity.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 200).isActive = true
        nutritionQuantity.widthAnchor.constraint(equalToConstant: 20).isActive = true
        nutritionQuantity.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        nutritionQuantity.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        nutritionUnitLabel.leadingAnchor.constraint(equalTo: nutritionQuantity.trailingAnchor, constant: 20).isActive = true
        nutritionUnitLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        nutritionUnitLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        nutritionUnitLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

