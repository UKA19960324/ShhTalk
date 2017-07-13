//
//  SignUpViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/7/13.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func nameChange() {
        if nameTextField.text != "" && emailTextField.text != "" && passwordTextField.text != ""{
            signupButton.isHidden = false
        }
        else{
            signupButton.isHidden = true
        }
    }
    @IBAction func emailChange() {
        if nameTextField.text != "" && emailTextField.text != "" && passwordTextField.text != ""{
            signupButton.isHidden = false
        }
        else{
            signupButton.isHidden = true
        }
    }
    @IBAction func passwordChange() {
        if nameTextField.text != "" && emailTextField.text != "" && passwordTextField.text != ""{
            signupButton.isHidden = false
        }
        else{
            signupButton.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        signupButton.isHidden = true
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
