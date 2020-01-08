//
//  ImageViewController.swift
//  Instagram
//
//  Created by Kostas Poimenidis on 23/12/19.
//  Copyright © 2019 Kostas Poimenidis. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ImageViewController: UIViewController {
    
   
    @IBOutlet weak var heartImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var imageTitle: String = ""
    var imageUrl: String = ""
    var userId: String = ""
    var imageId: String = ""
    var likes: [String] = []
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readData()

        titleLabel.text = imageTitle
        imageView.sd_setImage(with: URL(string: imageUrl))
        
        
        if likes.contains(Auth.auth().currentUser!.uid){
            heartImageView.image = UIImage(systemName: "heart.fill")
        }
        else{
            heartImageView.image = UIImage(systemName: "heart")
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTappedHeart(tapGestureRecognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        heartImageView?.isUserInteractionEnabled = true
        heartImageView?.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTappedHeart(tapGestureRecognizer: UITapGestureRecognizer){
        
        if heartImageView.image == UIImage(systemName: "heart"){
            heartImageView.image = UIImage(systemName: "heart.fill")
            ref = Database.database().reference()
        ref.child("Users").child(userId).child("Posts").child(imageId).child("Likes").child(Auth.auth().currentUser!.uid).setValue(Auth.auth().currentUser?.uid)
        ref.child("Posts").child(imageId).child("Likes").child(Auth.auth().currentUser!.uid).setValue(Auth.auth().currentUser?.uid)
            
        }
        else if heartImageView.image == UIImage(systemName: "heart.fill"){
            heartImageView.image = UIImage(systemName: "heart")
            
            ref = Database.database().reference()
            ref.child("Users").child(userId).child("Posts").child(imageId).child("Likes").child(Auth.auth().currentUser!.uid).removeValue()
            
            ref.child("Posts").child(imageId).child("Likes").child(Auth.auth().currentUser!.uid).removeValue()
        }
        
        
    }
    
    //for scroll refresh
    @objc private func readData(_ sender: Any) {
        // Fetch Weather Data
        readData()
    }
    
    
    //here is where app reads from firebase
    func readData(){
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("Posts").child(imageId).child("Likes").observe(.value, with: { (snapshot) in
            self.likes.removeAll()
            for child in snapshot.children {
            
                let snap = child as! DataSnapshot
                
                self.likes.append(snap.key)
            }
            
            
            if self.likes.count>0{
                self.likeLabel.text = "liked by \(self.likes.count) people"
            }
            else{
                self.likeLabel.text = ""
            }
                        
        }){ (error) in
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
