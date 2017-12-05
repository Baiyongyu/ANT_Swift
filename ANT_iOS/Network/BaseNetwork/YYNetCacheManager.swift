//
//  CacheManager.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/12/2.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import Foundation
import Cache

class YYNetCacheManager {
    static let `default` = YYNetCacheManager()
    /// Manage storage
    private var storage: Storage?
    /// init
    init() {
        let diskConfig = DiskConfig(name: "DaisyCache")
        let memoryConfig = MemoryConfig(expiry: .never)
        do {
            storage = try Storage(diskConfig: diskConfig, memoryConfig: memoryConfig)
        } catch {
            YYLog(error)
        }
    }
    /// 清除所有缓存
    ///
    /// - Parameter completion: 完成闭包
    func removeAllCache(completion: @escaping (Bool)->()) {
        storage?.async.removeAll(completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .value: completion(true)
                case .error: completion(false)
                }
            }
        })
    }
    /// 根据key值清除缓存
    func removeObjectCache(_ cacheKey: String, completion: @escaping (Bool)->()) {
        storage?.async.removeObject(forKey: cacheKey, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .value: completion(true)
                case .error: completion(false)
                }
            }
        })
    }
    /// 读取缓存
    func object<T: Codable>(ofType type: T.Type, forKey key: String, completion: @escaping (Cache.Result<T>)->Void) {
        storage?.async.object(ofType: type, forKey: key, completion: completion)
    }
    
    /// 异步存储
    func setObject<T: Codable>(_ object: T, forKey: String) {
        storage?.async.setObject(object, forKey: forKey, completion: { result in
            switch result {
            case .value: YYLog("saved successfully")
            case .error(let error): YYLog(error)
            }
        })
    }
}
