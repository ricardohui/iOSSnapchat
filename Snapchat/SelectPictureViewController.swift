//
//  SelectPictureViewController.swift
//  Snapchat
//
//  Created by Ricardo Hui on 25/4/2019.
//  Copyright © 2019 Ricardo Hui. All rights reserved.
//

import UIKit

class SelectPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var imagePicker : UIImagePickerController?
    var imageAdded : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var messageTextField: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func selectPhoto(_ sender: Any) {
        if imagePicker != nil{
            imagePicker?.sourceType = .photoLibrary
            present(imagePicker!, animated: true, completion: nil)
        }
        
        
        
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = image
            imageAdded = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        if let message  = messageTextField.text{
            if imageAdded && message != ""{
                // Segue to next view controller
                
                
            }else{
                // We are missing something
                
                let alertController = UIAlertController(title: "Error", message: "You must provide an image and a message  for your app", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
                
                
            }
        }
        
        
    }
    @IBAction func cameraTapped(_ sender: Any) {
        
        if imagePicker != nil{
            imagePicker?.sourceType = .camera
            present(imagePicker!, animated: true, completion: nil)
        }
    }
}
