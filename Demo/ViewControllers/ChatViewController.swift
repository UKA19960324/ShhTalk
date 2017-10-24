//
//  ChatViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/10/24.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController {
    var items = [Message]()
    var currentUser: User?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print(currentUser?.name)
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
