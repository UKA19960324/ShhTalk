//
//  ExtractionViewController.swift
//  Demo
//
//  Created by user on 2017/11/30.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
import SceneKit
import Firebase

class ExtractionViewController: UIViewController {
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var SCNView: SCNView!
    
    var filePath : URL!
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
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let ModelScene = try SCNScene(url: filePath ,options: nil )
            
            let CameraNode = SCNNode()
            CameraNode.camera = SCNCamera()
            CameraNode.position = SCNVector3(x:0,y:0,z:4.5)
            ModelScene.rootNode.addChildNode(CameraNode)
            
            let LightNode = SCNNode()
            LightNode.light = SCNLight()
            LightNode.light?.type = .ambient
            LightNode.light?.color = UIColor.darkGray
            ModelScene.rootNode.addChildNode(LightNode)
            
            SCNView.scene = ModelScene
            SCNView.allowsCameraControl = true
            
            Embeding()
        }catch{
            print("讀取錯誤")
        }
    }
    
    //萃取
    func Embeding(){
        var key = Auth.auth().currentUser!.uid
        let I4p = Ip/4
        //金鑰處理 最後兩位為起始位置
        var Sstart = String(key[key.index(before: key.endIndex)])
        key.remove(at: key.index(before: key.endIndex))
        Sstart = String(key[key.index(before: key.endIndex)]) + Sstart
        
        for k in Sstart.unicodeScalars{
            start = Int(k.value - UInt32(48)) + start
        }
        print("起始： \(start)" + "\n" + "\n")
        //剩下轉2進 1藏 0不藏
        let binaryKey = key.data(using: .utf8)
        hideKey = (binaryKey?.reduce(""){(acc,byte) -> String! in
            acc+String(byte,radix:2)
            })!
        do{
            var End = false
            var Hide = ""
            
            let StringFile = try String(contentsOfFile: filePath!.path , encoding: String.Encoding.utf8)
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
                            if (R < 0 && (R <= -(Ip - I4p) || R >= -I4p)) || (R > 0 && (R <= I4p || R >= Ip - I4p)){
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
                buffer.append(k)
                index = nextIndex
            }
            //print(Hide + "\n \n \n \n")
            messageTextView.text = String(bytes: buffer, encoding: String.Encoding.utf8)!
        }catch{
            print("萃取 Error")
        }
    }
    
    @IBAction func Delete(_ sender: Any) {
        do {
//            try FileManager.default.removeItem(at: filePath)
            self.dismiss(animated: true, completion: nil)
            self.inputAccessoryView?.isHidden = false
        }catch{
        }
    }
    
}
