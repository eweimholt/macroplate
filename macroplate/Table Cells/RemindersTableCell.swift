//
//  RemindersTableCell.swift
//  macroplate
//
//  Created by Elise Weimholt on 10/9/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import Foundation
import UIKit
import EventKit


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
    
    var reminderId : String!
    var reminderState : String!
    var isOn : Bool!
    var reminders : Reminders! {
        didSet {
            mealTimeLabel.text = reminders!.mealTime
            reminderId = reminders!.mealTime
            timePicker.date = reminders!.date //change to date picker later
            saveButton.isSelected = reminders!.isOn
            //isOn = reminders!.isOn
            //saveButton.isSelected = ((reminders?.isOn) != nil)
        }
    }
    
    var reminderTimeDate : Date?
    var timePicked : Date?
    
    let mealTimeLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        //lbl.backgroundColor = .lightGray
        lbl.font = UIFont(name: "AvenirNext-Bold", size: 18)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var timePicker = UIDatePicker()
    
    var saveButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 26, weight: .semibold, scale: .large)
        let cImage = UIImage(systemName: "circle", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let fillImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.setImage(cImage, for: .normal)
        button.setImage(fillImage, for: .selected)
        return button
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        contentView.addSubview(mealTimeLabel)
        contentView.addSubview(saveButton)
        //saveButton.isSelected = isOn!
        saveButton.addTarget(self, action: #selector(saveReminder), for: .touchUpInside)
        
        timePicker.datePickerMode = .time
        timePicker.tintColor = .white
        contentView.addSubview(timePicker)

        //CONSTRAINTS
        let padding = CGFloat(5)
        
        mealTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        mealTimeLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
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
        
        //getDefaultTimes()
    }
    
    func getDefaultTimes() {
        print("reminderId is: \(reminderId ?? "DNEEEEEEEEE")")
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
            
            self.timePicked = timePicker.date //capture the date shown on the picker
            
            let dateFormatter = DateFormatter() //create a date formatter
            
            dateFormatter.timeStyle = DateFormatter.Style.short
            let timeAsString = dateFormatter.string(from: timePicked!)
            //print("RemindersTableCell timeAsString: ", timeAsString)
            
            UserDefaults.standard.set(timeAsString, forKey: reminderId!)
            UserDefaults.standard.set(true, forKey: "\(reminderId!)STATE" )
            print("UserId set to true: \(reminderId!)STATE")
            
            setReminder(timeString: timeAsString)
        }
    }
    
    
    func setReminder(timeString: String?) {
        print("reminder is saved")
        //get permission to send notifications
        let eventStore = EKEventStore()
        eventStore.requestAccess(
            to: EKEntityType.event, completion: {(granted, error) in
                if !granted {
                    print("Access to store not granted")
                } else {
                    print("Access granted")
                    //self.createReminder(in: eventStore)
                }
            })
        
        //make reminder
        let content = UNMutableNotificationContent()
        content.title = "Meal Log Reminder"
        content.subtitle = "Snap a photo of your \(reminderId!) plate! #PhoneEatsFirst"
        content.sound = UNNotificationSound.default

        // *** Create date ***
        //let date = Date()
        let date = self.timePicked
        
        // *** create calendar object ***
        let calendar = Calendar.current
        //.year, .month, .day,
        let timeComponent = calendar.dateComponents([.hour, .minute], from: date! as Date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: timeComponent, repeats: true)
        
        // choose a random identifier
        
        let request = UNNotificationRequest(identifier: self.reminderId!, content: content, trigger: trigger) // UUID().uuidString
        //print("request saved for:", timeComponent.hour, reminderId ?? "didn't work")
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)
        
        
    }
    
    func unSetReminder() {
        print ("reminder is turned off")
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications() // To remove all delivered notifications
        center.removeAllPendingNotificationRequests()
        UserDefaults.standard.set(false, forKey: "\(reminderId!)STATE" )
        print("UserId set to false: \(reminderId!)STATE")

    }
    
    
    
}

