//
//  LoginViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/19.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    //获取验证码按钮
    var getVeriCodeBtn = UIButton()
    //计时时间
    var veriCodeSeconds = Int()
    //验证码计时器
    var veriCodeTimer = Timer()
    
    
    
    override func loadSubViews() {
        view.backgroundColor = UIColor.white
        
        let leftBtn = UIButton(type: UIButtonType.custom)
        leftBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e62b}", size: 20, color: UIColor.black)), for: .normal)
        leftBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e62b}", size: 20, color: UIColor.gray)), for: .highlighted)
        leftBtn.contentMode = .left
        leftBtn.imageView?.layer.masksToBounds = true
        leftBtn.addTarget(self, action: #selector(leftBtnAction), for: .touchUpInside)
        view.addSubview(leftBtn)
        leftBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.top.equalTo(22)
            make.width.equalTo(50)
            make.height.equalTo(40)
        }
        
        //icon
        let icon = UIImageView()
        icon.image = UIImage.init(named: "ic_settings_logo")
        view.addSubview(icon)
        icon.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(80)
        }
        
        //输入框背景
        let textFieldBgView = UIView()
        textFieldBgView.clipsToBounds = true
        textFieldBgView.layer.cornerRadius = 3
        textFieldBgView.layer.borderColor = BaseColor.LineColor.cgColor
        textFieldBgView.layer.borderWidth = 1
        view.addSubview(textFieldBgView)
        textFieldBgView.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(icon.snp.bottom).offset(50)
            make.height.equalTo(88)
        }
        
        //手机号 验证码
        textFieldBgView.addSubview(phoneNumberField)
        textFieldBgView.addSubview(veriCodeField)
        phoneNumberField.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalTo(textFieldBgView).offset(-10)
            make.top.equalTo(textFieldBgView)
            make.height.equalTo(textFieldBgView).dividedBy(2)
        }
        veriCodeField.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.right.equalTo(textFieldBgView).offset(-10)
            make.bottom.equalTo(textFieldBgView)
            make.height.equalTo(textFieldBgView).dividedBy(2)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = BaseColor.LineColor
        textFieldBgView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.centerY.equalTo(textFieldBgView)
            make.height.equalTo(1)
        }
        
        let tipLabel = UILabel()
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textColor = BaseColor.LightGrayColor
        tipLabel.text = "没有账号也可直接登录"
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(textFieldBgView)
            make.top.equalTo(textFieldBgView.snp.bottom).offset(15)
        }
        
        //登录按钮
        let loginBtn = UIButton(type: UIButtonType.custom)
        loginBtn.clipsToBounds = true
        loginBtn.layer.cornerRadius = 3
        loginBtn.setBackgroundImage(creatImageWithColor(color: BaseColor.ThemeColor), for: .normal)
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        loginBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(40)
            make.top.equalTo(tipLabel.snp.bottom).offset(10)
        }
    }
    
    func startTimer() {
        veriCodeSeconds = 60
        veriCodeTimerAction()
        veriCodeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(veriCodeTimerAction), userInfo: nil, repeats: true)
    }
    
    func veriCodeTimerAction() {
        
        if veriCodeSeconds > 0 {
            let btnTitle = "\(veriCodeSeconds)s可重试"
            self.getVeriCodeBtn.setTitle(btnTitle, for: .normal)
            self.getVeriCodeBtn.isEnabled = false
            veriCodeSeconds -= 1
        }else {
            veriCodeSeconds = 60
            self.getVeriCodeBtn.setTitle("获取动态码", for: .normal)
            veriCodeTimer.invalidate()
            self.getVeriCodeBtn.isEnabled = true
        }
    }
    
    func getVeriCodeAction() {
        if phoneNumberField.text?.characters.count == 0 {
            YYProgressHUD.showText(text: "请输入手机号", delay: delay)
            return
        }
        startTimer()
    }
    
    override func leftBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loginAction() {
        if phoneNumberField.text?.characters.count == 0 {
            YYProgressHUD.showText(text: "请输入手机号", delay: delay)
            return
        }
        if veriCodeField.text?.characters.count == 0 {
            YYProgressHUD.showText(text: "请输入6位动态码", delay: delay)
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    lazy var phoneNumberField: UITextField = {
        let phoneNumberField = UITextField()
        phoneNumberField.font = UIFont.systemFont(ofSize: 14)
        phoneNumberField.placeholder = "请输入手机号"
        phoneNumberField.keyboardType = .numberPad
        phoneNumberField.clearButtonMode = .whileEditing
        phoneNumberField.leftViewMode = .always
        let leftView = UILabel()
        leftView.textAlignment = .left
        leftView.font = UIFont.systemFont(ofSize: 14)
        leftView.textColor = BaseColor.GrayColor
        leftView.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        leftView.text = "  手机号："
        phoneNumberField.leftView = leftView
        return phoneNumberField
    }()
    
    lazy var veriCodeField: UITextField = {
        let veriCodeField = UITextField()
        veriCodeField.font = UIFont.systemFont(ofSize: 14)
        veriCodeField.placeholder = "请输入6位动态码"
        veriCodeField.keyboardType = .numberPad
        veriCodeField.clearButtonMode = .whileEditing
        veriCodeField.leftViewMode = .always
        veriCodeField.rightViewMode = .always
        let leftView = UILabel()
        leftView.textAlignment = .left
        leftView.font = UIFont.systemFont(ofSize: 14)
        leftView.textColor = BaseColor.GrayColor
        leftView.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        leftView.text = "  动态码："
        veriCodeField.leftView = leftView
        
        //获取验证码按钮
        self.getVeriCodeBtn = UIButton(type: UIButtonType.system)
        self.getVeriCodeBtn.frame = CGRect(x: 0, y: 0, width: 80, height: 44)
        self.getVeriCodeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.getVeriCodeBtn.setTitle("获取动态码", for: .normal)
        self.getVeriCodeBtn.addTarget(self, action: #selector(getVeriCodeAction), for: .touchUpInside)
        veriCodeField.rightView = self.getVeriCodeBtn
        return veriCodeField
    }()

}
