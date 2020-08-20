//
//  PostViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/28/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit
import HealthKit
import Photos
import FirebaseAuth
import Firebase
import FirebaseFirestore

class PostViewController: UIViewController {
    
    // health kit
    let healthKitStore:HKHealthStore = HKHealthStore()
    
    var carbs : String?
    var protein : String?
    var fat : String?
    var calories : String?
    
    var state : String?
    var healthDataEvent : String?
    var postId : String?
    var date: String?
    
    let postImageView : UIImageView = {
        let imageView = UIImageView() //frame: CGRect(x: 35, y: 15, width: 300, height: 300))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    // post image
    var postImage:UIImage?
    
    var dateText : UITextView = {
     let textView = UITextView()
     textView.textAlignment = .center
     textView.font    = UIFont(name: "AvenirNext-Regular", size: 14)
     textView.textColor = .lightGray
     textView.backgroundColor = .white
     textView.translatesAutoresizingMaskIntoConstraints = false
        //textView.text = "Date Here"
     return textView
     }()
    
    var userLabel : UILabel = {
        let textView = UILabel()
        textView.textAlignment = .center
        textView.font    = UIFont(name: "AvenirNext-Regular", size: 18)
        textView.textColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.lineBreakMode = .byWordWrapping
        textView.numberOfLines = 0
        return textView
    }()
    
    var caloriesText : UILabel = {
        let textView = UILabel()
        textView.textAlignment = .center
        textView.font = UIFont(name: "AvenirNext-Bold", size: 18)
        textView.textColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var carbsText : UILabel = {
        let textView = UILabel()
        textView.textAlignment = .center
        textView.font    = UIFont(name: "AvenirNext-Regular", size: 18)
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var proteinText : UILabel = {
        let textView = UILabel()
        textView.textAlignment = .center
        textView.font    = UIFont(name: "AvenirNext-Regular", size: 18)
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var fatText : UILabel = {
        let textView = UILabel()
        textView.textAlignment = .center
        textView.font    = UIFont(name: "AvenirNext-Regular", size: 18)
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    let pendingText : UILabel = {
        let label = UILabel()
        var text = """
        Processing...
        Check back in a few days.
        """
        label.text = text
        label.font = UIFont(name: "AvenirNext-Regular", size: 18)
        label.textColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()

    let annotatedView : UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 35, y: 420, width: 120, height: 120))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    
    let healthButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 70, y: 600, width: 300, height: 50))
        button.setTitle("View in Apple Health", for: .normal)
        button.backgroundColor = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.clipsToBounds = true
        //button.
        return button
    }()
    
    
    let stackView: UIStackView = {
        let sView = UIStackView()
        sView.axis  = NSLayoutConstraint.Axis.vertical
        sView.distribution  = UIStackView.Distribution.fillProportionally
        sView.alignment = UIStackView.Alignment.center
        sView.spacing   = 5
        sView.translatesAutoresizingMaskIntoConstraints = false
        
        return sView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKitInApp()
        
        view.backgroundColor = .white
        
        //self.view.addSubview(postImageView)
        stackView.addArrangedSubview(postImageView)
        postImageView.image = postImage
        stackView.addArrangedSubview(dateText)
        stackView.addArrangedSubview(userLabel)

        if state == "Pending" {
            stackView.addArrangedSubview(pendingText)
            self.view.addSubview(stackView)
            
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
            //stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            //stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40).isActive = true
            setUpLayout()
            //pendingText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            //pendingText.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 10).isActive = true
            pendingText.widthAnchor.constraint(equalToConstant: 300).isActive = true
            pendingText.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
        } else {

            self.stackView.addArrangedSubview(caloriesText)
            self.stackView.addArrangedSubview(carbsText)
            self.stackView.addArrangedSubview(proteinText)
            self.stackView.addArrangedSubview(fatText)
            self.stackView.addArrangedSubview(healthButton)
            self.view.addSubview(stackView)
            
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
            //stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            //stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
            
            healthButton.addTarget(self, action: #selector(healthButtonTapped), for: .touchUpInside)
            Utilities.styleFilledButton(healthButton)
            
            carbsText.text = "Carbs: \(carbs ?? "") g"
            carbsText.textAlignment = .center
            carbsText.textColor = .systemRed
            
            proteinText.text = "Protein: \(protein ?? "") g"
            proteinText.textAlignment = .center
            proteinText.textColor = .systemGreen
            
            fatText.text = "Fat: \(fat ?? "") g"
            fatText.textAlignment = .center
            fatText.textColor = .systemBlue
            
            //dateText.text = "Date logged: \(date))"
            setUpLayout()
            //caloriesText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            //caloriesText.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 10).isActive = true
            caloriesText.widthAnchor.constraint(equalToConstant: 300).isActive = true
            caloriesText.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            //carbsText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
           // carbsText.topAnchor.constraint(equalTo: view.topAnchor, constant: 510).isActive = true
            //carbsText.topAnchor.constraint(equalTo: caloriesText.bottomAnchor, constant: 5).isActive = true
            carbsText.widthAnchor.constraint(equalToConstant: 150).isActive = true
            carbsText.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            //proteinText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            //proteinText.topAnchor.constraint(equalTo: carbsText.bottomAnchor, constant: 5).isActive = true
            proteinText.widthAnchor.constraint(equalToConstant: 150).isActive = true
            proteinText.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            //fatText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            //fatText.topAnchor.constraint(equalTo: proteinText.bottomAnchor, constant: 5).isActive = true
            fatText.widthAnchor.constraint(equalToConstant: 150).isActive = true
            fatText.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            //healthButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            //healthButton.topAnchor.constraint(equalTo: fatText.bottomAnchor, constant: 5).isActive = true
            healthButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
            healthButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            

            if self.healthDataEvent == "false" {
                //write data to the health store
                //write to Health Kit Once
                writeToKit()
                //update healthDataEvent to true
                let switchState = ["healthDataEvent" : "true"]  as [String : Any]
                
                let db = Firestore.firestore()
                //postId =  //self.postId!
                db.collection("posts").document(self.postId!).updateData(switchState)  { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID:\(String(describing:self.postId!)) ")
                    }
                    
                }
            } else
            {
                print("data already saved to HealthKit")
            }
            
            
        }
        
    }
    
    private func setUpLayout() {
        

        //stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        //stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        //stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        //postImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //postImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 80).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: self.view.frame.width - 80).isActive = true

        //dateText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        //dateText.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 10).isActive = true
        dateText.widthAnchor.constraint(equalToConstant: 300).isActive = true
        dateText.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //userLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        //userLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 40).isActive = true
        userLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    @IBAction func healthButtonTapped(_ sender: Any) {
        
        openUrl(urlString: "x-apple-health://")
        
    }
    
    func openUrl(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func authorizeHealthKitInApp() {
        
        let healthKitTypesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!,        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein)!,        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal)!,
            
            
        ]
        let healthKitTypesToWrite: Set<HKSampleType> = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!,HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein)!,        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal)!]
        
        if !HKHealthStore.isHealthDataAvailable()
        {
            print("error occured at health store")
            return
        }
        healthKitStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) -> Void in
            print("Read Write Authorization Succeeded")
        }
        
    }
    
    func writeToKit() {
        let carbs = Double(self.carbs!)!
        let protein = Double(self.protein!)!
        let fat = Double(self.fat!)!

        //get date from post
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormatAs //"MMMM dd, yyyy HH:mm a"
        
        guard let today = dateFormatter.date(from: self.dateText.text!) else {
           fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        
        /*if self.dateText.text != nil {
            let today = dateFormatter.date(from: self.dateText.text!)
        } else {
            let today = Date()
        }*/
        
        //let today = getDateForHealth()
        print("health date is \(self.dateText.text)")
        
        //let today = NSDate() //self.date
        
        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates) {
            let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: Double(carbs))
            
            let sample = HKQuantitySample(type: type, quantity: quantity, start: today as Date, end: today as Date)
            healthKitStore.save(sample) { (success, error) in
                print("Saved \(success), error \(String(describing: error ?? nil))")
            }
        }
        
        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein) {
            let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: Double(protein))
            
            let sample = HKQuantitySample(type: type, quantity: quantity, start: today as Date, end: today as Date)
            healthKitStore.save(sample) { (success, error) in
                print("Saved \(success), error \(String(describing: error ?? nil))")
            }
        }
        
        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal) {
            let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: Double(fat))
            
            let sample = HKQuantitySample(type: type, quantity: quantity, start: today as Date, end: today as Date)
            healthKitStore.save(sample) { (success, error) in
                print("Saved \(success), error \(String(describing: error ?? nil))")
            }
        }

    }
 
    /*func getDateForHealth() {

        
    }*/
    
}
