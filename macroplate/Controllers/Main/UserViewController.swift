//
//  UserViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/5/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class UserViewController: UIViewController {
    
    
    @IBOutlet weak var hyperlinkTextView: UITextView!
    
    var docRef : DocumentReference!
    
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
    
    let aboutHeading : UILabel = {
        let label = UILabel()
        label.text = "About"
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    let aboutBody : UITextView = {
        let label = UITextView()
        label.isEditable = false
        label.isSelectable = true
        label.dataDetectorTypes = .link
        label.text = """
        Platemate is an automatic food tracker powered by Flowaste, a startup with a mission to reduce food waste. We develop deep learning models to recognize and track food.
        """
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.tintColor = .white
        //label.numberOfLines = 7
        return label
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
    
    let switchLabel : UILabel = {
        let label = UILabel()
        label.text = """
        Allow your photos to be used for promotional content: 
        """
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    /*let profileView : UIImageView = {
     let imageView = UIImageView()
     imageView.translatesAutoresizingMaskIntoConstraints = false
     return imageView
     }()
     
     let profilePic : UIImage = {
     let pImage = UIImage(named: "tacoavatar")
     return pImage!
     }()
     
     let mealsRecorded : UILabel = {
     let textView = UILabel()
     textView.text = "Joined July 7, 2020"
     textView.textAlignment = .center
     textView.font    = UIFont(name: "AvenirNext-Regular", size: 14)
     textView.textColor = .lightGray
     textView.translatesAutoresizingMaskIntoConstraints = false
     return textView
     }()
     
     let userGraph : UIImage = {
     let gImage = UIImage(named: "usergraph.png")
     return gImage!
     }()
     
     let graphView : UIImageView = {
     let gView = UIImageView()
     gView.translatesAutoresizingMaskIntoConstraints = false
     
     return gView
     }()*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTextView()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background_gradient.png")?.draw(in: self.view.bounds)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }else{
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
        }
        
        self.view.addSubview(name)
        self.personButton.setBackgroundImage(personImage, for: .normal)
        self.view.addSubview(personButton)
        self.view.addSubview(aboutHeading)
        self.view.addSubview(aboutBody)
        self.view.addSubview(useHeading)
        self.view.addSubview(useBody)
        
        
        let switchOnOff = UISwitch(frame:CGRect(x: 300, y: 550, width: 0, height: 0))
        switchOnOff.addTarget(self, action: #selector(UserViewController.switchStateDidChange(_:)), for: .valueChanged)
        switchOnOff.setOn(false, animated: false)
        self.view.addSubview(switchOnOff)
        self.view.addSubview(switchLabel)
        
        
        //add components
        //profileView.image = profilePic
        //self.view.addSubview(profileView)
        
        
        // self.view.addSubview(mealsRecorded)
        //mealsRecorded.text = "X meals saved to date"
        //graphView.image = userGraph
        //self.view.addSubview(graphView)
        
        
        //get personalized user data
        let db = Firestore.firestore()
        
        let uid = Auth.auth().currentUser!.uid;
        
        let dataGot: Void = db.collection("users").whereField("uid", isEqualTo: uid).getDocuments()
        { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
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
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
        name.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        name.widthAnchor.constraint(equalToConstant: 300).isActive = true
        name.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        personButton.translatesAutoresizingMaskIntoConstraints = false
        personButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55).isActive = true
        personButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55).isActive = true
        personButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        personButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        aboutHeading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55).isActive = true
        aboutHeading.topAnchor.constraint(equalTo: view.topAnchor, constant: 110).isActive = true
        aboutHeading.widthAnchor.constraint(equalToConstant: 300).isActive = true
        aboutHeading.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        aboutBody.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        aboutBody.topAnchor.constraint(equalTo: view.topAnchor, constant: 165).isActive = true
        aboutBody.widthAnchor.constraint(equalToConstant: 300).isActive = true
        aboutBody.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        useHeading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55).isActive = true
        useHeading.topAnchor.constraint(equalTo: view.topAnchor, constant: 325).isActive = true
        useHeading.widthAnchor.constraint(equalToConstant: 300).isActive = true
        useHeading.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        useBody.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        useBody.topAnchor.constraint(equalTo: view.topAnchor, constant: 375).isActive = true
        useBody.widthAnchor.constraint(equalToConstant: 300).isActive = true
        useBody.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        
        switchLabel.translatesAutoresizingMaskIntoConstraints = false
        switchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        switchLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 540).isActive = true
        switchLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        switchLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        /*profileView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
         profileView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
         profileView.widthAnchor.constraint(equalToConstant: 200).isActive = true
         profileView.heightAnchor.constraint(equalToConstant: 200).isActive = true
         
         mealsRecorded.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
         mealsRecorded.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10).isActive = true
         mealsRecorded.widthAnchor.constraint(equalToConstant: 170).isActive = true
         mealsRecorded.heightAnchor.constraint(equalToConstant: 40).isActive = true
         
         graphView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
         graphView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
         graphView.widthAnchor.constraint(equalToConstant: 370).isActive = true
         graphView.heightAnchor.constraint(equalToConstant: 290).isActive = true*/
        
    }
    
    func updateTextView() {
        print("hyperlink tapped")
        let path = "https://www.flowaste.com"
        let text2 = aboutBody.text ?? ""
        let font = aboutBody.font
        let fontColor = aboutBody.textColor
        let attributedString2 = NSAttributedString.makeHyperlink(for: path, in: text2, as: "Flowaste")
        aboutBody.attributedText = attributedString2
        
        let path2 = "https://www.platemate.io/"
        let text = useBody.text ?? ""
        let attributedString = NSAttributedString.makeHyperlink(for: path2, in: text, as: "here")
        useBody.attributedText = attributedString
        
        
        
        aboutBody.font = font
        aboutBody.backgroundColor = .clear//background
        aboutBody.textColor = fontColor
        aboutBody.tintColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        
        useBody.font = font
        useBody.backgroundColor = .clear//background
        useBody.textColor = fontColor
        useBody.tintColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
    }
    
    @objc func switchStateDidChange(_ sender:UISwitch){
        var switchState = ["permissionGranted" : "false"]  as [String : Any]
        
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
                        
                    }
                    else{
                        print("UISwitch state is now Off")
                        switchState = ["permissionGranted" : "false"]
                    }
                    
                    //set the data with the docid
                    db.collection("users").document(docId!).updateData(switchState)  { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(String(describing: docId))")
                        }
                    }
                }
        }
    }
                
}
