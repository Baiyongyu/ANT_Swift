//
//  FieldsMapViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/13.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit
import MapKit

class FieldsMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        view.addSubview(mapView)
        let tileOverlay = MKTileOverlay.init(urlTemplate: "http://mt2.google.cn/vt/lyrs=y&hl=zh-CN&gl=CN&src=app&x={x}&y={y}&z={z}&s=Ga")
        tileOverlay.canReplaceMapContent = true
        mapView.add(tileOverlay)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }

    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        var region = MKCoordinateRegion()
        region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.03, 0.03))
        mapView.setRegion(region, animated: true)
    }
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .satellite
        return mapView
    }()
    
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
