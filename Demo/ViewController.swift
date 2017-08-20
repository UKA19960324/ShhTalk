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
import GoogleSignIn

class ViewController: UIViewController , GIDSignInDelegate , GIDSignInUIDelegate {

    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var signUpContainerView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var lefttriangleButton: UIButton!
    @IBOutlet weak var righttriangleButton: UIButton!
    
    // Do any additional setup after loading the view, typically from a nib.
    override func viewDidLoad() {
        super.viewDidLoad()
        righttriangleButton.isHidden = true
        // GIDSignInDelegate , GIDSignInUIDelegate 初始值
        self.title = ""
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    //點選空白區域(鍵盤收合)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginAction() {
        loginContainerView.isHidden = false
        signUpContainerView.isHidden = true
        lefttriangleButton.isHidden = false
        righttriangleButton.isHidden = true
    }
    @IBAction func signUpAction() {
        loginContainerView.isHidden = true
        signUpContainerView.isHidden = false
        lefttriangleButton.isHidden = true
        righttriangleButton.isHidden = false
    }
    
    // FB 登入
    @IBAction func facebookSignIn(_ sender: Button) {
        
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
                // 跳制登入後的app畫面
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MyProfile") {
                        UIApplication.shared.keyWindow?.rootViewController = viewController
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
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
            //登入成功 轉畫面
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MyProfile"){
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    func sign(_ signIn: GIDSignIn, didDisconnectWith user: GIDGoogleUser, withError: Error){
    }
}
