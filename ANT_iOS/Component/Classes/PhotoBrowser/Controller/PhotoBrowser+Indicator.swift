//
//  PhotoBrowser+Indicator.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/20.
//  Copyright © 2017年 qianmo. All rights reserved.
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
