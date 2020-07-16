//
//  TapViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/16/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit

class TapViewController: UIViewController {
    
    
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
        doneButton.addTarget(self, action: #selector(goToFakeFeed), for: .touchUpInside)
        view.addSubview(doneButton)
        
        let backgroundImage = UIImage(named: "tap")
        let backImageView = UIImageView(frame: CGRect(x: 0, y: 75, width: 415, height: 775))
        backImageView.image = backgroundImage
        view.addSubview(backImageView)
        
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


}
