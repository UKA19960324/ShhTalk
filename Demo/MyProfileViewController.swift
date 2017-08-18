//
//  MyProfileViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/7/27.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
import Firebase
class MyProfileViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        addSideBarMenu(leftMenuButton: menuButton)
        if let currentuser = Auth.auth().currentUser{
            print("--------------------")
            print(currentuser.displayName)
            print(currentuser.email)
            print(currentuser.photoURL)
//            if let ProfileImageUrl = currentuser.photoURL{
//                do {
//                    let image = try Data(contentsOf: ProfileImageUrl)
//                    imageView.image = UIImage(data: image)
//                }catch{
//                    print("Unale to load data")
//                }
//            }
            if let IMVurl = NSData(contentsOf: currentuser.photoURL!){
                //let  img = UIImage(data: IMVurl as Data)
                //imageView.image = img?.scale(newWidth: 240)
                imageView.image = UIImage(data: IMVurl as Data)
            }
            //if let picture = resultNew["picture"] as? NSDictionary,
            //    let data = picture["data"] as? NSDictionary,
            //    let url = data["url"] as? NSString {
            //
            //    if let IMVurl = NSURL(string: url as String) {
            //        if let IMVdata = NSData(contentsOf: IMVurl as URL) {
            //            self.Picture.image = UIImage(data: IMVdata as Data)
            //        }
            //    }
            //    
            //    print(url) //臉書大頭貼的url, 再放入imageView內秀出來
            //}
            print(currentuser.uid)
            print("--------------------")
        }
    }
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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










