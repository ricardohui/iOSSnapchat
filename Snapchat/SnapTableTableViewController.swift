//
//  SnapTableTableViewController.swift
//  Snapchat
//
//  Created by Ricardo Hui on 25/4/2019.
//  Copyright © 2019 Ricardo Hui. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class SnapTableTableViewController: UITableViewController {

    var snaps : [DataSnapshot] = []
    
    @IBAction func logoutTapped(_ sender: Any) {
        try? Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentUserUid = Auth.auth().currentUser?.uid{
            Database.database().reference().child("users").child(currentUserUid).child("snaps").observe(.childAdded) { (snapshot) in
                self.snaps.append(snapshot)
                self.tableView.reloadData()
                
                Database.database().reference().child("users").child(currentUserUid).child("snaps").observe(.childRemoved, with: { (snapshot) in
                     var index = 0
                    for snap in self.snaps{
                        if snapshot.key == snap.key{
                            self.snaps.remove(at: index)
                        }
                        index += 1
                    }
                    self.tableView.reloadData()
                })
            }
        }
        
        
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if  snaps.count == 0{
            return 1
        }else{
            return snaps.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
      
        
        if snaps.count == 0 {
            cell.textLabel?.text = "You have no snaps..."
        }else{
            let snap = snaps[indexPath.row]
            if let snapDictionary = snap.value as? NSDictionary, let fromEmail = snapDictionary["from"] as? String{
                cell.textLabel?.text = fromEmail
            }

        }
        
        
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if snaps.count > 0 {
            let snap = snaps[indexPath.row]
            performSegue(withIdentifier: "viewSnapSegue", sender: snap)
        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "viewSnapSegue", let viewVC = segue.destination as? ViewSnapViewController, let snap = sender as? DataSnapshot{
                viewVC.snap = snap
        }
    }


}
