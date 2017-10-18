//
//  UIImage+Additions.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/16.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

extension UIImage {

}

func creatImageWithColor(color: UIColor) -> UIImage {
    let rect = CGRect.init(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor)
    context!.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}
