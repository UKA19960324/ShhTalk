//
//  DifferentViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/12/29.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit

class DifferentViewController: UIViewController {
    
    //var filePath : URL!
    var modelName : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print(filePath)
        print(modelName)
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
