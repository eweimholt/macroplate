//
//  User.swift
//  macroplate
//
//
// on August 10, 2020
// https://www.makeschool.com/academy/track/build-ios-apps/build-a-photo-sharing-app/keeping-users-logged-in

import Foundation
import Firebase

class User : Codable {
    
    //add a parameter that takes a Bool to decide whether a user should be written to UserDefaults
    /*static func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        
        if writeToUserDefaults {
            //Codable protocol is needed to use JSONEncoder
            if let data = try? JSONEncoder().encode(user) {
                //store the data
                UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
            }
        }

        _current = user
    }*/
}



//  Created by Elise Weimholt on 7/24/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
/*import Foundation
import FirebaseDatabase.FIRDataSnapshot


class User {

    // MARK: - Properties

    let uid: String
    let username: String

    // MARK: - Init

    init(uid: String, username: String) {
        
        init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String
            else { return nil }
            
        self.uid = uid
        self.username = username
    }
}*/
