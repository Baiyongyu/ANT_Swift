//
//  LocationMapViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/17.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class LocationMapViewController: BaseViewController {

    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text = "地址"
        rightBtn.isHidden = false
        rightBtn.setTitle("搜索", for: .normal)
        view.addSubview(mapView)
        view.addSubview(currentLocationView)
        view.addSubview(resetLocationBtn)
        view.addSubview(bottomView)
        
        mapView.showsUserLocation = true
    }

    override func layoutConstraints() {
        mapView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(NavBarHeight, 0, IS_IPHONE_iPX ? 134 : 100, 0))
        }
        
        resetLocationBtn.snp.makeConstraints { (make) in
            make.right.equalTo(mapView).offset(-10)
            make.bottom.equalTo(mapView).offset(-10)
            make.width.height.equalTo(50)
        }
        
        currentLocationView.snp.makeConstraints { (make) in
            make.center.equalTo(mapView)
            make.width.equalTo(20)
            make.height.equalTo(30)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(IS_IPHONE_iPX ? -44 : -10)
            make.top.equalTo(mapView.snp.bottom)
        }
        
        let confirmBtn = UIButton(type: UIButtonType.custom)
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.backgroundColor = BaseColor.ThemeColor
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        confirmBtn.layer.cornerRadius = 3
        confirmBtn.clipsToBounds = true
        confirmBtn.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        bottomView.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-5)
            make.height.equalTo(40)
        }
        
        let locationImage = UIImageView()
        locationImage.contentMode = .scaleAspectFit
        locationImage.image = UIImage.init(named: "ic_location")
        bottomView.addSubview(locationImage)
        locationImage.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(16)
            make.height.equalTo(24)
            make.top.equalTo(15)
        }
        bottomView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(locationImage.snp.right).offset(10)
            make.centerY.equalTo(locationImage)
            make.right.equalTo(-10)
        }
    }
    
    override func loadData() {
        locationUpdated()

        if LocationManager.sharedInstance().checkLocationAndShowingAlert(true) {
            LocationManager.sharedInstance().startLocation()
        }
    }
    
    func locationUpdated() {
        if (LocationManager.sharedInstance().userLocation != nil) {
            let center = LocationManager.sharedInstance().coordinate
            self.locationUpdated(center: center)
        }
    }
    
    func locationUpdated(center: CLLocationCoordinate2D) {
        let span = MACoordinateSpanMake(0.003, 0.003)
        let region = MACoordinateRegionMake(center, span)
        mapView.setRegion(region, animated: true)
        LocationManager.sharedInstance().reGeoSearch(withDelegate: self, coordinate: center)
    }
    
    func confirmAction() {
        AppCommon.popViewController(animated: true)
    }
    
    
    func resetLocationAction() {
        if LocationManager.sharedInstance().checkLocationAndShowingAlert(true) {
            self.locationUpdated(center: mapView.userLocation.coordinate)
        }
    }
    
    lazy var mapView: MAMapView = {
        let mapView = MAMapView()
        mapView.frame = CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT-64-100)
        mapView.delegate = self
        return mapView
    }()
    
    lazy var bottomView: UIView = {
        let bottomView = UIView()
        return bottomView
    }()
    
    lazy var currentLocationView: UIImageView = {
        let currentLocationView = UIImageView()
        currentLocationView.contentMode = .scaleAspectFit
        currentLocationView.image = UIImage.init(named: "ic_location")
        return currentLocationView
    }()
    
    lazy var resetLocationBtn: UIButton = {
        let resetLocationBtn = UIButton(type: UIButtonType.custom)
        resetLocationBtn.setImage(UIImage.init(named: "ic_reset_loacation"), for: .normal)
        resetLocationBtn.addTarget(self, action: #selector(resetLocationAction), for: .touchUpInside)
        return resetLocationBtn
    }()
    
    lazy var addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.numberOfLines = 2
        addressLabel.font = UIFont.systemFont(ofSize: 14)
        return addressLabel
    }()
}

extension LocationMapViewController: MAMapViewDelegate {

    // MAMapViewDelegate
    func mapView(_ mapView: MAMapView!, regionDidChangeAnimated animated: Bool) {
        LocationManager.sharedInstance().reGeoSearch(withDelegate: self, coordinate: mapView.centerCoordinate)
    }
    // AMAP ReGeo Search
}
