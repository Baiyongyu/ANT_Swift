//
//  YYAlertView.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/19.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

typealias AlertSelectIndex = (_ index: NSInteger) -> Void

class YYAlertView: UIView {

    var alertView = UIView()
    
    var alertSelectIndex: AlertSelectIndex?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        self.frame = UIScreen.main.bounds
        
        alertView.backgroundColor = UIColor.white
        alertView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 80, height: 200)
        alertView.layer.cornerRadius = 5
        alertView.layer.position = self.center
        
        self.addSubview(self.alertView)
        alertView.addSubview(title)
        alertView.addSubview(titleLabel)
        alertView.addSubview(lineView)
        alertView.addSubview(cancelBtn)
        alertView.addSubview(verLineView)
        alertView.addSubview(sureBtn)
        showAlertView()
    }
    
    //外部调用的方法
    public func initWithTitle(titles: String, message: String, sureTitle: String, cancleTitle: String) {
        
        title.text = titles
        title.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.centerX.equalTo(alertView)
            make.height.lessThanOrEqualTo(44)
        }
        
        titleLabel.text = message
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(20)
            make.centerX.equalTo(alertView)
            make.height.lessThanOrEqualTo(44)
        }
        
        if message.characters.count == 0 {
            lineView.snp.makeConstraints { (make) in
                make.top.equalTo(title.snp.bottom).offset(20)
                make.left.right.equalTo(alertView)
                make.height.equalTo(1)
            }
        }
        if message.characters.count != 0 {
            lineView.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(20)
                make.left.right.equalTo(alertView)
                make.height.equalTo(1)
            }
        }
        
        cancelBtn.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(lineView.snp.bottom)
            make.width.equalTo((SCREEN_WIDTH-100-1)/2.0)
            make.height.equalTo(40)
            make.bottom.equalTo(alertView)
        }
        
        verLineView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.equalTo(cancelBtn.snp.right)
            make.width.equalTo(1)
            make.height.equalTo(40)
            make.bottom.equalTo(alertView)
        }
        
        sureBtn.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.top.equalTo(lineView.snp.bottom)
            make.width.equalTo((SCREEN_WIDTH-100-1)/2.0+1)
            make.height.equalTo(40)
            make.bottom.equalTo(alertView)
        }
        
        alertView.snp.makeConstraints { (make) in
            make.center.equalTo(self.center)
            make.left.equalTo(40)
            make.right.equalTo(-40)
        }
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
    
    func buttonEvent(sender: UIButton) {
        if alertSelectIndex != nil {
            alertSelectIndex!(NSInteger(sender.tag))
        }
        self.removeFromSuperview()
    }
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.textColor = UIColor.black
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .center
        return title
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(white: 0.8, alpha: 0.6)
        return lineView
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: UIButtonType.custom)
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(UIColor.red, for: .normal)
        sureBtn.setTitleColor(UIColor.lightText, for: .selected)
        sureBtn.tag = 2
        sureBtn.layer.cornerRadius = 2
        sureBtn.layer.masksToBounds = true
        sureBtn.addTarget(self, action: #selector(buttonEvent), for: .touchUpInside)
        return sureBtn
    }()
    
    lazy var verLineView: UIView = {
        let verLineView = UIView()
        verLineView.backgroundColor = UIColor.init(white: 0.8, alpha: 0.6)
        return verLineView
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: UIButtonType.custom)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.black, for: .normal)
        cancelBtn.setTitleColor(UIColor.lightText, for: .selected)
        cancelBtn.tag = 1
        cancelBtn.layer.cornerRadius = 2
        cancelBtn.layer.masksToBounds = true
        cancelBtn.addTarget(self, action: #selector(buttonEvent), for: .touchUpInside)
        return cancelBtn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
