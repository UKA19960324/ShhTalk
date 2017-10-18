//
//  LogInViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/7/12.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
import Firebase
class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.attributedPlaceholder = NSAttributedString(string:
            "Email", attributes:
            [NSForegroundColorAttributeName:#colorLiteral(red: 0.6216775179, green: 0.9486287236, blue: 1, alpha: 0.6)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName:#colorLiteral(red: 0.6216775179, green: 0.9486287236, blue: 1, alpha: 0.6)])
    }
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // 登入按鈕功能
    @IBAction func loginAction(_ sender: UIButton) {
        //輸入驗證
        guard let emailAddress = emailTextField.text , emailAddress != "" ,
            let password = passwordTextField.text , password != ""
            else {
                let alertController = UIAlertController(title: "Login Error" , message: "Both fields must not be blank.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK" , style: .cancel,handler: nil)
                alertController.addAction(okayAction)
                present(alertController,animated: true, completion: nil)
                return
        }
        //呼叫Firebase API 執行登入
        Auth.auth().signIn(withEmail: emailAddress, password: password, completion: { (user , error) in
            if let error = error{
                let alertController = UIAlertController(title: "Login Error",message: error.localizedDescription,preferredStyle : .alert )
                let okayAction = UIAlertAction(title: "OK", style: .cancel,handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            //Email驗證
            guard let currentUser = user, currentUser.isEmailVerified
                else{
                    let alertController = UIAlertController(title: "Login Error",message: "You haven't confirmed your email address yet. We sent you a confirmation email when you sign up. Please click the verifiction link in that email. If you need us to send the confirmation email again, please tap Resend Email.",preferredStyle:
                        .alert)
                    let okayAction = UIAlertAction(title: "Resend email", style: .default,handler:{(action) in user?.sendEmailVerification(completion: nil)})
                    let cancelAction = UIAlertAction(title: "Cancel",style: .cancel,handler: nil)
                    alertController.addAction(okayAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
            }
            let usersDatabaseRef = Database.database().reference().child("Users").child((user?.uid)!)
            usersDatabaseRef.child("Name").setValue(user?.displayName)
            usersDatabaseRef.child("Photo").setValue( user?.photoURL?.absoluteString)
            usersDatabaseRef.child("Friends").child("X").setValue("X")
            //usersDatabaseRef.child("picture")
            //解除鍵盤
            self.view.endEditing(true)
            
            //呈現主視圖
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MyProfile"){
                self.present(viewController, animated: true, completion: nil)
            }
        })
    }
    
    // 忘記密碼按鈕功能
    @IBAction func forgetPassword(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Reset Password 🔑", message: "Please enter your alternate             email address.", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {(textField: UITextField) -> Void in
            textField.placeholder = "Email"
        })
        let resetAction = UIAlertAction(title: "Resend" , style: .default , handler:{ (action:UIAlertAction!) -> Void in
            // let email = (alertController.textFields?.first)! .text!
            // print (email)
            guard let email = (alertController.textFields?.first)!.text , email != ""
            else{
                let alertController = UIAlertController(title: "Input Error", message: "Please provide your email address for password reset.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK",style: .cancel,handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            Auth.auth().sendPasswordReset(withEmail: email, completion: {(error) in
                let title = (error == nil) ? "Password Rest Follow-up" : "Password Reset Error"
                let message = (error == nil) ? "We have just sent you a password reset email. Please check your inbox and follow the instructions to reset your password." : error?.localizedDescription
                let alertController = UIAlertController(title: title,message: message,preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel,handler:{(action) in
                    if error == nil{
                        //解除鍵盤
                        self.view.endEditing(true)
                    }
                })
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
            })
        })
        alertController.addAction(resetAction)
        let cancelAction = UIAlertAction(title: "取消" , style: .cancel , handler: nil)
        alertController.addAction(cancelAction)
        present(alertController,animated: true, completion: nil)
    }

}




