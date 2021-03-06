//
//  SecondImageViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 9/19/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//


import UIKit
import Photos
import HealthKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth


class SecondImageViewController: UIViewController {
    
    var secondPhoto:UIImage?
    var postId:String?
    
    //Firebase setup
    var userStorage = StorageReference()
    
    // MARK: Define
    let myImageView : UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 55, y: 175, width: 300, height: 300))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let sendButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 105, y: 500, width: 200, height: 50))
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext", size: 18)
        button.backgroundColor = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stackView: UIStackView = {
        let sView = UIStackView()
        sView.axis  = NSLayoutConstraint.Axis.vertical
        sView.distribution  = UIStackView.Distribution.equalSpacing
        sView.alignment = UIStackView.Alignment.center
        sView.spacing   = 15
        sView.translatesAutoresizingMaskIntoConstraints = false
        
        return sView
    }()
    
    var backButton: UIButton = {
        let dButton = UIButton()
        dButton.translatesAutoresizingMaskIntoConstraints = false
        dButton.clipsToBounds = true
        //dButton.setTitleColor(.white, for: .normal)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold, scale: .large)
        let cImage = UIImage(systemName: "x.circle", withConfiguration: config)?.withTintColor(UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1), renderingMode: .alwaysOriginal)
        dButton.setImage(cImage, for: .normal)
        dButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 24)
        return dButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        print("postId at SIVC is: \(postId ?? "none")")
        //Set up storage reference
        let storage = Storage.storage().reference(forURL: "gs://flowaste-595b7.appspot.com/")
        
        userStorage = storage.child("users_endOfMeal")
        
        //load view
        stackView.addArrangedSubview(myImageView)
        stackView.addArrangedSubview(sendButton)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        self.view.addSubview(stackView)
        
        self.view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        
        // Do any additional setup after loading the view.
        setUpLayout()
        
        //set image view with photo
        if let availableImage = secondPhoto {
            myImageView.image = availableImage
        }
        
        //get postId
        let docId:String?
        if let availableId = postId {
            docId = availableId
            //print("docId set to \(docId)")
        }
    }
    
    private func setUpLayout() {
        
        let stackWidth = self.view.frame.width - 80
        let componentHeight = 50
        
        Utilities.styleFilledButton(sendButton)
        
        
        //Constraints
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        myImageView.widthAnchor.constraint(equalToConstant: stackWidth).isActive = true
        myImageView.heightAnchor.constraint(equalToConstant: stackWidth).isActive = true
        
        sendButton.widthAnchor.constraint(equalToConstant: stackWidth).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: CGFloat(componentHeight)).isActive = true
        
        backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
    }
    
    @IBAction func backButtonTapped() {
        
        let alert = UIAlertController(title: "Are you sure?", message: "This action will delete the photo taken", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default) {action in
            self.transitionToFeed()
        })
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)

    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        //get the timestamp of when image is sent
        let secondDate = Date()//NSDate().timeIntervalSince1970 //
        let secondTimestamp = NSDate().timeIntervalSince1970 //Timestamp(date: date)
        
        //update isPlateEmpty
        
        
        if let user = Auth.auth().currentUser {
            
            let db = Firestore.firestore()
            
            //let storage = Storage.storage().reference(forURL: "gs://flowaste-595b7.appspot.com")
            
            let ref = db.collection("posts")

            let imageRef = self.userStorage.child("EOM_\(postId ?? "postIdNotSaved").jpg") //EOM = End of Meal
            
            let data = self.myImageView.image!.jpegData(compressionQuality: 0.0) //0.0 is smallest possible compression
            
            let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, err) in
                if err != nil {
                    print(err?.localizedDescription ?? "")
                    print("ERROR - URL upload unsuccesfull")
                }
                print("we have successfully uploaded the second photo!")
                
                //get a download link of the image of where the code will look for it
                imageRef.downloadURL { (url, er) in
                    if er != nil {
                        print(er?.localizedDescription ?? "")
                        print("ERROR - imageRef.downloadURL")
                    }
                    
                    let feed = ["urlToEOM" : url!.absoluteString,
                                "EOM_Date" : secondDate,
                                "EOM_Timestamp" : secondTimestamp,
                                "EOM_carbs" : "",
                                "EOM_protein" : "",
                                "EOM_fat" : "",
                                "EOM_calories" : "",
                                "EOM_State" : "Pending",
                                "plateIsEmpty" : "false"] as [String : Any]
                    
                    db.collection("posts").document(self.postId!).updateData(feed) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("EOM Data added with ID: \(self.postId ?? "postId Not Found")")
                            print("calling transition to feed")
                            self.transitionToFeed()
                        }
                    }
                }
            }
            uploadTask.resume()
            
        }
        else{
            print("no user logged in")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func transitionToFeed() {
        print("postId is \(postId ?? "0")")
        let mealsViewController = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(identifier: Constants.Storyboard.mealsViewController) as? MealsViewController
        
        //swap out root view controller for the feed one
        view.window?.rootViewController = mealsViewController
        view.window?.makeKeyAndVisible()
        
        //refresh cells
        mealsViewController?.mealsCollectionView.reloadData()
    }


}


