//
//  UserViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/5/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UserNotifications
import UserNotificationsUI
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import EventKit

class UserViewController: UIViewController {
    
    static let colorA = UIColor.init(displayP3Red: 125/255, green: 234/255, blue: 221/255, alpha: 1) //7deadd
    static let colorB = UIColor.init(displayP3Red: 99/255, green: 197/255, blue: 188/255, alpha: 1) //primary //63c5bc
    static let colorC = UIColor.init(displayP3Red: 50/255, green: 186/255, blue: 232/255, alpha: 1) //32bae8
    static let colorD = UIColor.init(displayP3Red: 49/255, green: 128/255, blue: 194/255, alpha: 1) //3180c2
    static let colorE = UIColor.init(displayP3Red: 36/255, green: 101/255, blue: 151/255, alpha: 1) //246597
    
    var dateOnPicker: Date?
    
    var breakfastDate : Date?
    var lunchDate : Date?
    var dinnerDate : Date?
    var snackDate : Date?
    
    var breakfastSaved : Bool?
    var lunchSaved : Bool?
    var dinnerSaved : Bool?
    var snackSaved : Bool? 
    
    @IBOutlet weak var hyperlinkTextView: UITextView!

    var docRef : DocumentReference!
    let remindersId = "remindersId"
    var reminders = [Reminders]()
    var notificationGranted = false

    
    let signOutButton : UIButton = {
        let uButton = UIButton(frame: CGRect(x: 100, y: 100, width: 35, height: 40))
        uButton.translatesAutoresizingMaskIntoConstraints = false
        uButton.setTitle("Sign Out", for: .normal )
        uButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 16)
        return uButton
    }()
    
    let name : UserButton =  {
        let button = UserButton()
        return button
    }()
    
    let personImage : UIImage = {
        let config = UIImage.SymbolConfiguration(pointSize: 5, weight: .regular, scale: .large)
        let pImage = UIImage(systemName: "person", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return pImage!
    }()
    
    let personButton : UIButton = {
        let uButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        uButton.translatesAutoresizingMaskIntoConstraints = false
        return uButton
    }()
    
    let useHeading : UILabel = {
        let label = UILabel()
        label.text = "HOW TO USE"
        label.font = UIFont(name: "AvenirNext-Bold", size: 20)
        label.textColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    let useBody : UITextView = {
        let label = UITextView()
        label.isEditable = false
        label.isSelectable = true
        label.dataDetectorTypes = .link
        label.text = """
        Log your meal with one picture, taken from a bird's eye view above your plate. Check back later for a complete nutritional breakdown, synced to Apple Health. Watch a demo here.
        """
        label.font = UIFont(name: "AvenirNext-Regular", size: 18)
        label.textColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.tintColor = .white
        return label
    }()
    
    let remindersText : UILabel = {
        let label = UILabel()
        var text = "SET A REMINDER"
        label.text = text
        label.font = UIFont(name: "AvenirNext-Bold", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.clipsToBounds = true
        label.textColor = .white
        //label.backgroundColor = .cyan
        //label.textColor = colorB
        //label.layer.cornerRadius = 15
        return label
    }()

    var remindersTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.clipsToBounds = true
        tableView.isEditing = false
        //tableView.largeContentTitle = "Reminders"
        tableView.register(RemindersCell.self, forCellReuseIdentifier: "remindersId")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTextView()

        //set background
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background_gradient.png")?.draw(in: self.view.bounds)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }else{
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
        }
        
        //add elements to view
        self.view.addSubview(name)
        self.personButton.setBackgroundImage(personImage, for: .normal)
        self.view.addSubview(personButton)
        self.view.addSubview(useHeading)
        self.view.addSubview(useBody)
        self.view.addSubview(signOutButton)
        self.view.addSubview(remindersText)
        signOutButton.addTarget(self, action: #selector(handleSignOut), for: .touchUpInside)

        //SET UP TABLE VIEW
        view.addSubview(remindersTableView)
        remindersTableView.dataSource = self
        remindersTableView.delegate = self
        remindersTableView.isOpaque = false
        remindersTableView.backgroundView?.isOpaque = false
        remindersTableView.backgroundColor = .clear
        remindersTableView.rowHeight = 50
        
        createRemindersArray()
        
        //get personalized user data
        let db = Firestore.firestore()
        
        let uid = Auth.auth().currentUser!.uid;
        
        let _: Void = db.collection("users").whereField("uid", isEqualTo: uid).getDocuments()
        { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    
                    if let person = document.data() as? [String:Any] {
                        let userFirstName = person["firstname"] as! String
                        let userLastName = person["lastname"] as! String
                        //let healthFlag = person["permissionGranted"] as! String
                        self.name.setTitle("\(userFirstName) \(userLastName)", for: .normal)
                    }
                    
                }
            }
        }
        setUpLayout()
    
    }
    
    private func setUpLayout() {
        let width = view.frame.width
        //let height = view.frame.height
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.leadingAnchor.constraint(equalTo: personButton.trailingAnchor, constant: 20).isActive = true
        name.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        name.widthAnchor.constraint(equalToConstant: 300).isActive = true
        name.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        personButton.translatesAutoresizingMaskIntoConstraints = false
        personButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        personButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        personButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        personButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        useHeading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        useHeading.topAnchor.constraint(equalTo: remindersTableView.bottomAnchor, constant: 40).isActive = true
        useHeading.widthAnchor.constraint(equalToConstant: width - 80).isActive = true
        useHeading.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        signOutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        signOutButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        signOutButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        useBody.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        useBody.topAnchor.constraint(equalTo: useHeading.bottomAnchor).isActive = true
        useBody.widthAnchor.constraint(equalToConstant: width - 40).isActive = true
        useBody.heightAnchor.constraint(equalToConstant: width).isActive = true

        remindersText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        remindersText.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        remindersText.bottomAnchor.constraint(equalTo: remindersTableView.topAnchor, constant: -10).isActive = true
        remindersText.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        remindersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        remindersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        remindersTableView.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 60).isActive = true
        remindersTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func handleSignOut() {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            let navController = UINavigationController(rootViewController: ViewController())
            navController.navigationBar.barStyle = .black
            
            //swap out root view controller for the feed one
            self.view.window?.rootViewController = ViewController()
            self.view.window?.makeKeyAndVisible()

        } catch let error {
            print("Failed to sign out with error..", error)
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
                            print(error!.localizedDescription)
                        } else {
                            print("Access granted")
                            //self.createReminder(in: eventStore)
                        }
                })
        //make reminder
        let content = UNMutableNotificationContent()
        content.title = "Meal Log Reminder"
        content.subtitle = "Snap a photo of your plate! #PhoneEatsFirst"
        content.sound = UNNotificationSound.default

        // *** Create date ***
        //let date = Date()
        let date = self.dateOnPicker

        // *** create calendar object ***
        let calendar = Calendar.current
        //.year, .month, .day,
        let timeComponent = calendar.dateComponents([.hour, .minute], from: date! as Date)
        print("timeComponent is", timeComponent)

        let trigger = UNCalendarNotificationTrigger(dateMatching: timeComponent, repeats: true)

        // choose a random identifier
        let request = UNNotificationRequest(identifier:"test", content: content, trigger: trigger) // UUID().uuidString

        // add our notification request
        UNUserNotificationCenter.current().add(request)
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Reminder Added!", message: "You set a reminder for \(timeString ?? "")", preferredStyle: .alert)

        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }

        // Add the actions
        alertController.addAction(okAction)

        // Present the controller
        self.present(alertController, animated: true, completion: nil)

    }
    
    func unSetReminder() {
        print ("reminder is turned off")
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications() // To remove all delivered notifications
        center.removeAllPendingNotificationRequests()

    }


    func updateTextView() {
        let font = useBody.font
        let fontColor = useBody.textColor
        
        let path2 = "https://www.platemate.io/demo"
        let text = useBody.text ?? ""
        let attributedString = NSAttributedString.makeHyperlink(for: path2, in: text, as: "here")
        useBody.attributedText = attributedString

        useBody.font = font
        useBody.backgroundColor = .clear//background
        useBody.textColor = fontColor
        useBody.tintColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
    }
}

extension UserViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 //UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentItem = self.reminders[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: remindersId, for: indexPath) as! RemindersCell
        cell.selectionStyle = .none
        cell.reminders = currentItem //sets the model to the current Item
        cell.isOpaque = false
        cell.backgroundView = nil
        cell.backgroundView?.isOpaque = false
        cell.backgroundColor = .clear
        //cell.saveButton.isSelected = isOn
        
        switch currentItem.mealTime {
        case ("Breakfast"):
            cell.saveButton.isSelected = currentItem.isOn
            print ("Breakfast saveButton set to: ", breakfastSaved ?? false)
        case ("Lunch"):
            cell.saveButton.isSelected = currentItem.isOn
            print ("Lunch saveButton set to: ", lunchSaved ?? false)
        case ("Dinner"):
            cell.saveButton.isSelected = currentItem.isOn
            print ("DInner saveButton set to: ", breakfastSaved ?? false)
        case ("Snack"):
            cell.saveButton.isSelected = currentItem.isOn
            print ("Snack saveButton set to: ", breakfastSaved ?? false)
        default:
            cell.saveButton.isSelected = false
            print ("default set to false ")
        }
        return cell
    }

    func createRemindersArray() {
        
        if let savedTime = UserDefaults.standard.object(forKey: "Breakfast") as? String {
            print("saved Initial Time is", savedTime, "Breakfast" )
            let formatter4 = DateFormatter()
            formatter4.timeStyle = DateFormatter.Style.short
            breakfastDate = formatter4.date(from: savedTime)
            //breakfastSaved = true
        } else {
            let breakfastTime = "8:00 AM"
            let formatter4 = DateFormatter()
            formatter4.timeStyle = DateFormatter.Style.short
            breakfastDate = formatter4.date(from: breakfastTime)
        }
        
        if let savedTime = UserDefaults.standard.object(forKey: "Lunch") as? String {
            print("saved Initial Time is", savedTime, "Lunch" )
            let formatter4 = DateFormatter()
            formatter4.timeStyle = DateFormatter.Style.short
            lunchDate = formatter4.date(from: savedTime)
            //lunchSaved = true
        } else {
            let lunchTime = "12:00 PM"
            let formatter4 = DateFormatter()
            formatter4.timeStyle = DateFormatter.Style.short
            lunchDate = formatter4.date(from: lunchTime)
        }
        
        if let savedTime = UserDefaults.standard.object(forKey: "Lunch") as? String {
            print("saved Initial Time is", savedTime, "Lunch" )
            let formatter4 = DateFormatter()
            formatter4.timeStyle = DateFormatter.Style.short
            lunchDate = formatter4.date(from: savedTime)
            //lunchSaved = true
        } else {
            let lunchTime = "12:00 PM"
            let formatter4 = DateFormatter()
            formatter4.timeStyle = DateFormatter.Style.short
            lunchDate = formatter4.date(from: lunchTime)
        }
        
        if let savedTime = UserDefaults.standard.object(forKey: "Dinner") as? String {
            print("saved Initial Time is", savedTime, "Dinner" )
            let formatter4 = DateFormatter()
            formatter4.timeStyle = DateFormatter.Style.short
            dinnerDate = formatter4.date(from: savedTime)
            //lunchSaved = true
        } else {
            let dinnerTime = "6:00 PM"
            let formatter4 = DateFormatter()
            formatter4.timeStyle = DateFormatter.Style.short
            dinnerDate = formatter4.date(from: dinnerTime)
        }
        
        if let savedTime = UserDefaults.standard.object(forKey: "Snack") as? String {
            print("saved Initial Time is", savedTime, "Snack" )
            let formatter4 = DateFormatter()
            formatter4.timeStyle = DateFormatter.Style.short
            snackDate = formatter4.date(from: savedTime)
            //lunchSaved = true
        } else {
            let snackTime = "3:00 PM"
            let formatter4 = DateFormatter()
            formatter4.timeStyle = DateFormatter.Style.short
            snackDate = formatter4.date(from: snackTime)
        }
        
        if let savedState = UserDefaults.standard.object(forKey: "SnackSTATE") as? Bool {
            print("SavedSTATE", savedState, "Snack" )
            snackSaved = savedState
        } else {
            snackSaved = false
        }
        
        if let savedState = UserDefaults.standard.object(forKey: "BreakfastSTATE") as? Bool {
            print("SavedSTATE", savedState, "Breakfast" )
            breakfastSaved = savedState
        } else {
            breakfastSaved = false
        }
        
        if let savedState = UserDefaults.standard.object(forKey: "LunchSTATE") as? Bool {
            print("SavedSTATE", savedState, "Lunch" )
            lunchSaved = savedState
        } else {
            lunchSaved = false
        }
        
        if let savedState = UserDefaults.standard.object(forKey: "DinnerSTATE") as? Bool {
            print("SavedSTATE", savedState, "Dinner" )
            dinnerSaved = savedState
        } else {
            dinnerSaved = false
        }
        
        self.reminders.append(Reminders(mealTime: "Breakfast", date: breakfastDate!, isOn: breakfastSaved!))
        reminders.append(Reminders(mealTime: "Lunch", date: lunchDate!, isOn: lunchSaved!))
        reminders.append(Reminders(mealTime: "Dinner", date: dinnerDate!, isOn: dinnerSaved!))
        reminders.append(Reminders(mealTime: "Snack", date: snackDate!, isOn: snackSaved!))
     
    }

}


/**
 @objc func switchStateDidChange(_ sender:UISwitch){
     //var switchState = ["permissionGranted" : "false"]  as [String : Any]
     var switchState:[String : Any]?
     
     let db = Firestore.firestore()
     let uid = Auth.auth().currentUser!.uid
     var docId : String?
     // get docid from a query looking at the uid
     db.collection("users").whereField("uid", isEqualTo: uid)
         .getDocuments() { (querySnapshot, err) in
             if let err = err {
                 print("Error getting documents: \(err)")
                 
             } else {
                 for document in querySnapshot!.documents {
                     let doc = document.data()
                     docId = doc["did"] as? String
                 }
                 
                 
                 if (sender.isOn == true){
                     print("UISwitch state is now ON")
                     switchState = ["permissionGranted" : "true"]
                     sender.setOn(true, animated: true)
                     //need to remember animation
                 }
                 else{
                     print("UISwitch state is now Off")
                     switchState = ["permissionGranted" : "false"]
                     sender.setOn(false, animated: true)
                 }
                 
                 //set the data with the docid
                 db.collection("users").document(docId!).updateData(switchState!)  { err in
                     if let err = err {
                         print("Error adding document: \(err)")
                     } else {
                         print("Document added with ID: \(String(describing: docId))")
                     }
                 }
             }     //return sender state
     }
 }
 */
