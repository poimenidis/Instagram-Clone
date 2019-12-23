//
//  PhotoViewController.swift
//  Instagram
//
//  Created by Kostas Poimenidis on 30/10/19.
//  Copyright © 2019 Kostas Poimenidis. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import ProgressHUD

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editText: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //to make image circle
//        imageView.layer.cornerRadius = 60
//        imageView.clipsToBounds = true
        
        //to add a clicklistener to the imageview
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        removeButton.isEnabled = false
        shareButton.isEnabled = false
        shareButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func share_OnClick(_ sender: Any) {
        if !(imageView.image!.isSymbolImage){
            uploadImage()
        }
        else{
            ProgressHUD.showError("You have to select an image!!")
        }
        
    }
    //action when imageView is clicked sos
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //select an image from library
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){

            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
        
        
    }
    
    //sos use the selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            
            shareButton.isEnabled = true
            shareButton.backgroundColor = UIColor.red
            
            removeButton.isEnabled = true
        }
     
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage() {
        let storage = Storage.storage()
        // Create a root reference
        let storageRef = storage.reference().child("Posts").child(Auth.auth().currentUser!.uid)
        
        var data = NSData()
        data = imageView.image!.jpegData(compressionQuality: 0.8)! as NSData
        
        ProgressHUD.show("Waiting...", interaction: false)
        
        let uploadTask = storageRef.putData(data as Data, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          storageRef.downloadURL { (url, error) in
            
            if error == nil{
                
                var text : String = self.editText.text ?? "nothing"
                
                
                ref = Database.database().reference()
                
                let userid : String = Auth.auth().currentUser!.uid
                ref.child("Posts").child(getTodayString()).setValue(["id": userid, "photo":url?.absoluteString as Any,"text": text])
            ref.child("Users").child(Auth.auth().currentUser!.uid).child("Posts").child(getTodayString()).setValue(["photo":url?.absoluteString,"text": text])
                
                ProgressHUD.showSuccess("Success")
                
                self.editText.text=""
                self.imageView.image = UIImage(systemName: "photo.fill")
                
                self.tabBarController?.selectedIndex = 0
            }
            else{
                ProgressHUD.showError("Error...Try again")
            }
            
          }
        }
        
        func getTodayString() -> String{
            
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let today_string = formatter.string(from: now)

            return today_string

        }

    }
    
    @IBAction func remove_OnClick(_ sender: Any) {
        editText.text=""
        imageView.image = UIImage(systemName: "photo.fill")
        removeButton.isEnabled = false
        shareButton.isEnabled = false
        shareButton.backgroundColor = UIColor.lightGray
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
