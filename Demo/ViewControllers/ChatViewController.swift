//
//  ChatViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/10/24.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    //MARK: Properties
    
    @IBOutlet var inputBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    override var inputAccessoryView: UIView? {
        get {
            self.inputBar.frame.size.height = self.barHeight
            self.inputBar.clipsToBounds = true
            return self.inputBar
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    var items = [Message]()
    var currentUser: User?
    let barHeight: CGFloat = 50
    
    //MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inputBar.backgroundColor = UIColor.clear
        self.view.layoutIfNeeded()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Methods
    
    func customization() {
        //self.imagePicker.delegate = self
        self.tableView.estimatedRowHeight = self.barHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset.bottom = self.barHeight
        self.tableView.scrollIndicatorInsets.bottom = self.barHeight
        //self.navigationItem.title = self.currentUser?.name
        //self.navigationItem.setHidesBackButton(true, animated: false)
        ///let icon = UIImage.init(named: "back")?.withRenderingMode(.alwaysOriginal)
        //let backButton = UIBarButtonItem.init(image: icon!, style: .plain, target: self, action: #selector(self.dismissSelf))
        //self.navigationItem.leftBarButtonItem = backButton
        //self.locationManager.delegate = self
    }

    
//    func animateExtraButtons(toHide: Bool)  {
//        switch toHide {
//        case true:
//            self.bottomConstraint.constant = 0
//            UIView.animate(withDuration: 0.3) {
//                self.inputBar.layoutIfNeeded()
//            }
//        default:
//            self.bottomConstraint.constant = -50
//            UIView.animate(withDuration: 0.3) {
//                self.inputBar.layoutIfNeeded()
//            }
//        }
//    }

    
    func composeMessage(type: MessageType, content: Any)  {
        let message = Message.init(type: type, content: content, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
        Message.send(message: message, toID: self.currentUser!.id, completion: {(_) in
        })
    }
    
    @IBAction func showMessage(_ sender: Any) {
        //self.animateExtraButtons(toHide: true)
    }
    
    @IBAction func selectGallery(_ sender: Any) {
//        self.animateExtraButtons(toHide: true)
//        let status = PHPhotoLibrary.authorizationStatus()
//        if (status == .authorized || status == .notDetermined) {
//            self.imagePicker.sourceType = .savedPhotosAlbum;
//            self.present(self.imagePicker, animated: true, completion: nil)
//        }
        
    }
    
    @IBAction func selectCamera(_ sender: Any) {
//        self.animateExtraButtons(toHide: true)
//        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
//        if (status == .authorized || status == .notDetermined) {
//            self.imagePicker.sourceType = .camera
//            self.imagePicker.allowsEditing = false
//            self.present(self.imagePicker, animated: true, completion: nil)
//        }
    }
    
    @IBAction func selectLocation(_ sender: Any) {
//        self.canSendLocation = true
//        self.animateExtraButtons(toHide: true)
//        if self.checkLocationPermission() {
//            self.locationManager.startUpdatingLocation()
//        } else {
//            self.locationManager.requestWhenInUseAuthorization()
//        }
    }
    
    @IBAction func showOptions(_ sender: Any) {
        //self.animateExtraButtons(toHide: false)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if let text = self.inputTextField.text {
            
            if text.count > 0 {
                self.composeMessage(type: .text, content: self.inputTextField.text!)
                self.inputTextField.text = ""
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch self.items[indexPath.row].owner {
//        case .receiver:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
//            cell.clearCellData()
//            switch self.items[indexPath.row].type {
//            case .text:
//                cell.message.text = self.items[indexPath.row].content as! String
//            case .photo:
//                if let image = self.items[indexPath.row].image {
//                    cell.messageBackground.image = image
//                    cell.message.isHidden = true
//                } else {
//                    cell.messageBackground.image = UIImage.init(named: "loading")
//                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
//                        if state == true {
//                            DispatchQueue.main.async {
//                                self.tableView.reloadData()
//                            }
//                        }
//                    })
//                }
//            case .location:
//                cell.messageBackground.image = UIImage.init(named: "location")
//                cell.message.isHidden = true
//            }
//            return cell
//        case .sender:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
//            cell.clearCellData()
//            cell.profilePic.image = self.currentUser?.profilePic
//            switch self.items[indexPath.row].type {
//            case .text:
//                cell.message.text = self.items[indexPath.row].content as! String
//            case .photo:
//                if let image = self.items[indexPath.row].image {
//                    cell.messageBackground.image = image
//                    cell.message.isHidden = true
//                } else {
//                    cell.messageBackground.image = UIImage.init(named: "loading")
//                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
//                        if state == true {
//                            DispatchQueue.main.async {
//                                self.tableView.reloadData()
//                            }
//                        }
//                    })
//                }
//            case .location:
//                cell.messageBackground.image = UIImage.init(named: "location")
//                cell.message.isHidden = true
//            }
//            return cell
//        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
        return cell
    }
    //  UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
