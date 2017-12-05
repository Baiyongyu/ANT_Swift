//
//  YYNetValue.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/12/2.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import Foundation
import Alamofire

//// MARK: - Result
public struct YYNetValue<Value> {
    public let isCacheData: Bool
    public let result: Alamofire.Result<Value>
    init(isCacheData: Bool, result: Alamofire.Result<Value>) {
        self.isCacheData = isCacheData
        self.result = result
    }
}

