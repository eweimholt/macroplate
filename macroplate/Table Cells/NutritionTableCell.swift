//
//  NutritionTableCell.swift
//  macroplate
//
//  Created by Elise Weimholt on 9/30/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import Foundation
import UIKit
class NutritionCell : UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    
    static let colorA = UIColor.init(displayP3Red: 125/255, green: 234/255, blue: 221/255, alpha: 1) //7deadd
    static let colorB = UIColor.init(displayP3Red: 99/255, green: 197/255, blue: 188/255, alpha: 1) //primary //63c5bc
    static let colorC = UIColor.init(displayP3Red: 50/255, green: 186/255, blue: 232/255, alpha: 1) //32bae8
    static let colorD = UIColor.init(displayP3Red: 49/255, green: 128/255, blue: 194/255, alpha: 1) //3180c2
    static let colorE = UIColor.init(displayP3Red: 36/255, green: 101/255, blue: 151/255, alpha: 1) //246597
    
    var subId = "subcell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subcell", for: indexPath) as! SubNutritionCell
        let currentItem = subNutrition[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        //returns entire model
        cell.subNutrition = currentItem
        return cell
    }
    
    //TABLE VIEW DATA
    var subNutrition : [Nutrition] = [Nutrition]()

    var cals : NSNumber?
    var carbs : NSNumber?
    var protein : NSNumber?
    var fat : NSNumber?
    
    var food : Food? {
        didSet {
            foodLabel.setTitle(food?.name, for: .normal)
            servingSizeUnitLabel.text = food?.servingSizeUnit
            if food?.servingSizeValue == 0 {
                servingSizeQuantity.text = ""
            } else {
                servingSizeQuantity.text = food?.servingSizeValue?.stringValue
            }
            
            self.cals = food?.individualNutrition?.cals
            self.carbs = food?.individualNutrition?.carbs
            self.protein = food?.individualNutrition?.protein
            self.fat = food?.individualNutrition?.fat
            getSubNutrition(cals: cals!, carbs: carbs!, protein: protein!, fat: fat!)
        }
    }
    
    var foodLabel : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 15)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.numberOfLines = 0
        return button
    }()
    
    
    let servingSizeUnitLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont(name: "AvenirNext-Regular", size: 15)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        //lbl.backgroundColor = .lightGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    var servingSizeQuantity : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-Regular", size: 15)
        label.textAlignment = .right
        //label.text = "1"
        label.textColor = .white
        //label.backgroundColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let subNutritionTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.clipsToBounds = true
        tableView.isEditing = false
        tableView.rowHeight = 35
        tableView.register(SubNutritionCell.self, forCellReuseIdentifier: "subcell")
        return tableView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(foodLabel)
        foodLabel.addTarget(self, action: #selector(foodNameLabelTapped), for: .touchUpInside)
        contentView.addSubview(servingSizeQuantity)
        contentView.addSubview(servingSizeUnitLabel)
        contentView.addSubview(subNutritionTableView)
        subNutritionTableView.dataSource = self
        subNutritionTableView.delegate = self
        //subNutritionTableView.backgroundColor = .lightGray
        let height = CGFloat(50)

        foodLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        foodLabel.widthAnchor.constraint(equalToConstant: 230).isActive = true
        foodLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        foodLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        servingSizeUnitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        servingSizeUnitLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        servingSizeUnitLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        servingSizeUnitLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        servingSizeQuantity.trailingAnchor.constraint(equalTo: servingSizeUnitLabel.leadingAnchor).isActive = true
        servingSizeQuantity.widthAnchor.constraint(equalToConstant: 50).isActive = true
        servingSizeQuantity.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        servingSizeQuantity.heightAnchor.constraint(equalToConstant: height).isActive = true

        subNutritionTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        subNutritionTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        subNutritionTableView.topAnchor.constraint(equalTo: foodLabel.bottomAnchor).isActive = true
        subNutritionTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getSubNutrition(cals: NSNumber, carbs: NSNumber, protein: NSNumber, fat: NSNumber) {
        subNutrition.append(Nutrition(nutritionTitle: "Calories: ", nutritionValue: cals, nutritionUnit: "kCal", nutritionColor: NutritionCell.colorB))
        subNutrition.append(Nutrition(nutritionTitle: "Carbs: ", nutritionValue: carbs, nutritionUnit: "g", nutritionColor: NutritionCell.colorC))
        subNutrition.append(Nutrition(nutritionTitle: "Fat: ", nutritionValue: fat, nutritionUnit: "g", nutritionColor: NutritionCell.colorD))
        subNutrition.append(Nutrition(nutritionTitle: "Protein: ", nutritionValue: protein, nutritionUnit: "g", nutritionColor: NutritionCell.colorE))
    }
    
    @IBAction func foodNameLabelTapped() {
        if foodLabel.isSelected == true {
            foodLabel.isSelected = false
            collapseFood()
        }
        else {
            foodLabel.isSelected = true
            expandFood()
        }
    }
    
    func expandFood() {
        print("expand food nutrition")
        /*contentView.addSubview(subNutritionTableView)
        
        self.nutrition?.nutritionUnit = "true"
        */
    }
    
    
    func collapseFood() {
        print ("collapse food nutrition")
        //self.nutrition?.nutritionUnit = "false"
        //subNutritionTableView.removeFromSuperview()
        
        
        
    }
    
    
}

