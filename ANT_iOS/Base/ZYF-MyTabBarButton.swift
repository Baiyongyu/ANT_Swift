//
//  ZYF-MyTabBarButton.swift
//  JSByZYF
//
//  Created by zhyunfe on 16/9/23.
//  Copyright © 2016年 zhyunfe. All rights reserved.
//

import UIKit

class ZYF_MyTabBarButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRectMake(0, 0, 49, 49)
        self.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.setTitleColor(UIColor.redColor(), forState: .Selected)
        self.titleLabel?.font = UIFont.systemFontOfSize(11)
        self.titleLabel?.textAlignment = .Center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //重写button中图片的位置
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake((contentRect.size.width - 30) / 2, 2, 30, 30)
    }
    //重写button中文本框的位置
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(0, contentRect.size.height - 17, contentRect.size.width, 15)
    }
    convenience init(frame: CGRect,image:String) {
        self.init(frame:frame)
        let imageView = UIImageView(frame: CGRectMake(0,0,70,70))
        imageView.image = UIImage(named: image)
        self.addSubview(imageView)
    }
}
