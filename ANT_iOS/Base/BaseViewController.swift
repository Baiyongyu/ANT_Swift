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
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.lightGray
        loadSubViews()
        view.bringSubview(toFront: navBar)
        layoutConstraints()
        loadData()
    }
    
    public func loadSubViews() {
        view.addSubview(contentView)
        view.addSubview(navBar)
        navBar.addSubview(leftBtn)
        navBar.addSubview(rightBtn)
        leftBtn.isHidden = navigationController?.childViewControllers.count == 1
        rightBtn.isHidden = true
        navBar.addSubview(titleLabel)
        layoutNavigationBar()
    }
    
    public func layoutNavigationBar() {
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(64, 0, 0, 0));
        }
        
        navBar.snp.makeConstraints { (make) in
            make.left.equalTo(view);
            make.top.equalTo(view);
            make.right.equalTo(view);
            make.height.equalTo(64);
        }
        
        leftBtn.snp.makeConstraints { (make) in
            make.left.equalTo(navBar);
            make.top.equalTo(navBar).offset(20);
            make.width.equalTo(50);
            make.height.equalTo(40);
        }
        
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(navBar);
            make.top.equalTo(navBar).offset(20);
            make.width.equalTo(50);
            make.height.equalTo(40);
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftBtn.snp.right).offset(5);
            make.right.equalTo(rightBtn.snp.left).offset(-5);
            make.top.equalTo(navBar).offset(20);
            make.height.equalTo(40);
        }
        
        self.view?.setNeedsLayout()
    }
    
    public func layoutConstraints() {
        
    }
    
    public func loadData() {
        
    }
    
    public func leftBtnAction() {
        navigationController?.popViewController(animated: true)
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
        leftBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e62b}", size: 20, color: UIColor.black)), for: .normal)
        leftBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e62b}", size: 20, color: UIColor.gray)), for: .highlighted)
        leftBtn.imageView?.layer.masksToBounds = true
        leftBtn.addTarget(self, action: #selector(BaseViewController.leftBtnAction), for: .touchUpInside)
        return leftBtn
    }()
    
    lazy var rightBtn: UIButton = {
        let rightBtn = UIButton(type: .custom)
        rightBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        rightBtn.titleLabel?.textAlignment = .right
        rightBtn.setTitleColor(UIColor.black, for: .normal)
        rightBtn.setTitleColor(BaseColor.ThemeColor, for: .highlighted)
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
