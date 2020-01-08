//
//  FriendViewController.swift
//  Instagram
//
//  Created by Kostas Poimenidis on 23/12/19.
//  Copyright © 2019 Kostas Poimenidis. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class FriendViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var posts : [Post] = []
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var userName : String = ""
    var id : String = ""
    var imageUrl : String = ""
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.imageView.sd_setImage(with: URL(string: self.posts[indexPath.row].imageUrl))

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "ImageId") as! ImageViewController
        vc.imageTitle = self.posts[indexPath.row].text
        vc.imageUrl = self.posts[indexPath.row].imageUrl
        vc.likes = self.posts[indexPath.row].likes
        vc.imageId = self.posts[indexPath.row].imageId
        vc.userId = id
        self.show(vc, sender: self)
    }
    
    //size of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.minimumInteritemSpacing = 05
            layout.minimumLineSpacing = 05

            return CGSize(width: ((self.view.frame.width/3) - 4), height:((self.view.frame.width / 3) - 4));
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameLabel.text = userName
        imageView.sd_setImage(with: URL(string: imageUrl))
        
        readData()
    }
    
     //here is where app reads from firebase
    func readData(){
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        
        ref.child("Users").child(id).child("Posts").observe(.value, with: { (snapshot) in
            var likes: [String] = []
            self.posts.removeAll()
            
            for child in snapshot.children {
                    
                let snap = child as! DataSnapshot
                
                let value = snap.value as? NSDictionary
                
                let text = value?["text"] as? String ?? ""
                let imageUrl = value?["photo"] as? String ?? ""
                let imageId = snap.key
                
                
                ref.child("Posts").child(imageId).child("Likes").observeSingleEvent(of: .value, with: { (snapshot) in
                        likes.removeAll()
                        
                        for child in snapshot.children {
                        
                            let snap = child as! DataSnapshot
                            
                            likes.append(snap.key)
                        }
                        
                    
                    self.posts.insert(Post(id: "", text: text, imageUrl: imageUrl, userName: "", userUrl: "", imageId: imageId, likes: likes), at: 0)
                    self.collectionView.reloadData()
                
                    }) { (error) in
                        print(error.localizedDescription)
                    }
            
                
                
            }
            
            
            
            
          }) { (error) in
                print(error.localizedDescription)
            }
        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
