//
//  UIImage+Additions.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/16.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

extension UIImage {
    
    func createImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
