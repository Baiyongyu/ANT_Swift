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
    var plant_crop_nam: String?
    
    var plant_crop: String?
    //作物品种
    var crop_variety: String?
    
    var year: String?
    
    override func copy() -> Any {
        return self.yy_modelCopy
    }
}
