//
//  ViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/7/11.
//  Copyright © 2017年 U.K.A. All rights reserved.
//
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var signUpContainerView: UIView!
    
    @IBAction func loginAction() {
        loginContainerView.isHidden = false
        signUpContainerView.isHidden = true
    }
    @IBAction func signUpAction() {
        loginContainerView.isHidden = true
        signUpContainerView.isHidden = false
    }
    //點選空白區域(鍵盤收合)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

}

