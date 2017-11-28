//
//  Helper Files.swift
//  Demo
//
//  Created by U.K.A on 2017/10/26.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import Foundation
import UIKit

//Enums
enum MessageType {
    case photo
    case text
    case location
    case model
}

enum MessageOwner {
    case sender
    case receiver
}

enum ShowExtraView {
    case photo
    case map
}

class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
