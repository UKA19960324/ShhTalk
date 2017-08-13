//
//  fbBtn.swift
//  
//
//  Created by 王曉琪 on 2017/8/13.
//
//

import UIKit

@IBDesignable
class fbBtn: UIButton {

// 按鈕外型
    // 圓角半徑
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    // 邊框寬度
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    // 邊框顏色
    
    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
// 內文對齊
    
    // 上
    @IBInspectable var titleTopPadding: CGFloat = 0.0 {
        didSet {
            titleEdgeInsets.top = titleTopPadding
        }
    }
    
    // 下
    @IBInspectable var titleBottomPadding: CGFloat = 0.0 {
        didSet {
            titleEdgeInsets.bottom = titleBottomPadding
        }
    }

    // 左
    @IBInspectable var titleLeftpadding: CGFloat = 0.0 {
        didSet {
            titleEdgeInsets.left = titleLeftpadding
        }
    }
    
    // 右
    @IBInspectable var titleRightPadding: CGFloat = 0.0 {
        didSet {
            titleEdgeInsets.right = titleRightPadding
        }
    }
    
    
// 圖示對齊
    
    //上
    @IBInspectable var imageTopPadding: CGFloat = 0.0 {
        didSet {
            imageEdgeInsets.top = imageTopPadding
        }
    }
    
    // 下
    @IBInspectable var imageBottomPadding: CGFloat = 0.0 {
        didSet {
            imageEdgeInsets.bottom = imageBottomPadding
        }
    }
    
    // 左
    @IBInspectable var imageLeftPadding: CGFloat = 0.0 {
        didSet {
            imageEdgeInsets.left = imageLeftPadding
        }
    }
    
    // 右
    @IBInspectable var imageRightPadding: CGFloat = 0.0 {
        didSet {
            imageEdgeInsets.right = imageRightPadding
        }
    }
    
// 圖示與內文之間
    
    @IBInspectable var enableImageRightAligned: Bool = false
    @IBInspectable var enableGradientBackground: Bool = false
    @IBInspectable var gradientColor1: UIColor = UIColor.black
    @IBInspectable var gradientColor2: UIColor = UIColor.white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if enableImageRightAligned,
            let imageView = imageView {
            imageEdgeInsets.left = self.bounds.width - imageView.bounds.width - imageRightPadding
        }
        
        // 漸層
        if enableGradientBackground {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [gradientColor1.cgColor, gradientColor2.cgColor]
            gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
            gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
            self.layer.insertSublayer(gradientLayer, at: 0)
            
            
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
