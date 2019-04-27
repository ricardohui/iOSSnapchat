//
//  SelectPictureViewController.swift
//  Snapchat
//
//  Created by Ricardo Hui on 25/4/2019.
//  Copyright © 2019 Ricardo Hui. All rights reserved.
//

import UIKit
import FirebaseStorage
class SelectPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var imagePicker : UIImagePickerController?
    var imageAdded : Bool = false
    let fileName = "\(NSUUID().uuidString).jpg"
    
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
                let imageFolder = Storage.storage().reference().child("images")
          
                if let image = imageView.image{
                    if let imageData = image.jpegData(compressionQuality: 0.1){
                        imageFolder.child(fileName).putData(imageData, metadata: nil) { (metadata, error) in
                            if let error = error {
                                self.presentAlert(message: error.localizedDescription)
                            }else{
                                //segue to the next view controller
                                let ref = Storage.storage().reference().child("images/\(self.fileName)")
                                ref.downloadURL(completion: { (url, error) in
                                    
                                    if let url = url{
                                       print("URL")
                                        print(url)
                                            self.performSegue(withIdentifier: "selectReceiverSegue", sender: url)
                                    }
                                    
                                })
                                
                            }
                        }
                    }
                }
                
            }else{
                // We are missing something
                
                let alertController = UIAlertController(title: "Error", message: "You must provide an image and a message  for your app", preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
                
                
            }
        }
        
        
    }
    
    
    func presentAlert(message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let downloadURL = sender as? NSURL{
            if let urlString = downloadURL.absoluteString{
                print(downloadURL)
                if let selectVC = segue.destination as? SelectRecipientTableViewController{
                    selectVC.downloadURL = urlString
                    selectVC.snapDescription = messageTextField.text!
                    selectVC.imageName = self.fileName
                }
            }
            
        }else{
            print("it is not a string")
        }
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        
        if imagePicker != nil{
            imagePicker?.sourceType = .camera
            present(imagePicker!, animated: true, completion: nil)
        }
    }
}
