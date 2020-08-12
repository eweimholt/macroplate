//
//  MainNavigationController.swift
//  macroplate
//
//  Created by Elise Weimholt on 8/11/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

/*import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if isLoggedIn() {
            //assume user is logged in
            //let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
            
            
            let homeController = HomeViewController()
            viewControllers = [homeController]
        }
        else{
            perform(#selector(showRootViewController), with: nil, afterDelay: 0.01)
        }
        // Do any additional setup after loading the view.
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
        
    }
    
    @objc func showRootViewController() {
        let loginController = ViewController()
        present(loginController, animated: true, completion: nil)
    }


}*/
