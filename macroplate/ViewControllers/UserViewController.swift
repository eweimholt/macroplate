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

class UserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //text.attributedText = .
 
        //create a standard button
        
        /*let testButton = StandardButton()
        testButton.setTitle("Profile", for: .normal)
        self.view.addSubview(testButton)
        
        testButton.translatesAutoresizingMaskIntoConstraints = false
        testButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        testButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        testButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        testButton.heightAnchor.constraint(equalToConstant: 50).isActive = true*/
        
        let profilePic = UIImage(named: "memoji.png")
        let profileView = UIImageView()
        profileView.image = profilePic
        self.view.addSubview(profileView)
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        profileView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        profileView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        //initialize an instance of Cloud Firestore:
        let db = Firestore.firestore()
        
        //var user = Auth.auth().currentUser;

        let usersRef = db.collection("users").document("gR9admJEP12va9PZ2a9x")
        
        usersRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
        
        //https://firebase.google.com/docs/firestore/query-data/get-data?authuser=0
        usersRef.getDocument { (document, error) in
            // Construct a Result type to encapsulate deserialization errors or
            // successful deserialization. Note that if there is no error thrown
            // the value may still be `nil`, indicating a successful deserialization
            // of a value that does not exist.
            //
            // There are thus three cases to handle, which Swift lets us describe
            // nicely with built-in sum types:
            //
            //      Result
            //        /\
            //   Error  Optional<City>
            //               /\
            //            Nil  City
           /* let result = Result {
              try document?.data(as: City.self)
            }
            switch result {
            case .success(let city):
                if let city = city {
                    // A `City` value was successfully initialized from the DocumentSnapshot.
                    print("City: \(city)")
                } else {
                    // A nil value was successfully initialized from the DocumentSnapshot,
                    // or the DocumentSnapshot was nil.
                    print("Document does not exist")
                }
            case .failure(let error):
                // A `City` value could not be initialized from the DocumentSnapshot.
                print("Error decoding city: \(error)")
            }*/
        }
        
        
        
        let name = UserButton()
        
        name.setTitle("Elise Weimholt", for: .normal)
        self.view.addSubview(name)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        name.topAnchor.constraint(equalTo: view.topAnchor, constant: 185).isActive = true
        name.widthAnchor.constraint(equalToConstant: 170).isActive = true
        name.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let dateJoined = UITextView()
        dateJoined.text = "Joined July 7, 2020"
        dateJoined.textAlignment = .center
        dateJoined.font    = UIFont(name: "AvenirNext-Regular", size: 14)
        dateJoined.textColor = .lightGray
        self.view.addSubview(dateJoined)
        
        dateJoined.translatesAutoresizingMaskIntoConstraints = false
        dateJoined.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        dateJoined.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10).isActive = true
        dateJoined.widthAnchor.constraint(equalToConstant: 170).isActive = true
        dateJoined.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let userGraph = UIImage(named: "usergraph.png")
              let graphView = UIImageView()
              graphView.image = userGraph
              self.view.addSubview(graphView)
              
              graphView.translatesAutoresizingMaskIntoConstraints = false
              graphView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
              graphView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
              graphView.widthAnchor.constraint(equalToConstant: 400).isActive = true
              graphView.heightAnchor.constraint(equalToConstant: 310).isActive = true
        
       /* let txtField: UITextField = UITextField()
        txtField.frame = CGRect(x: 50, y: 50, width: 100, height: 20)
        txtField.backgroundColor = .gray
        self.view.addSubview(txtField)
        */
        //let db = Firestore.firestore()
        //db.collection("users").g
        
        
                      //     db.collection("users").addDocument(data: ["firstname":firstName,"lastname":lastName, "uid": result!.user.uid])
        // Do any additional setup after loading the view.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
