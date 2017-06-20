//
//  VersionAlertView.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/19.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class VersionAlertView: UIView {
    
    var alertView = UIView()
    
    //外部调用的方法
    func initWithTitle(titles: String, message: String) {
        
        closeButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.top.equalTo(10)
            make.right.equalTo(-20)
        }
        
        versionImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.centerX.equalTo(alertView)
            make.top.equalTo(35)
        }
        
        title.text = titles
        title.snp.makeConstraints { (make) in
            make.top.equalTo(self.versionImage.snp.bottom).offset(20)
            make.centerX.equalTo(alertView)
            make.height.equalTo(20)
        }
        
        titleLabel.text = message
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.greaterThanOrEqualTo(44)
            
        }
        sureBtn.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(44)
            make.centerX.equalTo(alertView)
            make.bottom.equalTo(alertView).offset(-20)
        }
        alertView.snp.makeConstraints { (make) in
            make.center.equalTo(self.center)
            make.left.equalTo(40)
            make.right.equalTo(-40)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        self.frame = UIScreen.main.bounds
        
        alertView.backgroundColor = UIColor.white
        alertView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 80, height: 200)
        alertView.layer.cornerRadius = 5
        alertView.layer.position = self.center
        
        self.addSubview(self.alertView)
        alertView.addSubview(closeButton)
        alertView.addSubview(versionImage)
        alertView.addSubview(title)
        alertView.addSubview(titleLabel)
        alertView.addSubview(sureBtn)
    }
    
    public func showAlertView() {
        mainWindow().endEditing(true)
        UIApplication.shared.keyWindow?.addSubview(self)
        self.alertView.layer.position = self.center
        self.alertView.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.alertView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (false) in
            
        }
        CommonUtils().setCAKeyframeAnimation(view: self.alertView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.closeAction()
    }
    
    func closeAction() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0
        }) { (true) in
            self.removeFromSuperview()
        }
    }
    
    func buttonEvent() {
        self.removeFromSuperview()
    }
    
    lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: UIButtonType.custom)
        closeButton.setImage(UIImage.init(named: "ic_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return closeButton
    }()
    
    lazy var versionImage: UIImageView = {
        let versionImage = UIImageView()
        versionImage.image = UIImage.init(named: "ic_update_version")
        return versionImage
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 18)
        title.textAlignment = .center
        return title
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: UIButtonType.custom)
        sureBtn.setTitle(" 立即更新", for: .normal)
        sureBtn.setTitleColor(UIColor.white, for: .normal)
        sureBtn.tag = 1
        sureBtn.layer.cornerRadius = 2
        sureBtn.layer.masksToBounds = true
        sureBtn.backgroundColor = UIColor.orange
        sureBtn.addTarget(self, action: #selector(buttonEvent), for: .touchUpInside)
        return sureBtn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
