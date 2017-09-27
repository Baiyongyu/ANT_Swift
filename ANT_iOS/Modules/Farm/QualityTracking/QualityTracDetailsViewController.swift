//
//  QualityTracDetailsViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/19.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class QualityTracDetailsViewController: BaseViewController {

    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text = "质量溯源"
        contentView.backgroundColor = UIColor.white
        
        leftBtn.isHidden = false
        leftBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e611}", size: 25, color: UIColor.black)), for: .normal)
        leftBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e611}", size: 25, color: UIColor.gray)), for: .highlighted)
        
        rightBtn.isHidden = false
        rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e639}", size: 20, color: UIColor.black)), for: .normal)
        rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e639}", size: 20, color: UIColor.gray)), for: .highlighted)
    }
    
    override func layoutConstraints() {
        contentView.addSubview(leftEditBtn)
        leftEditBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.bottom.equalTo(view).offset(-10)
            make.height.equalTo(40)
            make.width.equalTo((SCREEN_WIDTH - 60 - 50)/2)
        }
        
        contentView.addSubview(rightShareBtn)
        rightShareBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-30)
            make.bottom.equalTo(view).offset(-10)
            make.height.equalTo(40)
            make.width.equalTo((SCREEN_WIDTH - 60 - 50)/2)
        }
        
        let seperator = UIView()
        seperator.backgroundColor = BaseColor.LineColor
        contentView.addSubview(seperator)
        seperator.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(0.5)
            make.bottom.equalTo(leftEditBtn.snp.top).offset(-10)
        }
    }
    
    override func leftBtnAction() {
        AppCommon.dismissViewController(animated: true)
    }
    
    override func rightBtnAction() {
        
    }
    
    func leftEditBtnAction() {
        let step1 = TraceStep1ViewController()
        let nav = UINavigationController.init(rootViewController: step1)
        nav.navigationBar.isHidden = true
        self.present(nav, animated: true, completion: nil)
    }
    
    func rightShareBtnAction() {
        
//        UMSocialUIManager.removeAllCustomPlatformWithoutFilted()
//        UMSocialShareUIConfig.shareInstance().sharePageGroupViewConfig.sharePageGroupViewPostionType = .bottom
//        UMSocialShareUIConfig.shareInstance().sharePageScrollViewConfig.shareScrollViewPageItemStyleType = .iconAndBGRadius
        
        UMSocialSwiftInterface.showShareMenuViewInWindowWithPlatformSelectionBlock { (platformType: UMSocialPlatformType, userInfo: Any) in
            //创建分享消息对象
            let messageObject = UMSocialMessageObject()
            //创建网页内容对象
            let shareTitle = "稻鳖共生米，有态度的农产品！"
            let shareDesTitle = "稻鳖共生米-阡陌优品"
            let shareObject = UMShareWebpageObject.shareObject(withTitle: shareTitle, descr: shareDesTitle, thumImage: UIImage.init(named: "ic_settings_logo"))
            //设置网页地址
            shareObject?.webpageUrl = ""
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject
            
            UMSocialSwiftInterface.share(plattype: platformType, messageObject: messageObject, viewController: nil, completion: { (data: Any, error: Error) in
                
                } as! (Any?, Error?) -> Void)
        }
    }

    lazy var leftEditBtn: UIButton = {
        let leftEditBtn = UIButton(type: UIButtonType.custom)
        leftEditBtn.setTitle("再次编辑", for: .normal)
        leftEditBtn.setTitleColor(UIColor.white, for: .normal)
        leftEditBtn.setTitleColor(UIColor.gray, for: .highlighted)
        leftEditBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftEditBtn.backgroundColor = BaseColor.ThemeColor
        leftEditBtn.layer.cornerRadius = 5
        leftEditBtn.clipsToBounds = true
        leftEditBtn.addTarget(self, action: #selector(leftEditBtnAction), for: .touchUpInside)
        return leftEditBtn
    }()

    lazy var rightShareBtn: UIButton = {
        let rightShareBtn = UIButton(type: UIButtonType.custom)
        rightShareBtn.setTitle("分享给朋友", for: .normal)
        rightShareBtn.setTitleColor(UIColor.white, for: .normal)
        rightShareBtn.setTitleColor(UIColor.gray, for: .highlighted)
        rightShareBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        rightShareBtn.backgroundColor = BaseColor.ThemeColor
        rightShareBtn.layer.cornerRadius = 5
        rightShareBtn.clipsToBounds = true
        rightShareBtn.addTarget(self, action: #selector(rightShareBtnAction), for: .touchUpInside)
        return rightShareBtn
    }()
    
}
