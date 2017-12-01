//
//  ShowMViewController.swift
//  Demo
//
//  Created by user on 2017/9/27.
//  Copyright © 2017年 U.K.A. All rights reserved.
//
import UIKit
import SceneKit
import Firebase

class ShowMViewController: UIViewController , UITextViewDelegate {
    
    //MARK: Properties
    var ModelName = ""
    var toUser: User?
    @IBOutlet weak var ModelView: SCNView!
    @IBOutlet weak var messageTextView: UITextView!
    
    let p = 0.001 //區段大小
    let Ip = 1000 //p的Int
    let Ep = 1000000 as Double //轉浮點數用
    var x = 0.0,y = 0.0,z = 0.0
    var Ix = 0.0,Iy = 0.0,Iz = 0.0
    var Rx = 0,Ry = 0,Rz = 0
    var writeString = ""
    var stringStart = 0 //藏第幾個bit
    var start = 0   //第幾行開始
    var hideKey = ""  //是否要藏
    var count = 0
    var hideKeyCount = 0
    let Zero = "0"
    var binary = ""
    
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ModelScene = SCNScene(named: ModelName)
        
        let CameraNode = SCNNode()
        CameraNode.camera = SCNCamera()
        CameraNode.position = SCNVector3(x:0,y:0,z:4.5)
        ModelScene?.rootNode.addChildNode(CameraNode)
        
        let LightNode = SCNNode()
        LightNode.light = SCNLight()
        LightNode.light?.type = .ambient
        LightNode.light?.color = UIColor.darkGray
        ModelScene?.rootNode.addChildNode(LightNode)
        
        ModelView.scene = ModelScene
        ModelView.allowsCameraControl = true
        
        messageTextView.delegate = self
        let spacing = NSMutableParagraphStyle()
        spacing.lineSpacing = 10
        let attr = [NSFontAttributeName:UIFont.systemFont(ofSize: 18),NSParagraphStyleAttributeName : spacing]
        messageTextView.typingAttributes = attr
        messageTextView.textColor = UIColor.white
        messageTextView.textContainer.maximumNumberOfLines = 3
        messageTextView.textContainer.lineBreakMode = .byTruncatingTail
        
    }
    
    //MARK: Methods
    func composeMessage(type: MessageType, content: Any)  {
        let message = Message.init(type: type, content: content, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
        //print(currentUser?.name)
        Message.send(message: message, toID: self.toUser!.id, completion: {(_) in
        })
    }
    
    @IBAction func sendModel(_ sender: UIButton) {
            let Name = ModelName.components(separatedBy: ".")
            let objName = Name[0]
            let NewObjName = UUID().uuidString
            var NewfileURL: URL
            //print(objName)
            self.composeMessage(type: .model, content: ModelName + " " + NewObjName)
            
            Bundle.main.path(forResource: objName, ofType: "obj")
            var key = toUser!.id
            let fileURL = Bundle.main.path(forResource: objName, ofType: "obj")
            let I4p = Ip/4
            let I2p = Ip/2
            //要藏的文字
            let Text = messageTextView.text!
            //創建新檔案
            let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            NewfileURL = DocumentDirURL.appendingPathComponent(NewObjName).appendingPathExtension("obj")
            //print("File Path: \(NewfileURL)")
            //金鑰處理 最後兩位為起始位置
            var Sstart = String(key[key.index(before: key.endIndex)])
            key.remove(at: key.index(before: key.endIndex))
            Sstart = String(key[key.index(before: key.endIndex)]) + Sstart
            for k in Sstart.unicodeScalars{
                start = Int(k.value - UInt32(48)) + start
            }
            //print ("藏金鑰: \(start) \n \n \n ")
            //剩下轉2進 1藏 0不藏
            let binaryKey:Data? = key.data(using: .utf8)
            hideKey = (binaryKey?.reduce(""){(acc,byte) -> String! in
                acc+String(byte,radix:2)
                })!
            //轉8進制
            let binaryData: Data? = Text.data(using: .utf8)
            //轉string String 2進制
            let stringToBite = (binaryData?.reduce(""){(acc,byte) -> String! in
                binary = String(byte,radix:2)
                // 填到8位
                if binary.characters.count % 8 == 1{
                    binary = Zero + Zero + Zero + Zero + Zero + Zero + Zero + binary
                }else if binary.characters.count % 8 == 2{
                    binary = Zero + Zero + Zero + Zero + Zero + Zero + binary
                }else if binary.characters.count % 8 == 3{
                    binary = Zero + Zero + Zero + Zero + Zero + binary
                }else if binary.characters.count % 8 == 4{
                    binary = Zero + Zero + Zero + Zero + binary
                }else if binary.characters.count % 8 == 5{
                    binary = Zero + Zero + Zero + binary
                }else if binary.characters.count % 8 == 6{
                    binary = Zero + Zero + binary
                }else if binary.characters.count % 8 == 7{
                    binary = Zero + binary
                }
                return acc + binary
            })!
            var char = Array(stringToBite)
            //print (stringToBite)
            do {
                //讀app內的檔
                let readStringProject = try String(contentsOfFile: fileURL!, encoding: String.Encoding.utf8)
                let lines = readStringProject.components(separatedBy: "\n")
                for line in lines {
                    //print(line)
                    let data = line.components(separatedBy: " ")
                    //print(data)
                    if data[0] == "v" && stringStart <= char.count{
                        count += 1
                        let check = hideKey[hideKey.index(hideKey.startIndex, offsetBy: hideKeyCount)]
                        //print(check)
                        if  count >= start && check == "1" {
                            
                            x = Double(data[1])!
                            y = Double(data[2])!
                            z = Double(data[3])!
                            //print(String(x) + " " + String(y) + " " + String(z))
                            //取餘數（有誤差）
                            Ix = x.truncatingRemainder(dividingBy: p)
                            Iy = y.truncatingRemainder(dividingBy: p)
                            Iz = z.truncatingRemainder(dividingBy: p)
                            //print(String(Ix) + " " + String(Iy) + " " + String(Iz))
                            //刪除誤差轉int處理 浮點數處理上有誤差
                            Rx = Int(round(Ix * Ep))
                            Ry = Int(round(Iy * Ep))
                            Rz = Int(round(Iz * Ep))
                            //處理在分界上的數值 )
                            if Rx == 500 || Rx == -500 || Rx == 0 || Rx == 1 || Rx == -1000 || Rx == -999{
                                Rx += 2
                            }else if Rx == 1000 || Rx == 999 || Rx == -1{ Rx -= 2 }
                            if Ry == 500 || Ry == -500 || Ry == 0 || Ry == 1 || Ry == -1000 || Ry == -999{
                                Ry += 2
                            }else if Ry == 1000 || Ry == 999 || Ry == -1{ Ry -= 2 }
                            if Rz == 500 || Rz == -500 || Rz == 0  || Rz == 1 || Rz == -1000 || Rz == -999{
                                Rz += 2
                            }else if Rz == 1000 || Rz == 999 || Rz == -1{ Rz -= 2 }
                            //print(String(Rx) + " " + String(Ry) + " " + String(Rz))
                            //朝區段中心點內縮一半 注意正負
                            if Rx > 0 && Rx < I2p{
                                Rx = Rx + (I2p - Rx)/2
                            }else if Rx > 0 && Rx > I2p{
                                Rx = Rx - (Rx - I2p)/2
                            }else if Rx < 0 && Rx < -I2p{
                                Rx = Rx - (Rx + I2p)/2
                            }else{
                                Rx = Rx - (I2p + Rx)/2
                            }
                            
                            if Ry > 0 && Ry < I2p{
                                Ry = Ry + (I2p - Ry)/2
                            }else if Ry > 0 && Ry > I2p{
                                Ry = Ry - (Ry - I2p)/2
                            }else if Ry < 0 && Ry < -I2p{
                                Ry = Ry - (Ry + I2p)/2
                            }else{
                                Ry = Ry - (I2p + Ry)/2
                            }
                            
                            if Rz > 0 && Rz < I2p{
                                Rz = Rz + (I2p - Rz)/2
                            }else if Rz > 0 && Rz > I2p{
                                Rz = Rz - (Rz - I2p)/2
                            }else if Rz < 0 && Rz < -I2p{
                                Rz = Rz - (Rz + I2p)/2
                            }else{
                                Rz = Rz - (I2p + Rz)/2
                            }
                            //print(String(Rx) + " " + String(Ry) + " " + String(Rz))
                            //嵌入x,y,z各一bit
                            if stringStart < char.count && char[stringStart] == "1" {
                                //左邊左移 右邊右移
                                if (Rx > 0 && Rx < I2p) || (Rx < 0 && Rx < -I2p){
                                    Rx -= I4p
                                }else{
                                    Rx += I4p
                                }
                                //print(String(char[stringStart]) + " " + String(Rx) + " Rx")
                            }else if stringStart >= char.count{
                                if Rx > 0 {Rx = 500}
                                else {Rx = -500}
                            }
                            stringStart += 1
                            
                            if stringStart < char.count && char[stringStart] == "1" {
                                //左邊左移 右邊右移
                                if (Ry > 0 && Ry < I2p) || (Ry < 0 && Ry < -I2p){
                                    Ry -= I4p
                                }else{
                                    Ry += I4p
                                }
                                //print(String(char[stringStart]) + " " + String(Ry))
                            }else if stringStart >= char.count{
                                if Ry > 0 {Ry = 500}
                                else {Ry = -500}
                            }
                            stringStart += 1
                            
                            if stringStart < char.count && char[stringStart] == "1" {
                                //左邊左移 右邊右移
                                if (Rz > 0 && Rz < I2p) || (Rz < 0 && Rz < -I2p){
                                    Rz -= I4p
                                }else{
                                    Rz += I4p
                                }
                                //print(String(char[stringStart]) + " " + String(Rz))
                            }else if stringStart >= char.count{
                                if Rz > 0 {Rz = 500}
                                else {Rz = -500}
                            }
                            stringStart += 1
                            //print(String(Rx) + " " + String(Ry) + " " + String(Rz))
                            
                            //餘數處理完 加回原本的值
                            Rx = Int(x / p) * Ip + Rx
                            x = Double(Rx) / Ep
                            Ry = Int(y / p) * Ip + Ry
                            y = Double(Ry) / Ep
                            Rz = Int(z / p) * Ip + Rz
                            z = Double(Rz) / Ep
                            
                            writeString += "v " + String(format: "%.6f",x) + " " + String(format: "%.6f",y) + " " + String(format: "%.6f",z) + "\n"
                            
                            if hideKeyCount < hideKey.characters.count - 1 {
                                hideKeyCount += 1
                            }else{
                                hideKeyCount = 0
                            }
                            //print("\(count) 地幾位:\(stringStart)")
                        }else{
                            //不用處理的直接寫
                            writeString += line + "\n"
                            if count >= start {
                                if hideKeyCount < hideKey.characters.count - 1 {
                                    hideKeyCount += 1
                                }else{
                                    hideKeyCount = 0
                                }
                            }
                        }
                    }else{
                        writeString += line + "\n"
                    }
                }
                //寫檔
                do {
                    try writeString.write(to: NewfileURL, atomically: true, encoding: String.Encoding.utf8)
                }catch{
                    print("Failed to write to URL")
                }
                //上傳
                let storageRef = Storage.storage()
                let uploadRef = storageRef.reference().child("Model").child(NewObjName+".obj")
                
                let uploadMetaData = StorageMetadata()
                uploadMetaData.contentType = "model/obj"
                
                var uploadUrl:String?
                uploadRef.putFile(from: NewfileURL,metadata: uploadMetaData,completion:{
                    (metadata, error) in
                    if error != nil {
                        print ("Error: \(error!.localizedDescription)")
                        return
                    }
                    uploadUrl = metadata?.downloadURL()?.absoluteString
                })
                /*
                uploadRef.observe(.success){ snapshot  in
                    
                }
                 */
                try FileManager.default.removeItem(at: NewfileURL)
            }catch{
                print("錯誤")
            }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Delegates
    
    func textViewDidChange(_ textView: UITextView) {
        let spacing = NSMutableParagraphStyle()
        spacing.lineSpacing = 10
        let attr = [NSFontAttributeName:UIFont.systemFont(ofSize: 18),NSParagraphStyleAttributeName : spacing]
        textView.typingAttributes = attr
        textView.textColor = UIColor.white
        textView.textContainer.maximumNumberOfLines = 3
        textView.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    //點選空白區域(鍵盤收合)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back"{
            self.inputAccessoryView?.isHidden = true
            let controller = segue.destination as! ChatViewController
            controller.currentUser = toUser
        }
    }
    
}
