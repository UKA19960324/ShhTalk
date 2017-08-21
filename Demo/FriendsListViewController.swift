//
//  FriendsListViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/7/27.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit

class FriendsListViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        addSideBarMenu(leftMenuButton: menuButton)
    }

    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func AddFriendBtnAction(_ sender: UIBarButtonItem) {
        // 建立一個 UIAlertController 的實體
        // 設定 UIAlertController 的標題與樣式為 動作清單 (actionSheet)
        let AddFriendAlertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        // Change font of the title and message
        let titleFont:[String : AnyObject] = [ NSFontAttributeName : UIFont(name: "AmericanTypewriter", size: 20)! ]
        let attributedTitle = NSMutableAttributedString(string: "Add friend using QRcode", attributes: titleFont)
        AddFriendAlertController.setValue(attributedTitle, forKey: "attributedTitle")
        // 建立三個 UIAlertAction 的實體
        // 新增 UIAlertAction 在 UIAlertController actionSheet 的 動作 (action) 與標題
        let QRcodeAction = UIAlertAction(title: "QRcode", style: .default) { (Void) in
            
        }
        let scanAction = UIAlertAction(title: "Scan", style: .default) { (Void) in
        }
        // 新增一個取消動作，讓使用者可以跳出 UIAlertController
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (Void) in
            AddFriendAlertController.dismiss(animated: true, completion: nil)
        }
        // 將上面三個 UIAlertAction 動作加入 UIAlertController
        AddFriendAlertController.addAction(QRcodeAction)
        AddFriendAlertController.addAction(scanAction)
        AddFriendAlertController.addAction(cancelAction)
        
        // 當使用者按下 AddFriendAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
        present(AddFriendAlertController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
