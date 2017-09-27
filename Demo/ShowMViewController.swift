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
    
    var ModelName = ""
    @IBOutlet weak var ModelView: SCNView!
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ModelScene = SCNScene(named: ModelName)
        
        let CameraNode = SCNNode()
        
        
    }
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
