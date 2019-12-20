//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Kostas Poimenidis on 30/10/19.
//  Copyright © 2019 Kostas Poimenidis. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class ProfileViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var posts : [Post] = []
    
    //number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    //custon the things inside cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.sd_setImage(with: URL(string: self.posts[indexPath.row].imageUrl))
        
        return cell
    }
    
    //size of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.minimumInteritemSpacing = 05
            layout.minimumLineSpacing = 05

            return CGSize(width: ((self.view.frame.width/3) - 4), height:((self.view.frame.width / 3) - 4));
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readDataUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.dataSource = self
        collectionView.delegate = self
        readData()
    }
    
    func readDataUser(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("Users").child(Auth.auth().currentUser!.uid).observe(.value, with: { (snapshot) in
        
            let value = snapshot.value as? NSDictionary
            
            let name = value?["username"] as? String ?? ""
            let imageUrl = value?["imageUrl"] as? String ?? ""
            
            self.nameLabel.text = name
            self.imageView.sd_setImage(with: URL(string: imageUrl))
            
            
          }) { (error) in
                print(error.localizedDescription)
            }
    }
    
     //here is where app reads from firebase
    func readData(){
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("Users").child(Auth.auth().currentUser!.uid).child("Posts").observe(.value, with: { (snapshot) in
            
            self.posts.removeAll()
            
            for child in snapshot.children {
                    
                let snap = child as! DataSnapshot
                let value = snap.value as? NSDictionary
                
                let text = value?["text"] as? String ?? ""
                let imageUrl = value?["photo"] as? String ?? ""
                
                
                self.posts.insert(Post(id: "", text: text, imageUrl: imageUrl, userName: "makis", userUrl: "makis"), at: 0)
                self.collectionView.reloadData()
            
                
                
            }
            
            
            
            
          }) { (error) in
                print(error.localizedDescription)
            }
        

    }

    

    /*
    // MARK: - Navigation
     @IBOutlet var collectionView: UICollectionView!
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
