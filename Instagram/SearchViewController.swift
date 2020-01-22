//
//  SearchViewController.swift
//  Instagram
//
//  Created by Kostas Poimenidis on 30/10/19.
//  Copyright © 2019 Kostas Poimenidis. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class SearchViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    var users : [User] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postrow", for: indexPath) as! SearchViewCell
        
        cell.nameTextview.text = self.users[indexPath.row].username
        cell.imageview.sd_setImage(with: URL(string: users[indexPath.row].imageUrl))
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "friendProfile") as! FriendViewController
        
        vc.id = self.users[indexPath.row].id
        vc.userName = self.users[indexPath.row].username
        vc.imageUrl = self.users[indexPath.row].imageUrl
        self.show(vc, sender: self)
    }

    

    @IBOutlet var teableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        readData()
        
        //sos. with this way tableview take the changes
        teableview.dataSource = self
        teableview.delegate = self
    }
    
    func readData(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
                
        
        ref.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
            self.users.removeAll()
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                let value = snap.value as? NSDictionary
            
                let username = value?["username"] as? String ?? ""
                let idd = snap.key
                let imageUrl = value?["imageUrl"] as? String ?? ""
            
                if idd != Auth.auth().currentUser?.uid{
                    self.users.append(User(id: idd, username: username, imageUrl: imageUrl))
                }
            }
            
            self.teableview.reloadData()
            
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
