//
//  User.swift
//  Demo
//
//  Created by U.K.A on 2017/10/18.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class User : NSObject {
    
    //MARK: Properties
    
    let name: String
    let email: String
    let id: String
    var profilePic: UIImage
    
    //MARK: Inits
    
    init(name: String, email: String, id: String, profilePic: UIImage) {
        self.name = name
        self.email = email
        self.id = id
        self.profilePic = profilePic
    }
    
    // 讀取使用者基本資料(email , name , picture)
    class func info(forUserID: String, completion: @escaping (User) -> Void ){
        Database.database().reference().child("users").child(forUserID).child("credentials").observeSingleEvent(of: .value, with: { (snapshot) in
            //            print("======================")
            //            print(snapshot.value)
            //            print("======================")
            if let data = snapshot.value as? [String:String]{
                let name = data["name"]!
                let email = data["email"]!
                let link = URL.init(string: data["profilePicLink"]!)
                URLSession.shared.dataTask(with: link! , completionHandler: { (data, response , error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        let user = User.init(name: name, email: email, id: forUserID, profilePic: profilePic!)
                        completion(user)
                    }
                }).resume()
            }
        })
    }
    
    // 讀取使用者好友資料
    class func downloadAllFriedns(forUserID: String, completion: @escaping (User) -> Void ){
        Database.database().reference().child("users").child(forUserID).child("Friends").observe(.childAdded, with: {(snapshot) in
            //            print("======================")
            //            print(snapshot)
            //            print(snapshot.key)
            //            print(snapshot.value )
            //            print("======================")
            let friendId = snapshot.key
            Database.database().reference().child("users").child(friendId).child("credentials").observeSingleEvent(of: .value, with: { (snapshot) in
                //                print("======================")
                //                print(snapshot.value)          // 中文亂碼
                //                print("======================")
                if let data = snapshot.value as? [String:String]{
                    let name = data["name"]!
                    let email = data["email"]!
                    //                    print("======================")
                    //                    print(name)                    //顯示正常
                    //                    print(email)
                    //                    print(link)
                    //                    print("======================")
                    let link = URL.init(string: data["profilePicLink"]!)
                    URLSession.shared.dataTask(with: link! , completionHandler: { (data, response , error) in
                        if error == nil {
                            let profilePic = UIImage.init(data: data!)
                            let user = User.init(name: name, email: email, id: forUserID, profilePic: profilePic!)
                            completion(user)
                        }
                    }).resume()
                }
            })
        })
    }
}
