//
//  FeedViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/12/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    let mealLabel : UILabel = {
        let label = UILabel()
        label.text = "Your Meals"
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        //label.layer.masksToBounds = true
        //label.layer.cornerRadius = 30
        //label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let backButton : UIButton = {
        let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        cButton.setTitle("Back", for: .normal)
        cButton.setTitleColor(.white, for: .normal) // You can change the TitleColor
        cButton.translatesAutoresizingMaskIntoConstraints = false
        return cButton
    }()
    
    let doneButton : UIButton = {
        let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        cButton.setTitle("Done", for: .normal)
        cButton.setTitleColor(.white, for: .normal) // You can change the TitleColor
        cButton.translatesAutoresizingMaskIntoConstraints = false
        return cButton
    }()
    
    let waitButton : UIButton = {
        let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 100))
        cButton.setTitle("Training in progress", for: .normal)
        cButton.setTitleColor(UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1), for: .normal) // You can change the TitleColor
        cButton.translatesAutoresizingMaskIntoConstraints = false
        return cButton
    }()
    
    let salmonMeal : UILabel = {
        let label = UILabel()
        var text = """
        Total Calories: 950
        Carbs: 21 g
        Protein: 8 g
        Fat: 8 g
        """
        label.text = text
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 4
        return label
    }()
    
    let date1Label : UILabel = {
        let label = UILabel()
        label.text = "20s ago"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    let tapButton : UIButton = {
        let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 100))
        cButton.setTitle("Tap to open!", for: .normal)
        cButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cButton.setTitleColor(UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1), for: .normal) // You can change the TitleColor
        cButton.translatesAutoresizingMaskIntoConstraints = false
        return cButton
    }()
    
    

    
    let date2Label : UILabel = {
        let label = UILabel()
        label.text = "2 days ago"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    

    
    let date3Label : UILabel = {
        let label = UILabel()
        label.text = "3 days ago"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    

    
    
    var imageView : UIImageView = {
     var iView = UIImageView(frame: CGRect(x: 20, y: 140, width: 110, height: 110))
     iView.translatesAutoresizingMaskIntoConstraints = true
     return iView
     }()
    
    var feedImage:UIImage?
    



    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "meals1")
        let backImageView = UIImageView(frame: CGRect(x: 7, y: 130, width: 400, height: 650))
        backImageView.image = backgroundImage
        view.addSubview(backImageView)
        
        /*let plateImage = UIImage(named: "plate")
        imageView.image = plateImage
        view.addSubview(imageView)*/
        
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        view.addSubview(backButton)
        doneButton.addTarget(self, action: #selector(goHome), for: .touchUpInside)
        view.addSubview(doneButton)
        tapButton.addTarget(self, action: #selector(goToTap), for: .touchUpInside)
        
        view.addSubview(mealLabel)
        
       
        view.addSubview(salmonMeal)
        view.addSubview(waitButton)
        //view.addSubview(date1Label)
        
        view.addSubview(tapButton)
        //view.addSubview(date2Label)
        
        
        //view.addSubview(date3Label)

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
        
        mealLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100).isActive = true
        mealLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        mealLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        mealLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
        
        
        

        
    
        
        
        
        tapButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 290).isActive = true
        tapButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 170).isActive = true
        tapButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        tapButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        waitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        waitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 170).isActive = true
        waitButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        waitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
   
        
       
        salmonMeal.topAnchor.constraint(equalTo: view.topAnchor, constant: 410).isActive = true
        salmonMeal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 165).isActive = true
        salmonMeal.widthAnchor.constraint(equalToConstant: 300).isActive = true
        salmonMeal.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
       /* date1Label.topAnchor.constraint(equalTo: waitButton.topAnchor, constant: -40).isActive = true
            date1Label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
            date1Label.widthAnchor.constraint(equalToConstant: 80).isActive = true
            date1Label.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        date2Label.topAnchor.constraint(equalTo: tapButton.topAnchor, constant: -40).isActive = true
           date2Label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
           date2Label.widthAnchor.constraint(equalToConstant: 120).isActive = true
           date2Label.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        date3Label.topAnchor.constraint(equalTo: salmonMeal.topAnchor, constant: -30).isActive = true
        date3Label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        date3Label.widthAnchor.constraint(equalToConstant: 120).isActive = true
        date3Label.heightAnchor.constraint(equalToConstant: 60).isActive = true*/
        
        
        

        
  
    }

    
    @IBAction func goBack(_ sender: Any) {
        transitionToConfirmation()
    }
    
    @IBAction func goHome(_ sender: Any) {
        transitionToHome()
    }
    
    @IBAction func goToTap(_ sender: Any) {
        transitionToTap()
    }

    func transitionToConfirmation() {
        
        let confirmationViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.confirmationViewController) as? ConfirmationViewController
        
        //swap out root view controller for the feed one
        view.window?.rootViewController = confirmationViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToTap() {
        
        let tapViewController = storyboard?.instantiateViewController(identifier: "TapVC") as? TapViewController
        
        //swap out root view controller for the feed one
        view.window?.rootViewController = tapViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToHome() {
        

        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        //swap out root view controller for the home one
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}
