//
//  DisplayView.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/20.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class DisplayView: UIView {
    var tapedImageV: ((_ index: Int)->())?
}

extension DisplayView {
    
    /** 准备 */
    func imgsPrepare(imgs: [String], isLocal: Bool) {
       
        for i in 0 ..< imgs.count {
            let imgV = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            imgV.backgroundColor = UIColor.lightGray
            imgV.isUserInteractionEnabled = true
            imgV.contentMode = .scaleAspectFill
            imgV.clipsToBounds = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(tap:)))
            imgV.addGestureRecognizer(tapGesture)
            imgV.tag = i
            if isLocal {
                imgV.image = UIImage(named: imgs[i])
            }else{
                imgV.kf.setImage(with: URL.init(string: imgs[i]))
            }
            self.addSubview(imgV)
        }
    }
    
    func tapAction(tap: UITapGestureRecognizer) {
        tapedImageV?(tap.view!.tag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let totalRow = 3
        let totalWidth = self.bounds.size.width
        let margin: CGFloat = 5
        let itemWH = (totalWidth - margin * CGFloat(totalRow + 1)) / CGFloat(totalRow)
        
        /** 数组遍历 */
        var i = 0
        for view in self.subviews {
            let row = i / totalRow
            let col = i % totalRow
            let x = (CGFloat(col) + 1) * margin + CGFloat(col) * itemWH
            let y = (CGFloat(row) + 1) * margin + CGFloat(row) * itemWH
            let frame = CGRect(x: x, y: y, width: itemWH, height: itemWH)
            view.frame = frame
            i += 1
        }
    }
}
