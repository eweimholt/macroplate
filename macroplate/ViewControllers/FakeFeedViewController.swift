//
//  FakeFeedViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/16/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit

class FakeFeedViewController: UIViewController {
    
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
    
    let saladMeal : UILabel = {
        let label = UILabel()
        var text = """
        Total Calories: 765
        Carbs: 17 g
        Protein: 8 g
        Fat: 6 g
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
    
    let doneButton : UIButton = {
        let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        cButton.setTitle("Done", for: .normal)
        cButton.setTitleColor(.blue, for: .normal) // You can change the TitleColor
        cButton.translatesAutoresizingMaskIntoConstraints = false
        return cButton
    }()

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "meals2")
        let backImageView = UIImageView(frame: CGRect(x: 7, y: 130, width: 400, height: 650))
        backImageView.image = backgroundImage
        view.addSubview(backImageView)
        
        doneButton.addTarget(self, action: #selector(goHome), for: .touchUpInside)
           view.addSubview(doneButton)
        
        view.addSubview(salmonMeal)
        view.addSubview(waitButton)
        view.addSubview(saladMeal)
        
        view.addSubview(mealLabel)
        
        setUpLayout()

    }
    
    @IBAction func goHome(_ sender: Any) {
        transitionToHome()
    }
    
    
    private func setUpLayout() {
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        mealLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100).isActive = true
          mealLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
          mealLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
          mealLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
             waitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
             waitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 170).isActive = true
             waitButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
             waitButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
             
        
             
            
             salmonMeal.topAnchor.constraint(equalTo: view.topAnchor, constant: 410).isActive = true
             salmonMeal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 165).isActive = true
             salmonMeal.widthAnchor.constraint(equalToConstant: 300).isActive = true
             salmonMeal.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        saladMeal.topAnchor.constraint(equalTo: view.topAnchor, constant: 272).isActive = true
        saladMeal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 165).isActive = true
        saladMeal.widthAnchor.constraint(equalToConstant: 300).isActive = true
        saladMeal.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
        
        
    }
    func transitionToHome() {
        

        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        //swap out root view controller for the home one
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    
    


}
