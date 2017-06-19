//
//  PlantManagerViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/13.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class PlantManagerViewController: BaseViewController {
    
    override func loadSubViews() {
        super.loadSubViews()
        self.titleLabel.text = "种植管理"
        self.rightBtn.isHidden = false
        self.rightBtn.setTitle("+", for: .normal)
        self.rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        self.contentView.addSubview(self.menuContainer)
    }
    override func layoutConstraints() {
        self.menuContainer.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 0, 0));
        }
    }
    
    override func loadData() {
    }
    
    override func rightBtnAction() {
        print("添加种植信息")
    }
    
    lazy var menuContainer: MenuContainer = {
        let menuContainer = MenuContainer()
        menuContainer.menuCtrl.indicatorInset = (SCREEN_WIDTH/2.0-70)/2.0
        menuContainer.menuCtrl.titles = ["当前种植","历史种植"];
        menuContainer.scrollAnimated = false;
        return menuContainer
    }()
}
