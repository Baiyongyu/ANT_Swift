//
//  Layout.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/20.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

extension PhotoBrowser {
    
    class Layout: UICollectionViewFlowLayout {
    
        override init() {
            super.init()
            /**  配置  */
            layoutSetting()
        }

        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
        }
        
        /**  配置  */
        func layoutSetting() {

            let size = UIScreen.main.bounds.size
            self.itemSize = size.sizeWithExtraWidth
            self.minimumInteritemSpacing = 0
            self.minimumLineSpacing = 0
            self.sectionInset = UIEdgeInsets.zero
            self.scrollDirection = UICollectionViewScrollDirection.horizontal
        }
    }
}
