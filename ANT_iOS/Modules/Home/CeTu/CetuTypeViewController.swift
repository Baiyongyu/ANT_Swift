//
//  CetuTypeViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/6.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class CetuTypeViewController: BaseViewController {
    
    var typeArray = NSArray()
    
    override func loadSubViews() {
        super.loadSubViews()
        self.titleLabel.text = "测土配肥"
        self.leftBtn.isHidden = false
        
        let bgView = UIImageView()
        bgView.image = UIImage.init(named: "ic_cetu_bg")
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 0, 0));
        }
        
        typeArray = ["免费测基肥","免费测追肥"]
        
        for i in 0 ..< typeArray.count {
            let cetuTypeBtn = UIButton(type: .custom)
            cetuTypeBtn.setTitle(typeArray[i] as? String, for: .normal)
            cetuTypeBtn.layer.cornerRadius = 5
            cetuTypeBtn.clipsToBounds = true
            cetuTypeBtn.layer.borderWidth = 0.5
            cetuTypeBtn.layer.borderColor = UIColor.orange.cgColor
            cetuTypeBtn.tag = 100+i
            cetuTypeBtn.setTitleColor(UIColor.orange, for: .normal)
            cetuTypeBtn.setTitleColor(UIColor.white, for: .highlighted)
            self.contentView.addSubview(cetuTypeBtn)
            cetuTypeBtn.snp.makeConstraints({ (make) in
                make.left.equalTo(20 + (SCREEN_WIDTH - 60)/2 * CGFloat(i) + CGFloat(20 * i))
                make.width.equalTo((self.view.bounds.size.width-60)/2.0);
                make.bottom.equalTo(bgView).offset(-55);
                make.height.equalTo(44);
            })
            
        }
    }
    
}
