//
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
    
    /*// health kit
    let healthKitStore:HKHealthStore = HKHealthStore()*/
    
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
        /*self.authorizeHealthKitInApp()
        writeToKit()*/
        transitionToHome()
        //transitionToFeed()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*func authorizeHealthKitInApp() {
        
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
        
    }*/
    
    func transitionToHome() {
        
        //explained at 1:11:00 on https://www.youtube.com/watch?v=1HN7usMROt8&t=94s
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        //swap out root view controller for the home one, once the signup is successful
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
}


