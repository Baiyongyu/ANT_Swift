//
//  YYLog.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/12/2.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import Foundation

// MARK: - log日志
func YYLog<T>( _ message: T, file: String = #file, method: String = #function, line: Int = #line){
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
