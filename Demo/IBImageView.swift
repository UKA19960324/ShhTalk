//
//  IBImageView.swift
//  Demo
//
//  Created by Chi on 2017/9/11.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit

@IBDesignable
class IBImageView: UIImageView {

    // 圓角半徑
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
