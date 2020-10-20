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
                        self.name.setTitle("\(userFirstName) \(userLastName)", for: .normal)
                    }
                    
                }
            }
        }
        setUpLayout()
        
    }
    
    private func setUpLayout() {
        let width = view.frame.width
        
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
        useHeading.topAnchor.constraint(equalTo: remindersTableView.bottomAnchor, constant: 10).isActive = true
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
        
        if let savedTime = UserDefaults.standard.object(forKey: "Breakfast") as? Date {
            breakfastDate = savedTime
        } else {
            breakfastDate = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())
        }
        
        if let savedTime = UserDefaults.standard.object(forKey: "Lunch") as? Date {
            lunchDate = savedTime
        } else {
            lunchDate = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())
        }
        
        if let savedTime = UserDefaults.standard.object(forKey: "Dinner") as? Date {
            dinnerDate = savedTime
        } else {
            dinnerDate = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())
        }
        
        if let savedTime = UserDefaults.standard.object(forKey: "Snack") as? Date {
            snackDate =  savedTime
        } else {
            snackDate = Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())
        }
        
        if let savedState = UserDefaults.standard.object(forKey: "SnackSTATE") as? Bool {
            snackSaved = savedState
        } else {
            snackSaved = false
        }
        
        if let savedState = UserDefaults.standard.object(forKey: "BreakfastSTATE") as? Bool {
            breakfastSaved = savedState
        } else {
            breakfastSaved = false
        }
        
        if let savedState = UserDefaults.standard.object(forKey: "LunchSTATE") as? Bool {
            lunchSaved = savedState
        } else {
            lunchSaved = false
        }
        
        if let savedState = UserDefaults.standard.object(forKey: "DinnerSTATE") as? Bool {
            dinnerSaved = savedState
        } else {
            dinnerSaved = false
        }
        
        reminders.append(Reminders(mealTime: "Breakfast", date: breakfastDate!, isOn: breakfastSaved!))
        reminders.append(Reminders(mealTime: "Lunch", date: lunchDate!, isOn: lunchSaved!))
        reminders.append(Reminders(mealTime: "Dinner", date: dinnerDate!, isOn: dinnerSaved!))
        reminders.append(Reminders(mealTime: "Snack", date: snackDate!, isOn: snackSaved!))
        
    }
    
}

