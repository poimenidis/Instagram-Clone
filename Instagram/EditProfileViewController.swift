//
//  EditProfileViewController.swift
//  Instagram
//
//  Created by Kostas Poimenidis on 21/12/19.
//  Copyright © 2019 Kostas Poimenidis. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
import FirebaseStorage
import ProgressHUD

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameEdit: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        readDataUser()
        
        //to make image circle
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        
        //to add a clicklistener to the imageview
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    //action when imageView is clicked sos
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        selectImage()
        
    }
    
    @IBAction func changeButton(_ sender: Any) {
        selectImage()
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        
        uploadImage()
        
        
    }
    
    func selectImage(){
        //select an image from library
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){

            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    //sos use the selected image. ImagePickerController is not called somewhere, but it is used automatically when UIImagePickerController is called
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
     
        dismiss(animated: true, completion: nil)
    }
    
    func readDataUser(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("Users").child(Auth.auth().currentUser!.uid).observe(.value, with: { (snapshot) in
        
            let value = snapshot.value as? NSDictionary
            
            let name = value?["username"] as? String ?? ""
            let imageUrl = value?["imageUrl"] as? String ?? ""
            
            self.nameEdit.text = name
            self.imageView.sd_setImage(with: URL(string: imageUrl))
            
            
          }) { (error) in
                print(error.localizedDescription)
            }
    }
    
    
    func uploadImage() {
        ProgressHUD.show("Waiting...", interaction: false)
        
        let storage = Storage.storage()
        // Create a root reference
        let storageRef = storage.reference().child(Auth.auth().currentUser!.uid)
        
        var data = NSData()
        data = imageView.image!.jpegData(compressionQuality: 0.8)! as NSData
        
        let uploadTask = storageRef.putData(data as Data, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          storageRef.downloadURL { (url, error) in
            
            ref = Database.database().reference()
        ref.child("Users").child(Auth.auth().currentUser!.uid).child("imageUrl").setValue(url?.absoluteString)
            
        ref.child("Users").child(Auth.auth().currentUser!.uid).child("username").setValue(self.nameEdit.text)
            
            ProgressHUD.showSuccess("Success")
            //go back
            _ = self.navigationController?.popViewController(animated: true)
            
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
            
          }
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
