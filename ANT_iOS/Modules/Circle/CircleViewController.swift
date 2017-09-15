//
//  CircleViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/2.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class CircleViewController: BaseViewController {

    override func loadSubViews() {
        super.loadSubViews()
        self.titleLabel.text = "圈子"
        rightBtn.isHidden = false
        rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e61e}", size: 20, color: UIColor.black)), for: .normal)
        rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e61e}", size: 20, color: UIColor.gray)), for: .highlighted)
    }
    
    override func rightBtnAction() {
        YYSheetView.actionSheet().showActionSheetWithTitles(["农友圈","提问题"], { (index) in
            switch index {
                case 0:
                    AppCommon.push(PublishViewController(), animated: true)
                case 1:
                    AppCommon.push(PublishViewController(), animated: true)
                default:
                    break
            }
        })
    }

}
