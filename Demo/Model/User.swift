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
    
}
