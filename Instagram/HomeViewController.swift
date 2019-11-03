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
    
    var posts : [Post] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //for a better functionality
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostRow", for: indexPath) as! TableViewCell
        cell.comment.text = self.posts[indexPath.row].text
        cell.name.text = self.posts[indexPath.row].userName

        cell.uploadImage.sd_setImage(with: URL(string: self.posts[indexPath.row].imageUrl))
        
        cell.profileImage.sd_setImage(with: URL(string: self.posts[indexPath.row].userUrl))
        
        

        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readData()

        view.backgroundColor = .gray
        // Do any additional setup after loading the view.]
        
        //sos. with this way tableview take the changes
        tableView.dataSource = self
    }
    
    @IBAction func logOut_OnClick(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil);
                let vc = storyboard.instantiateViewController(withIdentifier: "SignInViewId") ; // MySecondSecreen the storyboard ID
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil);
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

        
    }
    
    
    //here is where app reads from firebase
    func readData(){
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("Posts").observe(.value, with: { (snapshot) in
            
            self.posts.removeAll()
            
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                let value = snap.value as? NSDictionary
                
                let text = value?["text"] as? String ?? ""
                let id = value?["id"] as? String ?? ""
                let imageUrl = value?["photo"] as? String ?? ""
                
               
                
                ref.child("Users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    
                    let username = value?["username"] as? String ?? ""
                    let imageurl = value?["imageUrl"] as? String ?? ""
                    
                    self.posts.insert(Post(id: id, text: text, imageUrl: imageUrl, userName: username, userUrl: imageurl), at: 0)
                    self.tableView.reloadData()
                }) { (error) in
                    print(error.localizedDescription)
                }
                
            }
            
            
            
            
          }) { (error) in
                print(error.localizedDescription)
            }
    }

}

struct Post  : Identifiable{
    
    var id : String
    var text : String
    var imageUrl : String
    var userName : String
    var userUrl : String
    
    
}
