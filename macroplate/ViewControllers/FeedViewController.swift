//
//  FeedViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/12/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    
    var characters = ["Link", "Zelda", "Ganondorf", "Midna"]
    
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
    
    let tapButton : UIButton = {
        let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        cButton.setTitle("tap", for: .normal)
        cButton.setTitleColor(.black, for: .normal) // You can change the TitleColor
        cButton.translatesAutoresizingMaskIntoConstraints = false
        return cButton
    }()
    
    //let tableView = UITableView() 

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*//tableView.delegate = .self
        //tableView.dataSource = .self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false*/
        
        let backgroundImage = UIImage(named: "meals1")
        let backImageView = UIImageView(frame: CGRect(x: 7, y: 130, width: 400, height: 650))
        backImageView.image = backgroundImage
        view.addSubview(backImageView)
        
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        view.addSubview(backButton)
        doneButton.addTarget(self, action: #selector(goHome), for: .touchUpInside)
        view.addSubview(doneButton)
        tapButton.addTarget(self, action: #selector(goToTap), for: .touchUpInside)
        view.addSubview(tapButton)
        //view.addSubview(mealLabel)
        

        
        // Do any additional setup after loading the view.
        setUpLayout()
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        
        tapButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 330).isActive = true
        tapButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 250).isActive = true
        tapButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        tapButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        /*mealLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mealLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        mealLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        mealLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true*/
        
        
        /*NSLayoutConstraint.activate([
        tableView.topAnchor.constraint(equalTo: view.topAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])*/
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


/*
extension ViewController : UITableViewDataSource {
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let characters = ["Link", "Zelda", "Ganondorf", "Midna"]
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let characters = ["Link", "Zelda", "Ganondorf", "Midna"]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = characters[indexPath.row]
        return cell
    }
 
}*/
