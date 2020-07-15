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
        label.font = UIFont.systemFont(ofSize: 36)
        label.textColor = .black
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        view.addSubview(backButton)
        doneButton.addTarget(self, action: #selector(goHome), for: .touchUpInside)
        view.addSubview(doneButton)
        view.addSubview(mealLabel)
        
        // Do any additional setup after loading the view.
        setUpLayout()
    }
    
    private func setUpLayout() {
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        mealLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mealLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        mealLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        mealLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        print("goBack")
        transitionToConfirmation()
    }
    
    @IBAction func goHome(_ sender: Any) {
        transitionToHome()
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        //swap out root view controller for the home one, once the signup is successful
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    
    func transitionToConfirmation() {
        
        let confirmationViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.confirmationViewController) as? ConfirmationViewController
        
        //swap out root view controller for the feed one
        view.window?.rootViewController = confirmationViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
