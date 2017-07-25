//
//  SignUpViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/7/13.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
import Firebase
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
    
    @IBAction func registerAccount(_ sender: UIButton) {
        //輸入驗證
        guard let name = nameTextField.text , name != "" ,
                   let emailAddress = emailTextField.text , emailAddress != "" ,
                   let password = passwordTextField.text , password != ""
        else {
            let alertController = UIAlertController(title: "Registration Error", message: "Please make sure you provide your name,email address and password to complete the registration",preferredStyle: .alert )
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            present(alertController,animated: true,completion: nil)
            return
        }
        //在Firebase 註冊使用者帳號
        Auth.auth().createUser(withEmail: emailAddress , password: password , completion: {(user , error ) in
            if let error = error {
                let alertController = UIAlertController(title : "Registration Error" , message : error.localizedDescription,preferredStyle: .alert )
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController,animated: true,completion: nil)
                return
            }
            //儲存使用者名稱
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest(){
                changeRequest.displayName = name
                changeRequest.commitChanges(completion: {(error: Error?) in
                    if let error = error{
                        print("Failed to change the display name: \(error.localizedDescription)")
                    }
                })
            }
            //移除鍵盤
            self.view.endEditing(true)
            //傳送驗證信
            user?.sendEmailVerification(completion: nil)
            let alertController = UIAlertController(title: "Email Verification", message: "We've just sent a confirmation email to your email address. Please check your inbox and click the verification link in that email to complete the sign up.",preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        })
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