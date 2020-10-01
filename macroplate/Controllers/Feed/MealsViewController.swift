//
//  MealsViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/25/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth


class MealsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let cellId = "cell"
    let cleanId = "clean"
    let eomId = "eom"
    let screenSize: CGRect = UIScreen.main.bounds
    
    let backButton : UIButton = {
       let cButton = UIButton()
        cButton.setTitle("Back", for: .normal)
        cButton.setTitleColor(.darkGray, for: .normal) // You can change the TitleColor
        cButton.translatesAutoresizingMaskIntoConstraints = false
       return cButton
    }()

    var mealsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //layout.itemSize = CGSize(width: 300, height: 300)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white //UIColor.clear.withAlphaComponent(0)
        //cv.layer.cornerRadius = 20
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PostCell.self, forCellWithReuseIdentifier: "cell")
        cv.register(CleanPostCell.self, forCellWithReuseIdentifier: "clean")
        cv.register(EOMPostCell.self, forCellWithReuseIdentifier: "eom")
        return cv
    }()
    
    
    //create an array of posts
    var posts = [Post]()
    
    let mealLabel : UILabel = {
        let label = UILabel()
        label.text = "Your Meals"
        label.font = UIFont.systemFont(ofSize: 40)
        label.font = UIFont.init(name: "AvenirNext-Bold", size: 40)
        //label.textColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        //label.backgroundColor = .cyan
        return label
    }()
    
    let initialLabel : UILabel = {
        let label = UILabel()
        label.text = """
        No meals logged yet.
        Take a photo or upload one from your libary.
        """
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(displayP3Red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        view.addSubview(backButton)

        
        view.addSubview(mealsCollectionView)
        mealsCollectionView.dataSource = self
        mealsCollectionView.delegate = self

        self.view.addSubview(self.mealLabel)
        
        setUpLayout()
        
        fetchPosts()
        
    }
    
    func setUpLayout() {
        
        mealsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        mealsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        mealsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        mealsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        mealLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mealLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        mealLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        mealLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }

    
    func fetchPosts() {
        
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser!.uid
        
        db.collection("posts").whereField("uid", isEqualTo: uid).order(by: "date", descending: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")

                } else {
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let doc = document.data()
                        let post = Post()

                        post.name = doc["name"] as? String
                        post.pathToImage = doc["urlToImage"] as? String
                        post.timestamp = doc["timestamp"] as? TimeInterval
                        post.postId = doc["key"] as? String
                        post.userId = doc["uid"] as? String
                        post.userTextInput = doc["userTextInput"] as? String
                        post.carbs = doc["carbs"] as? String
                        post.protein = doc["protein"] as? String
                        post.fat = doc["fat"] as? String
                        post.calories = doc["calories"] as? String
                        post.state = doc["State"] as? String
                        post.healthDataEvent = doc["healthDataEvent"] as? String
                        post.isPlateEmpty = doc["plateIsEmpty"] as? String
                        
                        //End of Meal
                        post.pathToEOMImage = doc["urlToEOM"] as? String
                        //print("EOM string: \(post.pathToEOMImage)")

                        if post.timestamp != nil {
                            post.date = post.timestamp.stringFromTimeInterval()
                        }
                        else {
                            //print("Post timestamp is nil, add view load accordingly here")
                            post.date = Date().toString()
                            post.timestamp = TimeInterval()
                        }
                        
                        if post.isPlateEmpty == nil {
                            post.isPlateEmpty = "DNE"
                        }
                        
                        if post.pathToEOMImage == nil {
                            //post.pathToEOMImage = "none"
                            post.pathToEOMImage =  "DNE" //doc["urlToImage"] as? String
                        } else {
                            post.isPlateEmpty = "false"
                        }
                        
                        self.posts.append(post)
                
                    }
                    
                }
                if self.posts.isEmpty {
                    self.view.addSubview(self.initialLabel)
                    
                    self.initialLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                    self.initialLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
                    self.initialLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
                    self.initialLabel.heightAnchor.constraint(equalToConstant: 300).isActive = true
                }
                else {
                    self.mealsCollectionView.reloadData()
                }
        }

    }

    // UICOLLECTIONVIEW DATA SOURCE
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        //Get UI SCreen size
       let screenWidth = screenSize.width
              //let screenHeight = screenSize.height
        return CGSize(width: screenWidth, height: screenWidth * 0.6)
        //print("cellWidth= ",screenWidth)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return the number of posts
        return self.posts.count
    }
    
    //TO DO: Update Cell When Selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PostCell {
            print("PostCell was tapped")
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        func setUpInitialCell() -> PostCell {
            let cell = mealsCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCell
            
            cell.postImage.downloadImage(from: self.posts[indexPath.row].pathToImage)
            cell.postButton.tag = indexPath.row // set tag
            
            //cell.indicator.setTitle(self.posts[indexPath.row].state, for: .normal)
            
            
            cell.userTextInput = self.posts[indexPath.row].userTextInput
            cell.date = self.posts[indexPath.row].date
            cell.timestamp = self.posts[indexPath.row].timestamp
            
            let weekdayDate = cell.timestamp?.getDateFromTimeInterval()
            let weekday = weekdayDate?.dayOfWeek()!
            let dateString = "\(weekday ?? ""), \(cell.date ?? "no date")"
            cell.headerButton.setTitle(dateString, for: .normal)
            
            //set nutritional data
            cell.calories = self.posts[indexPath.row].calories
            cell.carbs = self.posts[indexPath.row].carbs
            cell.protein = self.posts[indexPath.row].protein
            cell.fat = self.posts[indexPath.row].fat
            
            
            cell.state = self.posts[indexPath.row].state
            cell.postId = self.posts[indexPath.row].postId
            cell.healthDataEvent = self.posts[indexPath.row].healthDataEvent
            cell.isPlateEmpty = self.posts[indexPath.row].isPlateEmpty
            cell.backgroundColor = UIColor.white
            cell.delegate = self
            cell.index = indexPath
            
            // Create Cell Outline
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1.5)
            bottomLine.backgroundColor = UIColor.darkGray.cgColor
            cell.layer.addSublayer(bottomLine)
            
            return cell
        }
        
        func setUpTrueCell() -> PostCell {
            let cell = mealsCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCell
            
            cell.postImage.downloadImage(from: self.posts[indexPath.row].pathToImage)
            cell.postButton.tag = indexPath.row // set tag
            //cell.headerButton.setTitle(self.posts[indexPath.row].date, for: .normal)
            //cell.indicator.setTitle(self.posts[indexPath.row].state, for: .normal)
            cell.cleanPlateButton.isSelected = true
            cell.leftoversButton.isSelected = false

            cell.userTextInput = self.posts[indexPath.row].userTextInput
            cell.date = self.posts[indexPath.row].date
            cell.timestamp = self.posts[indexPath.row].timestamp
            let weekdayDate = cell.timestamp?.getDateFromTimeInterval()
            let weekday = weekdayDate?.dayOfWeek()!
            let dateString = "\(weekday ?? ""), \(cell.date ?? "no date")"
            cell.headerButton.setTitle(dateString, for: .normal)
            //print("\(String(describing: self.posts[indexPath.row].date))")

            //set nutritional data
            cell.calories = self.posts[indexPath.row].calories
            cell.carbs = self.posts[indexPath.row].carbs
            cell.protein = self.posts[indexPath.row].protein
            cell.fat = self.posts[indexPath.row].fat
            
            
            cell.state = self.posts[indexPath.row].state
            cell.postId = self.posts[indexPath.row].postId
            cell.healthDataEvent = self.posts[indexPath.row].healthDataEvent
            cell.isPlateEmpty = self.posts[indexPath.row].isPlateEmpty
            cell.backgroundColor = UIColor.white
            cell.delegate = self
            cell.index = indexPath
            
            // Create Cell Outline
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1.5)
            bottomLine.backgroundColor = UIColor.darkGray.cgColor
            cell.layer.addSublayer(bottomLine)
            
            return cell
        }
        
        func setUpFalseCell() -> PostCell {
            let cell = mealsCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCell
            
            cell.postImage.downloadImage(from: self.posts[indexPath.row].pathToImage)
            cell.postButton.tag = indexPath.row // set tag
            cell.headerButton.setTitle(self.posts[indexPath.row].date, for: .normal)
            //cell.indicator.setTitle(self.posts[indexPath.row].state, for: .normal)
            cell.cleanPlateButton.isSelected = false
            cell.leftoversButton.isSelected = true

            cell.userTextInput = self.posts[indexPath.row].userTextInput
            cell.date = self.posts[indexPath.row].date
            cell.timestamp = self.posts[indexPath.row].timestamp
            let weekdayDate = cell.timestamp?.getDateFromTimeInterval()
            let weekday = weekdayDate?.dayOfWeek()!
            let dateString = "\(weekday ?? ""), \(cell.date ?? "no date")"
            cell.headerButton.setTitle(dateString, for: .normal)
            //print("\(String(describing: self.posts[indexPath.row].date))")
            
            //set nutritional data
            cell.calories = self.posts[indexPath.row].calories
            cell.carbs = self.posts[indexPath.row].carbs
            cell.protein = self.posts[indexPath.row].protein
            cell.fat = self.posts[indexPath.row].fat
            
            
            cell.state = self.posts[indexPath.row].state
            cell.postId = self.posts[indexPath.row].postId
            cell.healthDataEvent = self.posts[indexPath.row].healthDataEvent
            cell.isPlateEmpty = self.posts[indexPath.row].isPlateEmpty
            cell.backgroundColor = UIColor.white
            cell.delegate = self
            cell.index = indexPath
            
            cell.mealIsNotComplete()
            
            // Create Cell Outline
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1.5)
            bottomLine.backgroundColor = UIColor.darkGray.cgColor
            cell.layer.addSublayer(bottomLine)
            
            return cell
        }
        
        func setUpEmptyPlateCell() -> CleanPostCell  {
            let cell = mealsCollectionView.dequeueReusableCell(withReuseIdentifier: cleanId, for: indexPath) as! CleanPostCell
            
            cell.postImage.downloadImage(from: self.posts[indexPath.row].pathToImage)
            //cell.postButton.setTitle(self.posts[indexPath.row].state, for: .normal) //self.posts[indexPath.row].userTextInput
            cell.postButton.tag = indexPath.row // set tag
            //cell.headerButton.setTitle(self.posts[indexPath.row].date, for: .normal)
            cell.indicator.setTitle(self.posts[indexPath.row].state, for: .normal)
            //this is just filler to conform to PostCellDelegate
            // cell.EOMImage.downloadImage(from: self.posts[indexPath.row].pathToImage)
            
            if self.posts[indexPath.row].state == "Pending" {
                cell.indicator.backgroundColor = UIColor.orange
            } else {
                cell.indicator.backgroundColor = UIColor.systemGreen
                cell.completeMealLabel.text = "Tap to View"
                cell.cleanPlateImage.removeFromSuperview()
            }
            
            cell.userTextInput = self.posts[indexPath.row].userTextInput
            cell.date = self.posts[indexPath.row].date //need to add real timestamp
            cell.timestamp = self.posts[indexPath.row].timestamp
            let weekdayDate = cell.timestamp?.getDateFromTimeInterval()
            let weekday = weekdayDate?.dayOfWeek()!
            let dateString = "\(weekday ?? ""), \(cell.date ?? "no date")"
            cell.headerButton.setTitle(dateString, for: .normal)
            //print("\(String(describing: self.posts[indexPath.row].date))")
            //print(self.posts[indexPath.row].date.dayOfWeek()!) // Wednesday
            
            //set nutritional data
            cell.calories = self.posts[indexPath.row].calories
            cell.carbs = self.posts[indexPath.row].carbs
            cell.protein = self.posts[indexPath.row].protein
            cell.fat = self.posts[indexPath.row].fat
            cell.state = self.posts[indexPath.row].state
            cell.postId = self.posts[indexPath.row].postId
            cell.healthDataEvent = self.posts[indexPath.row].healthDataEvent
            cell.isPlateEmpty = self.posts[indexPath.row].isPlateEmpty
            
            cell.backgroundColor = UIColor.white
            cell.delegate = self
            cell.index = indexPath
            //cell.btn1.tag = indexPath.row // set tag
           
            // Create Cell Outline
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1.5)
            bottomLine.backgroundColor = UIColor.darkGray.cgColor
            cell.layer.addSublayer(bottomLine)
            return cell
        }
        
        func setUpEOMCell() -> EOMPostCell  {
            let cell = mealsCollectionView.dequeueReusableCell(withReuseIdentifier: eomId, for: indexPath) as! EOMPostCell
            
            cell.postImage.downloadImage(from: self.posts[indexPath.row].pathToImage)
            //cell.postButton.setTitle(self.posts[indexPath.row].state, for: .normal) //self.posts[indexPath.row].userTextInput
            cell.postButton.tag = indexPath.row // set tag
            //cell.headerButton.setTitle(self.posts[indexPath.row].date, for: .normal)
            cell.indicator.setTitle(self.posts[indexPath.row].state, for: .normal)
            
            if self.posts[indexPath.row].state == "Pending" {
                cell.indicator.backgroundColor = UIColor.orange
            } else {
                cell.indicator.backgroundColor = UIColor.systemGreen
                cell.completeMealLabel.text = "Tap to View"
                cell.leftoverImage.removeFromSuperview()
            }

            //print("\(String(describing: self.posts[indexPath.row].isPlateEmpty))")
            cell.EOMImage.downloadImage(from: self.posts[indexPath.row].pathToEOMImage)
            
            cell.userTextInput = self.posts[indexPath.row].userTextInput
            cell.date = self.posts[indexPath.row].date
            cell.timestamp = self.posts[indexPath.row].timestamp
            let weekdayDate = cell.timestamp?.getDateFromTimeInterval()
            let weekday = weekdayDate?.dayOfWeek()!
            let dateString = "\(weekday ?? ""), \(cell.date ?? "no date")"
            cell.headerButton.setTitle(dateString, for: .normal)
            //print("\(String(describing: self.posts[indexPath.row].date))")
            
            //set nutritional data
            cell.calories = self.posts[indexPath.row].calories
            cell.carbs = self.posts[indexPath.row].carbs
            cell.protein = self.posts[indexPath.row].protein
            cell.fat = self.posts[indexPath.row].fat
            cell.state = self.posts[indexPath.row].state
            cell.postId = self.posts[indexPath.row].postId
            cell.healthDataEvent = self.posts[indexPath.row].healthDataEvent
            cell.isPlateEmpty = self.posts[indexPath.row].isPlateEmpty
            
            cell.backgroundColor = UIColor.white
            cell.delegate = self
            cell.index = indexPath
            
            
            //cell.layer.borderColor = UIColor.black.cgColor
            //cell.layer.borderWidth = 1
            //cell.layer.cornerRadius = 8 // optional
            
            // Create Cell Outline
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1.5)
            bottomLine.backgroundColor = UIColor.darkGray.cgColor
            cell.layer.addSublayer(bottomLine)

            return cell
        }
        
        if self.posts[indexPath.row].state == "Pending" {
            switch self.posts[indexPath.row].isPlateEmpty {
            case ("initial"):
                return setUpInitialCell()
            case ("true"):
                return setUpEmptyPlateCell()
            case ("false"):
                if self.posts[indexPath.row].pathToEOMImage == "DNE" {
                    return setUpFalseCell()
                } else {
                    return setUpEOMCell() //setUpFalseCell() //
                }
            default:
                print("default")
                return setUpEmptyPlateCell()//setUpInitialCell()        
            }
        } else {
            if self.posts[indexPath.row].isPlateEmpty == "false" {
                return setUpEOMCell()
            } else {
                return setUpEmptyPlateCell()
            }
        }

        
        
        
    }
    
    @IBAction func goBack(_ sender: Any) {
        print("goBack")
        transitionToHome()
    }

    func transitionToHome() {

        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        //swap out root view controller for the home one, once the signup is successful
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
}

extension MealsViewController: EOMPostCellDelegate {
    func didExpandEOMPost(image: UIImage, EOMImage: UIImage, date: String?, timestamp: TimeInterval?, userText: String?, calories: String?, carbs: String?, protein: String?, fat: String?, state: String?, postId: String?, healthDataEvent: String?, isPlateEmpty: String?) {
        
        let postVC = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(identifier: "PostVC") as! PostViewController
        //pass data to VC
        postVC.postImage = image
        //postVC.date = date! as NSDate
        postVC.userLabel.text = userText
        postVC.date = date
        //postVC.caloriesText.text = "Total Calories: \(calories ?? "pending")"
        postVC.calories = calories
        postVC.carbs = carbs
        postVC.protein = protein
        postVC.fat = fat
        postVC.state = state
        postVC.postId = postId
        postVC.healthDataEvent = healthDataEvent
        postVC.isPlateEmpty = isPlateEmpty
        postVC.timestamp = timestamp
        
        //FIXXXXX should be EOMimage but it's not working "Cannot find 'EOMimage' in scope
        postVC.EOMImage = EOMImage
   
        print("post tapped")
        //present VC
         DispatchQueue.main.async {
             self.present(postVC, animated: true, completion: nil)
         }
    }
    
    
}


extension MealsViewController: CleanPostCellDelegate {
    func didExpandCleanPost(image: UIImage, date: String?, timestamp: TimeInterval?, userText: String?, calories: String?, carbs: String?, protein: String?, fat: String?, state: String?, postId: String?, healthDataEvent: String?, isPlateEmpty: String?) {
        let postVC = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(identifier: "PostVC") as! PostViewController
        //pass data to VC
        postVC.postImage = image
        //postVC.date = date! as NSDate
        postVC.userLabel.text = userText
        postVC.date = date
        //postVC.caloriesText.text = "Total Calories: \(calories ?? "pending")"
        postVC.calories = calories
        postVC.carbs = carbs
        postVC.protein = protein
        postVC.fat = fat
        postVC.state = state
        postVC.postId = postId
        postVC.healthDataEvent = healthDataEvent
        postVC.isPlateEmpty = isPlateEmpty
        postVC.timestamp = timestamp
        
        //FIXXXXX should be EOMimage but it's not working "Cannot find 'EOMimage' in scope
        //postVC.EOMImage = image
   
        print("clean post tapped")
        //present VC
         DispatchQueue.main.async {
             self.present(postVC, animated: true, completion: nil)
         }
        
        
    }
    
}


extension MealsViewController: PostCellDelegate {
    //POST CELL DELEGATE
    func didExpandPost(image: UIImage, date: String?, timestamp: TimeInterval?, userText: String?, calories: String?, carbs: String?, protein: String?, fat: String?, state : String?, postId : String?, healthDataEvent : String?, isPlateEmpty: String? ) {
        
        let postVC = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(identifier: "PostVC") as! PostViewController
        //pass data to VC
        postVC.postImage = image
        //postVC.date = date! as NSDate
        postVC.userLabel.text = userText
        postVC.date = date
        //postVC.caloriesText.text = "Total Calories: \(calories ?? "pending")"
        postVC.calories = calories
        postVC.carbs = carbs
        postVC.protein = protein
        postVC.fat = fat
        postVC.state = state
        postVC.postId = postId
        postVC.healthDataEvent = healthDataEvent
        postVC.isPlateEmpty = isPlateEmpty
        postVC.timestamp = timestamp
        
        //FIXXXXX should be EOMimage but it's not working "Cannot find 'EOMimage' in scope
        postVC.EOMImage = image
   
        print("post tapped")
        //present VC
         DispatchQueue.main.async {
             self.present(postVC, animated: true, completion: nil)
         }
    }
    
    func didDeletePost(index: Int) {

        print("delete tapped")
        
        let alert = UIAlertController(title: "Are you sure?", message: "This action will permanently delete the selected meal.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default) {action in
            
            let db = Firestore.firestore()
            
            guard let deleteId = self.posts[index].postId else { return }
            
            self.posts.remove(at: index)
            self.mealsCollectionView.reloadData()

            db.collection("posts").document(deleteId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }

            //Set up storage reference
            let storageRef = Storage.storage().reference(forURL: "gs://flowaste-595b7.appspot.com/")
            
            let userStorage = storageRef.child("users")
            
            // Create a reference to the file to delete
            let desertRef = userStorage.child("\(deleteId).jpg")

            // Delete the file
            desertRef.delete { error in
              if let error = error {
                // Uh-oh, an error occurred!
              } else {
                print("Document successfully removed from Storage!")
                // File deleted successfully
              }
            }
            
        })
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)

    }
    
    func addAfterMeal(index: Int, postId : String?) {
        let secondVC = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(identifier: "SecondVC") as! SecondCaptureViewController
        secondVC.postId = postId
        
        view.window?.rootViewController = secondVC
        view.window?.makeKeyAndVisible()

    }
    
    func didSelectCleanPlate() {
         let alert = UIAlertController(title: "Save Meal Log?", message: "Just making sure.", preferredStyle: .alert)

         alert.addAction(UIAlertAction(title: "Yes", style: .default) {action in
             //update Firebase
            // let plateIsEmpty = true//self.cleanPlateButton.isSelected.description
            //self.mealsCollectionView.reloadData()
             //self.updateFirebaseSecondMeal(value: plateIsEmpty)
            //completeMealLabel.removeFromSuperview()
            //UPDATE VIEW
            
             
         })
         
         alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
         
         //let mealsVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.mealsViewController) as? MealsViewController
         
         present(alert, animated: true)
     }
}

extension UIImageView {
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) { (data, reponse, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        
        task.resume()
        
    }
    
    func downloadEOMImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) { (data, reponse, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        
        task.resume()
        
    }
    
}

extension TimeInterval{

    func stringFromTimeInterval() -> String {

        //Convert to Date
        let date = NSDate(timeIntervalSince1970: self)

        //Date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormatAs
        //dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone? //remove timezones for now
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }

}

extension TimeInterval{
    
    func getDateFromTimeInterval() -> NSDate {
        let date = NSDate(timeIntervalSince1970: self)
        print("returning NSDate")
        return date
        
    }
}


extension Date
{
    func toString() -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormatAs
        return dateFormatter.string(from: self)
    }
    
    /*func dayOfWeek() -> String? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: self).capitalized
            // or use capitalized(with: locale) if you want
    }*/

}

extension NSDate {
    func dayOfWeek() -> String? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: self as Date).capitalized
            // or use capitalized(with: locale) if you want
    }
}
