//
//  WebThingViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/27.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class WebThingViewController: BaseViewController {
    
    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text = "物联网"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // 关闭侧滑返回手势，防止视频监控没有退出。
        if (navigationController?.responds(to: #selector(getter: navigationController?.interactivePopGestureRecognizer)))! {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // 打开侧滑返回手势
        if (navigationController?.responds(to: #selector(getter: navigationController?.interactivePopGestureRecognizer)))! {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
}
