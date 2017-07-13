//
//  LogInViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/7/12.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit

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
