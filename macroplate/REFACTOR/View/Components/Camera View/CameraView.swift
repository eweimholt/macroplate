//
//  CameraView.swift
//  macroplate
//
//  Created by Zachary Sy on 10/23/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//


// https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/avcam_building_a_camera_app


import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {
	typealias Context = UIViewRepresentableContext<Self>
	
	var captureSession = AVCaptureSession()
	
	func makeUIView(context: Context) -> some UIView {
		captureSession.beginConfiguration()
		let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified)
		guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
			captureSession.canAddInput(videoDeviceInput) else { fatalError("Something messed up in Camera View") }
		
		captureSession.addInput(videoDeviceInput)
		
		guard captureSession.canAddOutput(PhotoCapture.shared.photoOutput) else { fatalError("Something messed up in Camera View") }
		captureSession.sessionPreset = .photo
		captureSession.addOutput(PhotoCapture.shared.photoOutput)
		captureSession.commitConfiguration()
		
		let view = PreviewView()
		view.videoPreviewLayer.session = captureSession
		view.videoPreviewLayer.videoGravity = .resizeAspectFill
		
		captureSession.startRunning()
		
		return view
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {
	}
}

class PreviewView: UIView {
	override class var layerClass: AnyClass {
		return AVCaptureVideoPreviewLayer.self
	}
	
	/// Convenience wrapper to get layer as its statically known type.
	var videoPreviewLayer: AVCaptureVideoPreviewLayer {
		return layer as! AVCaptureVideoPreviewLayer
	}
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
