//
//  AppTabBar.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/16.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

protocol AppTabBarDelegate {
    func tabBarPlusBtnClick(tabBar: AppTabBar)
}

class AppTabBar: UITabBar {

    var myDelegate: AppTabBarDelegate?
    var plusImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(ovalBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //系统自带的按钮类型是UITabBarButton，找出这些类型的按钮，然后重新排布位置，空出中间的位置
        let width = ovalBtn.currentBackgroundImage?.size.width
        let height = ovalBtn.currentBackgroundImage?.size.height
        self.ovalBtn.frame = CGRect(x: (self.width-width!)/2.0, y: (self.height-height!)/2.0 - 3*CGFloat(TabBarMagin)-2 - (IS_IPHONE_iPX ? 17 : 0), width: width!, height: height!)
        
        let plusImageView = UIImageView()
        self.plusImageView = plusImageView
        plusImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AppTabBar.plusBtnDidClick))
        plusImageView.addGestureRecognizer(tapGesture)
        self.ovalBtn.addSubview(plusImageView)
        plusImageView.image = UIImage.icon(with: TBCityIconInfo.init(text: "\u{e651}", size: 50, color: BaseColor.ThemeColor))
        plusImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.ovalBtn)
            make.top.equalTo(5)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        let label = UILabel()
        label.text = "发布"
        label.font = UIFont.init(name: "STHeitiSC-Light", size: 10)
        label.sizeToFit()
        label.textColor = UIColor.gray
        self.addSubview(label)
        label.centerX = self.ovalBtn.centerX
        label.centerY = plusImageView.bottom + 3 * CGFloat(TabBarMagin) + 6
        
        var btnIndex: NSInteger = 0
        for btn in self.subviews { //遍历tabbar的子控件
            if btn.isKind(of: NSClassFromString("UITabBarButton")!) { //如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
                //每一个按钮的宽度==tabbar的五分之一
                btn.width = self.width/5
                btn.left = btn.width * CGFloat(btnIndex)
                btnIndex += 1
                
                //如果是索引是2(从0开始的)，直接让索引++，目的就是让消息按钮的位置向右移动，空出来发布按钮的位置
                if btnIndex == 2 {
                    btnIndex += 1
                }
            }
        }
        self.bringSubview(toFront: self.ovalBtn)
    }
    
    func plusBtnDidClick() {
        //如果tabbar的代理实现了对应的代理方法，那么就调用代理的该方法
        self.myDelegate?.tabBarPlusBtnClick(tabBar: self)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        //这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
        //self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
        //在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
        //是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
        if self.isHidden == false {
            //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
            var newP = CGPoint()
            newP = self.convert(point, to: self.plusImageView)
            
            //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
            if self.ovalBtn.point(inside: newP, with: event) || self.plusImageView.point(inside: newP, with: event) {
                return self.ovalBtn
            }else { //如果点不在发布按钮身上，直接让系统处理就可以了
                return super.hitTest(point, with: event)
            }
        }else {//tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
            return super.hitTest(point, with: event)
        }
    }
    
    lazy var ovalBtn: UIButton = {
        let ovalBtn = UIButton(type: UIButtonType.custom)
        ovalBtn.setBackgroundImage(UIImage.init(named: "ic_tabbar_oval"), for: .normal)
        ovalBtn.setBackgroundImage(UIImage.init(named: "ic_tabbar_oval"), for: .highlighted)
        ovalBtn.sizeToFit()
        ovalBtn.addTarget(self , action: #selector(plusBtnDidClick), for: .touchUpInside)
        return ovalBtn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
