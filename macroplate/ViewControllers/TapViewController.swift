//
//  TapViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/16/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit
import HealthKit
import Photos

class TapViewController: UIViewController {
    
    // health kit
    let healthKitStore:HKHealthStore = HKHealthStore()
    
    // Health Kit Data to read/write
    /*@IBOutlet weak var carbAmount: UILabel!
    @IBOutlet weak var proteinAmount: UILabel!
    @IBOutlet weak var fatAmount: UILabel!*/
    
    
    let backButton : UIButton = {
        let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        cButton.setTitle("Back", for: .normal)
        cButton.setTitleColor(.blue, for: .normal) // You can change the TitleColor
        cButton.translatesAutoresizingMaskIntoConstraints = false
        return cButton
    }()
    
    let doneButton : UIButton = {
        let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        cButton.setTitle("Done", for: .normal)
        cButton.setTitleColor(.blue, for: .normal) // You can change the TitleColor
        cButton.translatesAutoresizingMaskIntoConstraints = false
        return cButton
    }()
    
    let healthButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 55, y: 700, width: 300, height: 50))
        button.setTitle("View in Apple Health", for: .normal)
        button.backgroundColor = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        view.addSubview(backButton)
        doneButton.addTarget(self, action: #selector(goToFakeFeed), for: .touchUpInside)
        view.addSubview(doneButton)
        
        healthButton.addTarget(self, action: #selector(healthButtonTapped), for: .touchUpInside)
        self.view.addSubview(healthButton)
        Utilities.styleFilledButton(healthButton)

        
        let plateImage = UIImage(named: "plate")
        let plateImageView = UIImageView(frame: CGRect(x: 15, y: 85, width: 385, height: 385))
        plateImageView.image = plateImage
        view.addSubview(plateImageView)
        
        let chartImage = UIImage(named: "piechart")
        let chartImageView = UIImageView(frame: CGRect(x: 250, y: 500, width: 90, height: 90))
        chartImageView.image = chartImage
        view.addSubview(chartImageView)
        
        chartImageView.translatesAutoresizingMaskIntoConstraints = false
        chartImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chartImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 125).isActive = true
        chartImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        chartImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        setUpLayout()

    }
    
    private func setUpLayout() {
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        

        
    }
    
    
    @IBAction func goBack(_ sender: Any) {
       transitionToFeed()
    }
    
    @IBAction func goToFakeFeed(_ sender: Any) {
        transitionToFake()
    }
    
    @IBAction func healthButtonTapped(_ sender: Any) {
       self.authorizeHealthKitInApp()
       writeToKit()
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
    
    func transitionToFake() {
        

        let fakeViewController = storyboard?.instantiateViewController(identifier: "FakeVC") as? FakeFeedViewController
        
        //swap out root view controller for the home one
        view.window?.rootViewController = fakeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToFeed() {
        

        let feedViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.feedViewController) as? FeedViewController
        
        //swap out root view controller for the home one
        view.window?.rootViewController = feedViewController
        view.window?.makeKeyAndVisible()
        
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
        /*guard let carbs = Double(self.carbAmount.text!) else { return }
        guard let protein = Double(self.proteinAmount.text!) else { return }
        guard let fat = Double(self.fatAmount.text!) else { return }*/
        
        let carbs : Double = 17
        let protein : Double = 8
        let fat : Double = 6
        
        let today = NSDate()
        
        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates) {
            let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: Double(carbs))
            
            let sample = HKQuantitySample(type: type, quantity: quantity, start: today as Date, end: today as Date)
            healthKitStore.save(sample) { (success, error) in
                print("Saved \(success), error \(error ?? nil)")
            }
        }
        
        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein) {
            let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: Double(protein))
            
            let sample = HKQuantitySample(type: type, quantity: quantity, start: today as Date, end: today as Date)
            healthKitStore.save(sample) { (success, error) in
                print("Saved \(success), error \(error ?? nil)")
            }
        }
        
        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal) {
            let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: Double(fat))
            
            let sample = HKQuantitySample(type: type, quantity: quantity, start: today as Date, end: today as Date)
            healthKitStore.save(sample) { (success, error) in
                print("Saved \(success), error \(error ?? nil)")
            }
        }
        
    }


}








/*//
//  ImageViewController.swift
//
//
//  Created by Elise Weimholt on 6/17/20.
//

import UIKit
import Photos
import HealthKit


class ImageViewController: UIViewController {

    // Was photo taken?
    var takenPhoto:UIImage?
    
    // health kit
    let healthKitStore:HKHealthStore = HKHealthStore()
    
    // Health Kit Data to read/write
    @IBOutlet weak var carbAmount: UILabel!
    @IBOutlet weak var proteinAmount: UILabel!
    @IBOutlet weak var fatAmount: UILabel!
    
    // UI image view of taken photo
    @IBOutlet weak var myImageView: UIImageView!
    
    //Identified food
    @IBOutlet weak var mealLabel: UILabel!
    
    // Button object
    @IBOutlet weak var syncHealthButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
        
        if let availableImage = takenPhoto {
            myImageView.image = availableImage
        }
    }
    
    func setUpElements() {
        //style elements
        Utilities.styleHollowButton(syncHealthButton)
        //Utilities.styleLabel(mealLabel)
    }
    
    
    @IBAction func healthSyncTapped(_ sender: Any) {
        self.authorizeHealthKitInApp()
        writeToKit()
        transitionToHome()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    // from https://www.youtube.com/watch?v=0N6pInrmgXg tutorial 6.28.2020
    func writeToKit() {
        guard let carbs = Double(self.carbAmount.text!) else { return }
        guard let protein = Double(self.proteinAmount.text!) else { return }
        guard let fat = Double(self.fatAmount.text!) else { return }
        
        let today = NSDate()
        
        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates) {
            let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: Double(carbs))
            
            let sample = HKQuantitySample(type: type, quantity: quantity, start: today as Date, end: today as Date)
            healthKitStore.save(sample) { (success, error) in
                print("Saved \(success), error \(error ?? nil)")
            }
        }
        
        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryProtein) {
            let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: Double(protein))
            
            let sample = HKQuantitySample(type: type, quantity: quantity, start: today as Date, end: today as Date)
            healthKitStore.save(sample) { (success, error) in
                print("Saved \(success), error \(error ?? nil)")
            }
        }
        
        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryFatTotal) {
            let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: Double(fat))
            
            let sample = HKQuantitySample(type: type, quantity: quantity, start: today as Date, end: today as Date)
            healthKitStore.save(sample) { (success, error) in
                print("Saved \(success), error \(error ?? nil)")
            }
        }
        
    }
    
    func transitionToHome() {
        
        //explained at 1:11:00 on https://www.youtube.com/watch?v=1HN7usMROt8&t=94s
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        //swap out root view controller for the home one, once the signup is successful
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
}*/
