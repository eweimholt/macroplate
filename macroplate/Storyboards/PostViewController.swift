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
    
    var secondPhoto:UIImage?
    
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
    var timestamp: TimeInterval?
    var isPlateEmpty : String?
    var weekday : String?
    
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
    
    let EOMImageView : UIImageView = {
        let imageView = UIImageView() //frame: CGRect(x: 35, y: 15, width: 300, height: 300))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    // post image
    var EOMImage:UIImage?
    
    var dateText : UITextView = {
     let textView = UITextView()
     textView.isEditable = false
     textView.textAlignment = .left
     textView.font    = UIFont(name: "AvenirNext-Bold", size: 28)
     textView.textColor = .darkGray
     textView.backgroundColor = .white
     textView.translatesAutoresizingMaskIntoConstraints = false
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
    
    let pendingText : UILabel = {
        let label = UILabel()
        var text = """
        Processing...
        Check back in a few days.
        """
        label.text = text
        label.font = UIFont(name: "AvenirNext-Regular", size: 18)
        label.textColor = .darkGray//UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.backgroundColor = UIColor(displayP3Red: 188/255, green: 188/255, blue: 188/255, alpha: 1)
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        return label
    }()

    let healthButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 70, y: 600, width: 300, height: 50))
        button.setTitle("View in Apple Health", for: .normal)
        button.backgroundColor = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let captureSecondPhotoButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.20)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 32)
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
    
    let summaryTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 15
        tableView.isEditing = false
        //tableView.register(NutritionCell.self, forCellReuseIdentifier: "tablecell")
        return tableView
    }()
    //TABLE VIEW DATA
    var characters = ["Link", "Zelda", "Ganondorf", "Midna"]
    
    var nutrition : [Nutrition] = [Nutrition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKitInApp()
        
        //FORMATTING
        view.backgroundColor = .white
        let weekdayDate = timestamp?.getDateFromTimeInterval()
        weekday = weekdayDate?.dayOfWeek()!

        if state == "Pending" {
            switch isPlateEmpty {
            case ("initial"):
                setUpInitial()
            case ("true"):
                setUpCleanPlate()
            case ("false"):
                setUpTwoPhotos()
            default:
                print("default")
                setUpInitial()
            }
        } else {
            if isPlateEmpty == "false" {
                setUpTwoPhotosReady() //TO DO
            } else {
                setUpEmptyReady()
            }
        }
    }
    
    func setUpEmptyReady() {
        
        //NUTRITION DATA
        createNutritionArray()
        summaryTableView.register(NutritionCell.self, forCellReuseIdentifier: "tablecell")
        
        //CALCULATIONS
        postImageView.image = postImage
        dateText.text = "\(weekday ?? ""), \(date ?? "no date")"
        
        
        //LOAD VIEW
        view.addSubview(dateText)
        postImageView.image = postImage
        view.addSubview(postImageView)
        //TABLE VIEW
        view.addSubview(summaryTableView)
        summaryTableView.dataSource = self
        //summaryTableView.delegate = self
        view.addSubview(healthButton)
        healthButton.addTarget(self, action: #selector(healthButtonTapped), for: .touchUpInside)
        Utilities.styleFilledButton(healthButton)

        //setUpLayout
        let cellWidth = self.view.frame.width
        let padding = CGFloat(20)
        let photoWidth = cellWidth - 6*padding
        let height = CGFloat(50)
   
        //CONSTRAINTS
        dateText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        dateText.topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
        dateText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        dateText.heightAnchor.constraint(equalToConstant: height).isActive = true

        postImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postImageView.topAnchor.constraint(equalTo: dateText.bottomAnchor, constant: padding).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: photoWidth).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: photoWidth).isActive = true
        
        summaryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        summaryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        summaryTableView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 40).isActive = true
        //summaryTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        summaryTableView.heightAnchor.constraint(equalToConstant: 175).isActive = true
        
        healthButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        healthButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        healthButton.topAnchor.constraint(equalTo: summaryTableView.bottomAnchor, constant: 40).isActive = true
        //summaryTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        healthButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
 
        checkHealthDataEvent()
    }
    
    func setUpTwoPhotosReady() {
        
        //NUTRITION DATA
        createNutritionArray()
        summaryTableView.register(NutritionCell.self, forCellReuseIdentifier: "tablecell")
        
        //CALCULATIONS
        postImageView.image = postImage
        dateText.text = "\(weekday ?? ""), \(date ?? "no date")"
        
        
        //LOAD VIEW
        view.addSubview(dateText)
        postImageView.image = postImage
        view.addSubview(postImageView)
        EOMImageView.image = EOMImage
        view.addSubview(EOMImageView)
        //TABLE VIEW
        view.addSubview(summaryTableView)
        summaryTableView.dataSource = self
        view.addSubview(healthButton)
        healthButton.addTarget(self, action: #selector(healthButtonTapped), for: .touchUpInside)
        Utilities.styleFilledButton(healthButton)

        //setUpLayout
        let cellWidth = self.view.frame.width
        let padding = CGFloat(20)
        let photoWidth = cellWidth / 2 - 3/2*padding //cellWidth - 6*padding
        let height = CGFloat(50)
   
        //CONSTRAINTS
        dateText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        dateText.topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
        dateText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        dateText.heightAnchor.constraint(equalToConstant: height).isActive = true

        postImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        postImageView.topAnchor.constraint(equalTo: dateText.bottomAnchor, constant: padding).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: photoWidth).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: photoWidth).isActive = true
        
        EOMImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        EOMImageView.topAnchor.constraint(equalTo: dateText.bottomAnchor, constant: padding).isActive = true
        EOMImageView.widthAnchor.constraint(equalToConstant: photoWidth).isActive = true
        EOMImageView.heightAnchor.constraint(equalToConstant: photoWidth).isActive = true
        
        summaryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        summaryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        summaryTableView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 40).isActive = true
        //summaryTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        summaryTableView.heightAnchor.constraint(equalToConstant: 175).isActive = true
        
        healthButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        healthButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        healthButton.topAnchor.constraint(equalTo: summaryTableView.bottomAnchor, constant: 40).isActive = true
        //summaryTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        healthButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
 
        checkHealthDataEvent()
    }
    
    func setUpInitial() {
        postImageView.image = postImage
        
        dateText.text = "\(weekday ?? ""), \(date ?? "no date")"
        
        view.addSubview(dateText)
        view.addSubview(pendingText)
        view.addSubview(postImageView)
        view.addSubview(captureSecondPhotoButton)
        captureSecondPhotoButton.addTarget(self, action: #selector(secondCaptureButtonTapped), for: .touchUpInside)
        
        
        //setUpLayout
        let cellWidth = self.view.frame.width
        let padding = CGFloat(20)
        let photoWidth = cellWidth / 2 - 3/2*padding
        let height = CGFloat(50)
   
        dateText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        dateText.topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
        dateText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        dateText.heightAnchor.constraint(equalToConstant: height).isActive = true

        postImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        postImageView.topAnchor.constraint(equalTo: dateText.bottomAnchor, constant: padding).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: photoWidth).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: photoWidth).isActive = true
        
        captureSecondPhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        captureSecondPhotoButton.topAnchor.constraint(equalTo: dateText.bottomAnchor, constant: padding).isActive = true
        captureSecondPhotoButton.widthAnchor.constraint(equalToConstant: photoWidth).isActive = true
        captureSecondPhotoButton.heightAnchor.constraint(equalToConstant: photoWidth).isActive = true
        
        pendingText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        pendingText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        pendingText.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 2*padding).isActive = true
        pendingText.heightAnchor.constraint(equalToConstant: 175).isActive = true
    }

    func setUpCleanPlate() {
        postImageView.image = postImage
        
        dateText.text = "\(weekday ?? ""), \(date ?? "no date")"
        
        view.addSubview(dateText)
        view.addSubview(pendingText)
        view.addSubview(postImageView)

        //setUpLayout
        let cellWidth = self.view.frame.width
        let padding = CGFloat(20)
        let photoWidth = cellWidth - 6*padding
        let height = CGFloat(50)
   
        dateText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        dateText.topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
        dateText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        dateText.heightAnchor.constraint(equalToConstant: height).isActive = true

        postImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postImageView.topAnchor.constraint(equalTo: dateText.bottomAnchor, constant: padding).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: photoWidth).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: photoWidth).isActive = true
        
        pendingText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        pendingText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        pendingText.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 2*padding).isActive = true
        pendingText.heightAnchor.constraint(equalToConstant: 175).isActive = true
        
    }
    func setUpTwoPhotos() {
        
        postImageView.image = postImage
        
        dateText.text = "\(weekday ?? ""), \(date ?? "no date")"
        
        view.addSubview(dateText)
        view.addSubview(pendingText)
        EOMImageView.image = EOMImage
        view.addSubview(postImageView)
        view.addSubview(EOMImageView)
        
        //setUpLayout
        let cellWidth = self.view.frame.width
        let padding = CGFloat(20)
        let photoWidth = cellWidth / 2 - 3/2*padding
        let height = CGFloat(50)
   
        dateText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        dateText.topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
        dateText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        dateText.heightAnchor.constraint(equalToConstant: height).isActive = true

        postImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        postImageView.topAnchor.constraint(equalTo: dateText.bottomAnchor, constant: padding).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: photoWidth).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: photoWidth).isActive = true
        
        EOMImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        EOMImageView.topAnchor.constraint(equalTo: dateText.bottomAnchor, constant: padding).isActive = true
        EOMImageView.widthAnchor.constraint(equalToConstant: photoWidth).isActive = true
        EOMImageView.heightAnchor.constraint(equalToConstant: photoWidth).isActive = true
        
        pendingText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        pendingText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        pendingText.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 2*padding).isActive = true
        pendingText.heightAnchor.constraint(equalToConstant: 175).isActive = true

    }

    func checkHealthDataEvent() {
        
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

    @IBAction func secondCaptureButtonTapped(_ sender: Any) {
        print("second capture button tapped")
        let secondVC = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(identifier: "SecondVC") as! SecondCaptureViewController
        secondVC.postId = postId
    
        view.window?.rootViewController = secondVC
        view.window?.makeKeyAndVisible()
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
        
        guard let today = dateFormatter.date(from: self.date!) else {
           fatalError("ERROR: Date conversion failed due to mismatched format.")
        }

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

extension PostViewController: UITableViewDataSource {
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
    //return nutrition.count
  }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath) as! NutritionCell
    let currentItem = nutrition[indexPath.row]
    cell.backgroundColor = .gray
    //cell.textLabel?.font =
    cell.selectionStyle = .none
    cell.textLabel?.text = currentItem.nutritionTitle
    cell.nutritionNameLabel.text = currentItem.nutritionUnit
    cell.nutrition = currentItem
    return cell
  }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100 //UITableView.automaticDimension
    }
    
    func createNutritionArray() {
        /*if calories == nil {
            return calories = "10"
        }*/
        nutrition.append(Nutrition(nutritionTitle: "Calories: \(calories ?? "")", nutritionValue: "10", nutritionUnit: "kJ"))
        nutrition.append(Nutrition(nutritionTitle: "Carbs: \(carbs ?? "") g", nutritionValue: "10", nutritionUnit: "g"))
        nutrition.append(Nutrition(nutritionTitle: "Protein: \(protein ?? "") g", nutritionValue: "10", nutritionUnit: "g"))
        nutrition.append(Nutrition(nutritionTitle: "Fat: \(fat ?? "") g", nutritionValue: "10", nutritionUnit: "g"))
    }
}

