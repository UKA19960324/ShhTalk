//
//  SideButton.swift
//  Demo
//
//  Created by U.K.A on 2017/9/13.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
var buttonsArr = [RHButtonView]()
var sideButtonsView: RHSideButtons?
extension UIViewController: RHSideButtonsDataSource , RHSideButtonsDelegate{
    
    func addSideButton() {
        let triggerButton = RHTriggerButtonView(pressedImage: UIImage(named: "exit_icon")!) {
            $0.image = UIImage(named: "trigger_img")
            $0.hasShadow = true
        }
        
        sideButtonsView = RHSideButtons(parentView: view, triggerButton: triggerButton)
        sideButtonsView?.delegate = self
        sideButtonsView?.dataSource = self
        sideButtonsView?.setTriggerButtonPosition(CGPoint(x: view.bounds.width - 53,
                                                          y: view.bounds.height - 55))
        
        for index in 1...3 {
            buttonsArr.append(generateButton(withImgName: "icon_\(index)"))
        }
        sideButtonsView?.reloadButtons()
    }
    
    func generateButton(withImgName imgName: String) -> RHButtonView {
        
        return RHButtonView {
            $0.image = UIImage(named: imgName)
            $0.hasShadow = true
        }
    }
    public func sideButtonsNumberOfButtons(_ sideButtons: RHSideButtons) -> Int {
        return buttonsArr.count
    }
    
    public func sideButtons(_ sideButtons: RHSideButtons, buttonAtIndex index: Int) -> RHButtonView {
        return buttonsArr[index]
    }

    public func sideButtons(_ sideButtons: RHSideButtons, didSelectButtonAtIndex index: Int) {
        //print("🍭 button index tapped: \(index)")
        switch index {
        case 0:
            print("You Tube ! ")
        case 1:
            print("iN ! ")
        case 2:
            print("Yahoo ! ")
        default:
            break
        }
    }
    
    public func sideButtons(_ sideButtons: RHSideButtons, didTriggerButtonChangeStateTo state: RHButtonState) {
        print("🍭 Trigger button")
    }
}
