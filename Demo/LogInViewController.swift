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
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func emailChange() {
        if emailTextField.text != "" && passwordTextField.text != ""{
            nextButton.isHidden = false
        }
        else{
            nextButton.isHidden = true
        }
    }
    @IBAction func passwordChange() {
        if emailTextField.text != "" && passwordTextField.text != ""{
            nextButton.isHidden = false
        }
        else{
            nextButton.isHidden = true
        }
    }
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        let alertController = UIAlertController(title: "重設密碼 🔑", message: "請輸入您忘記密碼的信箱", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {(textField: UITextField) -> Void in
            textField.placeholder = "Email"
        })
        let resetAction = UIAlertAction(title: "重新發送" , style: .default , handler:{ (action:UIAlertAction!) -> Void in
            let email = (alertController.textFields?.first)! .text!
            print (email)
        })
        alertController.addAction(resetAction)
        let cancelAction = UIAlertAction(title: "取消" , style: .cancel , handler: nil)
        alertController.addAction(cancelAction)
        present(alertController,animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nextButton.isHidden = true
        
    }
    
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

            //解除鍵盤
            self.view.endEditing(true)
            
            //呈現主視圖
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MyProfile"){
                self.present(viewController, animated: true, completion: nil)
            }
        })
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
