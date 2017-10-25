//
//  MessageViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/7/27.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
import Firebase
class MessageViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var messageTableView: UITableView!
    var items = [Conversation]()
    var selectedUser: User?
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        addSideButton()
        self.fetchData()
    }
 
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Downloads conversations
    func fetchData() {
        if let id = Auth.auth().currentUser?.uid {
            Conversation.showConversations(forUserID: id , completion: { (conversations) in
                DispatchQueue.main.async {
                    self.items = conversations
                    self.messageTableView.reloadData()
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MessageTableViewCell
        cell.nameLabel.text = items[indexPath.row].user.name
        cell.photoImageView.image = items[indexPath.row].user.profilePic
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedUser = self.items[indexPath.row].user
        self.performSegue(withIdentifier: "segue", sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let vc = segue.destination as! ChatViewController
            vc.currentUser = self.selectedUser
        }
    }
    
}
