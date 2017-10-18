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
}
