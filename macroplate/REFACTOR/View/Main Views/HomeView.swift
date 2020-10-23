//
//  HomeView.swift
//  macroplate
//
//  Created by Zachary Sy on 10/23/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import SwiftUI
import AVFoundation

struct HomeView: View {
	@ObservedObject var viewModel = HomeViewModel()
	
    var body: some View {
		ZStack(alignment: .top){
			CameraView()
				.edgesIgnoringSafeArea(.all)
			
			VStack{
				if viewModel.showText{
					Text("This is example text to be used as an example")
						.font(.title)
						.fontWeight(.black)
						.transition(.opacity)
						.animation(.easeIn)
						.padding()
						.background(Color.red)
				}
				
				Button {
					PhotoCapture.shared.takePhoto()
				} label: {
					Text("Tap Me")
					.font(.title)
					.fontWeight(.black)
					.padding()
					.foregroundColor(.white)
					.background(Color.accentColor)
					.clipShape(RoundedRectangle(cornerRadius: 20))
				}
				
				if let image = viewModel.image{
					VStack{
						Image(uiImage: image)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(maxWidth: 500, maxHeight: 500)
							.padding(2)
							.background(Color.black)
						Button{
							viewModel.image = nil
						} label: {
							Text("Clear")
								.font(.title)
								.fontWeight(.black)
								.padding()
								.foregroundColor(.white)
								.background(Color.accentColor)
								.clipShape(RoundedRectangle(cornerRadius: 20))
						}
					}
				}
				
			}
			
		}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
