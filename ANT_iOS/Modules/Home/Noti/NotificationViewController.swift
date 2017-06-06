//
//  NotificationViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/4.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class NotificationViewController: BaseViewController {

    override func loadSubViews() {
        super.loadSubViews()
        self.titleLabel.text = "通知"
        self.leftBtn.isHidden = false
    }

}
