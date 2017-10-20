//
//  PhotoBrowser+Indicator.swift
//  PhotoBrowser
//
//  Created by 冯成林 on 15/8/13.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit

extension PhotoBrowser {
    
    /** pagecontrol准备 */
    func pagecontrolPrepare() {
        
        if !hideMsgForZoomAndDismissWithSingleTap {
            return
        }
        
        view.addSubview(pagecontrol)
        pagecontrol.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, 0, 37))
        }
        pagecontrol.numberOfPages = photoModels.count
        pagecontrol.isEnabled = false
    }
    
    /** pageControl页面变动 */
    func pageControlPageChanged(page: Int) {

        if page < 0 || page >= photoModels.count {
            return
        }
        
        if showType == PhotoBrowser.ShowType.ZoomAndDismissWithSingleTap && hideMsgForZoomAndDismissWithSingleTap {
            pagecontrol.currentPage = page
        }
    }
}
