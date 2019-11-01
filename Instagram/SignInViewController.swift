//
//  ViewController.swift
//  Instagram
//
//  Created by Kostas Poimenidis on 30/10/19.
//  Copyright © 2019 Kostas Poimenidis. All rights reserved.
//

import UIKit
import FirebaseAuth


class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if Auth.auth().currentUser != nil {
            self.showSpinner(onView: self.view)
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block:{ timer in
                self.changeViewAfterLogin()
            })
            
        }
        
        //set signIn button disable when the textfields are emty
        signInButton.isEnabled = false
        handleTextField()
    }

    @IBAction func signIn_OnClick(_ sender: Any) {
        
        self.showSpinner(onView: self.view)
        
        Auth.auth().signIn(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] authResult, error in
            guard self != nil else { return }
            
            if error != nil{
                self!.showToast(message: "Wrong email or password...Try again")
            }
            else{
                self!.changeViewAfterLogin()
            }
            
            self!.removeSpinner()
            
        }
        
        Timer.scheduledTimer(withTimeInterval: 20, repeats: false, block:{ timer in
            self.removeSpinner()
            self.showToast(message: "Wrong email or password...Try again")
        })
        
    }
    
    func changeViewAfterLogin(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewController(withIdentifier: "tabBarViewId") ; // MySecondSecreen the storyboard ID
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil);
    }
    
    func handleTextField(){
        emailTextField.addTarget(self, action: #selector(SignInViewController.textFieldChanged), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignInViewController.textFieldChanged), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldChanged(){
        if passwordTextField.text != "" && emailTextField.text != "" {
            signInButton.isEnabled = true
        }
        else{
            signInButton.isEnabled = false
        }
    }
    
    
}

