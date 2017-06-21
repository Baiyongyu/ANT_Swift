//
//  MenuControl.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/13.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit
protocol MenuControlDelegate {
    func menuCtrl(menuCtrl: MenuControl, didSelectIndex index:NSInteger)
}

class MenuControl: UIView {
    
    //外部调用可修改的属性
    var font = UIFont()
    var selectedFont = UIFont()
    var textColor = UIColor()
    var selectedTextColor = UIColor()
    var indicatorColor = UIColor()
    var titles = NSArray()
    var selectedIndex = NSInteger()
//    var indicatorLine = UIView()
    var indicatorInset = CGFloat()
    var animating = Bool()
    //代理
    var delegate:MenuControlDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.indicatorColor = UIColor.orange
        self.selectedTextColor = UIColor.orange
        self.textColor = UIColor.lightGray
        self.font = UIFont.systemFont(ofSize: 14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func menuBtnClick(sender: UIButton) {
        var selectedIndex = NSInteger()
        selectedIndex = sender.tag - 1000
        if self.selectedIndex != selectedIndex {
            self.selectedIndex = selectedIndex
            if ((self.delegate?.menuCtrl(menuCtrl: self, didSelectIndex: selectedIndex)) != nil) {
                self.delegate?.menuCtrl(menuCtrl: self, didSelectIndex: selectedIndex)
            }
        }
    }
    
    func setTitles(titles: NSArray) {
        self.titles = titles
        for view in self.subviews {
            view.removeFromSuperview()
        }
        for i in 0 ..< self.titles.count {
            let menuBtn = UIButton(type: UIButtonType.custom)
            menuBtn.tag = 1000 + i
            menuBtn.setTitle(self.titles[i] as? String, for: .normal)
            menuBtn.setTitleColor(self.textColor, for: .normal)
            menuBtn.setTitleColor(self.selectedTextColor, for: .selected)
            menuBtn.titleLabel?.font = self.font
            self.addSubview(menuBtn)
            if i == 0 {
                menuBtn.isSelected = true
                menuBtn.snp.makeConstraints({ (make) in
                    make.width.equalTo(self).dividedBy(self.titles.count);
                    make.top.height.equalTo(self);
                    make.left.equalTo(0);
                })
                if (!(self.indicatorLine.superview != nil)) {
                    self.indicatorLine.backgroundColor = self.indicatorColor
                    self.addSubview(self.indicatorLine)
                    self.indicatorLine.frame = CGRect(x: self.indicatorInset, y: self.bottom-2, width: SCREEN_WIDTH/CGFloat(self.titles.count)-2*self.indicatorInset, height: 2)
                }
            }else {
                var formerBtn = UIButton(type: UIButtonType.custom)
                formerBtn = self.viewWithTag(1000+i-1) as! UIButton
                menuBtn.snp.makeConstraints({ (make) in
                    make.width.equalTo(self).dividedBy(self.titles.count);
                    make.top.height.equalTo(self);
                    make.left.equalTo(formerBtn.snp.right);
                })
            }
            menuBtn.addTarget(self, action: #selector(menuBtnClick(sender:)), for: .touchUpInside)
        }
        if (!(self.seperatorLine.superview != nil)) {
            self.addSubview(self.seperatorLine)
            self.seperatorLine.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalTo(self);
                make.height.equalTo(0.5);
            })
        }
    }
    
    func setSelectedIndex(selectedIndex: NSInteger) {
        self.selectedIndex = selectedIndex
        if self.titles.count == 0 {
            return
        }
        for i in 0 ..< self.titles.count {
            var menuBtn = UIButton()
            menuBtn = self.viewWithTag(1000+i) as! UIButton
            menuBtn.isSelected = (i == selectedIndex)
        }
        self.animating = true
        UIView.animate(withDuration: 0.3, animations: {
            self.indicatorLine.left = self.width/CGFloat(self.titles.count) + self.indicatorInset
        }) { (true) in
            self.animating = false
        }
    }
    
    lazy var indicatorLine: UIView = {
        let indicatorLine = UIView()
        return indicatorLine
    }()
    
    lazy var seperatorLine: UIView = {
        let seperatorLine = UIView()
        seperatorLine.backgroundColor = BaseColor.BackGroundColor
        return seperatorLine
    }()
}




class MenuContainer: UIView, UITableViewDelegate, UITableViewDataSource, MenuControlDelegate {
    
    var selectedIndex = NSInteger()
    var childViewControlllers = NSArray()
    var childViews = NSArray()
    var scrollAnimated = Bool()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.orange
        self.scrollAnimated = true
        self.addSubview(self.menuCtrl)
        self.addSubview(self.containerTableView)
        layoutConstraints()
    }
    
    
    func layoutConstraints() {
        self.menuCtrl.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self);
            make.height.equalTo(44);
        }
        
        self.containerTableView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(22);
            make.height.equalTo(self.snp.width);
            make.width.equalTo(self.snp.height).offset(-44);
        }
        layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.childViewControlllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.contentView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2));
        cell.selectionStyle = .none;
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        var view = UIView()
        if (self.childViewControlllers.count != 0) {
            var vc = UIViewController()
            vc = self.childViewControlllers[indexPath.row] as! UIViewController
            view = vc.view
        }else if self.childViews.count != 0 {
            view = self.childViews[indexPath.row] as! UIView
        }
        cell.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalTo(cell.contentView);
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.width
    }
    
    func menuCtrl(menuCtrl: MenuControl, didSelectIndex index: NSInteger) {
        if index < self.childViewControlllers.count {
            self.containerTableView.scrollToRow(at: NSIndexPath.init(row: selectedIndex, section: 0) as IndexPath, at: .top, animated: self.scrollAnimated)
        }
        if index < self.childViews.count {
            self.containerTableView.scrollToRow(at: NSIndexPath.init(row: selectedIndex, section: 0) as IndexPath, at: .top, animated: self.scrollAnimated)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.menuCtrl.indicatorLine.left = scrollView.contentOffset.y / CGFloat(self.menuCtrl.titles.count) + self.menuCtrl.indicatorInset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.selectedIndex = NSInteger(scrollView.contentOffset.y / scrollView.width)
        self.menuCtrl.selectedIndex = self.selectedIndex
    }
    
    func setSelectedIndex(selectedIndex: NSInteger) {
        self.selectedIndex = selectedIndex
        self.menuCtrl.selectedIndex = selectedIndex
        self.containerTableView.scrollToRow(at: NSIndexPath.init(row: selectedIndex, section: 0) as IndexPath, at: .top, animated: self.scrollAnimated)
    }
    
    func setChildViewControlllers(childViewControlllers: NSArray) {
        self.childViewControlllers = childViewControlllers
        self.containerTableView.reloadData()
    }
    
    func setChildViews(childViews: NSArray) {
        self.childViews = childViews
        self.containerTableView.reloadData()
    }
    
    func setScrollAnimated(scrollAnimated: Bool) {
        self.scrollAnimated = scrollAnimated
        self.containerTableView.isScrollEnabled = scrollAnimated
    }
    
    public lazy var menuCtrl: MenuControl = {
        let menuCtrl = MenuControl()
        menuCtrl.backgroundColor = UIColor.white
        menuCtrl.font = UIFont.systemFont(ofSize: 14)
        menuCtrl.delegate = self
        return menuCtrl
    }()
    
    public lazy var containerTableView: UITableView = {
        let containerTableView = UITableView()
        containerTableView.backgroundColor = UIColor.white
        containerTableView.delegate = self
        containerTableView.dataSource = self
        containerTableView.transform = CGAffineTransform.init(rotationAngle: CGFloat(-Double.pi/2))
        containerTableView.showsVerticalScrollIndicator = false
        containerTableView.showsVerticalScrollIndicator = false
        containerTableView.separatorStyle = .none
        containerTableView.isPagingEnabled = true
        containerTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return containerTableView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

