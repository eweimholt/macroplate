//
//  RemindersTableCell.swift
//  macroplate
//
//  Created by Elise Weimholt on 10/9/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import Foundation
import UIKit


/*protocol RemindersCellDelegate {
    func didSaveReminder()
}*/

class RemindersCell : UITableViewCell {
    
    //var delegate : UITableViewDelegate?
    
    static let colorA = UIColor.init(displayP3Red: 125/255, green: 234/255, blue: 221/255, alpha: 1) //7deadd
    static let colorB = UIColor.init(displayP3Red: 99/255, green: 197/255, blue: 188/255, alpha: 1) //primary //63c5bc
    static let colorC = UIColor.init(displayP3Red: 50/255, green: 186/255, blue: 232/255, alpha: 1) //32bae8
    static let colorD = UIColor.init(displayP3Red: 49/255, green: 128/255, blue: 194/255, alpha: 1) //3180c2
    static let colorE = UIColor.init(displayP3Red: 36/255, green: 101/255, blue: 151/255, alpha: 1) //246597
    
    var reminders : Reminders? {
        didSet {
            mealTimeLabel.text = reminders?.mealTime
            //dateLabel.text = reminders?.date //change to date picker later
            saveButton.titleLabel?.text = reminders?.isOn
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

    var timePicker = UIDatePicker()

    var saveButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitleColor(.darkGray, for: .normal) // You can change the TitleColor
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold, scale: .large)
        let cImage = UIImage(systemName: "circle", withConfiguration: config)?.withTintColor(colorB, renderingMode: .alwaysOriginal)
        let fillImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)?.withTintColor(colorB, renderingMode: .alwaysOriginal)
        button.setImage(cImage, for: .normal)
        button.setImage(fillImage, for: .selected)
        return button
        
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //addSubview(productImage)
        contentView.backgroundColor = .white
        contentView.addSubview(mealTimeLabel)
        contentView.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveReminder), for: .touchUpInside)

        timePicker.datePickerMode = .time
        //timePicker.datePickerStyle.wheel
        contentView.addSubview(timePicker)
        
        let padding = CGFloat(5)

        mealTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding).isActive = true
        mealTimeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        mealTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
        mealTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true
        
        saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        saveButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true

        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.leadingAnchor.constraint(equalTo: mealTimeLabel.trailingAnchor, constant: padding).isActive = true
        timePicker.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -padding).isActive = true
        timePicker.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding).isActive = true
        timePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func saveReminder() {
        if saveButton.isSelected == true {
            saveButton.isSelected = false
            unSetReminder()
        }
        else {
            saveButton.isSelected = true
            setReminder()
        }
    }
    
    func setReminder() {
        print("reminder is saved")
    }
    
    func unSetReminder() {
        print ("reminder is turned off")
        
    }
    
}

