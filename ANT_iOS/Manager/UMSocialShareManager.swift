//
//  UMSocialShareManager.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/19.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class UMSocialShareManager: NSObject {

    //创建一个静态或者全局变量，保存当前单例实例值
    private static let sharedInstance = UMSocialShareManager()
    //私有化构造方法
    private override init() {
        
    }
    
    func showSharePlatformTypeTitle(title: String, descr: String, thumImage: AnyObject, webpageUrl: String) {
        UMSocialUIManager.removeAllCustomPlatformWithoutFilted()
        UMSocialShareUIConfig.shareInstance().sharePageGroupViewConfig.sharePageGroupViewPostionType = .bottom
        UMSocialShareUIConfig.shareInstance().sharePageScrollViewConfig.shareScrollViewPageItemStyleType = .iconAndBGRadius
        
        //显示分享面板
        UMSocialUIManager.showShareMenuViewInWindow { (platformType: UMSocialPlatformType, userInfo: Any) in
            // 根据获取的platformType确定所选平台进行下一步操作
            self.shareWebPageToPlatformType(platformType: platformType, title: title, descr: descr, thumImage: thumImage, webpageUrl: webpageUrl)
        }
    }
    
    func shareWebPageToPlatformType(platformType: UMSocialPlatformType, title: String, descr: String, thumImage: AnyObject, webpageUrl: String) {
        //创建分享消息对象
//        let messageObject = UMSocialMessageObject
        //创建网页内容对象
        let shareObject = UMShareWebpageObject.shareObject(withTitle: title, descr: descr, thumImage: thumImage)
        //设置网页地址
        shareObject?.webpageUrl = webpageUrl
        //分享消息对象设置分享内容对象
//        messageObject.shareObject = shareObject
//        print(\(shareObject.webpageUrl))
        
        
    }
    
    //提供一个公开的用来去获取单例的方法
    class func defaultSingleInstance() -> UMSocialShareManager {
        //返回初始化好的静态变量值
        return sharedInstance
    }
}
