//
//  ChatViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/10/25.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
import MapKit
import SceneKit
import Firebase
class ChatViewController: UIViewController, UITableViewDelegate , UITableViewDataSource,UITextFieldDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate{
    
    //MARK: Properties
    
    @IBOutlet var inputBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var items = [Message]()
    var currentUser: User?
    let barHeight: CGFloat = 50
    let imagePicker = UIImagePickerController()
    let locationManager = CLLocationManager()
    var canSendLocation = true
    var selectedImage: UIImage!
    var latitude  : CLLocationDegrees!
    var longitude : CLLocationDegrees!
    var filePath : URL!
    var Name : String!
    
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
    
    //MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        self.fetchData()
        let statusBar = UIView(frame: CGRect(x: 0, y: -20, width: view.frame.width, height: 20))
        statusBar.backgroundColor = UIColor(red: 255.0/255.0, green: 132.0/255.0, blue: 175.0/255.0, alpha: 1.0)
        navigationBar.isTranslucent = false
        self.navigationBar.topItem?.title = self.currentUser?.name
        navigationBar.addSubview(statusBar)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Methods
    
    func customization() {
        self.imagePicker.delegate = self
        self.locationManager.delegate = self
        self.tableView.estimatedRowHeight = self.barHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset.bottom = self.barHeight
        self.tableView.scrollIndicatorInsets.bottom = self.barHeight
    }
    
    func composeMessage(type: MessageType, content: Any)  {
        let message = Message.init(type: type, content: content, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
        Message.send(message: message, toID: self.currentUser!.id, completion: {(_) in
        })
    }
    
    func fetchData() {
        Message.downloadAllMessages(forUserID: self.currentUser!.id, completion: {[weak weakSelf = self] (message) in
            weakSelf?.items.append(message)
            weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
            DispatchQueue.main.async {
                if let state = weakSelf?.items.isEmpty, state == false {
                    weakSelf?.tableView.reloadData()
                    weakSelf?.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: false)
                }
            }
        })
    }
    
    func animateExtraButtons(toHide: Bool)  {
        switch toHide {
        case true:
            self.bottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.inputBar.layoutIfNeeded()
            }
        default:
            self.bottomConstraint.constant = -50
            UIView.animate(withDuration: 0.3) {
                self.inputBar.layoutIfNeeded()
            }
        }
    }
    
    //要求地圖權限
    func checkLocationPermission() -> Bool {
        var state = false
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            state = true
        case .authorizedAlways:
            state = true
        default: break
        }
        return state
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        if let text = self.inputTextField.text {
            if text.count > 0 {
                self.composeMessage(type: .text, content: self.inputTextField.text!)
                self.inputTextField.text = ""
            }
        }
    }
    
    @IBAction func showOptions(_ sender: Any) {
        self.animateExtraButtons(toHide: false)
    }
    
    @IBAction func showMessage(_ sender: Any) {
        self.animateExtraButtons(toHide: true)
    }
    
    @IBAction func selectPhoto(_ sender: Any) {
        self.animateExtraButtons(toHide: true)
        // 判斷是否可以從照片圖庫取得照片來源
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.photoLibrary)，並 present UIImagePickerController
            self.imagePicker.sourceType = .photoLibrary
            self.inputBar.isHidden = true
            //imagePicker.delegate = self
            self.present(imagePicker,animated: true,completion: nil)
        }
    }
        
    @IBAction func selectLocation(_ sender: Any) {
        self.animateExtraButtons(toHide: true)
        self.canSendLocation = true
        if self.checkLocationPermission() {
            self.locationManager.startUpdatingLocation()
        }
        else{
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "Chat") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK: Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.items[indexPath.row].owner {
        case .receiver:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
            cell.clearCellData()
            switch self.items[indexPath.row].type {
            case .text:
                cell.message.isHidden = false
                cell.messageBackground.isHidden = false
                cell.message3D.isHidden = true
                cell.message.text = self.items[indexPath.row].content as! String
            case .photo:
                cell.message.isHidden = false
                cell.messageBackground.isHidden = false
                cell.message3D.isHidden = true
                if let image = self.items[indexPath.row].image {
                    cell.messageBackground.image = image
                    cell.message.isHidden = true
                }
                else {
                    cell.messageBackground.image = UIImage.init(named: "loading")
                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                        if state == true {
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            case .location:
                cell.message.isHidden = false
                cell.messageBackground.isHidden = false
                cell.message3D.isHidden = true
                cell.messageBackground.image = UIImage.init(named: "location")
                cell.message.isHidden = true
            case .model:
                cell.message3D.isHidden = false
                cell.message.isHidden = true
                cell.messageBackground.isHidden = true
                let obj = (self.items[indexPath.row].content as! String).components(separatedBy: " ")
                var ModelName = obj[0]
                let ModelScene = SCNScene(named: ModelName)
                
                let CameraNode = SCNNode()
                CameraNode.camera = SCNCamera()
                CameraNode.position = SCNVector3(x:0,y:0,z:5)
                ModelScene?.rootNode.addChildNode(CameraNode)
                
                let LightNode = SCNNode()
                LightNode.light = SCNLight()
                LightNode.light?.type = .ambient
                LightNode.light?.color = UIColor.darkGray
                ModelScene?.rootNode.addChildNode(LightNode)
                cell.message3D.scene = ModelScene
                cell.message3D.allowsCameraControl = true
            }
            return cell
        case .sender:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
            cell.clearCellData()
            cell.profilePic.image = self.currentUser?.profilePic
            switch self.items[indexPath.row].type {
            case .text:
                cell.message.isHidden = false
                cell.messageBackground.isHidden = false
                cell.message3D.isHidden = true
                cell.message.text = self.items[indexPath.row].content as! String
            case .photo:
                cell.message.isHidden = false
                cell.messageBackground.isHidden = false
                cell.message3D.isHidden = true
                if let image = self.items[indexPath.row].image {
                    cell.messageBackground.image = image
                    cell.message.isHidden = true
                }
                else {
                    cell.messageBackground.image = UIImage.init(named: "loading")
                    self.items[indexPath.row].downloadImage(indexpathRow: indexPath.row, completion: { (state, index) in
                        if state == true {
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            case .location:
                cell.message.isHidden = false
                cell.messageBackground.isHidden = false
                cell.message3D.isHidden = true
                cell.messageBackground.image = UIImage.init(named: "location")
                cell.message.isHidden = true
            case .model:
                cell.message3D.isHidden = false
                cell.message.isHidden = true
                cell.messageBackground.isHidden = true
                let obj = (self.items[indexPath.row].content as! String).components(separatedBy: " ")
                let ModelName = obj[0]
                let ModelScene = SCNScene(named: ModelName)
                
                let CameraNode = SCNNode()
                CameraNode.camera = SCNCamera()
                CameraNode.position = SCNVector3(x:0,y:0,z:5)
                ModelScene?.rootNode.addChildNode(CameraNode)
                
                let LightNode = SCNNode()
                LightNode.light = SCNLight()
                LightNode.light?.type = .ambient
                LightNode.light?.color = UIColor.darkGray
                ModelScene?.rootNode.addChildNode(LightNode)
                cell.message3D.scene = ModelScene
                cell.message3D.allowsCameraControl = true
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.items[indexPath.row].type == .model {
            return 200
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.inputTextField.resignFirstResponder()
        switch self.items[indexPath.row].type {
        case .photo:
            if let photo = self.items[indexPath.row].image {
                self.selectedImage = photo
                self.inputAccessoryView?.isHidden = true
                self.performSegue(withIdentifier: "FullImage", sender: self)
            }
        case .location:
            let coordinates = (self.items[indexPath.row].content as! String).components(separatedBy: ":")
            latitude = CLLocationDegrees(coordinates[0])!
            longitude = CLLocationDegrees(coordinates[1])!
            self.inputAccessoryView?.isHidden = true
            self.performSegue(withIdentifier: "Map", sender: self)
        case .model:
            let objName = (self.items[indexPath.row].content as! String).components(separatedBy: " ")
            if self.items[indexPath.row].owner == .sender {
                downlord(objName: objName[1])
//                let desertRef = Storage.storage().reference().child("Model").child(objName[1] + ".obj")
//                desertRef.delete{ error in
//                    if let error = error {
//                        // Uh-oh, an error occurred!
//                        print ("刪除錯誤：" + String(describing: error) + "\n\n\n\n")
//                    } else {
//                        // File deleted successfully
//
//                    }
//                }
                self.inputAccessoryView?.isHidden = true
                if FileManager.default.fileExists(atPath: filePath.path) {
                    self.performSegue(withIdentifier: "Extract", sender: self)
                }
            }
            self.inputAccessoryView?.isHidden = false
            break
        default: break
        }
    }
    
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // modelName
        let showAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "😎", handler: {(action,indexPath) -> Void in
            
            self.inputAccessoryView?.isHidden = true
            let alertController = UIAlertController(title: "開發人員專用", message: "請輸入密碼開啟此功能", preferredStyle: .alert)
            alertController.addTextField(configurationHandler: {(textField: UITextField) -> Void in
                textField.placeholder = "Password"
                textField.isSecureTextEntry = true
            })
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction!) -> Void in
                self.inputAccessoryView?.isHidden = false
            })
            let enterAction = UIAlertAction(title: "Enter", style: .default , handler: { (action:UIAlertAction!) -> Void in
                
                let password = (alertController.textFields?.first)!.text
                print(password)
                
                if  password == "CSIE"{
                    let obj = (self.items[indexPath.row].content as! String).components(separatedBy: " ")
                    self.Name = obj[0]
                    self.inputAccessoryView?.isHidden = false
                    self.performSegue(withIdentifier: "Different", sender: self)
                    print(" Correct ! ! ")
                }
                else{
                    let alertController = UIAlertController(title: "Input Error", message: "Wrong Password.", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK",style: .cancel,handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    self.inputAccessoryView?.isHidden = false
                }
            })
            alertController.addAction(enterAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        })
    return [showAction]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.composeMessage(type: .photo, content: selectedImage)
        }
        self.inputBar.isHidden = false
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.inputBar.isHidden = false
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 每次CLLocationManager 更新位置後 觸發
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingHeading()
        // 拿到目前的座標
        if let lastLocation = locations.last {
            if self.canSendLocation {
                let coordinate = String(lastLocation.coordinate.latitude) + ":" + String(lastLocation.coordinate.longitude)
                let message = Message.init(type: .location, content: coordinate, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
                Message.send(message: message, toID: self.currentUser!.id, completion: {(_) in
                })
                self.canSendLocation = false
            }
        }
    }
    
    func downlord(objName: String){
        let check = false
        let objURL = Storage.storage().reference().child("Model").child(objName + ".obj")
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        filePath = DocumentDirURL.appendingPathComponent(objName).appendingPathExtension("obj")
        print(filePath.path + "\n\n\n\n")
        let downloadTask = objURL.write(toFile: filePath) { (url, error) in
            if error != nil {
                //有錯誤
                print("有錯:\(String(describing: error?.localizedDescription))")
            }else{
                //return檔案位置
                print("位置：\(String(describing: self.filePath))")
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "model"{
            self.inputAccessoryView?.isHidden = true
            let controller = segue.destination as! ChooseMViewController
            controller.currentUser = currentUser
        }
        else if  segue.identifier == "FullImage" {
            let controller = segue.destination as! ShowImageViewController
            controller.selectedImage = selectedImage
        }
        else if  segue.identifier == "Map" {
            let controller = segue.destination as! MapViewController
            controller.latitude = latitude
            controller.longitude = longitude
        }
        else if  segue.identifier == "Extract" {
            let controller = segue.destination as! ExtractionViewController
            controller.filePath = filePath
        }
        else if  segue.identifier == "Different" {
            let controller = segue.destination as! DifferentViewController
            //controller.filePath = filePath
            controller.modelName = Name
//            let obj = (self.items[indexPath.row].content as! String).components(separatedBy: " ")
//            let ModelName = obj[0]
//            controller.modelName = ModelName
        }
    }
}
