//
//  BaseViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/2.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.lightGray
        loadSubViews()
        self.view.bringSubview(toFront: self.navBar)
        layoutConstraints()
        loadData()
    }
    
    public func loadSubViews() {
        self.view.addSubview(self.contentView)
        self.view.addSubview(self.navBar)
        self.navBar.addSubview(self.leftBtn)
        self.navBar.addSubview(self.rightBtn)
        self.leftBtn.isHidden = self.navigationController?.childViewControllers.count == 1
        self.rightBtn.isHidden = true
        self.navBar.addSubview(self.titleLabel)
        layoutNavigationBar()
    }
    
    public func layoutNavigationBar() {
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 0, 0));
        }
        
        self.navBar.snp.makeConstraints { (make) in
            make.left.equalTo(self.view);
            make.top.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.equalTo(64);
        }
        
        self.leftBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.navBar).offset(0);
            make.top.equalTo(self.navBar).offset(20);
            make.width.equalTo(80);
            make.height.equalTo(40);
        }
        
        self.rightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.navBar);
            make.top.equalTo(self.navBar).offset(20);
            make.width.equalTo(60);
            make.height.equalTo(40);
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.leftBtn.snp.right).offset(5);
            make.right.equalTo(self.rightBtn.snp.left).offset(-25);
            make.top.equalTo(self.navBar).offset(20);
            make.height.equalTo(40);
        }
        
        self.view?.setNeedsLayout()
    }
    
    public func layoutConstraints() {
    }
    
    public func loadData() {
    }
    
    public func leftBtnAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    public func rightBtnAction() {
        
    }
    
    
    lazy var navBar: UIView = {
        let navBar = UIView()
        navBar.backgroundColor = UIColor.white
        navBar.layer.shadowOffset = CGSize(width: 0, height: 0.3)
        navBar.layer.shadowColor = UIColor.init(white: 0, alpha: 0.4).cgColor
        navBar.layer.shadowOpacity = 0.3
        return navBar
    }()
    
    lazy var leftBtn: UIButton = {
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage.init(named: "ic_back"), for: .normal)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        leftBtn.contentMode = .center
        leftBtn.imageView?.layer.masksToBounds = true
        leftBtn.addTarget(self, action: #selector(BaseViewController.leftBtnAction), for: .touchUpInside)
        return leftBtn
    }()
    
    lazy var rightBtn: UIButton = {
        let rightBtn = UIButton(type: .custom)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightBtn.titleLabel?.textAlignment = .right
        rightBtn.contentMode = .center
        rightBtn.addTarget(self, action: #selector(BaseViewController.rightBtnAction), for: .touchUpInside)
        return rightBtn
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = BaseColor.BlackColor
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    
    lazy var contentView: UIScrollView = {
        let contentView = UIScrollView()
        contentView.isScrollEnabled = false
        contentView.scrollsToTop = false
        contentView.backgroundColor = BaseColor.BackGroundColor
        return contentView
    }()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
