//
//  ShowImageViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/11/27.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit

class ShowImageViewController: UIViewController/* , UIScrollViewDelegate*/ {

    //MARK: Properties
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var selectedImage: UIImage!
    //let darkView = UIView.init()
    
    //MARK: Methods
    func customization() {
        
        //DarkView customization
//        self.view.addSubview(self.darkView)
//        self.darkView.backgroundColor = UIColor.black
//        self.darkView.alpha = 0.8
//        self.darkView.translatesAutoresizingMaskIntoConstraints = false
//        self.darkView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        self.darkView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        self.darkView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//        self.darkView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        self.darkView.isHidden = true
        previewImageView.image = selectedImage
        
//        self.scrollView.minimumZoomScale = 1.0
//        self.scrollView.maximumZoomScale = 3.0
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.inputAccessoryView?.isHidden = false
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
//    @IBAction func doubleTapGesture(_ sender: UITapGestureRecognizer) {
//        if self.scrollView.zoomScale == 1 {
//            self.scrollView.zoom(to: zoomRectForScale(scale: self.scrollView.maximumZoomScale, center: sender.location(in: sender.view)), animated: true)
//        } else {
//            self.scrollView.setZoomScale(1, animated: true)
//        }
//    }
    
//    //Preview view scrollview's zoom calculation
//    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
//        var zoomRect = CGRect.zero
//        zoomRect.size.height = self.previewImageView.frame.size.height / scale
//        zoomRect.size.width  = self.previewImageView.frame.size.width  / scale
//        let newCenter = self.previewImageView.convert(center, from: self.scrollView)
//        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
//        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
//        return zoomRect
//    }
    
//    //Preview view scrollview zooming
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return self.previewImageView
//    }
    
    //MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.view.transform = CGAffineTransform.identity
    }
}
