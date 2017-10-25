//
//  Conversation.swift
//  Demo
//
//  Created by U.K.A on 2017/10/25.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class Conversation {
    
    //MARK: Properties
    
    let user: User
//    var lastMessage: Message
    
    //MARK: Inits
    
    init(user: User/*, lastMessage: Message*/) {
        self.user = user
//        self.lastMessage = lastMessage
    }
    
    //MARK: Methods
    class func showConversations(forUserID: String , completion: @escaping ([Conversation]) -> Swift.Void){
        var conversations = [Conversation]()
        Database.database().reference().child("users").child(forUserID).child("friends").observe(.childAdded, with: { (snapshot) in
            let friendsId = snapshot.key
            User.info(forUserID: friendsId , completion: { (user) in
                Database.database().reference().child("users").child(user.id).child("conversations").observe(.childAdded, with: { (snapshot) in
                    if snapshot.exists() {
                    // ...
                    }
                })
                let conversation = Conversation.init(user: user/*, lastMessage: emptyMessage*/)
                conversations.append(conversation)
                completion(conversations)
            })
        })
    }
    
}
