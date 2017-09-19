//
//  CustomPageControl.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/19.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class CustomPageControl: UIView {

    /** 普通状态下Dot颜色 */
    var normalDotColor: UIColor?
    /** 选中状态下Dot颜色 */
    var selectedDotColor: UIColor?
    
    var currentDot: UIImageView?
    var currentIndex: NSInteger?
    var dot = NSMutableArray()
    var count: NSInteger = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        self.normalDotColor = BaseColor.ThemeColor
        self.selectedDotColor = BaseColor.ThemeColor
        self.currentIndex = 0
        setupUI()
    }
    
    
    func setupUI() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 这种方式直接改变位置没有动画
    func setSelectedIndex(_ index: NSInteger) {
        
    }

}
