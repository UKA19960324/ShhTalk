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
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var lefttriangleButton: UIButton!
    @IBOutlet weak var righttriangleButton: UIButton!

    @IBAction func loginAction() {
        loginContainerView.isHidden = false
        signUpContainerView.isHidden = true
        lefttriangleButton.isHidden = false
        righttriangleButton.isHidden = true
        //loginButton.setTitleColor(UIColor.black, for: .normal)
        //signupButton.setTitleColor(UIColor.white, for: .normal)
    }
    @IBAction func signUpAction() {
        loginContainerView.isHidden = true
        signUpContainerView.isHidden = false
        lefttriangleButton.isHidden = true
        righttriangleButton.isHidden = false
        //loginButton.setTitleColor(UIColor.white, for: .normal)
        //signupButton.setTitleColor(UIColor.black, for: .normal)
    }
    //點選空白區域(鍵盤收合)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        righttriangleButton.isHidden = true
        //loginButton.setTitleColor(UIColor.black, for: .normal)
    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

}

