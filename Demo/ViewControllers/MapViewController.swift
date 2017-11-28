//
//  MapViewController.swift
//  Demo
//
//  Created by U.K.A on 2017/11/28.
//  Copyright © 2017年 U.K.A. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController {

    //MARK: Properties
    
    @IBOutlet weak var mapVIew: MKMapView!
    var latitude  : CLLocationDegrees!      // 緯度
    var longitude : CLLocationDegrees!      // 經度
    
    //MARK: Methods
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.inputAccessoryView?.isHidden = false
    }
    
    //MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 從緯度與經度產生座標
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        // 產生大頭針
        let annotation = MKPointAnnotation()
        // 設定大頭針座標
        annotation.coordinate = coordinate
        // 把大頭針到地圖上面
        self.mapVIew.addAnnotation(annotation)
        // 顯示地圖大頭針所在
        self.mapVIew.showAnnotations(self.mapVIew.annotations, animated: false)
    }
}
