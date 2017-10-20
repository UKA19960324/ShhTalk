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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        addSideButton()
        if let currentuser = Auth.auth().currentUser{
            let username = currentuser.displayName
            let useremail = currentuser.email
//            print("--------------------")
//            print(currentuser.displayName)
//            print(currentuser.email)
//            print(currentuser.photoURL)
//            print(currentuser.uid)
//            print("--------------------")
            nameLabel.text = username
            emailLabel.text = useremail
            if let ProfileImageUrl = currentuser.photoURL{
                do {
                    let image = try Data(contentsOf: ProfileImageUrl)
                    imageView.image = UIImage(data: image)
                }catch{
                    print("Unale to load data")
                }
            }
            let rootRef = Database.database().reference()
            let friends = rootRef.child("users").child(currentuser.uid).child("friends")
            friends.observe(.value , with: { (snap) in
                print(snap.childrenCount)
                self.countLabel.text = String(snap.childrenCount)
            })
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
/*
             `
            -d-
           -ds-
           /--`             ``.--.        .--
          .---         `..----smh:      .----`
          --:-.---....-------:o-      .-------
        `:-----:/o---::--.``       .---------
        :o:----:so----:          .-----:::::-
      -:/+sos:--ooo:--.        .///////:-`
     ++-:yso/--/+/----`        :///:.`
      .----//:----------`        ://:
    `.-:---------::::--:-      `-///
   -:-------::::--:------:-   `:///-`
   .------::-------:::::----:-+o.
       ``....----------------//ys+`
               ------------------+.
               .----------------/:
               `----:://::::::///`
                   .-//.`   `.--:/:
                     --         `::
*/
/*
                   .
                 .yh
                .dmd
                ss::                                  .`
               -:---                ````.//::.     `.---
               :---`            `..-----:mmd+`   `------`
              .--::`.....````.----------yy/`   `---------
              .::-------:---------------.`   `----------:
             `-:------//yy----:/--.``      `.-----------:`
             -s/-------oy+-----:.         .-------::::::-`
            .:o//+//+---:+++/---:        ::::///////:-`
           `++--sdhyy---:oooo----.       -///////:-`
           `++---oo+o:---:/::-----`       :////:`
            .-----:/+--------------`       :///:
           ``.::------------:::::----      .////
        ..-----------------::-------+:` `.:////:
        ::----------:://:---:----------.-////-`
        ----------/----------::///:-----:.-+s/`
          ```..---::--------------------//:syy+`
                    :---------------------:o:.`
                    :---------------------:o:
                    :--------------------:/:
                    --------::::::::-:::///`
                     .-::///:-...-:///////-
                       `-//.        ```./:-
                          -:             -/:
*/
