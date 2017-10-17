//
//  UIViewControllerExtension.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/17.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit
extension UIViewController {
    /// parentViewController
    public weak var zj_scrollPageController: UIViewController? {
        get {
            var superVc = self.parentViewController
            while superVc != nil {
                if superVc! is ContentViewDelegate  {
                    break
                }
                superVc = superVc!.parentViewController
            }
            return superVc
        }
    }
}
