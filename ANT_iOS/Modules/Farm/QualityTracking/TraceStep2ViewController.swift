//
//  TraceStep2ViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/19.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class TraceStep2ViewController: BaseViewController {

    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text = "第二步"
        contentView.backgroundColor = UIColor.white
        
        rightBtn.isHidden = false
        rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e611}", size: 25, color: UIColor.black)), for: .normal)
        rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e611}", size: 25, color: UIColor.gray)), for: .highlighted)
        
        let traceStepView = TraceStepView(style: .default, reuseIdentifier: "")
        traceStepView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 220)
        traceStepView.centerX = view.centerX
        
        let stepData = StepGuideModel()
        stepData.server_name = "小陌"
        stepData.server_image = ""
        stepData.step_title = "给你的农产品取个响当当的名字吧"
        traceStepView.stepData = stepData
        contentView.addSubview(traceStepView)
    }
    
    override func layoutConstraints() {
        contentView.addSubview(productNameInputDialog)
        productNameInputDialog.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.top.equalTo(250)
            make.height.equalTo(30)
        }
        
        contentView.addSubview(nextStepkBtn)
        nextStepkBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.bottom.equalTo(view).offset(-40)
            make.height.equalTo(44)
        }
    }
    
    override func rightBtnAction() {
        let alertView = YYAlertView()
        alertView.initWithTitle(titles: "退出后已经填写的信息将不会被保存，确定要退出吗？", message: "", sureTitle: "确定", cancleTitle: "取消")
        alertView.alertSelectIndex = { (index) -> Void in
            if index == 2 {
                self.dismiss(animated: true, completion: nil)
            }
        }
        alertView.showAlertView()
    }
    
    func nextStepkBtnAction() {
        let step3 = TraceStep3ViewController()
        self.navigationController?.pushViewController(step3, animated: true)
    }
    
    lazy var productNameInputDialog: InputDialog = {
        let productNameInputDialog = InputDialog(initWithCountEnabled: true)
        productNameInputDialog.characterCount = 10
        productNameInputDialog.textView.placeHolder = " 请输入产品名称"
        productNameInputDialog.addLineOnBottom()
        return productNameInputDialog
    }()
    
    lazy var nextStepkBtn: UIButton = {
        let nextStepkBtn = UIButton(type: UIButtonType.custom)
        nextStepkBtn.setTitle("下一步", for: .normal)
        nextStepkBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextStepkBtn.setTitleColor(UIColor.white, for: .normal)
        nextStepkBtn.setTitleColor(BaseColor.ThemeColor, for: .highlighted)
        nextStepkBtn.setBackgroundImage(creatImageWithColor(color: BaseColor.ThemeColor), for: .normal)
        nextStepkBtn.setBackgroundImage(creatImageWithColor(color: UIColor.white), for: .highlighted)
        nextStepkBtn.layer.borderWidth = 0.5
        nextStepkBtn.layer.borderColor = BaseColor.ThemeColor.cgColor
        nextStepkBtn.layer.cornerRadius = 5
        nextStepkBtn.clipsToBounds = true
        nextStepkBtn.addTarget(self, action: #selector(nextStepkBtnAction), for: .touchUpInside)
        return nextStepkBtn
    }()
}
