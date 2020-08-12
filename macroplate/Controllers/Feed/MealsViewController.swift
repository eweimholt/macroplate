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
    
    /*var testButton: UIButton = {
        let dButton = UIButton()
        dButton.translatesAutoresizingMaskIntoConstraints = false
        dButton.setTitle("Test", for: .normal)
        dButton.clipsToBounds = true
        dButton.layer.cornerRadius = 10
        dButton.backgroundColor = UIColor.init(displayP3Red: 100/255, green: 196/255, blue: 188/255, alpha: 1)
        dButton.setTitleColor(.white, for: .normal)
        dButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20)
        return dButton
    }()*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(mealsCollectionView)
        
        view.addSubview(mealLabel)
        
        
        //view.addSubview(testButton)
        //testButton.addTarget(self, action: #selector(testTapped), for: .touchUpInside)

        mealsCollectionView.dataSource = self
        mealsCollectionView.delegate = self
        
        setUpLayout()
        
        fetchPosts()
        //AppDelegate.instance().dismissActivityIndicator()
        
    }
    
    func setUpLayout() {
        
        mealsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        mealsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        mealsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        //mealsCollectionView.heightAnchor.constraint(equalToConstant: ).isActive = true
        mealsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        
        mealLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mealLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        mealLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        mealLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
        /*testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 150).isActive = true
        testButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        testButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        testButton.heightAnchor.constraint(equalToConstant: 50).isActive = true*/
        
    }
    
    
    
    func fetchPosts() {
        //show activity indicator while fetching posts
        //AppDelegate.instance().showActivityIndicator()
        
       // var window: UIWindow?
        /*var actIdc = UIActivityIndicatorView()
        
        var container: UIView!
        
        container = UIView()
        container.frame = CGRect(x: 10, y: 10, width: 300, height: 300)//window.frame
        //container.center = //window.center
        container.backgroundColor = UIColor(white: 0, alpha: 0.8)
        
        actIdc.style = .large
        actIdc.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actIdc.hidesWhenStopped = true
        actIdc.center = CGPoint(x: container.frame.size.width/2, y: container.frame.size.height/2)
        
        container.addSubview(actIdc)
        self.view.addSubview(container)
        
        actIdc.startAnimating()
        print("showing indicator")*/

        
        let db = Firestore.firestore()
        
        let uid = Auth.auth().currentUser!.uid
        
        //let docRef = db.collection("cities").document("SF")

        db.collection("posts").whereField("uid", isEqualTo: uid).order(by: "date", descending: true)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    //AppDelegate.instance().dismissActivityIndicator()
                    //container.removeFromSuperview()

                } else {
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let post = Post()
                        let doc = document.data()
                        
                        post.name = doc["name"] as? String
                        post.pathToImage = doc["urlToImage"] as? String
                        post.date = doc["date"] as? String
                        post.postId = doc["key"] as? String
                        post.userId = doc["uid"] as? String
                        post.userTextInput = doc["userTextInput"] as? String
                        post.carbs = doc["carbs"] as? String
                        post.protein = doc["protein"] as? String
                        post.fat = doc["fat"] as? String
                        post.calories = doc["calories"] as? String
                        post.state = doc["State"] as? String
                        post.healthDataEvent = doc["healthDataEvent"] as? String
                        
                        
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

     //container.removeFromSuperview()
    }
    
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
        cell.date = "August 1" //self.posts[indexPath.row].date //need to add real timestamp
        //print(self.posts[indexPath.row].date!)
        
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
        //postVC.date.text = date
        postVC.userLabel.text = userText
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

