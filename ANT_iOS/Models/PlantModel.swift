//
//  PlantModel.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/5.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class PlantModel: NSObject {
    //作物名称
    var plant_crop_name: String?
    
    var plant_crop: String?
    //作物品种
    var crop_variety: String?
    
    var year: String?
    
    override func copy() -> Any {
        return self.yy_modelCopy
    }
}

//田块分组列表
class GroupListModel: NSObject {
    //田块分组名称
    var group_name: String?
    // 田块名称
    var field_name: String?
}
