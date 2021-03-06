//
//  PhotoBrowser.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/20.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class PhotoBrowser: BaseViewController {
    
    lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: Layout())
    /**  展示样式：请设置  */
    var showType: ShowType!
    /**  相册类型：请设置  */
    var photoType: PhotoType!
    /**  相册数据  */
    var photoModels: [PhotoModel]! {
        didSet {
            collectionView.reloadData()
        }
    }
    /**  强制关闭一切信息显示: 仅仅针对ZoomAndDismissWithSingleTap模式有效  */
    var hideMsgForZoomAndDismissWithSingleTap: Bool = false
    
    lazy var pagecontrol = UIPageControl()
    var page: Int = 0 {
        didSet {
            pageControlPageChanged(page: page)
        }
    }
    weak var vc: UIViewController!
    var isNavBarHidden: Bool!
    var isTabBarHidden: Bool!
    var isStatusBarHidden: Bool!
    var showIndex: Int = 0
    var dismissBtn,saveBtn: UIButton!
    var isHiddenBar: Bool = false
    
    lazy var photoArchiverArr: [Int] = []
    
    lazy var hud: UILabel = {
        let hud = UILabel()
        hud.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        hud.textColor = UIColor.white
        hud.alpha = 0
        hud.textAlignment = NSTextAlignment.center
        hud.layer.cornerRadius = 5
        hud.layer.masksToBounds = true
        return hud
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self);print("deinit")
    }
}
