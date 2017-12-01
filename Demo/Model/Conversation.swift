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
    var lastMessage: Message
    
    //MARK: Inits
    
    init(user: User, lastMessage: Message) {
        self.user = user
        self.lastMessage = lastMessage
    }
    
    //MARK: Methods
    class func showConversations(forUserID: String , completion: @escaping ([Conversation]) -> Swift.Void){
        var conversations = [Conversation]()
        Database.database().reference().child("users").child(forUserID).child("friends").observe(.childAdded, with: { (snapshot) in
            let friendsId = snapshot.key
            let emptyMessage = Message.init(type: .text, content: "", owner: .sender, timestamp: 0, isRead: true)
            User.info(forUserID: friendsId , completion: { (user) in
                let conversation = Conversation.init(user: user, lastMessage: emptyMessage)
                Database.database().reference().child("users").child(user.id).child("conversations").observeSingleEvent(of: .childAdded, with:{ (snapshot) in
                    if snapshot.exists() {
                        let values = snapshot.value as! [String: String]
                        let location = values["location"]! // 訊息位置
                        conversation.lastMessage.downloadLastMessage(forLocation: location, completion:{(_) in
                            completion(conversations)
                        })
                    }
                })
                conversations.append(conversation)
                completion(conversations)
            })
        })
    }
    
}
