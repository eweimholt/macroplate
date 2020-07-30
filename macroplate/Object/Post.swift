//
//  Post.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/25/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit

class Post: NSObject {

    var name : String!
    var date : String!
    var pathToImage : String!
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
}
