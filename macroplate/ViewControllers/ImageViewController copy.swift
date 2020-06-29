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

    var takenPhoto:UIImage?
    let healthKitStore:HKHealthStore = HKHealthStore()
    
    @IBOutlet weak var myImageView: UIImageView!

    @IBOutlet weak var mealLabel: UILabel!
    
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
        Utilities.styleLabel(mealLabel)
    }
    
    @IBAction func healthSyncTapped(_ sender: Any) {
        self.authorizeHealthKitInApp()
      transitionToHome()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func authorizeHealthKitInApp() {
        
        let healthKitTypesToRead: Set<HKObjectType> = [
            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!, HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!,
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!,
            
        
        ]
        let healthKitTypesToWrite: Set<HKSampleType> = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCarbohydrates)!]
        
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
        //let carbs = Double(self.)
        
    }
    
    func transitionToHome() {
        
        //explained at 1:11:00 on https://www.youtube.com/watch?v=1HN7usMROt8&t=94s
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        //swap out root view controller for the home one, once the signup is successful
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
}


