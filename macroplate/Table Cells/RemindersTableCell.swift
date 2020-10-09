//
//  RemindersTableCell.swift
//  macroplate
//
//  Created by Elise Weimholt on 10/9/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import Foundation
import UIKit
class RemindersCell : UITableViewCell {
    var delegate : UITableViewDelegate?
    
    var reminders : Reminders? {
        didSet {
            mealTimeLabel.text = reminders?.mealTime
            dateLabel.text = reminders?.date //change to date picker later
            saveLabel.text = reminders?.isOn
        }
    }

    let mealTimeLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.backgroundColor = .lightGray
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    let dateLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.backgroundColor = .lightGray
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var timePicker = UIDatePicker()

    var saveLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //addSubview(productImage)
        contentView.backgroundColor = .white
        contentView.addSubview(mealTimeLabel)
        //contentView.addSubview(dateLabel)
        contentView.addSubview(saveLabel)
        timePicker.datePickerMode = .time
        //timePicker.datePickerStyle.wheel
        contentView.addSubview(timePicker)
        
        let padding = CGFloat(5)

        mealTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
        mealTimeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        mealTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
        mealTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
        
        saveLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
        saveLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        saveLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
        saveLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
        
        /*dateLabel.leadingAnchor.constraint(equalTo: mealTimeLabel.trailingAnchor, constant: padding).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true*/
        
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.leadingAnchor.constraint(equalTo: mealTimeLabel.trailingAnchor, constant: padding).isActive = true
        timePicker.trailingAnchor.constraint(equalTo: saveLabel.leadingAnchor, constant: -padding).isActive = true
        timePicker.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
        timePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

