//
//  FieldGroupModel.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/13.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class FieldGroupModel: NSObject {
    //分组id
    var group_id: String?
    //分组名称
    var group_name: String?
    //田块分组颜色
    var groupColor: String?
    //亩数
    var total_area_size: NSNumber?
    //田块列表
    var field_list: Array<Any>?
    //选中的田块
    var selectedFields: NSMutableArray?
    //打开/关闭
    var isOpen: Bool?
    //是否选中
    var isChecked: Bool?
    
    override func copy() -> Any {
        return self.yy_modelCopy
    }
    
    func modelCustomPropertyMapper() -> NSDictionary {
        return ["field_list":FieldModel()]
    }
}

class FieldModel: NSObject {
    //田块id
    var field_id: String?
    //田块名称
    var field_name: String?
    //田块面积
    var area_size: NSNumber?
    //田块图片
    var thumbnail_url: String?
    //田块作物列表
    var crop_list = NSArray()
    //种植计划列表
    var plan_list: Array<Any>?
    //田块责任人
    var userName: String?
    //田块位置
    var fieldPosition: Array<Any>?
    //经纬度集合
    var geometry: String?
    //田块图片
    var image: UIImage?
    //田块分组id
    var group_id: String?
    //田块分组颜色
    var groupColor: String?
    //分组名称
    var group_name: String?
    //是否选中
    var selected: Bool?
    
    override func copy() -> Any {
        return self.yy_modelCopy
    }
    
    func modelCustomPropertyMapper() -> NSDictionary {
        return ["crop_list":PlantModel(),
                "plan_list":PlantModel()]
    }
    
}
