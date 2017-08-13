//
//  ViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/7/11.
//  Copyright © 2017年 U.K.A. All rights reserved.
//
import UIKit
import FBSDKLoginKit
import Firebase

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
    
    // FB登入按鈕
    @IBAction func facebookSignIn(_ sender: fbBtn) {
        FBSDKLoginManager().logOut()
        // 採用FBSDKLoginManager類別進行登入動作
        let fbLoginManager = FBSDKLoginManager()

        // 取得登入授權
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to signin: \(error.localizedDescription)")
                return
            }
            
            // 是否確定授權
            if result?.isCancelled != true {
                print("Auth Successed")
                
                // 未知
                guard let accessToken = FBSDKAccessToken.current() else {
                    print("Failed to get access token")
                    return
                }
                
                // 未知
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                
                // 呼叫 Firebase API 來執行登入
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if let error = error {
                        print("Login error: \(error.localizedDescription)")
                        return
                    }
                    
                    // 跳制登入後的app畫面
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MyProfile") {
                        UIApplication.shared.keyWindow?.rootViewController = viewController
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                })
            }
        }
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

