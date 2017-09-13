//
//  PublishViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/29.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class PublishViewController: BaseViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            self.activityInputDialog.textView.becomeFirstResponder()
        }
    }
    
    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text = "农友圈"
        rightBtn.isHidden = false
        rightBtn.setTitle("发布", for: .normal)
        rightBtn.setTitleColor(BaseColor.GrayColor, for: .disabled)
        rightBtn.isEnabled = false
        contentView.backgroundColor = BaseColor.BackGroundColor
        contentView.addSubview(activityInputDialog)
        
        activityInputDialog.valueBlock = { (objc) -> Void in
            self.checkInput()
        }
    }
    
    override func layoutConstraints() {
        activityInputDialog.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.top.equalTo(10)
            make.height.equalTo(100)
        }
    }
    
    func checkInput() {
        self.rightBtn.isEnabled = activityInputDialog.textView.text.lengthOfBytes(using: .utf8) > 0
    }
    
    override func leftBtnAction() {
        let alertView = ActionAlertView()
        alertView.initWithTitle(titles: "是否放弃此次编辑？", message: "", sureTitle: "确定", cancleTitle: "取消")
        alertView.alertSelectIndex = { (index) -> Void in
            if index == 2 {
                AppCommon.popViewController(animated: true)
            }
        }
        alertView.showAlertView()
    }
    
    override func rightBtnAction() {
        view.endEditing(true)
    }
    
    lazy var activityInputDialog: InputDialog = {
        let activityInputDialog = InputDialog(initWithCountEnabled: true)
        activityInputDialog.characterCount = 100
        activityInputDialog.textView.placeHolder = " 请输入内容..."
        activityInputDialog.backgroundColor = UIColor.white
        activityInputDialog.layer.cornerRadius = 3
        activityInputDialog.layer.borderColor = BaseColor.BackGroundColor.cgColor
        activityInputDialog.layer.borderWidth = 0.5
        activityInputDialog.layer.masksToBounds = true
        return activityInputDialog
    }()

}
