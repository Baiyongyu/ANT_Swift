//
//  AppTabBarController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/2.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class AppTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let home = HomeViewController()
        home.tabBarItem.title = "首页"
        home.tabBarItem.image = UIImage.init(named: "ic_tabbar_home_normal")
        home.tabBarItem.selectedImage = UIImage.init(named: "ic_tabbar_home_selected")?.withRenderingMode(.alwaysOriginal)
        
        let farm = FarmViewController()
        farm.tabBarItem.title = "农田"
        farm.tabBarItem.image = UIImage.init(named: "ic_tabbar_farm_normal")
        farm.tabBarItem.selectedImage = UIImage.init(named: "ic_tabbar_farm_selected")?.withRenderingMode(.alwaysOriginal)
        
        let circle = CircleViewController()
        circle.tabBarItem.title = "圈子"
        circle.tabBarItem.image = UIImage.init(named: "ic_tabbar_circle_normal")
        circle.tabBarItem.selectedImage = UIImage.init(named: "ic_tabbar_circle_selected")?.withRenderingMode(.alwaysOriginal)
        
        let mine = MineViewController()
        mine.tabBarItem.title = "我的"
        mine.tabBarItem.image = UIImage.init(named: "ic_tabbar_mine_normal")
        mine.tabBarItem.selectedImage = UIImage.init(named: "ic_tabbar_mine_selected")?.withRenderingMode(.alwaysOriginal)
        
        self.tabBar.tintColor = UIColor.orange
        self.viewControllers = [home, farm, circle, mine];
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        var index = NSInteger()
//        index = (self.tabBar.items?.index(of: item))!
//        animationWithIndex(index: index)
    }
    
    
    func animationWithIndex(index: NSInteger) -> () {
    
    }
    
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
