//
//  AddFriendViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/10/9.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
import Firebase
class AddFriendViewController: UIViewController {
    
    var uID: String?
    let rootRef = Database.database().reference().child("users")
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addFriend(_ sender: UIButton) {
        let userId = Auth.auth().currentUser?.uid
        let userName = Auth.auth().currentUser?.displayName
        rootRef.child(userId!).child("Friends").child(uID!).setValue(nameLabel.text)
        rootRef.child(uID!).child("Friends").child(userId!).setValue(userName)
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Friends"){
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
