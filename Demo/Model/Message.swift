//
//  Message.swift
//  Demo
//
//  Created by U.K.A on 2017/10/26.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class Message {

    //MARK: Properties
    
    var owner: MessageOwner
    var type: MessageType
    var content: Any
    var timestamp: Int
    var isRead: Bool
    var image: UIImage?
    private var toID: String?
    private var fromID: String?
    
    //MARK: Inits
    
    init(type: MessageType, content: Any, owner: MessageOwner, timestamp: Int, isRead: Bool) {
        self.type = type
        self.content = content
        self.owner = owner
        self.timestamp = timestamp
        self.isRead = isRead
    }
    
    //MARK: Methods
    
    class func send(message: Message, toID: String, completion: @escaping (Bool) -> Swift.Void)  {
        if let currentUserID = Auth.auth().currentUser?.uid {
//            switch message.type {
//            case .location:
//                let values = ["type": "location", "content": message.content, "fromID": currentUserID, "toID": toID, "timestamp": message.timestamp, "isRead": false]
//                Message.uploadMessage(withValues: values, toID: toID, completion: { (status) in
//                    completion(status)
//                })
//            case .photo:
//                let imageData = UIImageJPEGRepresentation((message.content as! UIImage), 0.5)
//                let child = UUID().uuidString
//                FIRStorage.storage().reference().child("messagePics").child(child).put(imageData!, metadata: nil, completion: { (metadata, error) in
//                    if error == nil {
//                        let path = metadata?.downloadURL()?.absoluteString
//                        let values = ["type": "photo", "content": path!, "fromID": currentUserID, "toID": toID, "timestamp": message.timestamp, "isRead": false] as [String : Any]
//                        Message.uploadMessage(withValues: values, toID: toID, completion: { (status) in
//                            completion(status)
//                        })
//                    }
//                })
//            case .text:
            let values = ["type": "text", "content": message.content, "fromID": currentUserID, "toID": toID, "timestamp": message.timestamp, "isRead": false]
            Message.uploadMessage(withValues: values, toID: toID, completion: { (status) in
                completion(status)
            })
            //            }
        }
    }
    
}

