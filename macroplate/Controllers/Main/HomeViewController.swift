//
//  HomeViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 6/6/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//  based on this tutorial: https://www.youtube.com/watch?v=hRRammUA6I8


import UIKit
import AVFoundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import FirebaseAnalytics

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    var backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
    var capturePhotoOutput: AVCapturePhotoOutput?
    let picker = UIImagePickerController()
 
    
    let cameraView : UIView = {
        let camView = UIView()
        camView.translatesAutoresizingMaskIntoConstraints = false
        camView.clipsToBounds = true
        //camView.layer.cornerRadius = 10
        return camView
    }()
   
    // initialize symbols
    
    //ultralight, thin, light, regular, medium, semibold, bold, heavy, black
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
    
    let personImage : UIImage = {
        let config = UIImage.SymbolConfiguration(pointSize: 5, weight: .regular, scale: .large)
        let pImage = UIImage(systemName: "person", withConfiguration: config)?.withTintColor(UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1), renderingMode: .alwaysOriginal)
        return pImage!
    }()
    
    let uploadImage : UIImage = {
        let config = UIImage.SymbolConfiguration(pointSize: 5, weight: .regular, scale: .large)
        let uImage = UIImage(systemName: "square.and.arrow.up", withConfiguration: config)?.withTintColor(UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1), renderingMode: .alwaysOriginal)
        return uImage!
    }()
    
    let galleryImage : UIImage = {
        let config = UIImage.SymbolConfiguration(pointSize: 5, weight: .regular, scale: .large)
        let pImage = UIImage(systemName: "photo.on.rectangle", withConfiguration: config)?.withTintColor(UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1), renderingMode: .alwaysOriginal)
        return pImage!
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
    
    let userButton : UIButton = {
        let uButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        uButton.translatesAutoresizingMaskIntoConstraints = false
        return uButton
    }()
    
    let galleryButton : UIButton = {
        let uButton = UIButton(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        uButton.translatesAutoresizingMaskIntoConstraints = false
        return uButton
    }()
    
    let uploadButton : UIButton = {
        let uButton = UIButton(frame: CGRect(x: 100, y: 100, width: 35, height: 40))
        uButton.translatesAutoresizingMaskIntoConstraints = false
        return uButton
    }()

    
    var cameraText : UILabel = {
        let textLabel = UILabel()
        textLabel.textAlignment = .center
        textLabel.font = UIFont(name: "AvenirNext-Regular", size: 20)
        textLabel.text = "Take a photo of your meal!"
        textLabel.textColor = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //authenticateUser()
        picker.delegate = self //image picker will now listen to delegates. has method called when user is done selecting image

        
        //add elements to view
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: ViewController())
                navController.navigationBar.barStyle = .black
                //self.present(navController, animated: true, completion: nil)
                
                //swap out root view controller for the feed one
                self.view.window?.rootViewController = ViewController()
                self.view.window?.makeKeyAndVisible()
                
                /*let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "rootVC") as? ViewController
                
                self.show(vc!, sender: self)*/
                //self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
        else {
        //set user id for analytics
        let uid = Auth.auth().currentUser!.uid
        Analytics.setUserID(uid)

        self.view.addSubview(cameraView)

        cameraButton.setBackgroundImage(circleImage, for: .normal)
        cameraButton.addTarget(self, action: #selector(imageCapture), for: .touchUpInside)
        self.view.addSubview(cameraButton)
   
        flipButton.setBackgroundImage(flipImage, for: .normal)
        flipButton.addTarget(self, action: #selector(rotateCamera), for: .touchUpInside)
        self.view.addSubview(flipButton)
        
        userButton.setBackgroundImage(personImage, for: .normal)
        userButton.addTarget(self, action: #selector(userTapped), for: .touchUpInside)
        self.view.addSubview(userButton)
        
        galleryButton.setBackgroundImage(galleryImage, for: .normal)
        galleryButton.addTarget(self, action: #selector(galleryTapped), for: .touchUpInside)
        self.view.addSubview(galleryButton)
        
        uploadButton.setBackgroundImage(uploadImage, for: .normal)
        uploadButton.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)
        //uploadButton.setTitle("Upload", for: .normal)
        self.view.addSubview(uploadButton)

        
        self.view.addSubview(cameraText)
        
        setUpLayout()
        
        
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
        
    }
    
    // MARK - APIs
    
    /*func authenticateUser() {
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: ViewController())
                navController.navigationBar.barStyle = .black
                self.present(navController, animated: true, completion: nil)
                
                //swap out root view controller for the feed one
                self.view.window?.rootViewController = ViewController()
                self.view.window?.makeKeyAndVisible()
                
                /*let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "rootVC") as? ViewController
                
                self.show(vc!, sender: self)*/
                //self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
        else {
            
        }
        
    }*/

    
    private func setUpLayout() {
        
        view.backgroundColor = .black
           //view.backgroundColor = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
        
        
        cameraView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        //cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        cameraView.heightAnchor.constraint(equalToConstant: 700).isActive = true
        cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
           
        cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        cameraText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraText.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110).isActive = true
        //cameraText.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        cameraText.widthAnchor.constraint(equalToConstant: 300).isActive = true
        cameraText.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        flipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        flipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        flipButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        flipButton.heightAnchor.constraint(equalToConstant: 35).isActive = true

        
        userButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        userButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        userButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        userButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        galleryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        galleryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        galleryButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        galleryButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 80).isActive = true
        uploadButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70).isActive = true
        uploadButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        uploadButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
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
    
    @IBAction func galleryTapped(_sender: Any) {
        transitionToFeed()
    }
    
    @IBAction func uploadTapped(_sender: Any) {
        //picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("picker selected image!")
            presentToImageVC(image)
            
        } // no editing allowed
            // for edited image: info[UIImagePickerController.InfoKey.editedImage]
        self.dismiss(animated: true, completion: nil)
            
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
        
    func presentToImageVC(_ image : UIImage) {
        let imageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.Storyboard.imageViewController) as! ImageViewController
        imageVC.takenPhoto = image
        
        /*let feedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.Storyboard.feedViewController) as! FeedViewController
        feedVC.feedImage = image*/

        DispatchQueue.main.async {
            self.present(imageVC, animated: true, completion: nil)
        }
    }
    
    func transitionToFeed() {

        /*let mealVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FeedVC") as! FeedViewController
         DispatchQueue.main.async {
             self.present(mealVC, animated: true, completion: nil)
         }*/
        
        let mealVC = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(identifier: "MealsVC") as! MealsViewController
         DispatchQueue.main.async {
             self.present(mealVC, animated: true, completion: nil)
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
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            //print("saved to album")
            //let customAlbum = CustomPhotoAlbum()
            //customAlbum.save(image: image)
            print("image captured, presenting image VC")
            presentToImageVC(image)
        }
        
    }
    
}


