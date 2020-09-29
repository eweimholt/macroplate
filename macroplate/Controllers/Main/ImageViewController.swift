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
    
    var takenPhoto:UIImage?
    
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
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.text = "Please add a label describing what's on your plate:"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    var inputField: UITextField = {
        var tField = UITextField(frame: CGRect(x: 55, y: 110, width: 300, height: 40))
        //tField.placeholder = "ex. chicken, rice, brocolli"
        tField.clipsToBounds = true
        tField.attributedPlaceholder = NSAttributedString(string: "ex. chicken, rice, broccoli", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        tField.textColor = .black
        tField.translatesAutoresizingMaskIntoConstraints = false
        tField.textAlignment = .left
        
        return tField
    }()
    
    let restaurantLabel : UILabel = {
        let label = UILabel()
        label.text = "Restaurant, if applicable: "
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    var restaurantField: UITextField = {
        var tField = UITextField(frame: CGRect(x: 55, y: 110, width: 300, height: 40))
        //tField.placeholder = "ex. chicken, rice, brocolli"
        tField.clipsToBounds = true
        tField.attributedPlaceholder = NSAttributedString(string: "ex: Domino's", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        tField.textColor = .black
        tField.textAlignment = .left
        tField.translatesAutoresizingMaskIntoConstraints = false
        
        return tField
    }()
    
    let imageInputErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "Please add a label describing what's on your plate:"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.textColor = .red
        return label
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.hideKeyboardWhenTappedAround()
        
        //Set up storage reference
        let storage = Storage.storage().reference(forURL: "gs://flowaste-595b7.appspot.com/")
        
        userStorage = storage.child("users")
        
        //load view
        stackView.addArrangedSubview(messageLabel)
        stackView.addArrangedSubview(inputField)
        //stackView.addArrangedSubview(restaurantLabel)
        //stackView.addArrangedSubview(restaurantField)
        stackView.addArrangedSubview(myImageView)
        stackView.addArrangedSubview(sendButton)
        stackView.addArrangedSubview(imageInputErrorLabel)
        self.view.addSubview(stackView)

        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        self.inputField.delegate = self
        
        // Do any additional setup after loading the view.
        setUpLayout()
        
        
        //set image view with photo
        if let availableImage = takenPhoto {
            myImageView.image = availableImage
        }
    }

    private func setUpLayout() {
        

        let stackWidth = self.view.frame.width - 80
        let componentHeight = 50
        
        imageInputErrorLabel.alpha = 0
        Utilities.styleInputField(inputField, stackWidth)
        Utilities.styleInputField(restaurantField, stackWidth)
        Utilities.styleFilledButton(sendButton)

        
        //Constraints
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        messageLabel.widthAnchor.constraint(equalToConstant: stackWidth).isActive = true //equalToConstant: 300
        messageLabel.heightAnchor.constraint(equalToConstant: CGFloat(componentHeight)).isActive = true
        
        inputField.widthAnchor.constraint(equalToConstant: stackWidth).isActive = true
        inputField.heightAnchor.constraint(equalToConstant: CGFloat(componentHeight-10)).isActive = true
        
        restaurantLabel.widthAnchor.constraint(equalToConstant: stackWidth).isActive = true //equalToConstant: 300
        restaurantLabel.heightAnchor.constraint(equalToConstant: CGFloat(componentHeight-20)).isActive = true
        
        restaurantField.widthAnchor.constraint(equalToConstant: stackWidth).isActive = true
        restaurantField.heightAnchor.constraint(equalToConstant: CGFloat(componentHeight-10)).isActive = true
        
        imageInputErrorLabel.widthAnchor.constraint(equalToConstant: stackWidth).isActive = true
        imageInputErrorLabel.heightAnchor.constraint(equalToConstant: CGFloat(componentHeight)).isActive = true
        
        
        myImageView.widthAnchor.constraint(equalToConstant: stackWidth).isActive = true
        myImageView.heightAnchor.constraint(equalToConstant: stackWidth).isActive = true
   
        sendButton.widthAnchor.constraint(equalToConstant: stackWidth).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: CGFloat(componentHeight)).isActive = true

        
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        //get the timestamp of when image is sent
        let date = Date()//NSDate().timeIntervalSince1970 //
        let timestamp = NSDate().timeIntervalSince1970 //Timestamp(date: date)
        //print("date set to: \(date)")
        //print("timestamp set to: \(timestamp)")
        
        func validateFields() -> String? {
            
            //check that all fields are filled in
            if  inputField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return """
                Please add a label to aide the
                training of the machine learning model.
                """
            }
            
            return nil
        }
        
        //Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // there's something wrong with the fields, show error message
            showError(error!)
            print("error - invalidated field")
            
        } else{
            
            if let user = Auth.auth().currentUser {
                let db = Firestore.firestore()
                let ref = db.collection("posts")
                let docId = ref.document().documentID
                
                let imageRef = self.userStorage.child("\(docId).jpg")
                
                let data = self.myImageView.image!.jpegData(compressionQuality: 0.0) //0.0 is smallest possible compression
                
                let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, err) in
                    if err != nil {
                        print(err?.localizedDescription ?? "nil")
                    }
                    imageRef.downloadURL { (url, er) in
                        if er != nil {
                            print(er?.localizedDescription ?? "nil")
                        }
                        
                        let feed = ["uid": user.uid,
                                    "urlToImage" : url!.absoluteString,
                                    "name" : user.displayName ?? "nil",
                                    "date" : date,
                                    "timestamp" : timestamp,
                                    "key" : docId,
                                    "userTextInput" : self.inputField.text!,
                                    "carbs" : "",
                                    "protein" : "",
                                    "fat" : "",
                                    "calories" : "",
                                    "State" : "Pending",
                                    "plateIsEmpty" : "initial",
                                    "healthDataEvent" : "false"] as [String : Any]
                        
                        db.collection("posts").document(docId).setData(feed) { err in
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
            transitionToConfirmation()
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
    
    
    func showError(_ message:String) {
        print("Showing Error")
        imageInputErrorLabel.text = message
        imageInputErrorLabel.alpha = 1
        
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

