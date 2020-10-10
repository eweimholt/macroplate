//
//  Post.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/25/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class Post: NSObject {

    var name : String!
    var date : String!
    var timestamp : TimeInterval!
    var pathToImage : String!
    //var pathToImageANNOTATED : String!
    var pathToEOMImage : String!
    //var pathToEOMImageANNOTATED : String!
    var userId : String!
    var postId : String!
    var userTextInput : String!
    var index : IndexPath!
    
    //nutritional data
    var carbs : String!
    var protein : String!
    var fat : String!
    var calories : String!
    
    //State
    var state : String!
    var healthDataEvent : String!
    var isPlateEmpty : String!
    
    //Barcode
    var servingSize : String!
    var barcodeName : String!
}
