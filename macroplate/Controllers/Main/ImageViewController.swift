//
//  ImageViewController.swift
//
//
//  Created by Elise Weimholt on 6/17/20.

import UIKit
import Photos
import HealthKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth


class ImageViewController: UIViewController, UITextFieldDelegate {
    
    // Was photo taken?
    var takenPhoto:UIImage?
    
    
    //Firebase setup
    var userStorage = StorageReference()
    //var ref = DatabaseReference()
    
    
    let myImageView : UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 55, y: 175, width: 300, height: 500))
        imageView.translatesAutoresizingMaskIntoConstraints = true
        return imageView
    }()
    
    let sendButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 55, y: 700, width: 300, height: 50))
        button.setTitle("Send to AI Model", for: .normal)
        button.backgroundColor = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
        return button
    }()
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.text = "Please enter what's on your plate to aide the model-in-training:"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    var inputField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        //Set up storage reference
        let storage = Storage.storage().reference(forURL: "gs://flowaste-595b7.appspot.com/")
        
        userStorage = storage.child("users")
        
        inputField = UITextField(frame: CGRect(x: 55, y: 90, width: 300, height: 50))
        inputField.placeholder = "ex. chicken, rice, broccoli"
        Utilities.styleTextField(inputField)
        self.view.addSubview(inputField)
        self.inputField.delegate = self
        
        
        
        self.view.addSubview(myImageView)
        
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        self.view.addSubview(sendButton)
        Utilities.styleFilledButton(sendButton)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(messageLabel)
        
        // Do any additional setup after loading the view.
        setUpLayout()
        
        
        
        if let availableImage = takenPhoto {
            myImageView.image = availableImage
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    private func setUpLayout() {
        
        messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        messageLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        messageLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        //get the timestamp of when image is sent
        let date = Date()
        
        if let user = Auth.auth().currentUser {
            
            let db = Firestore.firestore()
            
            //let storage = Storage.storage().reference(forURL: "gs://flowaste-595b7.appspot.com")
                 
            let ref = db.collection("uploads")
            let docId = ref.document().documentID
            
            let imageRef = self.userStorage.child("\(docId).jpg")
            
            let data = self.myImageView.image!.jpegData(compressionQuality: 0.0) //0.0 is smallest possible compression
            
            let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, err) in
                if err != nil {
                    print(err?.localizedDescription ?? nil!)
                }
                //we have successfully uploaded the photo!
                
                //get a download link of the image of where the code will look for it
                imageRef.downloadURL { (url, er) in
                    if er != nil {
                        print(er?.localizedDescription ?? nil!)
                    }
                    
                    let feed = ["uid": user.uid,
                                "urlToImage" : url!.absoluteString,
                                "name" : user.displayName ?? nil!,
                                "date" : date,
                                "key" : docId,
                                "userTextInput" : self.inputField.text!] as [String : Any]

                    db.collection("uploads").document(docId).setData(feed) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(docId)")
                        }
                    }

                    
                }
                
            }
            uploadTask.resume()
        }
        else{
            print("no user logged in")
        }
        
        //transitionToHome()
        transitionToConfirmation()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func transitionToHome() {
        
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        //swap out root view controller for the home one
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToConfirmation() {
        
        let confirmationViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.confirmationViewController) as? ConfirmationViewController
        
        //swap out root view controller for the feed one
        view.window?.rootViewController = confirmationViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    
    
}

extension ImageViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

