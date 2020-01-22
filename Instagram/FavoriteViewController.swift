//
//  FavoriteViewController.swift
//  Instagram
//
//  Created by Kostas Poimenidis on 30/10/19.
//  Copyright © 2019 Kostas Poimenidis. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class FavoriteViewController: UIViewController, UITableViewDataSource {
    
    var userName: String = ""
    var imageUrl: String = ""
    var messages: [Message] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if messages[indexPath.row].senderId == Auth.auth().currentUser!.uid{
            let cell = tableView.dequeueReusableCell(withIdentifier: "rowUser", for: indexPath) as! UserChatTableViewCell
            
            //to set tableview from bottom to top
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            
            cell.message.text = self.messages[indexPath.row].text
            cell.name.text = self.messages[indexPath.row].username
            cell.imageUser.sd_setImage(with: URL(string: self.messages[indexPath.row].imageUrl))
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "rowFriend", for: indexPath) as! FriendChatTableViewCell
            
            //to set tableview from bottom to top
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            
            cell.message.text = self.messages[indexPath.row].text
            cell.name.text = self.messages[indexPath.row].username
            cell.imageFriend.sd_setImage(with: URL(string: self.messages[indexPath.row].imageUrl))
            
            return cell
        }
        

    }
    
    @IBAction func sendButton(_ sender: Any) {
        
        if editText.text != ""{
            
            let message = Message(id: getTodayString(), senderId: Auth.auth().currentUser!.uid, username: self.userName, imageUrl: self.imageUrl, text: editText.text!)
            
            ref = Database.database().reference()
            ref.child("ChatRoom").child(getTodayString()).setValue(["senderId" : message.senderId , "text" : message.text , "userName":userName, "imageUrl": imageUrl] )
            
            
            
                editText.text = ""
        }
        
        
        
    }
    
    func getTodayString() -> String{
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let today_string = formatter.string(from: now)

        return today_string

    }
    
    
    func readDataUser(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("Users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
        
            let value = snapshot.value as? NSDictionary
            
            let name = value?["username"] as? String ?? ""
            let imageUrl = value?["imageUrl"] as? String ?? ""
            
            self.userName = name
            self.imageUrl =  imageUrl
            
            
          }) { (error) in
                print(error.localizedDescription)
            }
    }
    
    func readMessages(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("ChatRoom").observe(.childAdded, with: { snapshot in
        
                let value = snapshot.value as? NSDictionary
                let id = snapshot.key
                let name = value?["userName"] as? String ?? ""
            let text = value?["text"] as? String ?? ""
                let imageUrl = value?["imageUrl"] as? String ?? ""
            let senderId = value?["senderId"] as? String ?? ""
            
            let message = Message(id: id, senderId: senderId, username: name, imageUrl: imageUrl, text: text)
                
            
            self.messages.insert(message, at: 0)
            self.tableView.reloadData()
            
            
            
            
          }) { (error) in
                print(error.localizedDescription)
            }
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        
        //to set tableview from bottom to top
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        readDataUser()
        readMessages()
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
