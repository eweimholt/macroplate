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

    var cals : String?
    var carbs : String?
    var protein : String?
    var fat : String?
    
    var food : Food? {
        didSet {
            foodLabel.setTitle(food?.name, for: .normal)
            servingSizeUnitLabel.text = food?.servingSizeUnit
            servingSizeQuantity.text = food?.servingSizeValue
            self.cals = food?.individualNutrition.cals
            self.carbs = food?.individualNutrition.carbs
            self.protein = food?.individualNutrition.protein
            self.fat = food?.individualNutrition.fat
            getSubNutrition(cals: cals!, carbs: carbs!, protein: protein!, fat: fat!)
        }
    }
    
    var foodLabel : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 17)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    
    let servingSizeUnitLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.backgroundColor = .lightGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    var servingSizeQuantity : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        //label.text = "1"
        label.textColor = .black
        label.backgroundColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let subNutritionTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.clipsToBounds = true
        tableView.isEditing = false
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
        let height = CGFloat(35)

        foodLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        foodLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        foodLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        foodLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        servingSizeUnitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        servingSizeUnitLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        servingSizeUnitLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        servingSizeUnitLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        servingSizeQuantity.trailingAnchor.constraint(equalTo: servingSizeUnitLabel.leadingAnchor).isActive = true
        servingSizeQuantity.widthAnchor.constraint(equalToConstant: 30).isActive = true
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
    
    func getSubNutrition(cals: String, carbs: String, protein: String, fat: String) {
        subNutrition.append(Nutrition(nutritionTitle: "Calories: ", nutritionValue: cals, nutritionUnit: "kCal"))
        subNutrition.append(Nutrition(nutritionTitle: "Carbs: ", nutritionValue: carbs, nutritionUnit: "g"))
        subNutrition.append(Nutrition(nutritionTitle: "Fat: ", nutritionValue: fat, nutritionUnit: "g"))
        subNutrition.append(Nutrition(nutritionTitle: "Protein: ", nutritionValue: protein, nutritionUnit: "g"))
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

