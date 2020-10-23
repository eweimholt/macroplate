//
//  PhotoCapture.swift
//  macroplate
//
//  Created by Zachary Sy on 10/23/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import AVFoundation
import SwiftUI

class PhotoCapture:NSObject, AVCapturePhotoCaptureDelegate{
	static let shared = PhotoCapture()
	
	var photoOutput:AVCapturePhotoOutput = AVCapturePhotoOutput()
	var uiImage:UIImage? = nil
	
	func takePhoto(){
		let photoSettings = AVCapturePhotoSettings()
		
		if let firstAvailablePreviewPhotoPixelFormatTypes = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
			photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: firstAvailablePreviewPhotoPixelFormatTypes]
		}
		
		photoOutput.capturePhoto(with: photoSettings, delegate: self)
	}
	
	// Got the photo
	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
		
		guard let data = photo.fileDataRepresentation(),
			  let image = UIImage(data: data) else {
			return
		}
		uiImage = image
		
		NotificationCenter.default.post(name: .photoWasTaken, object: image)
		
	}
}
