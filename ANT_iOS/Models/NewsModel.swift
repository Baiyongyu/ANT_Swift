//
//  NewsModel.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/30.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class NewsModel: NSObject {
    
    var news_id: String?
    var title: String?
    var content: String?
    var news_source: String?
    var create_date: String?
    var title_image: String?
    var imagePathsArray = NSArray()
    var height: CGFont?
    var newsTableViewCellType: NewsTableViewCellType?
}
