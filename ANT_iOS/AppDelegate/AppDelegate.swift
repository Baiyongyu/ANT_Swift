//
//  AppDelegate.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/2.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        let tabBarController = AppTabBarController()
        let nav = AppNavigationController.init(rootViewController: tabBarController)
        nav.navigationBar.isHidden = true
        window?.rootViewController = nav
        
        /* 版本判断 */
//        let versionManager = VersionManager()
//        versionManager.checkVersionUpdate()
        
        /* 高德地图 */
        AMapServices.shared().enableHTTPS = true
        AMapServices.shared().apiKey = AMAP_KEY
        
        /* 友盟分享 */
        /* 打开调试日志 */
        UMSocialManager.default().openLog(true)
        UMSocialManager.default().umSocialAppkey = UMSHARE_APPKEY
        configUSharePlatforms()
        
        /* IQKeyboardManagerSwift */
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = "完成"
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = true
        IQKeyboardManager.sharedManager().placeholderFont = UIFont.systemFont(ofSize: 14)
        IQKeyboardManager.sharedManager().toolbarTintColor = BaseColor.ThemeColor
        
        /* iconfont图标 */
        TBCityIconFont.setFontName("iconfont")
        return true
    }

    func configUSharePlatforms() {
        /* 设置微信的appKey和appSecret */
        UMSocialManager.default().setPlaform(.wechatSession, appKey: WXSHARE_KEY, appSecret: WXSHARE_SECRET, redirectURL: "http://mobile.umeng.com/social")
        /* 移除微信收藏*/
        UMSocialManager.default().removePlatformProvider(with: .wechatFavorite)
        
        /* 设置QQ平台的appID*/
        UMSocialManager.default().setPlaform(.QQ, appKey: QQSHARE_APPKEY, appSecret: nil, redirectURL: "http://mobile.umeng.com/social")
        UMSocialGlobal.shareInstance().isUsingHttpsWhenShareContent = false
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let result = UMSocialManager.default().handleOpen(url, options: options)
        return result
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let result = UMSocialManager.default().handleOpen(url)
        return result
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let result = UMSocialManager.default().handleOpen(url, sourceApplication: sourceApplication, annotation: annotation)
        return result
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

