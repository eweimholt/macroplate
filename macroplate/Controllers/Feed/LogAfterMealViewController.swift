//
//  LogAfterMealViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 9/15/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class LogAfterMealViewController: UIViewController {
    
    var postId : String?
    
    let backButton : UIButton = {
        let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        cButton.setTitle("Back", for: .normal)
        cButton.setTitleColor(.blue, for: .normal) // You can change the TitleColor
        cButton.translatesAutoresizingMaskIntoConstraints = false
        return cButton
    }()
   /*let circleImage : UIImage = {
        let config = UIImage.SymbolConfiguration(pointSize: 5, weight: .regular, scale: .large)
        let cImage = UIImage(systemName: "circle", withConfiguration: config)?.withTintColor(UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1), renderingMode: .alwaysOriginal)
        return cImage!
    }()*/
    
    let cleanPlateButton : UIButton = {
        let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        cButton.setTitle("I finished my plate.", for: .normal)
        cButton.setTitleColor(.black, for: .normal) // You can change the TitleColor
        cButton.translatesAutoresizingMaskIntoConstraints = false
        
        //let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .large)
        cButton.setImage(UIImage(systemName: "checkmark.circle"), for: UIControl.State.normal)
        cButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: UIControl.State.selected)
        return cButton
    }()

    let leftoversButton : UIButton = {
        let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        cButton.setTitle("I had leftovers.", for: .normal)
        cButton.setTitleColor(.black, for: .normal) // You can change the TitleColor
        cButton.translatesAutoresizingMaskIntoConstraints = false
        cButton.setImage(UIImage(systemName: "checkmark.circle"), for: UIControl.State.normal)
        cButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: UIControl.State.selected)
        return cButton
    }()

    let stackView: UIStackView = {
        let sView = UIStackView()
        sView.axis  = NSLayoutConstraint.Axis.vertical
        sView.distribution  = UIStackView.Distribution.equalSpacing
        sView.alignment = .leading
        sView.spacing   = 10
        sView.translatesAutoresizingMaskIntoConstraints = false
        
        return sView
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .white
        
        //load view
        stackView.addArrangedSubview(cleanPlateButton)
        stackView.addArrangedSubview(leftoversButton)
        stackView.addArrangedSubview(captureSecondPhotoButton)
        self.view.addSubview(stackView)
        view.addSubview(backButton)

        cleanPlateButton.addTarget(self, action: #selector(btn_box(sender:)), for: .touchUpInside)
        leftoversButton.addTarget(self, action: #selector(btn_leftovers(sender:)), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        captureSecondPhotoButton.addTarget(self, action: #selector(expandSecondCapture), for: .touchUpInside)

        setUpLayout()
        
        print("postId at LogVC is \(postId ?? "empty")")
        //send postId
        /*let mealsVC = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(identifier: Constants.Storyboard.mealsViewController) as? MealsViewController*/
        //secondImageVC?.postId = postId
        
        //let cellIndexAt = mealsVC.cell
    }
    
    func setUpLayout() {
        let stackWidth = 200 //self.view.frame.width - 80
        let componentHeight = 40

        //Constraints
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        cleanPlateButton.widthAnchor.constraint(equalToConstant: CGFloat(stackWidth)).isActive = true //equalToConstant: 300
        cleanPlateButton.heightAnchor.constraint(equalToConstant: CGFloat(componentHeight)).isActive = true
        
        leftoversButton.widthAnchor.constraint(equalToConstant: CGFloat(stackWidth)).isActive = true
        leftoversButton.heightAnchor.constraint(equalToConstant: CGFloat(componentHeight-10)).isActive = true
        
        captureSecondPhotoButton.widthAnchor.constraint(equalToConstant: CGFloat(stackWidth)*0.5).isActive = true
        captureSecondPhotoButton.heightAnchor.constraint(equalToConstant: CGFloat(stackWidth)*0.5).isActive = true

        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    
    @IBAction func btn_box(sender: UIButton) {
        if cleanPlateButton.isSelected == true {
            cleanPlateButton.isSelected = false
            leftoversButton.isSelected = true
        }
        else {
            cleanPlateButton.isSelected = true
            leftoversButton.isSelected = false
        }
        
        let plateIsEmpty = cleanPlateButton.isSelected.description
        updateFirebaseSecondMeal(value: plateIsEmpty)
    }
    
    @IBAction func btn_leftovers(sender: UIButton) {
        if leftoversButton.isSelected == true {
            leftoversButton.isSelected = false
            cleanPlateButton.isSelected = true
        }
        else {
            leftoversButton.isSelected = true
            cleanPlateButton.isSelected = false
        }
        let plateIsEmpty = cleanPlateButton.isSelected.description
        updateFirebaseSecondMeal(value: plateIsEmpty)
    }
    
    func updateFirebaseSecondMeal(value: String) {
        //To Do: set the default of plateIsEmpty to true.
        
        //if the leftovers button is tapped, set plateIsEmpty to false
        //var plateisEmptyState:[String : Any]?
        
        let db = Firestore.firestore()
        //let uid = Auth.auth().currentUser!.uid
        //var docId : String?
        
        // get docid from a query looking at the uid
        db.collection("posts").document(postId!).updateData([
            "plateIsEmpty" : value
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("plateIsEmpty set to: ", value)
            }
        }
    }

    @IBAction func goBack(_ sender: Any) {
        print("goBack")
        transitionToMeals()
    }
    
    func transitionToMeals() {
        
        let mealsViewController = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(identifier: "MealsVC") as? MealsViewController
        
        //swap out root view controller for the home one, once the signup is successful
        view.window?.rootViewController = mealsViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    
    @IBAction func expandSecondCapture() { //index: Int, postId : String?
        print("second capture tapped")
        
        //pass post data
        let secondVC = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(identifier: "SecondVC") as! SecondCaptureViewController
        secondVC.postId = self.postId
        
        view.window?.rootViewController = secondVC
        view.window?.makeKeyAndVisible()
    }
    
    
}
