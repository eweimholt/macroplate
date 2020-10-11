//
//  Food.swift
//  macroplate
//
//  Created by Elise Weimholt on 10/10/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import Foundation
import UIKit
import UIKit
import FirebaseFirestore
import Firebase

//class Food: NSObject {
struct Food {
    var name : String? //kale, raw
    var servingSizeValue : Int?//userServingSize, should be Int
    var servingSizeUnit : String? //grams,
    var individualNutrition : IndivNutrition?
}

