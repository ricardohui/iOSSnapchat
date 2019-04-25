//
//  ViewController.swift
//  Snapchat
//
//  Created by Ricardo Hui on 25/4/2019.
//  Copyright © 2019 Ricardo Hui. All rights reserved.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {

    
    @IBOutlet var topButton: UIButton!
    
    @IBOutlet var bottomButton: UIButton!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    
    var signUpMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    
    @IBAction func topTapped(_ sender: Any) {
        print("topTapped")
        if let email = emailTextField.text{
            if let password = passwordTextField.text{
                if signUpMode{
                    //Sign Up
                    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                        if let error = error{
                            self.presentAlert(message: error.localizedDescription)
                        }else{
                            print("Sign Up was successful")
                            self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                        }
                    }
                    
                }else{
                    //Log In
                    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                        if let error = error{
                            self.presentAlert(message: error.localizedDescription)
                        }else{
                            print("Log In was successful")
                            self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                        }
                    }
                }
            }
        }
        
    }
    
    func presentAlert(message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func bottomTapped(_ sender: Any) {
        print("bottomTapped")
        if signUpMode{
            signUpMode = false
            // show switch to Log In
            topButton.setTitle("Log In", for: .normal)
            bottomButton.setTitle("Switch to Sign Up", for: .normal)
        }else{
            signUpMode = true
            // show switch to Sign Up
            topButton.setTitle("Sign Up", for: .normal)
            bottomButton.setTitle("Switch to Log In", for: .normal)
            
        }
        
        
        
    }
    
    


}

