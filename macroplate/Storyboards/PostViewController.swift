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

class PostViewController: UIViewController {
    
    // health kit
    let healthKitStore:HKHealthStore = HKHealthStore()
    
    var carbs : String?
    var protein : String?
    var fat : String?
    var calories : String?
    
    var state : String? 
    
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
    
    /*var date : UITextView = {
        let textView = UITextView()
        textView.textAlignment = .center
        textView.font    = UIFont(name: "AvenirNext-Regular", size: 14)
        textView.textColor = .lightGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()*/
    
    var userLabel : UILabel = {
        let textView = UILabel()
        textView.textAlignment = .center
        textView.font    = UIFont(name: "AvenirNext-Regular", size: 18)
        textView.textColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        textView.translatesAutoresizingMaskIntoConstraints = false
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
        AI training in progress!
        Check back in a few days.
        """
        label.text = text
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    /*let pendingView : UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 35, y: 330, width: 300, height: 290))
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .green
        imageView.layer.cornerRadius = 20
        return imageView
    }()*/

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(postImageView)
        postImageView.image = postImage
        
        //annotatedView.image = UIImage(named: "activityring" )
        
        
        //self.view.addSubview(date)
        self.view.addSubview(userLabel)
        self.view.addSubview(caloriesText)

        setUpLayout()
        
        
        if state == "Pending" {
            //self.view.addSubview(pendingView)
            self.view.addSubview(pendingText)
            
            pendingText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            //pendingText.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 150).isActive = true
            pendingText.topAnchor.constraint(equalTo: caloriesText.bottomAnchor, constant: 10).isActive = true
            pendingText.widthAnchor.constraint(equalToConstant: 300).isActive = true
            pendingText.heightAnchor.constraint(equalToConstant: 100).isActive = true
            //print(state!)
        } else {
            //self.view.addSubview(annotatedView)
            self.view.addSubview(carbsText)
            self.view.addSubview(fatText)
            self.view.addSubview(proteinText)
            
            self.view.addSubview(healthButton)
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
            
            self.authorizeHealthKitInApp()
            writeToKit()
            
            carbsText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            carbsText.topAnchor.constraint(equalTo: view.topAnchor, constant: 510).isActive = true
            carbsText.topAnchor.constraint(equalTo: caloriesText.bottomAnchor, constant: 10).isActive = true
            //carbsText.topAnchor.constraint(equalTo: caloriesText.bottomAnchor, constant: 10).isActive = true
            carbsText.widthAnchor.constraint(equalToConstant: 150).isActive = true
            carbsText.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            proteinText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            proteinText.topAnchor.constraint(equalTo: carbsText.bottomAnchor, constant: 10).isActive = true
            proteinText.widthAnchor.constraint(equalToConstant: 150).isActive = true
            proteinText.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            fatText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            fatText.topAnchor.constraint(equalTo: proteinText.bottomAnchor, constant: 10).isActive = true
            fatText.widthAnchor.constraint(equalToConstant: 150).isActive = true
            fatText.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            healthButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            healthButton.topAnchor.constraint(equalTo: fatText.bottomAnchor, constant: 20).isActive = true
            healthButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
            healthButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            //print(state!)
        }

        


    }
    

    private func setUpLayout() {

        /*date.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        date.topAnchor.constraint(equalTo: view.topAnchor, constant: 400).isActive = true
        date.widthAnchor.constraint(equalToConstant: 170).isActive = true
        date.heightAnchor.constraint(equalToConstant: 40).isActive = true*/
        
        postImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        userLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        userLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        userLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        //userLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        caloriesText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        //caloriesText.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60).isActive = true
        caloriesText.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 10).isActive = true
        caloriesText.widthAnchor.constraint(equalToConstant: 300).isActive = true
        caloriesText.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        /*annotatedView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100).isActive = true
        annotatedView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
        annotatedView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        annotatedView.heightAnchor.constraint(equalToConstant: 120).isActive = true*/
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
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!, HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!,
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
        guard let carbs = Double(self.carbsText.text!) else { return }
        guard let protein = Double(self.proteinText.text!) else { return }
        guard let fat = Double(self.fatText.text!) else { return }
        print("\(carbs) written")
        
        
        /*let carbs = 7
        let protein = 10
        let fat = 8;*/
        
        
        let today = NSDate()
        
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
    
}
