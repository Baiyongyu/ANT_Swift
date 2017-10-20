//
//  Menu.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/20.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import Foundation
import UIKit

class Menu:UIView {
    
    let likeBtn = UIButton()
    let commentBtn = UIButton()
    var line = UIView()
    var show = false
    var isShowing = false
    var flag1 = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.show = false
        self.isShowing = false
        self.backgroundColor = UIColor(red: 60/255, green: 64/255, blue: 66/255, alpha: 1)
        self.setNeedsLayout()
        self.likeBtn.frame = CGRect(x: 0, y: 0, width: 80, height: 35)
        self.commentBtn.frame = CGRect(x: 80, y: 0, width: 80, height: 35)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    
        self.line = UIView(frame: CGRect(x: 80, y: 5, width: 1, height: 25))
        self.line.backgroundColor = UIColor(red: 50/255, green: 53/255, blue: 56/255, alpha: 1)
        self.addSubview(self.likeBtn)
        self.addSubview(self.commentBtn)
        self.addSubview(self.line)
    }
    
    func clickMenu() {
        if(self.show){
            //按钮隐藏
            menuHide()
        }else {
            menuShow()
        }
    }
    
    func menuShow() {
        self.show = true
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.layoutSubviews, animations: {
            self.frame = CGRect(x: self.frame.origin.x-160, y: self.frame.origin.y, width: 160, height: 34)
            }) { (Bool) in
                
        }
    }
    
    func menuHide() {
        self.show = false
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.layoutSubviews, animations: {
            self.frame = CGRect(x: self.frame.origin.x+160, y: self.frame.origin.y, width: 0, height: 34)
        }) { (Bool) in
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
