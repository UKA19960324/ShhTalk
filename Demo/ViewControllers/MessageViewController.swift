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
    //Downloads user friends list
    func fetchUsers()  {
        if let id = Auth.auth().currentUser?.uid{
            User.downloadAllFriedns(forUserID: id, completion: { (user) in
                DispatchQueue.main.async {
                    self.items.append(user)
                    self.messageTableView.reloadData()
                }
            })
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
