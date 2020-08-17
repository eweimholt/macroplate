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


class MealsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PostCellDelegate {

    let cellId = "cell"
    
    var mealsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 300, height: 300)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white //UIColor.clear.withAlphaComponent(0)
        cv.layer.cornerRadius = 20
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PostCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    
    //create an array of posts
    var posts = [Post]()
    
    let mealLabel : UILabel = {
        let label = UILabel()
        label.text = "Your Meals"
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = UIColor(displayP3Red: 0/255, green: 32/255, blue: 61/255, alpha: 1)
        //label.layer.masksToBounds = true
        //label.layer.cornerRadius = 30
        //label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
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
        //label.layer.masksToBounds = true
        //label.layer.cornerRadius = 30
        //label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    let activityView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(mealsCollectionView)
        mealsCollectionView.dataSource = self
        mealsCollectionView.delegate = self

        self.view.addSubview(self.mealLabel)
        
        setUpLayout()
        
        fetchPosts()
        
    }
    
    func setUpLayout() {
        
        mealsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        mealsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        mealsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        mealsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        mealLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mealLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        mealLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        mealLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

    
    func fetchPosts() {
        
        let db = Firestore.firestore()
        
        let uid = Auth.auth().currentUser!.uid
        
        //let docRef = db.collection("cities").document("SF")

        db.collection("posts").whereField("uid", isEqualTo: uid).order(by: "date", descending: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")

                } else {
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let post = Post()
                        let doc = document.data()
   
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
                        
                        //let myTimeInterval = TimeInterval(post.timestamp)
                        //post.date = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval)) as Date
                        //print("post.timestamp is \(post.timestamp)")
                        
                        //convert time interval to date
                        
                        if post.timestamp != nil {
                            post.date = post.timestamp.stringFromTimeInterval()
                        }
                        else {
                            //print("Post timestamp is nil, add view load accordingly here")
                            //post.date = "timestamp was nil"
                        }
                        //post.date = Date(timeIntervalSince1970: post.date)
                        
                        
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
    
    /*func dateValue() -> Date {
        
    }*/
    // UICOLLECTIONVIEW DATA SOURCE
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return the number of posts
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = mealsCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCell
        
        cell.postImage.downloadImage(from: self.posts[indexPath.row].pathToImage)
        cell.postButton.setTitle(self.posts[indexPath.row].state, for: .normal) //self.posts[indexPath.row].userTextInput
        
        
        cell.userTextInput = self.posts[indexPath.row].userTextInput
        cell.date = self.posts[indexPath.row].date //need to add real timestamp
        print("\(String(describing: self.posts[indexPath.row].date))")
        
        //set nutritional data
        cell.calories = self.posts[indexPath.row].calories
        cell.carbs = self.posts[indexPath.row].carbs
        cell.protein = self.posts[indexPath.row].protein
        cell.fat = self.posts[indexPath.row].fat
        cell.state = self.posts[indexPath.row].state
        cell.postId = self.posts[indexPath.row].postId
        cell.healthDataEvent = self.posts[indexPath.row].healthDataEvent
    
        cell.backgroundColor = UIColor.white
        cell.delegate = self
        cell.index = indexPath
        
        return cell
    }
    
    
    
    //POST CELL DELEGATE
    func didExpandPost(image: UIImage, date: String?, userText: String?, calories: String?, carbs: String?, protein: String?, fat: String?, state : String?, postId : String?, healthDataEvent : String? ) {
        
        let postVC = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(identifier: "PostVC") as! PostViewController
        //pass data to VC
        postVC.postImage = image
        //postVC.date = date! as NSDate
        postVC.userLabel.text = userText
        postVC.dateText.text = date
        postVC.caloriesText.text = "Total Calories: \(calories ?? "pending")"
        postVC.carbs = carbs
        postVC.protein = protein
        postVC.fat = fat
        postVC.state = state
        postVC.postId = postId
        postVC.healthDataEvent = healthDataEvent
        
        
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
            
        })
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)


    }
    
    /*func didHoldPost(index: Int) {
        print("good job elise")
    }*/
    
    @IBAction func testTapped(_sender: Any) {
        
        //present to ProfileVC
        let testVC = UIStoryboard(name: "Feed", bundle: nil).instantiateViewController(identifier: "TestVC") as! TestViewController
        DispatchQueue.main.async {
            self.present(testVC, animated: true, completion: nil)
        }
        
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
    
}

extension TimeInterval{

    func stringFromTimeInterval() -> String {

        //Convert to Date
        let date = NSDate(timeIntervalSince1970: self)

        //Date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy HH:mm a"
        //dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone? //remove timezones for now
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
}

