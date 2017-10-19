//
//  ScannerViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/10/2.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
class ScannerViewController: UIViewController , AVCaptureMetadataOutputObjectsDelegate{
    
    @IBOutlet weak var scannerView: UIView!
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        // 取得 AVCaptureDevice 類別的實例來初始化一個裝置(device)物件，並提供video做為媒體類型參數
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            // 使用前面的裝置物件取得 AVCaptureDeviceInput 類別的實例
            let input = try AVCaptureDeviceInput(device: captureDevice)
            // 初始化 capturSession 物件
            captureSession = AVCaptureSession()
            // 在擷取 session 設定輸入裝置
            captureSession?.addInput(input)
            //初始化 AVCaptureNetadataOutput 物件並將其設定做為擷取 session 的輸出裝置
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            //設定委派並使用預設的調度佇列來執行回呼(call back)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            // 初始化影片預覽層，並將其加入 viewPreview 視圖層的子層
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = scannerView.layer.bounds
            scannerView.layer.addSublayer(videoPreviewLayer!)
            // 開始影片的擷取
            captureSession?.startRunning()
            // 初始化 QR code框 來突顯 QR code
            qrCodeFrameView = UIView()
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                scannerView.addSubview(qrCodeFrameView)
                //view.bringSubview(toFront: qrCodeFrameView)
            }
        }catch{
            print(error)
            return
        }
    }
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // 檢查  metadataObjects 陣列是否為非空值，它至少需包含一個物件
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame  = CGRect.zero
            //messageLabel.text = "No QR code is detected"
            return
        }
        //取得metadata物件
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObjectTypeQRCode{
            //倘若發現的metadata與QR code metadata相同，便更新狀態標籤的文字並設定邊界
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            if metadataObj.stringValue != nil {
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AddFriend"){
                    let addvc = viewController as! AddFriendViewController
                    addvc.uID = metadataObj.stringValue
                    User.info(forUserID: metadataObj.stringValue!, completion: { /*[weak weakSelf = self]*/ (user) in
                        DispatchQueue.main.async {
                            /*weakSelf?.*/addvc.image.image = user.profilePic
                            /*weakSelf?.*/addvc.nameLabel.text = user.name
                            //weakSelf = nil
                        }
                    })
                    UIApplication.shared.keyWindow?.rootViewController = addvc
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
