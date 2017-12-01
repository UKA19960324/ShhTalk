//
//  UIImage+Scale.swift
//  Demo
//
//  Created by U.K.A on 2017/8/18.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
extension UIImage {
    func scale(newWidth: CGFloat) -> UIImage {
        // 確認所給定的寬度與目前的不同
        if self.size.width == newWidth {
            return self
        }
        // 計算縮放因子
        let scaleFactor = newWidth / self.size.width
        let newHeight = self.size.height * scaleFactor
        let newSize = CGSize(width: newWidth , height: newHeight)
        UIGraphicsBeginImageContextWithOptions(newSize,false,0.0)
        self.draw(in: CGRect(x: 0 , y: 0 , width: newWidth,height: newHeight))
        let newImage : UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}


