//
//  MealsViewController.swift
//  macroplate
//
//  Created by Elise Weimholt on 7/25/20.
//  Copyright © 2020 Elise Weimholt. All rights reserved.
//

import UIKit
import Firebase

class MealsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let cellId = "cell"
    
    var mealsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 350, height: 350)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view.backgroundColor = UIColor.white
        view.addSubview(mealsCollectionView)
        
        view.addSubview(mealLabel)
        //mealsCollectionView.register(PostCell.self, forCellWithReuseIdentifier: cellId)
        mealsCollectionView.backgroundColor = UIColor.white
        mealsCollectionView.dataSource = self
        mealsCollectionView.delegate = self
        
        
        setUpLayout()
        
        fetchPosts()
        
        
    }
    
    func setUpLayout() {
      
        mealsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        mealsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        mealsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        //mealsCollectionView.heightAnchor.constraint(equalToConstant: ).isActive = true
        mealsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        
        
        mealLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100).isActive = true
        mealLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        mealLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        mealLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
 
    }
    
    
    
    func fetchPosts() {
        let db = Firestore.firestore()
        
        let uid = Auth.auth().currentUser!.uid
        
        //get documents created by user
        // throws an error if there are no RESULTS ___ FIX
        
        db.collection("uploads").whereField("uid", isEqualTo: uid)//.order(by: "date")
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
                        post.postId = doc["postId"] as? String
                        
                        self.posts.append(post)
                        
                    }
                    
                }
                self.mealsCollectionView.reloadData()
        }
        
        
    }
    
    
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
        
        //cell.postButton.setTitle(self.posts[indexPath.row].name, for: .normal)

        
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
}

extension UIImageView {
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) { (data, reponse, error) in
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        
        task.resume()
        
    }
    
}

