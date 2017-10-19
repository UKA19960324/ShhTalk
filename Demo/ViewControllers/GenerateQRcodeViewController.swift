//
//  GenerateQRcodeViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/9/14.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
import Firebase
class GenerateQRcodeViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        let userId = Auth.auth().currentUser?.uid
        imageView.image = generateQRCode(from: userId! , icon: "APPQRcodeIcon")
    }
    
    // Dispose of any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func generateQRCode(from string: String,icon image:String ) -> UIImage?{
        let data = string.data(using: String.Encoding.utf8)!
        if let filter = CIFilter(name: "CIQRCodeGenerator",withInputParameters: ["inputMessage" : data, "inputCorrectionLevel":"H"]){
            let ciimage = filter.outputImage!
            let transform = CGAffineTransform(scaleX: 100,y:100)
            let codeImage = UIImage(ciImage: ciimage.applying(transform))
            if let iconImage = UIImage(named: image){
                let qrImageBounds = CGRect.init(x: 0, y: 0, width: codeImage.size.width , height: codeImage.size.height)
                UIGraphicsBeginImageContext(qrImageBounds.size)
                codeImage.draw(in:qrImageBounds)
                let logoSize = CGSize.init(width: qrImageBounds.size.width * 0.25, height: qrImageBounds.size.height * 0.25)
                let x = (qrImageBounds.width - logoSize.width) * 0.5
                let y = (qrImageBounds.height - logoSize.height) * 0.5
                iconImage.draw(in: CGRect(x:x, y:y, width: logoSize.width,height: logoSize.height) )
                let resultImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return resultImage
            }
        return codeImage
        }
    return nil
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
