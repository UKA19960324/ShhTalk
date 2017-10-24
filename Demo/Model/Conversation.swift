//
//  Conversation.swift
//  Demo
//
//  Created by U.K.A on 2017/10/23.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class Conversation {
    
    //MARK: Properties
    let user: User
    //var lastMessage: Message
    //MARK: Inits
    init(user: User/*, lastMessage: Message*/) {
        self.user = user
        //self.lastMessage = lastMessage
    }
    //MARK: Methods
    class func showConversations(forUserID: String,completion: @escaping ([Conversation]) -> Swift.Void) {
        var conversations = [Conversation]()
        Database.database().reference().child("users").child(forUserID).child("friends").observe(.childAdded, with: {(snapshot) in
//            print("======================")
//            print(snapshot)
//            print(snapshot.key)
//            print(snapshot.value )
//            print("======================")
            let friendId = snapshot.key
            User.info(forUserID: friendId, completion: { (user) in                Database.database().reference().child("users").child(user.id).child("conversations").observe(.childAdded, with: { (snapshot) in
                    if snapshot.exists() {
                        print("Yes")
//                        let fromID = snapshot.key
//                        let values = snapshot.value as! [String: String]
//                        let location = values["location"]!
//                        User.info(forUserID: fromID, completion: { (user) in
//                            let emptyMessage = Message.init(type: .text, content: "loading", owner: .sender, timestamp: 0, isRead: true)
//                            let conversation = Conversation.init(user: user, lastMessage: emptyMessage)
//                            conversations.append(conversation)
//                            conversation.lastMessage.downloadLastMessage(forLocation: location, completion: { (_) in
//                                completion(conversations)
//                            })
//                        })
                    }
                })
                    //print(user.name)
                    //print("~~~~~~~~~~~")
                    let conversation = Conversation.init(user: user/*, lastMessage: emptyMessage*/)
                    conversations.append(conversation)
                completion(conversations)
            })
        })
    }
}


//
//        if let currentUserID = Auth.auth().currentUser?.uid {
//            var conversations = [Conversation]()
//            User.downloadAllFriedns(forUserID: id, completion: { (user) in
//
//            })
//            Database.database().reference().child("users").child(currentUserID).child("conversations").observe(.childAdded, with: { (snapshot) in
//                if snapshot.exists() {
//                    print(snapshot)
//                    let fromID = snapshot.key
//                    //let values = snapshot.value as! [String: String]
//                    //let location = values["location"]!
//                    User.info(forUserID: fromID, completion: { (user) in
//                        //let emptyMessage = Message.init(type: .text, content: "loading", owner: .sender, timestamp: 0, isRead: true)
//                        let conversation = Conversation.init(user: user/*, lastMessage: emptyMessage*/)
//                        conversations.append(conversation)
////                        conversation.lastMessage.downloadLastMessage(forLocation: location, completion: { (_) in
////                            completion(conversations)
////                        })
//                    })
//                }
//            })
//        }
