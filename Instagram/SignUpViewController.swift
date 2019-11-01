//
//  SignUpViewController.swift
//  Instagram
//
//  Created by Kostas Poimenidis on 30/10/19.
//  Copyright © 2019 Kostas Poimenidis. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

var ref: DatabaseReference!
 

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //to make image circle
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        
        //to add a clicklistener to the imageview
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        //set signIn button disable when the textfields are emty
        signUpButton.isEnabled = false
        handleTextField()

        // Do any additional setup after loading the view.
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
        }
     
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage() {
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
            
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
            
          }
        }

    }
    
    @IBAction func dismiss_OnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signup_OnClick(_ sender: Any) {
        
        self.showSpinner(onView: self.view)
    
        Auth.auth().createUser(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { authResult, error in
        
            if error != nil{
                self.showToast(message: "There was a problem...Please try again")
            }
            else{
                let user = Auth.auth().currentUser
                if let user = user {
                    // The user's ID, unique to the Firebase project.
                    // Do NOT use this value to authenticate with your backend server,
                    // if you have one. Use getTokenWithCompletion:completion: instead.
                    let uid = user.uid
                    print(uid)
                    let email = user.email
                    let username = self.userNameTextField.text
                    
                    let user1 = User(id : uid,email : email!,username: username!)
                    
                    print(user1.email)

                    ref = Database.database().reference()
                    ref.child("Users").child(uid).setValue(["id": user1.id, "email": user1.email, "username": user1.username])
                    
                    self.uploadImage()
                }
                                
                let storyboard = UIStoryboard(name: "Main", bundle: nil);
                let vc = storyboard.instantiateViewController(withIdentifier: "tabBarViewId") ; // MySecondSecreen the storyboard ID
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil);
            }
            self.removeSpinner()
            
        }
        

    }
    
    func handleTextField(){
        userNameTextField.addTarget(self, action: #selector(SignUpViewController.textFieldChanged), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldChanged), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldChanged), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldChanged(){
        if passwordTextField.text != "" && emailTextField.text != "" && userNameTextField.text != "" {
            signUpButton.isEnabled = true
        }
        else{
            signUpButton.isEnabled = false
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
