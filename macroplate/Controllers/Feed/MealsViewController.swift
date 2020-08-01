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
        cv.translatesAutoresizingMaskIntoConstraints = false
        //cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
        
        // view.backgroundColor = UIColor.white
        view.addSubview(mealsCollectionView)
        
        view.addSubview(mealLabel)
        
        //view.addSubview(testButton)
        //testButton.addTarget(self, action: #selector(testTapped), for: .touchUpInside)
        
        //mealsCollectionView.register(PostCell.self, forCellWithReuseIdentifier: cellId)
        mealsCollectionView.backgroundColor = UIColor.white
        mealsCollectionView.dataSource = self
        mealsCollectionView.delegate = self
        
        
        setUpLayout()
        
        fetchPosts()
        
        
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
        let db = Firestore.firestore()
        
        let uid = Auth.auth().currentUser!.uid
        
        //get documents created by user
        // throws an error if there are no RESULTS ___ FIX
        
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
                        post.date = doc["date"] as? String
                        post.postId = doc["key"] as? String
                        post.userId = doc["uid"] as? String
                        post.userTextInput = doc["userTextInput"] as? String
                        post.carbs = doc["carbs"] as? String
                        post.protein = doc["protein"] as? String
                        post.fat = doc["fat"] as? String
                        post.calories = doc["calories"] as? String
                        post.state = doc["State"] as? String
              
                        self.posts.append(post)
                        
                    }
                    
                }
                self.mealsCollectionView.reloadData()
        }
        
        
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
    
        cell.backgroundColor = UIColor.white
        cell.delegate = self
        cell.index = indexPath
        
        return cell
    }
    
    //POST CELL DELEGATE
    func didExpandPost(image: UIImage, date: String?, userText: String?, calories: String?, carbs: String?, protein: String?, fat: String?, state : String?) {
        
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
        
        print("post tapped")
        //present VC
         DispatchQueue.main.async {
             self.present(postVC, animated: true, completion: nil)
         }
    }
    
    func didDeletePost(index: Int) {

        print("delete tapped")

        /*let db = Firestore.firestore()
        
        guard let deleteId = posts[index].postId else { return }
        
        posts.remove(at: index)
        mealsCollectionView.reloadData()

        db.collection("posts").document(deleteId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }*/
    }
    
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

