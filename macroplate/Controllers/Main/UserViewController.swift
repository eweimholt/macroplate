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

class UserViewController: UIViewController {

    @IBOutlet weak var hyperlinkTextView: UITextView!

    var docRef : DocumentReference!
    let remindersId = "remindersId"
    var reminders = [Reminders]()
    
    let signOutButton : UIButton = {
        let uButton = UIButton(frame: CGRect(x: 100, y: 100, width: 35, height: 40))
        uButton.translatesAutoresizingMaskIntoConstraints = false
        uButton.setTitle("Sign Out", for: .normal )
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
        label.text = "How To Use"
        label.font = UIFont.systemFont(ofSize: 32)
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
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.tintColor = .white
        return label
    }()

    var remindersTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.clipsToBounds = true
        tableView.isEditing = false
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
        signOutButton.addTarget(self, action: #selector(handleSignOut), for: .touchUpInside)
        self.view.addSubview(signOutButton)
        
        //SET UP TABLE VIEW
        view.addSubview(remindersTableView)
        remindersTableView.dataSource = self
        remindersTableView.delegate = self
        //remindersTableView.rowHeight = 50
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
                    print("\(document.documentID) => \(document.data())")
                    
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
    
    private func setUpLayout() {
        let width = view.frame.width
        let height = view.frame.height
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        name.topAnchor.constraint(equalTo: view.topAnchor, constant: 55).isActive = true
        name.widthAnchor.constraint(equalToConstant: 300).isActive = true
        name.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        personButton.translatesAutoresizingMaskIntoConstraints = false
        personButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55).isActive = true
        personButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55).isActive = true
        personButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        personButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        useHeading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55).isActive = true
        useHeading.topAnchor.constraint(equalTo: view.topAnchor, constant: 325).isActive = true
        useHeading.widthAnchor.constraint(equalToConstant: width - 80).isActive = true
        useHeading.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        signOutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        signOutButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        signOutButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        useBody.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        useBody.topAnchor.constraint(equalTo: view.topAnchor, constant: 375).isActive = true
        useBody.widthAnchor.constraint(equalToConstant: width - 80).isActive = true
        useBody.heightAnchor.constraint(equalToConstant: width).isActive = true
        
        remindersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        remindersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        remindersTableView.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 20).isActive = true
        remindersTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true

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
                }
                //return sender state
        }
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
        return cell
    }
    

    func createRemindersArray() {
     self.reminders.append(Reminders(mealTime: "Breakfast", date: "date1", isOn: "1"))
     reminders.append(Reminders(mealTime: "Lunch", date: "date2", isOn: "2"))
     reminders.append(Reminders(mealTime: "Dinner", date: "date3", isOn: "3"))
     reminders.append(Reminders(mealTime: "Snack", date: "time4", isOn: "4"))
     
    }

}

