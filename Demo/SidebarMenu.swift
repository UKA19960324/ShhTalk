//
//  SidebarMenu.swift
//  Demo
//
//  Created by U.K.A on 2017/8/16.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
extension UIViewController{
    func addSideBarMenu(leftMenuButton: UIBarButtonItem? )  {
        if revealViewController() != nil {
            if let menuButton = leftMenuButton {
                menuButton.target = revealViewController()
                menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
                revealViewController().rearViewRevealWidth = 200
            }
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
