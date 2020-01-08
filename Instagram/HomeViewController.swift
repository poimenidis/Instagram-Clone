//
//  HomeViewController.swift
//  Instagram
//
//  Created by Kostas Poimenidis on 30/10/19.
//  Copyright © 2019 Kostas Poimenidis. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage


class HomeViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var refresh = UIRefreshControl()
    
    var posts : [Post] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //for a better functionality
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostRow", for: indexPath) as! TableViewCell
        if !posts.isEmpty{
            cell.comment.text = self.posts[indexPath.row].text
            cell.name.text = self.posts[indexPath.row].userName

            cell.uploadImage.sd_setImage(with: URL(string: self.posts[indexPath.row].imageUrl))
            
            cell.profileImage.sd_setImage(with: URL(string: self.posts[indexPath.row].userUrl))
            
            //a way to pass the row when image is clicked (by saving it in tag)
            cell.profileImage?.tag = indexPath.row
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            tapGestureRecognizer.numberOfTapsRequired = 1
            cell.profileImage?.isUserInteractionEnabled = true
            cell.profileImage?.addGestureRecognizer(tapGestureRecognizer)
            
            cell.imageHeart?.tag = indexPath.row
            
            if posts[indexPath.row].likes.contains(Auth.auth().currentUser!.uid){
                cell.imageHeart?.image = UIImage(systemName: "heart.fill")
            }
            else{
                cell.imageHeart?.image = UIImage(systemName: "heart")
            }
            
            
            let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTappedHeart(tapGestureRecognizer:)))
            tapGestureRecognizer.numberOfTapsRequired = 1
            cell.imageHeart?.isUserInteractionEnabled = true
            cell.imageHeart?.addGestureRecognizer(tapGestureRecognizer2)
            
            if posts[indexPath.row].likes.count>0{
                cell.likeLabel.text = "liked by \(posts[indexPath.row].likes.count) people"
            }
            else{
                cell.likeLabel.text = ""
            }
            
        }

        
        return cell
    }
    
    // method to run when imageview is tapped
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //a way to pass the row when image is clicked (by saving it in tag)
        let imgView = tapGestureRecognizer.view as! UIImageView
        let row = imgView.tag
        
        if posts[row].id == Auth.auth().currentUser?.uid{
            self.tabBarController?.selectedIndex = 4
        }
        else{
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "friendProfile") as! FriendViewController
            vc.id = self.posts[row].id
            vc.userName = self.posts[row].userName
            vc.imageUrl = self.posts[row].userUrl
            self.show(vc, sender: self)
        }
        
        
    }
    
    @objc func imageTappedHeart(tapGestureRecognizer: UITapGestureRecognizer){
        
        //a way to pass the row when image is clicked (by saving it in tag)
        let imgView = tapGestureRecognizer.view as! UIImageView
        let row = imgView.tag
        
        if imgView.image == UIImage(systemName: "heart"){
            imgView.image = UIImage(systemName: "heart.fill")
            ref = Database.database().reference()
        ref.child("Users").child(posts[row].id).child("Posts").child(posts[row].imageId).child("Likes").child(Auth.auth().currentUser!.uid).setValue(Auth.auth().currentUser?.uid)
        ref.child("Posts").child(posts[row].imageId).child("Likes").child(Auth.auth().currentUser!.uid).setValue(Auth.auth().currentUser?.uid)
            
        }
        else if imgView.image == UIImage(systemName: "heart.fill"){
            imgView.image = UIImage(systemName: "heart")
            
            ref = Database.database().reference()
            ref.child("Users").child(posts[row].id).child("Posts").child(posts[row].imageId).child("Likes").child(Auth.auth().currentUser!.uid).removeValue()
            
            ref.child("Posts").child(posts[row].imageId).child("Likes").child(Auth.auth().currentUser!.uid).removeValue()
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresh
        } else {
            tableView.addSubview(refresh)
        }
        
        readData()
        
        //when i scroll down to refresh the data
        refresh.addTarget(self, action: #selector(readData(_:)), for: .valueChanged)
        

        view.backgroundColor = .gray
        // Do any additional setup after loading the view.]
        
        //sos. with this way tableview take the changes
        tableView.dataSource = self
        
    }
    
    //for scroll refresh
    @objc private func readData(_ sender: Any) {
        // Fetch Weather Data
        readData()
    }
    
    
    //here is where app reads from firebase
    func readData(){
        self.refresh.beginRefreshing()
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("Posts").observe(.value, with: { (snapshot) in
            
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                let value = snap.value as? NSDictionary
                
                let text = value?["text"] as? String ?? ""
                let id = value?["id"] as? String ?? ""
                let imageUrl = value?["photo"] as? String ?? ""
                let imageId = snap.key
                var likes : [String] = []
                
                self.posts.removeAll()
                ref.child("Users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    
                    let username = value?["username"] as? String ?? ""
                    let imageurl = value?["imageUrl"] as? String ?? ""
                    
                    ref.child("Posts").child(imageId).child("Likes").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        
                        for child in snapshot.children {
                        
                            let snap = child as! DataSnapshot
                            
                            likes.append(snap.key)
                        }
                        
                        self.posts.insert(Post(id: id, text: text, imageUrl: imageUrl, userName: username, userUrl: imageurl , imageId: imageId, likes: likes), at: 0)
                        self.posts.sort(by: { $0.imageId > $1.imageId })
                        self.tableView.reloadData()
                        
                        self.refresh.endRefreshing()
                            
                    }){ (error) in
                        print(error.localizedDescription)
                    }
                    
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
                
            }
            
            
            
            
          }) { (error) in
                print(error.localizedDescription)
            }
    }

}


