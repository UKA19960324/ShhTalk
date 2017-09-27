//
//  ShowMViewController.swift
//  Demo
//
//  Created by user on 2017/9/27.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
import SceneKit

class ShowMViewController: UIViewController {
    
    @IBOutlet weak var ModelView: SCNView!
    
    var ModelName = ""
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ModelScene = SCNScene(named: ModelName)
        
        let CameraNode = SCNNode()
        CameraNode.camera = SCNCamera()
        CameraNode.position = SCNVector3(x:0,y:0,z:5)
        ModelScene?.rootNode.addChildNode(CameraNode)
        
        let LightNode = SCNNode()
        LightNode.light = SCNLight()
        LightNode.light?.type = .ambient
        LightNode.light?.color = UIColor.white
        ModelScene?.rootNode.addChildNode(LightNode)
        
        ModelView.scene = ModelScene
        ModelView.allowsCameraControl = true
    }
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
