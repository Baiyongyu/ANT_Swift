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
        
        let updateContent = "1、增加【圈子】，可以分享天然气信息，提问天然气问题\n2、用户可查询附近的气站，并在线购买\n3、增加【贷款、保险】可在线资讯贷款、保险信息\n4、可以更方便添加天然气记录"
        
        let alertView = VersionAlertView()
        alertView.initWithTitle(titles: "发现新版本V\(CurrentVersion)", message: updateContent)
        alertView.showAlertView()
    }
    
}
