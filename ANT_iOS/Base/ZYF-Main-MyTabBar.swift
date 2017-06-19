//
//  ZYF-Main-MyTabBar.swift
//  JSByZYF
//
//  Created by zhyunfe on 16/9/23.
//  Copyright © 2016年 zhyunfe. All rights reserved.
//

import UIKit
//封装了一个带有中间凸起的自定制Tabbar，包含4个普通按钮和中间的一个凸起按钮
//首先封装了一个UIButton，重新设置了UIButton的图片位置和label位置，使用便利构造器创建了一个带有imageview的构造方法，用来构造中间特殊的按钮
//继承与UIView创建了一个自定制tabbar类，大小为屏幕宽度和49 高，动态创建5个自定制的UIButton，对中间的按钮做了特殊处理，其中的位置大小可以根据需求设置。设置了一个全局的button存储高亮状态下的按钮，使用闭包进行了控制器于自定制tabbar之间的传值，实现了不同按钮切换不同界面的功能

//使用方法：
/*
 1、实例化一个自定制TabBar  let myTabbar = ZYF_Main_MyTabBar()
 2、设置自定制TabBar的frame   myTabbar.frame = CGRectMake(0, height - 49, width, 49)
 3、调用方法，传入参数：标题数组、.Normal状态下的图片数组、.selected状态下的图片数组，每个按钮之间的间距

    tabbar.creatTabBar(title, imageNames: imageName, selectedImageNames: selectedImage, space: 83)
 */
class ZYF_Main_MyTabBar: UIView {
    var button = UIButton()
    let height = UIScreen.mainScreen().bounds.size.height
    let width = UIScreen.mainScreen().bounds.size.width

    //闭包传值，创建一个闭包
    var clickBlock:((selcted:Int) ->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRectMake(0, 0, width, 49)
        self.backgroundColor = UIColor.blackColor()
        self.userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func creatTabBar(titNames:[String],imageNames:[String],selectedImageNames:[String],space:Int) {
        for i in 0...titNames.count - 1 {
            var btn = ZYF_MyTabBarButton(type: .Custom)
            btn.frame = CGRectMake(20 + CGFloat(i) * 83, 0, 49, 49)
            let image = UIImage(named: imageNames[i])
            let selectedImage = UIImage(named: selectedImageNames[i])
            if i == 2{
                let pointY:CGFloat = -40
                let pointX:CGFloat = 49 + abs(pointY)
                btn = ZYF_MyTabBarButton.init(frame: frame, image: "ZYF-Login-Dou")
                btn.frame = CGRectMake(183, pointY, width / 5, pointX)
            } else {
                btn.setImage(selectedImage, forState: .Selected)
                btn.setImage(image, forState: .Normal)
            }
            btn.setTitle(titNames[i], forState: .Normal)
            self.addSubview(btn)
            btn.tag = 10 + i
            btn.addTarget(self, action: #selector(self.btnClick(_:)), forControlEvents: .TouchUpInside)
            if i == 0 {
                btn.selected = true
                self.button = btn
            }
        }
    }
    func btnClick(sender:UIButton) {
        //实现视图切换
        print("视图切换")
        let index = sender.tag - 10
        if index < 2 {
            //设置闭包中的值
            if clickBlock != nil {
                clickBlock!(selcted:index)
                print("index<2")
            }
        } else if index > 2 {
            if clickBlock != nil {
                clickBlock!(selcted:index - 1)
            }
        } else {
            clickBlock!(selcted:999)
            return
        }
        self.button.selected = false
        sender.selected = true
        self.button = sender
    }
}
