//
//  BaseConst.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/6.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit
/******************************* ThirdLib *******************************/
import SnapKit
import Kingfisher

let SCREEN_Window = UIApplication.shared.keyWindow!
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN = UIScreen.main.bounds
let CurrentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

let IMAGE_PLACEHOLDER = UIImage.init(named: "ic_default_image")
let IMAGE_AVATAR_PLACEHOLDER = UIImage.init(named: "placeholder.jpg")
let IMAGE_HUD_SUCCESS = UIImage.init(named: "ic_hud_success")

let TabBarMagin = 12
let TableViewCellDefaultHeight = 44

//-----------------------------------  手机型号  ------------------------------------
let IS_IPHONE           = (UI_USER_INTERFACE_IDIOM() == .phone)
let SCREEN_MAX_LENGTH   = max(SCREEN_WIDTH, SCREEN_HEIGHT)
let IS_IPHONE_4_OR_LESS = (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
let IS_IPHONE_iPX       = (IS_IPHONE && SCREEN_MAX_LENGTH > 736.0)

let NavBarHeight        = CGFloat(IS_IPHONE_iPX ? 88 : 64)
let TabBarHeight        = CGFloat(IS_IPHONE_iPX ? 83 : 49)

let PhoneNumber         = "0553-5010050"
let Tip_RequestError    = "网络请求错误，请重试"
let Tip_RequestOutTime  = "请求超时"
let Tip_NoNetwork       = "暂无网络，请稍后再试"
let Tip_LoginTimeOut    = "登录超时"
let Tip_RequestUnlegal  = "账号在其他设备登录，请重新登录"

let UMSHARE_APPKEY      = "58a11aac4544cb5cd2001b93"
let WXSHARE_KEY         = "wx2c2b08f1eb7c9ca6"
let WXSHARE_SECRET      = "9e9a9d2926c129ecba5cc2e2e8902528"
let QQSHARE_APPKEY      = "1106007592"
let QQSHARE_SECRET      = "N7SFtmSPnoMQIfHQ"
