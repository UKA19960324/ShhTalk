//
//  HomeViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/9/10.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var signUpContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginContainerView.isHidden = false
        signUpContainerView.isHidden = true
    }
    @IBAction func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        //let location = sender.location(in: view)
        //print("Left :  \(location)")
        loginContainerView.isHidden = true
        signUpContainerView.isHidden = false
    }
    @IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        //let location = sender.location(in: view)
        //print("Left :  \(location)")
        signUpContainerView.isHidden = true
        loginContainerView.isHidden = false
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
