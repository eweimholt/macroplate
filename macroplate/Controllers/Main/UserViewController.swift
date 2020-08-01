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
    
    var docRef : DocumentReference!
    
    let name : UserButton =  {
        let button = UserButton()
        return button
    }()
    
    let profileView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let profilePic : UIImage = {
        let pImage = UIImage(named: "tacoavatar")
        return pImage!
    }()
    
    let dateJoined : UILabel = {
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
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add components
        profileView.image = profilePic
        self.view.addSubview(profileView)
        self.view.addSubview(name)
   
        //self.view.addSubview(dateJoined)
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
                        self.name.setTitle(userFirstName, for: .normal)
                    }
 
                }
            }
        }

        setUpLayout()
        
    }
    
    private func setUpLayout() {
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        name.topAnchor.constraint(equalTo: view.topAnchor, constant: 185).isActive = true
        name.widthAnchor.constraint(equalToConstant: 170).isActive = true
        name.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        profileView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        profileView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        profileView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        /*dateJoined.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        dateJoined.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10).isActive = true
        dateJoined.widthAnchor.constraint(equalToConstant: 170).isActive = true
        dateJoined.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        graphView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        graphView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        graphView.widthAnchor.constraint(equalToConstant: 370).isActive = true
        graphView.heightAnchor.constraint(equalToConstant: 290).isActive = true*/
        
    }
    
}
