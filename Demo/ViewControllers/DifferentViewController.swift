//
//  DifferentViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/12/29.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
import SceneKit

class DifferentViewController: UIViewController {
    
    @IBOutlet weak var scnAfter: SCNView!
    @IBOutlet weak var scnBefore: SCNView!
    //var filePath : URL!
    var modelName : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(modelName)
        
        let objName = modelName.components(separatedBy: " ")
        let beforeName = objName[0]
        
        let Modelbefore = SCNScene(named: beforeName)
        var Modelafter = SCNScene()
        
        let CameraNode = SCNNode()
        CameraNode.camera = SCNCamera()
        CameraNode.position = SCNVector3(x:0,y:0,z:4.5)
        Modelbefore?.rootNode.addChildNode(CameraNode)
        
        let LightNode = SCNNode()
        LightNode.light = SCNLight()
        LightNode.light?.type = .ambient
        LightNode.light?.color = UIColor.lightGray
        Modelbefore?.rootNode.addChildNode(CameraNode)
        
        scnBefore.scene = Modelbefore
        scnBefore.allowsCameraControl = true
        
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let filePath = DocumentDirURL.appendingPathComponent(objName[1]).appendingPathExtension("obj")
        do{
            Modelafter = try SCNScene(url: filePath ,options: nil )
        }catch{
            print("檔案沒下載")
        }
        Modelafter.rootNode.addChildNode(CameraNode)
        Modelafter.rootNode.addChildNode(LightNode)
        
        scnAfter.scene = Modelafter
        scnAfter.allowsCameraControl = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
