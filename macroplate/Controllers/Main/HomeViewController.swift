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

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    //create color dictionaries
    static let primaryBlue = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
    
    let colorA = UIColor.init(displayP3Red: 125/255, green: 234/255, blue: 221/255, alpha: 1) //7deadd
    let colorB = UIColor.init(displayP3Red: 99/255, green: 197/255, blue: 188/255, alpha: 1) //primary //63c5bc
    let colorC = UIColor.init(displayP3Red: 50/255, green: 186/255, blue: 232/255, alpha: 1) //32bae8
    let colorD = UIColor.init(displayP3Red: 49/255, green: 128/255, blue: 194/255, alpha: 1) //3180c2
    let colorE = UIColor.init(displayP3Red: 36/255, green: 101/255, blue: 151/255, alpha: 1) //246597
    
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
        let cImage = UIImage(systemName: "circle", withConfiguration: config)?.withTintColor(primaryBlue, renderingMode: .alwaysOriginal)
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
    
    let barcodeButton : UIButton = {
        let uButton = UIButton()
        uButton.setTitle("BARCODE SCAN ENABLED", for: .normal)
        //uButton.titleLabel?.textColor = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
        uButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 12)
        //uButton.titleLabel?.tintColor = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
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
    
    let transparentBackground : UIButton = {
        let uButton = UIButton()
        uButton.translatesAutoresizingMaskIntoConstraints = false
        uButton.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.70)
        uButton.clipsToBounds = true
        return uButton
    }()
    
    let transparentBackground2 : UIButton = {
        let uButton = UIButton() //frame: CGRect(x: 100, y: 100, width: 35, height: 40)
        uButton.translatesAutoresizingMaskIntoConstraints = false
        uButton.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.70)
        uButton.clipsToBounds = true
        return uButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: ViewController())
                navController.navigationBar.barStyle = .black
                self.view.window?.rootViewController = ViewController()
                self.view.window?.makeKeyAndVisible()
            }
        }
        else {
            //set user id for analytics
            let uid = Auth.auth().currentUser!.uid
            Analytics.setUserID(uid)
            
            self.view.addSubview(cameraView)
            self.view.addSubview(transparentBackground)
            self.view.addSubview(transparentBackground2)
            self.view.addSubview(barcodeButton)
            //barcodeButton.titleLabel?.textColor = colorB
            //barcodeButton.titleLabel?.tintColor = colorB
            barcodeButton.setTitleColor(colorB, for: .normal)
            //barcodeButton
            
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
                    videoPreviewLayer?.frame = CGRect(x: -100, y: 0, width: view.frame.width+200, height: view.frame.height) //view.layer.bounds
                    cameraView.layer.addSublayer(videoPreviewLayer!)
                    captureSession?.startRunning()
                }
                catch {
                    print("error setting capture device")
                }
            }
            //photo capture output
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            captureSession?.addOutput(capturePhotoOutput!)
            
            //barcode scan output
            let output = AVCaptureMetadataOutput()
            captureSession?.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main) //AVCaptureMetadataOutputObjectsDelegate
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.ean13,AVMetadataObject.ObjectType.ean8,AVMetadataObject.ObjectType.upce]
        }
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObject.ObjectType.ean13 || object.type == AVMetadataObject.ObjectType.ean8 
                {
                    let alert = UIAlertController(title: "Barcode Detected:", message: "Add to Meal Log?", preferredStyle: .alert) //object.stringValue
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Save", style: .default, handler: {(action) in //UIPasteboard.general.string = object.stringValue
                        let Bar = object.stringValue!
                        //get results
                        //let URL = "https://world.openfoodfacts.org/api/v0/product/\(Bar).json";
                        //let data = URL.downloadURL
                        //print(data)
                        // Add a new document in collection "cities"
                        let db = Firestore.firestore()
                        
                        let date = Date()//NSDate().timeIntervalSince1970 //
                        let timestamp = NSDate().timeIntervalSince1970 //Timestamp(date: date)
                        let uid = Auth.auth().currentUser!.uid
                        
                        let barcodeData = ["BarcodeNumber" : Bar,
                                           "timestamp": timestamp,
                                           "date": date,
                                           "uid" : uid,
                                           "State" : "Pending",
                                           "plateIsEmpty" : "barcode",
                                           "healthDataEvent" : "false"
                        ] as [String : Any]
                        
                        db.collection("posts").addDocument(data: barcodeData) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                print("Document added with Barcode: \(Bar)")
                               // self.transitionToConfirmation() for some reason, it adds two here
                            }
                        }

                    }))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }

private func setUpLayout() {
    
    view.backgroundColor = .black
    
    let deviceWidth = self.view.frame.width
    let deviceHeight = self.view.frame.height
    let w = deviceWidth*0.50
    
    cameraView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    
    transparentBackground.topAnchor.constraint(equalTo: cameraView.topAnchor).isActive = true
    transparentBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    transparentBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    transparentBackground.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -CGFloat(w*8/10)).isActive = true
    
    transparentBackground2.topAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(w*10/8)).isActive = true
    transparentBackground2.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    transparentBackground2.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    transparentBackground2.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor).isActive = true
    
    barcodeButton.topAnchor.constraint(equalTo: transparentBackground2.topAnchor).isActive = true
    barcodeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    barcodeButton.widthAnchor.constraint(equalToConstant: 175).isActive = true
    barcodeButton.heightAnchor.constraint(equalToConstant: 35).isActive = true

    cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    cameraButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    cameraButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
    cameraButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    
    cameraText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    cameraText.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110).isActive = true
    cameraText.widthAnchor.constraint(equalToConstant: 300).isActive = true
    cameraText.heightAnchor.constraint(equalToConstant: 30).isActive = true
    
    flipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    flipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    flipButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
    flipButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    
    
    userButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    userButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    userButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    userButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    galleryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    galleryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    galleryButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    galleryButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 80).isActive = true
    uploadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    uploadButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
    uploadButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
}


@IBAction func imageCapture(_ sender: Any) {
    
    guard let capturePhotoOutput = self.capturePhotoOutput else { return}
    let photoSettings = AVCapturePhotoSettings()
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
    
    /*let mealVC = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(identifier: "MealsVC") as! MealsViewController
     DispatchQueue.main.async {
     self.present(mealVC, animated: true, completion: nil)
     }*/
    
    let mealsVC = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(identifier: "MealsVC") as? MealsViewController
    
    //swap out root view controller for the home one, once the signup is successful
    view.window?.rootViewController = mealsVC
    view.window?.makeKeyAndVisible()
    //refresh cells
    mealsVC?.mealsCollectionView.reloadData()
    
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
            print("image captured, presenting image VC")
            presentToImageVC(image)
        }
        
    }
    
}



/*extension String {
    func downloadURL(from imgURL: String!) ->  {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) { (data, reponse, error) in
            if error != nil {
                print(error!)
                return
            } else {
                return data
            }
            
            DispatchQueue.main.async {
                //self.image = UIImage(data: data!)
                print(data)
            }
        }
        
        task.resume()
    }
}*/
