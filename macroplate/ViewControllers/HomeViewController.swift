//
//  HomeViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 6/6/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//  based on this tutorial: https://www.youtube.com/watch?v=hRRammUA6I8


import UIKit
import AVFoundation

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    var backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    let cameraView = UIView()
    
    //look up closures/ anon functions
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        //view.backgroundColor = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
        cameraView.translatesAutoresizingMaskIntoConstraints = true
        //cameraView.clipsToBounds = true
        //cameraView.layer.cornerRadius = 10
        view.addSubview(cameraView)

        
        // initialize symbols
        let config = UIImage.SymbolConfiguration(pointSize: 5, weight: .regular, scale: .large)
        //ultralight, thin, light, regular, medium, semibold, bold, heavy, black
        let circleImage = UIImage(systemName: "circle", withConfiguration: config)?.withTintColor(UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1), renderingMode: .alwaysOriginal)
        let flipImage = UIImage(systemName: "camera.rotate", withConfiguration: config)?.withTintColor(UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1), renderingMode: .alwaysOriginal)
        let personImage = UIImage(systemName: "person", withConfiguration: config)?.withTintColor(UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1), renderingMode: .alwaysOriginal)
       
        // create camera Button object
        let cameraButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        cameraButton.setBackgroundImage(circleImage, for: .normal)
        cameraButton.addTarget(self, action: #selector(imageCapture), for: .touchUpInside)
        self.view.addSubview(cameraButton)
        
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        //create camera flip object
        let flipButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        flipButton.setBackgroundImage(flipImage, for: .normal)
        flipButton.addTarget(self, action: #selector(rotateCamera), for: .touchUpInside)
        self.view.addSubview(flipButton)
        
        flipButton.translatesAutoresizingMaskIntoConstraints = false
        flipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        flipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        flipButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        flipButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        //create user Button object
        let userButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        userButton.setBackgroundImage(personImage, for: .normal)
        userButton.addTarget(self, action: #selector(userTapped), for: .touchUpInside)
        self.view.addSubview(userButton)
        
        userButton.translatesAutoresizingMaskIntoConstraints = false
        userButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        userButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -107).isActive = true
        userButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        userButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //clean up code with closures later : setupLayout() https://www.youtube.com/watch?v=9RydRg0ZKaI
        
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
                
                //picker.delegate = self
                
                
            }
            catch {
                
                print("error setting capture device")
            }
        }
        
        capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput?.isHighResolutionCaptureEnabled = true
        captureSession?.addOutput(capturePhotoOutput!)
        
    }
    
    
    @IBAction func imageCapture(_ sender: Any) {
        
        guard let capturePhotoOutput = self.capturePhotoOutput else { return}
        let photoSettings = AVCapturePhotoSettings()
        //photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
        
    }
    
    @IBAction func userTapped(_sender: Any) {
        
        //present to ProfileVC
        let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileVC") as! UserViewController
        DispatchQueue.main.async {
            self.present(profileVC, animated: true, completion: nil)
        }
        
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


extension HomeViewController: AVCapturePhotoCaptureDelegate {
    
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
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            print("saved to album")
            let customAlbum = CustomPhotoAlbum()
            customAlbum.save(image: image)
            print("image captured, presenting image VC")
            //present to ImageVC from Brian Advent https://www.youtube.com/watch?v=Zv4cJf5qdu0&t=1511s
            let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PhotoVC") as! ImageViewController
            photoVC.takenPhoto = image
            DispatchQueue.main.async {
                self.present(photoVC, animated: true, completion: nil)
            }
            
        }
        
    }
    
}


/*//following two methods from //https://www.hackingwithswift.com/read/10/4/importing-photos-with-uiimagepickercontroller 6.6.1010
 func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
 print("inside  imagePickerController")
 guard let image = info[.editedImage] as? UIImage else { return }
 
 let imageName = UUID().uuidString
 let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
 
 if let jpegData = image.jpegData(compressionQuality: 0.8) {
 try? jpegData.write(to: imagePath)
 }
 
 dismiss(animated: true)
 }
 
 func getDocumentsDirectory() -> URL {
 let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
 return paths[0]
 }*/
