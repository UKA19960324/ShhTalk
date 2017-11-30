//
//  NoEctractViewController.swift
//  Demo
//
//  Created by user on 2017/12/1.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit

class NoExtractionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.inputAccessoryView?.isHidden = false
    }
}
