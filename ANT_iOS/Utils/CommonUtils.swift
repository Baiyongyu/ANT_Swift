//
//  CommonUtils.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/8.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit
import WebKit

class CommonUtils: NSObject {

    // 加载弹框视图的动画
    public func setCAKeyframeAnimation(view: UIView) {
        
        var animation = CAKeyframeAnimation()
        animation = CAKeyframeAnimation.init(keyPath: "transform")
        animation.duration = 0.3
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        let values = NSMutableArray()
        values.add(NSValue.init(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)))
        values.add(NSValue.init(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)))
        values.add(NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values as? [Any]
        view.layer.add(animation, forKey: nil)
    }
    
//    public func loadLocalPath(path: String, webView: WKWebView) {
//        
//        
//        
//
//    }
    
    
    
    /*
    //将文件copy到tmp目录
    func fileURLForBuggyWKWebView8(fileURL: NSURL) throws -> NSURL {
        // Some safety checks
        var error:NSError? = nil;
        if (!fileURL.isFileURL || !fileURL.checkResourceIsReachableAndReturnError(&error)) {
            throw error ?? NSError(
                domain: "BuggyWKWebViewDomain",
                code: 1001,
                userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("URL must be a file URL.", comment:"")])
        }
        
        // Create "/temp/www" directory
        let fm = FileManager.default
        
        let tmpDirURL = NSURL.fileURLWithPath(NSTemporaryDirectory()).URLByAppendingPathComponent("www")
        try! fm.createDirectory(at: tmpDirURL, withIntermediateDirectories: true, attributes: nil)
        
        // Now copy given file to the temp directory
        let dstURL = tmpDirURL.URLByAppendingPathComponent(fileURL.lastPathComponent!)
        let _ = try? fileURL.removeItemAtURL(dstURL)
        try! fm.copyItemAtURL(fileURL, toURL: dstURL)
        
        // Files in "/temp/www" load flawlesly :)
        return dstURL
    }
    */
    
}
