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

class PostViewController: UIViewController, UITableViewDelegate {
    
    static let colorA = UIColor.init(displayP3Red: 125/255, green: 234/255, blue: 221/255, alpha: 1) //7deadd
    static let colorB = UIColor.init(displayP3Red: 99/255, green: 197/255, blue: 188/255, alpha: 1) //primary //63c5bc
    static let colorC = UIColor.init(displayP3Red: 50/255, green: 186/255, blue: 232/255, alpha: 1) //32bae8
    static let colorD = UIColor.init(displayP3Red: 49/255, green: 128/255, blue: 194/255, alpha: 1) //3180c2
    static let colorE = UIColor.init(displayP3Red: 36/255, green: 101/255, blue: 151/255, alpha: 1) //246597
    
    var secondPhoto:UIImage?
    
    //create an array of posts
    //var foods = [Food]()
    //TABLE VIEW DATA
    var nutrition : [Nutrition] = [Nutrition]()
    var food : [Food] = [Food]()
    //var indivNutrition : IndivNutrition()
    
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
    
    //TO DO: Pass In Meal Summary Food Object
    
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
     textView.font    = UIFont(name: "AvenirNext-Bold", size: 24)
     textView.textColor = colorB //.darkGray
     textView.backgroundColor = .white
     textView.translatesAutoresizingMaskIntoConstraints = false
     return textView
     }()
    
    var userLabel : UILabel = {
        let textView = UILabel()
        textView.textAlignment = .center
        textView.font    = UIFont(name: "AvenirNext-Regular", size: 16)
        textView.textColor = .gray //UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.lineBreakMode = .byWordWrapping
        textView.numberOfLines = 0
        //textView.backgroundColor = .red
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        return label
    }()
    
    let foodText : UILabel = {
        let label = UILabel()
        var text = "IDENTIFIED FOODS"
        label.text = text
        label.font = UIFont(name: "AvenirNext-Bold", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.clipsToBounds = true
        //label.backgroundColor = .cyan
        label.textColor = colorB
        //label.layer.cornerRadius = 15
        return label
    }()
    
    let qtyText : UILabel = {
        let label = UILabel()
        var text = "QTY"
        label.text = text
        label.font = UIFont(name: "AvenirNext-Bold", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.clipsToBounds = true
        //label.backgroundColor = .cyan
        label.textColor = colorB
        //label.layer.cornerRadius = 15
        return label
    }()
    
    let servingSizeText : UILabel = {
        let label = UILabel()
        var text = "SERVING"
        label.text = text
        label.font = UIFont(name: "AvenirNext-Bold", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        label.clipsToBounds = true
        //label.backgroundColor = .cyan
        label.textColor = colorB
        //label.layer.cornerRadius = 15
        return label
    }()

    let healthButton : UIButton = {
        let button = UIButton()
        button.setTitle("View in Apple Health", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20)
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

    let summaryTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = true
        tableView.clipsToBounds = true
        tableView.isEditing = false
        tableView.estimatedRowHeight = 100
        //tableView.spacing
        return tableView
    }()
   
    
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
            switch isPlateEmpty {
            case ("false"):
                setUpTwoPhotosReady()
            case ("barcode"):
                setUpBarcodeReady()
            default:
                setUpEmptyReady()
            }
        }
    }
    func setUpBarcodeReady() {
        createBarcodeFoodArray()
        summaryTableView.register(NutritionCell.self, forCellReuseIdentifier: "tablecell")
        
        dateText.text = "\(weekday ?? ""), \(date ?? "no date")"

        //LOAD VIEW
        view.addSubview(dateText)
        view.addSubview(postImageView)
        postImageView.image = UIImage(named: "barcode.png")
        postImageView.contentMode = .scaleAspectFit
        view.addSubview(foodText)
        view.addSubview(qtyText)
        view.addSubview(servingSizeText)
        //TABLE VIEW
        view.addSubview(summaryTableView)
        summaryTableView.dataSource = self
        summaryTableView.delegate = self
        summaryTableView.backgroundView = nil
        summaryTableView.isOpaque = false
        summaryTableView.backgroundView?.isOpaque = false
        summaryTableView.backgroundColor = .white
        view.addSubview(healthButton)
        healthButton.addTarget(self, action: #selector(healthButtonTapped), for: .touchUpInside)
        Utilities.styleFilledButton(healthButton)

        //setUpLayout
        let cellWidth = self.view.frame.width
        let padding = CGFloat(20)
        let photoWidth = cellWidth*0.5// - 6*padding
        let height = CGFloat(50)
   
        //CONSTRAINTS
        dateText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
        dateText.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        dateText.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        dateText.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        postImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postImageView.topAnchor.constraint(equalTo: dateText.bottomAnchor).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: photoWidth).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: photoWidth).isActive = true

        foodText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        foodText.widthAnchor.constraint(equalToConstant: 120).isActive = true
        foodText.bottomAnchor.constraint(equalTo: summaryTableView.topAnchor, constant: -5).isActive = true
        foodText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        qtyText.trailingAnchor.constraint(equalTo: servingSizeText.leadingAnchor, constant: -10).isActive = true
        qtyText.widthAnchor.constraint(equalToConstant: 50).isActive = true
        qtyText.bottomAnchor.constraint(equalTo: summaryTableView.topAnchor, constant: -5).isActive = true
        qtyText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        servingSizeText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        servingSizeText.widthAnchor.constraint(equalToConstant: 60).isActive = true
        servingSizeText.bottomAnchor.constraint(equalTo: summaryTableView.topAnchor, constant: -5).isActive = true
        servingSizeText.heightAnchor.constraint(equalToConstant: 20).isActive = true

        summaryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        summaryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        summaryTableView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: padding+10).isActive = true
        //summaryTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        summaryTableView.bottomAnchor.constraint(equalTo: healthButton.topAnchor, constant: -100).isActive = true

        healthButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        healthButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        healthButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        healthButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
 
        checkHealthDataEvent()
    }
    
    func setUpEmptyReady() {
        createFoodArray()
        summaryTableView.register(NutritionCell.self, forCellReuseIdentifier: "tablecell")
        
        //CALCULATIONS
        postImageView.image = postImage
        dateText.text = "\(weekday ?? ""), \(date ?? "no date")"
        
        
        //LOAD VIEW
        view.addSubview(dateText)
        postImageView.image = postImage
        view.addSubview(postImageView)
        view.addSubview(foodText)
        view.addSubview(qtyText)
        view.addSubview(servingSizeText)
        //TABLE VIEW
        view.addSubview(summaryTableView)
        summaryTableView.dataSource = self
        summaryTableView.delegate = self
        summaryTableView.isOpaque = false
        summaryTableView.backgroundView?.isOpaque = false
        summaryTableView.backgroundColor = .white
        view.addSubview(healthButton)
        healthButton.addTarget(self, action: #selector(healthButtonTapped), for: .touchUpInside)
        Utilities.styleFilledButton(healthButton)

        //setUpLayout
        let cellWidth = self.view.frame.width
        let padding = CGFloat(20)
        let photoWidth = cellWidth*0.7// - 6*padding
        let height = CGFloat(50)
   
        //CONSTRAINTS
        dateText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
        dateText.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        dateText.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        dateText.heightAnchor.constraint(equalToConstant: height).isActive = true

        postImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postImageView.topAnchor.constraint(equalTo: dateText.bottomAnchor).isActive = true
        postImageView.widthAnchor.constraint(equalToConstant: photoWidth).isActive = true
        postImageView.heightAnchor.constraint(equalToConstant: photoWidth).isActive = true
        
        foodText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        foodText.widthAnchor.constraint(equalToConstant: 120).isActive = true
        foodText.bottomAnchor.constraint(equalTo: summaryTableView.topAnchor, constant: -5).isActive = true
        foodText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        qtyText.trailingAnchor.constraint(equalTo: servingSizeText.leadingAnchor, constant: -10).isActive = true
        qtyText.widthAnchor.constraint(equalToConstant: 50).isActive = true
        qtyText.bottomAnchor.constraint(equalTo: summaryTableView.topAnchor, constant: -5).isActive = true
        qtyText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        servingSizeText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        servingSizeText.widthAnchor.constraint(equalToConstant: 60).isActive = true
        servingSizeText.bottomAnchor.constraint(equalTo: summaryTableView.topAnchor, constant: -5).isActive = true
        servingSizeText.heightAnchor.constraint(equalToConstant: 20).isActive = true

        summaryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        summaryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        summaryTableView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: padding+10).isActive = true
        //summaryTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        summaryTableView.bottomAnchor.constraint(equalTo: healthButton.topAnchor, constant: -20).isActive = true

        healthButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        healthButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        healthButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        healthButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
 
        checkHealthDataEvent()
    }
    
    func setUpTwoPhotosReady() {
        createFoodArray()
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
        view.addSubview(foodText)
        view.addSubview(qtyText)
        view.addSubview(servingSizeText)
        
        //TABLE VIEW
        view.addSubview(summaryTableView)
        summaryTableView.dataSource = self
        summaryTableView.delegate = self
        summaryTableView.isOpaque = false
        summaryTableView.backgroundView?.isOpaque = false
        summaryTableView.backgroundColor = .white
        //summaryTableView.rowHeight = 40
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
        
        foodText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        foodText.widthAnchor.constraint(equalToConstant: 120).isActive = true
        foodText.bottomAnchor.constraint(equalTo: summaryTableView.topAnchor, constant: -5).isActive = true
        foodText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        qtyText.trailingAnchor.constraint(equalTo: servingSizeText.leadingAnchor, constant: -10).isActive = true
        qtyText.widthAnchor.constraint(equalToConstant: 50).isActive = true
        qtyText.bottomAnchor.constraint(equalTo: summaryTableView.topAnchor, constant: -5).isActive = true
        qtyText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        servingSizeText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        servingSizeText.widthAnchor.constraint(equalToConstant: 60).isActive = true
        servingSizeText.bottomAnchor.constraint(equalTo: summaryTableView.topAnchor, constant: -5).isActive = true
        servingSizeText.heightAnchor.constraint(equalToConstant: 20).isActive = true

        summaryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        summaryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        summaryTableView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: padding+10).isActive = true
        //summaryTableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        summaryTableView.bottomAnchor.constraint(equalTo: healthButton.topAnchor, constant: -20).isActive = true

        healthButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        healthButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        healthButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        healthButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
 
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
        pendingText.heightAnchor.constraint(equalToConstant: 160).isActive = true

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
        dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm" //"MMMM dd, yyyy HH:mm a" // Constants.dateFormatAs
        
        guard let today = self.timestamp?.getDateFromTimeInterval() else {
            fatalError("Guard date in writeToKit() failed")
        }
        
       /* guard let today = dateFormatter.date(from: self.date!) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }*/
        
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
        return food.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath) as! NutritionCell
        //let currentItem = nutrition[indexPath.row]
        let currentItem = food[indexPath.row]
        cell.selectionStyle = .none//.default
        cell.backgroundColor = PostViewController.colorE //.lightGray
        cell.food = currentItem
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableView.automaticDimension
        return 188
        //return tableView.

    }

    func createFoodArray() {
        let db = Firestore.firestore()
        db.collection("posts").document(postId ?? "DNE").collection("individualFoods")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")

                } else {
                    for document in querySnapshot!.documents {
                        let doc = document.data()
                        
                        let foodName = doc["name"] as? String
                        let foodServingSizeValue = doc["userServingCount"] as? NSNumber ?? 1 //need to change this to NsNumber
                        var multiple = doc["servingSize_100g"] as? Int ?? 1
                        multiple = multiple * 100
                        let foodServingSizeUnit = "(\(multiple) g)"
                        let foodCarbs = (doc["carbs"] as? NSNumber)!
                        let foodCals = (doc["calories"] as? NSNumber)!
                        let foodProtein = (doc["protein"] as? NSNumber)!
                        let foodFat = (doc["fat"] as? NSNumber)!
                        
                        let newFood = Food(name: foodName, servingSizeValue: foodServingSizeValue, servingSizeUnit: foodServingSizeUnit, individualNutrition: IndivNutrition(carbs: foodCarbs, cals: foodCals, protein: foodProtein, fat: foodFat))

                        self.food.append(newFood)
                        
                    }
                   
                    let newNutrition = IndivNutrition(carbs: NSNumber(value:Int(self.carbs!)!), cals: NSNumber(value:Int(self.calories!)!), protein: NSNumber(value:Int(self.protein!)!), fat:  NSNumber(value:Int(self.fat!)!))
                    self.food.append(Food(name: "Meal Summary", servingSizeValue: 0, servingSizeUnit: "", individualNutrition:newNutrition))
                    
                    //blank cell
                    //self.food.append(Food(name: "", servingSizeValue: 0, servingSizeUnit: "", individualNutrition:IndivNutrition(carbs: 0, cals: 0, protein: 0, fat: 0)))
                    self.summaryTableView.reloadData()
                }
            }
    }
    
    func createBarcodeFoodArray() {
        let db = Firestore.firestore()
        db.collection("posts").document(postId ?? "DNE")
            .getDocument { (document, error) in
            if let document = document, document.exists {
                let doc = document.data()
                
                let barName = doc?["name"] as? String
                let servingSizeUnit = doc?["servingSize"] as? String
                let barCals = doc?["calories"] as? String
                let barCarbs = doc?["carbs"] as? String
                let barProtein = doc?["protein"] as? String
                let barFat = doc?["fat"] as? String

                let newNutrition = IndivNutrition(carbs: NSNumber(value:Int(barCarbs!)!), cals: NSNumber(value:Int(barCals!)!), protein: NSNumber(value:Int(barProtein!)!), fat:  NSNumber(value:Int(barFat!)!))
                //let newNutrition = IndivNutrition(carbs: NSNumber(value:barCarbs), cals: NSNumber(value:barCals), protein: NSNumber(value:barProtein), fat:  NSNumber(value:barFat))
                self.food.append(Food(name: barName, servingSizeValue: 1, servingSizeUnit: servingSizeUnit, individualNutrition:newNutrition))
                self.summaryTableView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
    }

}

