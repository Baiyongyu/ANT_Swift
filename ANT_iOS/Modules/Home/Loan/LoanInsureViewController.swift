//
//  LoanInsureViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/6.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

enum LoanOrInsureType {
    case loan
    case insure
}

class LoanInsureViewController: BaseViewController {
    
    var dataArray = NSArray()
    var selectType: LoanOrInsureType?
    
    override func loadSubViews() {
        super.loadSubViews()
        
        if selectType == .loan {
            self.titleLabel.text = "办贷款"
        }else {
            self.titleLabel.text = "买保险"
        }
        
        let bgView = UIImageView()
        bgView.image = UIImage.init(named: "ic_cetu_bg")
        self.contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(NavBarHeight, 0, 0, 0));
        }
        
        self.dataArray = ["北京","上海","哈尔滨","杭州","南京","广东","大连","沈阳","北京","上海","哈尔滨","杭州","南京","广东","大连","沈阳"]
        SelectAreaAlert().selectAreaAlert(title: "选择地区", titles: self.dataArray, codes: self.dataArray)
    }
    
    override func loadData() {
        
    }
}
