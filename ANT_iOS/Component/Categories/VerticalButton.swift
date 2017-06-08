//
//  VerticalButton.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/4.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class VerticalButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var center = self.imageView?.center
        center?.x = self.frame.size.width/2
        center?.y = (self.imageView?.frame.size.height)!/2
        self.imageView?.center = center!
        
        //Center text
        var newFrame = self.titleLabel?.frame
        newFrame?.origin.x = 3
        newFrame?.origin.y = (self.imageView?.frame.size.height)! + 5
        newFrame?.size.width = self.frame.size.width
        self.titleLabel?.frame = newFrame!
        self.titleLabel?.textAlignment = .center
        self.imageView?.contentMode = .center
    }
}
