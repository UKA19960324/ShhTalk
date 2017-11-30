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
    
    let p = 0.001 //區段大小
    let Ip = 1000 //p的Int
    let Ep = 1000000 as Double //轉浮點數用
    var x = 0.0,y = 0.0,z = 0.0
    var Ix = 0.0,Iy = 0.0,Iz = 0.0
    var Rx = 0,Ry = 0,Rz = 0
    var start = 0
    var count = 0
    var hideKey = ""
    var hideKeyCount = 0
    var buffer = [UInt8]()
    
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
                let ModelName = self.items[indexPath.row].content as! String
                
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
                var ModelName = self.items[indexPath.row].content as! String
                
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
            let alertController = UIAlertController(title: "Want to say",message : Embeding(objName: objName[0]),preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Delete the Message", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true,completion: nil)
            break
        default: break
        }
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
    //萃取
    func Embeding(objName: String) -> String{
        var key = Auth.auth().currentUser!.uid
        let I4p = Ip/4
        //金鑰處理 最後兩位為起始位置
        var Sstart = String(key[key.index(before: key.endIndex)])
        key.remove(at: key.index(before: key.endIndex))
        Sstart = String(key[key.index(before: key.endIndex)]) + Sstart
        start = Int(Sstart)!
        //剩下轉2進 1藏 0不藏
        let binaryKey = key.data(using: .utf8)
        hideKey = (binaryKey?.reduce(""){(acc,byte) -> String! in
            acc+String(byte,radix:2)
            })!
        do{
            var End = false
            var Hide = ""
            let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let ReadURL = DocumentDirURL.appendingPathComponent(objName)
            
            let StringFile = try String(contentsOfFile: ReadURL.path , encoding: String.Encoding.utf8)
            let lines = StringFile.components(separatedBy: "\n")
            for line in lines {
                let data = line.components(separatedBy: " ")
                //print(data)
                if data[0] == "v" && End == false{
                    count += 1
                    if count >= start && hideKey[hideKey.index(hideKey.startIndex, offsetBy: hideKeyCount)] == "1"{
                        x = Double(data[1])!
                        y = Double(data[2])!
                        z = Double(data[3])!
                        //取餘數（有誤差）
                        Ix = x.truncatingRemainder(dividingBy: p)
                        Iy = y.truncatingRemainder(dividingBy: p)
                        Iz = z.truncatingRemainder(dividingBy: p)
                        //刪除誤差轉int處理 浮點數處理上有誤差
                        Rx = Int(round(Ix * Ep))
                        Ry = Int(round(Iy * Ep))
                        Rz = Int(round(Iz * Ep))
                        //4個嵌入1的區段
                        //print(String(Rx)+" "+String(Ry)+" "+String(Rz))
                        let Ver = [Rx , Ry , Rz]
                        for R in Ver{
                            if R == 500 || R == -500{
                                End = true
                                //print("End \(count)" )
                                break
                            }
                            if (R < 0 && (R < -(Ip - I4p) || R >= -I4p)) || (R > 0 && (R < I4p || R >= Ip - I4p)){
                                Hide += "1"
                                //print("\(count) \(R)")
                            }else{
                                Hide += "0"
                                //print("\(count) \(R)")
                            }
                        }
                        
                        if hideKeyCount < hideKey.characters.count - 1 {
                            hideKeyCount += 1
                        }else{
                            hideKeyCount = 0
                        }
                    }else if count >= start{
                        if hideKeyCount < hideKey.characters.count - 1 {
                            hideKeyCount += 1
                        }else{
                            hideKeyCount = 0
                        }
                    }
                }else if End == true {
                    break
                }
            }
            var index = Hide.startIndex
            for _ in 0..<Hide.characters.count/8{
                let nextIndex = Hide.index(index, offsetBy: 8)
                let charBits = Hide[index..<nextIndex]
                let k = UInt8(charBits,radix:2)!
                //print(k)
                buffer.append(k)
                index = nextIndex
            }
            let text = String(bytes: buffer, encoding: String.Encoding.utf8)!
            return text
        }catch{
            print("萃取 Error")
        }
        return "Nothing to say"
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
    }


}
