//
//  HomeViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/9/10.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class HomeViewController: UIViewController,GIDSignInDelegate , GIDSignInUIDelegate {

    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var signUpContainerView: UIView!
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        loginContainerView.isHidden = false
        signUpContainerView.isHidden = true
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //點選空白區域(鍵盤收合)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    //左滑切換到登入畫面
    @IBAction func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        //let location = sender.location(in: view)
        //print("Left :  \(location)")
        loginContainerView.isHidden = true
        signUpContainerView.isHidden = false
    }
    
    //右滑切換到註冊畫面
    @IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        //let location = sender.location(in: view)
        //print("Left :  \(location)")
        signUpContainerView.isHidden = true
        loginContainerView.isHidden = false
    }

    // Google登入
    @IBAction func googleLogin(sender: UIButton){
        GIDSignIn.sharedInstance().signIn()
    }
    
    //  GIDSignInDelegate  協定所需實作之方法
    func sign(_ signin: GIDSignIn, didSignInFor user: GIDGoogleUser!, withError error: Error!){
        
        if error != nil{
            return
        }
        guard let authentication = user.authentication else {
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential, completion: {(user,error) in
            //登入失敗
            if let error = error {
                let alertController = UIAlertController(title: "Login Error",message: error.localizedDescription,preferredStyle : .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController,animated: true,completion: nil)
                return
            }
            let usersDatabaseRef = Database.database().reference().child("Users").child((user?.uid)!)
            usersDatabaseRef.child("Name").setValue(user?.displayName)
            usersDatabaseRef.child("Photo").setValue( user?.photoURL?.absoluteString)
            usersDatabaseRef.child("Friends").child("X").setValue("X")
            //登入成功 轉畫面
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MyProfile"){
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func sign(_ signIn: GIDSignIn, didDisconnectWith user: GIDGoogleUser, withError: Error){
    }
    
    // FB 登入
    @IBAction func facebookSignIn(_ sender: UIButton) {
        //FBSDKLoginManager().logOut()
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
                    let usersDatabaseRef = Database.database().reference().child("Users").child((user?.uid)!)
                    usersDatabaseRef.child("Name").setValue(user?.displayName)
                    usersDatabaseRef.child("Photo").setValue( user?.photoURL?.absoluteString)
                    usersDatabaseRef.child("Friends").child("X").setValue("X")
                    // 跳制登入後的app畫面
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MyProfile") {
                        UIApplication.shared.keyWindow?.rootViewController = viewController
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }

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
