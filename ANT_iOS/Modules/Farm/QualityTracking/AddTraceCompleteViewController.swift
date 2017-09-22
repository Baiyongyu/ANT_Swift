//
//  AddTraceCompleteViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/19.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class AddTraceCompleteViewController: BaseViewController {

    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text = "完成"
        contentView.backgroundColor = UIColor.white
        
        leftBtn.isHidden = false
        leftBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e611}", size: 25, color: UIColor.black)), for: .normal)
        leftBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e611}", size: 25, color: UIColor.gray)), for: .highlighted)
        
        let traceStepView = TraceStepView(style: .default, reuseIdentifier: "")
        traceStepView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 220)
        traceStepView.centerX = view.centerX
        
        let stepData = StepGuideModel()
        stepData.server_name = "小陌"
        stepData.server_image = ""
        stepData.step_title = "恭喜你，质量溯源已生成，快去查看吧\n如果想定制个性化高级溯源系统，请联系\n18109635506"
        traceStepView.stepData = stepData
        contentView.addSubview(traceStepView)
    }
    
    override func layoutConstraints() {
        contentView.addSubview(productImage)
        productImage.snp.makeConstraints { (make) in
            make.top.equalTo(290)
            make.centerX.equalTo(view)
            make.width.height.equalTo(160)
        }
        
        contentView.addSubview(nextStepkBtn)
        nextStepkBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.bottom.equalTo(view).offset(-40)
            make.height.equalTo(44)
        }
    }
    
    override func leftBtnAction() {
        self.dismiss(animated: true, completion: nil)
    }

    func nextStepkBtnAction() {
        let details = QualityTracDetailsViewController()
        self.present(details, animated: true, completion: nil)
    }
    
    lazy var productImage: UIImageView = {
        let productImage = UIImageView()
        productImage.contentMode = .scaleAspectFill
        productImage.kf.setImage(with: nil, placeholder: IMAGE_PLACEHOLDER, options: nil, progressBlock: nil, completionHandler: nil)
        productImage.layer.cornerRadius = 2
        productImage.clipsToBounds = true
        productImage.layer.borderColor = BaseColor.LineColor.cgColor
        productImage.layer.borderWidth = 0.5
        return productImage
    }()
    
    lazy var nextStepkBtn: UIButton = {
        let nextStepkBtn = UIButton(type: UIButtonType.custom)
        nextStepkBtn.setTitle("查看溯源页面", for: .normal)
        nextStepkBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextStepkBtn.setTitleColor(UIColor.white, for: .normal)
        nextStepkBtn.setTitleColor(BaseColor.GrayColor, for: .highlighted)
        nextStepkBtn.backgroundColor = BaseColor.ThemeColor
        nextStepkBtn.layer.cornerRadius = 5
        nextStepkBtn.clipsToBounds = true
        nextStepkBtn.addTarget(self, action: #selector(nextStepkBtnAction), for: .touchUpInside)
        return nextStepkBtn
    }()
    
}
