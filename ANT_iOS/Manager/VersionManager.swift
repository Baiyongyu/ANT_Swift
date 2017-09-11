//
//  VersionManager.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/19.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class VersionManager: NSObject {
    
    func checkVersionUpdate() {
        
        let updateContent = "1、页面UI优化，更清爽\n2、增加农田管理模块，可绘制田块，添加种植计划\n3、基于田块位置展示天气预报\n4、农事记录可对应到作物和田块"
        
        let alertView = VersionAlertView()
        alertView.initWithTitle(titles: "发现新版本V\(CurrentVersion)", message: updateContent)
        alertView.resultIndex = { (index) -> Void in
            UIApplication.shared.openURL(NSURL.init(string: "http://itunes.apple.com/app/id1203569270")! as URL)
        }
        alertView.showAlertView()
    }
    
}
