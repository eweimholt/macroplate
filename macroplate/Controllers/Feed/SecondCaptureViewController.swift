//
//  SecondCaptureViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 9/18/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import FirebaseAnalytics

class SecondCaptureViewController: UIViewController, UINavigationControllerDelegate {
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    var backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    var capturePhotoOutput: AVCapturePhotoOutput?
    let picker = UIImagePickerController()
    var postId : String?
    
    /*let backButton : UIButton = {
        let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        cButton.setTitle("Back", for: .normal)
        cButton.setTitleColor(.blue, for: .normal) // You can change the TitleColor
        cButton.translatesAutoresizingMaskIntoConstraints = false
        return cButton
    }()*/
    
    var backButton: UIButton = {
        let dButton = UIButton()
        dButton.translatesAutoresizingMaskIntoConstraints = false
        dButton.clipsToBounds = true
        //dButton.setTitleColor(.white, for: .normal)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .large)
        let cImage = UIImage(systemName: "x.circle", withConfiguration: config)?.withTintColor(UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1), renderingMode: .alwaysOriginal)
        dButton.setImage(cImage, for: .normal)
        dButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 20)
        return dButton
    }()
    
    let cameraView : UIView = {
        let camView = UIView()
        camView.translatesAutoresizingMaskIntoConstraints = false
        camView.clipsToBounds = true
        //camView.layer.cornerRadius = 10
        return camView
    }()
    
    let circleImage : UIImage = {
        let config = UIImage.SymbolConfiguration(pointSize: 5, weight: .regular, scale: .large)
        let cImage = UIImage(systemName: "circle", withConfiguration: config)?.withTintColor(UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1), renderingMode: .alwaysOriginal)
        return cImage!
    }()
    
    let flipImage : UIImage = {
        let config = UIImage.SymbolConfiguration(pointSize: 5, weight: .regular, scale: .large)
        let fImage = UIImage(systemName: "camera.rotate", withConfiguration: config)?.withTintColor(UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1), renderingMode: .alwaysOriginal)
        return fImage!
    }()
    
    //initialize buttons
    let cameraButton : UIButton = {
        let cButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        cButton.translatesAutoresizingMaskIntoConstraints = false
        return cButton
    }()
    
    let flipButton : UIButton = {
        let fButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        fButton.translatesAutoresizingMaskIntoConstraints = false
        return fButton
    }()
    
    var cameraText : UILabel = {
        let textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.font = UIFont(name: "AvenirNext-Regular", size: 20)
        textLabel.text = "Take a photo at the end of your meal!"
        textLabel.textColor = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    let transparentBackground : UIButton = {
        let uButton = UIButton(frame: CGRect(x: 100, y: 100, width: 35, height: 40))
        uButton.translatesAutoresizingMaskIntoConstraints = false
        uButton.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.70)
        uButton.clipsToBounds = true
        return uButton
    }()
    
    let transparentBackground2 : UIButton = {
        let uButton = UIButton(frame: CGRect(x: 100, y: 100, width: 35, height: 40))
        uButton.translatesAutoresizingMaskIntoConstraints = false
        uButton.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.70)
        uButton.clipsToBounds = true
        return uButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(cameraView)
        
        self.view.addSubview(transparentBackground)
        self.view.addSubview(transparentBackground2)
        
        cameraButton.setBackgroundImage(circleImage, for: .normal)
        cameraButton.addTarget(self, action: #selector(imageCapture), for: .touchUpInside)
        self.view.addSubview(cameraButton)
        self.view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        flipButton.setBackgroundImage(flipImage, for: .normal)
        flipButton.addTarget(self, action: #selector(rotateCamera), for: .touchUpInside)
        self.view.addSubview(flipButton)
        self.view.addSubview(cameraText)
        
        setUpLayout()
        print("postId at SecondCaptureVC is \(postId ?? "empty")")
        
        
        if #available(iOS 10.2, *) {
            let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            do {
                
                let input = try AVCaptureDeviceInput(device: captureDevice!)
                captureSession = AVCaptureSession()
                captureSession?.addInput(input)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer?.frame = view.layer.bounds
                cameraView.layer.addSublayer(videoPreviewLayer!)
                captureSession?.startRunning()
            }
            catch {
                
                print("error setting capture device")
            }
        }
        
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
        captureSession?.addOutput(capturePhotoOutput!)
    }
    
    private func setUpLayout() {
        
        view.backgroundColor = .black
        
        let deviceWidth = self.view.frame.width
        let deviceHeight = self.view.frame.height
        let w = deviceWidth*0.50

        cameraView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        cameraView.heightAnchor.constraint(equalToConstant: 700).isActive = true
        cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        cameraText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraText.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110).isActive = true
        cameraText.widthAnchor.constraint(equalToConstant: 400).isActive = true
        cameraText.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        flipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        flipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        flipButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        flipButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        transparentBackground.topAnchor.constraint(equalTo: cameraView.topAnchor).isActive = true
        transparentBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        transparentBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        transparentBackground.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -CGFloat(w*8/10)).isActive = true
        
        transparentBackground2.topAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(w*10/8)).isActive = true
        transparentBackground2.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        transparentBackground2.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        transparentBackground2.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor).isActive = true
        
    }
    
    
    @IBAction func imageCapture(_ sender: Any) {
        
        guard let capturePhotoOutput = self.capturePhotoOutput else { return}
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isHighResolutionPhotoEnabled = true
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
        //transitionToSecondImage()
    }
    
    @IBAction func backButtonTapped() {
        
        let mealsVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.mealsViewController) as? MealsViewController
        
        //swap out root view controller for the feed one
        view.window?.rootViewController = mealsVC
        view.window?.makeKeyAndVisible()
    }
    
    func transitionToSecondImage(_ image : UIImage) {
        let secondImageVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.secondImageViewController) as? SecondImageViewController
        secondImageVC!.secondPhoto = image
        secondImageVC!.postId = self.postId
        
        //swap out root view controller for the feed one
        view.window?.rootViewController = secondImageVC
        view.window?.makeKeyAndVisible()
    }

    func switchToFrontCamera() {
        if frontCamera?.isConnected == true {
            captureSession?.stopRunning()
            let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice!)
                captureSession = AVCaptureSession()
                captureSession?.addInput(input)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer?.frame = view.layer.bounds
                cameraView.layer.addSublayer(videoPreviewLayer!)
                captureSession?.startRunning()
                capturePhotoOutput = AVCapturePhotoOutput()
                capturePhotoOutput?.isHighResolutionCaptureEnabled = true
                captureSession?.addOutput(capturePhotoOutput!)
            }
            catch {
                print("error switching to front cam")
            }
        }
    }
    
    func switchToBackCamera() {
        if backCamera?.isConnected == true {
            captureSession?.stopRunning()
            let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice!)
                captureSession = AVCaptureSession()
                captureSession?.addInput(input)
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer?.frame = view.layer.bounds
                cameraView.layer.addSublayer(videoPreviewLayer!)
                captureSession?.startRunning()
                capturePhotoOutput = AVCapturePhotoOutput()
                capturePhotoOutput?.isHighResolutionCaptureEnabled = true
                captureSession?.addOutput(capturePhotoOutput!)
            }
            catch {
                print("error switching to back cam")
            }
        }
    }
    
    @IBAction func rotateCamera(_ sender: Any) {
        
        guard let currentCameraInput:AVCaptureInput = captureSession?.inputs.first else {
            return
        }
        if let input = currentCameraInput as? AVCaptureDeviceInput {
            if input.device.position == .back {
                switchToFrontCamera()
            }
            if input.device.position == .front {
                switchToBackCamera()
            }
        }
    }
}

extension SecondCaptureViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("error in extension guard")
                return
        }
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }
        let capturedImage = UIImage.init(data: imageData,scale: 1.0)
        if let image = capturedImage {
            print("image captured")
            transitionToSecondImage(image)
            //TODO: Save Second Image to Firebase
        }
    }
    
}
