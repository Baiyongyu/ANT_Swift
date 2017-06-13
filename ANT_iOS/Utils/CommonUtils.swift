//
//  CommonUtils.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/8.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class CommonUtils: NSObject {

    // 加载弹框视图的动画
    public func setCAKeyframeAnimation(view: UIView) {
        
        var animation = CAKeyframeAnimation()
        animation = CAKeyframeAnimation.init(keyPath: "transform")
        animation.duration = 0.3
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        let values = NSMutableArray()
        values.add(NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)))
        values.add(NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)))
        values.add(NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values as? [Any]
        view.layer.add(animation, forKey: nil)
    }
}
