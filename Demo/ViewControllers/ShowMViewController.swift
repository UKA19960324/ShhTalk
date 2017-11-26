//
//  ShowMViewController.swift
//  Demo
//
//  Created by user on 2017/9/27.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
import SceneKit

class ShowMViewController: UIViewController , UITextViewDelegate {
    
    //MARK: Properties
    
    var ModelName = ""
    var currentUser: User?
    @IBOutlet weak var ModelView: SCNView!
    @IBOutlet weak var messageTextView: UITextView!
    
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
        Message.send(message: message, toID: self.currentUser!.id, completion: {(_) in
        })
    }
    
    @IBAction func sendModel(_ sender: UIButton) {
        let objName = ModelName
        //print(objName)
        self.composeMessage(type: .model, content: objName)
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
    
}
