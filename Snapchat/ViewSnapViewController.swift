//
//  ViewSnapViewController.swift
//  Snapchat
//
//  Created by Ricardo Hui on 27/4/2019.
//  Copyright © 2019 Ricardo Hui. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage
import FirebaseStorage
import FirebaseAuth


class ViewSnapViewController: UIViewController {
    var snap: DataSnapshot?
    
    @IBOutlet var imageView: UIImageView!
    
    
    @IBOutlet var messageLabel: UILabel!
    var imageName = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let snapDictionary = snap?.value as? NSDictionary, let description = snapDictionary["description"] as? String, let imageURL = snapDictionary["imageURL"] as? String, let url = URL(string: imageURL), let imageName = snapDictionary["imageName"] as? String{
                messageLabel.text = description
                imageView.sd_setImage(with: url, completed: nil)
            self.imageName = imageName
            
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
    
    override func viewWillDisappear(_ animated: Bool) {
        if let currentUserUid = Auth.auth().currentUser?.uid, let key = snap?.key{
            Database.database().reference().child("users").child(currentUserUid).child("snaps").child(key ).removeValue()
            Storage.storage().reference().child("images").child(imageName).delete(completion: nil)
        }
    }

}
