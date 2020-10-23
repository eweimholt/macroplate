//
//  HomeViewModel.swift
//  macroplate
//
//  Created by Zachary Sy on 10/23/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import SwiftUI
import AVFoundation
import Combine

class HomeViewModel:ObservableObject{
	
	@Published var showText:Bool = true
	@Published var image:UIImage? = nil
	
	
	
	private var photoCancellable:AnyCancellable?
	
	private var textTime:TimeInterval = 5 // Show the help text for 5 seconds
	
	
	
	// MARK: - Init
	
	init(){
		Timer.scheduledTimer(withTimeInterval: textTime, repeats: false){_ in
			self.showText = false
			print("did a thing")
		}
		
		// Listen for photos
		photoCancellable = NotificationCenter.Publisher(center: .default, name: .photoWasTaken)
			.sink{ notif in
				guard let newImage = notif.object as? UIImage else {
					fatalError("something went wrong with taking the photo")
				}
				
				self.image = newImage
			}
			
	}
}

