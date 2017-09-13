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

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN = UIScreen.main.bounds
let CurrentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

let IMAGE_PLACEHOLDER = UIImage.init(named: "ic_default_image")
let IMAGE_AVATAR_PLACEHOLDER = UIImage.init(named: "placeholder.jpg")
let IMAGE_HUD_SUCCESS = UIImage.init(named: "ic_hud_success")

let TabBarMagin = 12
let TableViewCellDefaultHeight = 44

let PhoneNumber         = "0553-5010050"
let Tip_RequestError    = "网络请求错误，请重试"
let Tip_RequestOutTime  = "请求超时"
let Tip_NoNetwork       = "暂无网络，请稍后再试"
let Tip_LoginTimeOut    = "登录超时"
let Tip_RequestUnlegal  = "账号在其他设备登录，请重新登录"
