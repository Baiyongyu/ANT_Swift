//
//  YYRequestManager.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/12/2.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - RequestManager

class YYRequestManager {
    static let `default` = YYRequestManager()
    private var requestTasks = [String: RequestTaskManager]()
    
    func request(
        _ url: String,
        method: HTTPMethod = .get,
        params: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> RequestTaskManager
    {
        let key = cacheKey(url: url, params: params)
        var taskManager : RequestTaskManager?
        if requestTasks[key] == nil {
            taskManager = RequestTaskManager()
            requestTasks[key] = taskManager
        } else {
            taskManager = requestTasks[key]
        }
        taskManager?.completionClosure = {
            self.requestTasks.removeValue(forKey: key)
        }
        taskManager?.request(url, method: method, params: params, cacheKey: key, encoding: encoding, headers: headers)
        return taskManager!
    }
    
    /// 取消请求
    func cancel(_ url: String, params: Parameters? = nil) {
        let key = cacheKey(url: url, params: params)
        let taskManager = requestTasks[key]
        taskManager?.dataRequest?.cancel()
    }
    
    /// 清除所有缓存
    func removeAllCache(completion: @escaping (Bool)->()) {
        YYNetCacheManager.default.removeAllCache(completion: completion)
    }
    
    /// 根据key值清除缓存
    func removeObjectCache(_ url: String, params: [String: Any]? = nil,  completion: @escaping (Bool)->()) {
        let cacheKey = self.cacheKey(url: url, params: params)
        YYNetCacheManager.default.removeObjectCache(cacheKey, completion: completion)
    }
    
    /// 将参数字典转换成字符串
    private func cacheKey(url: String, params: Dictionary<String, Any>?) -> String {
        guard let params = params,
            let stringData = try? JSONSerialization.data(withJSONObject: params, options: []),
            let paramString = String(data: stringData, encoding: String.Encoding.utf8) else {
                return url
        }
        let str = "\(url)" + "\(paramString)"
        return str
    }
}

// MARK: - 请求任务
public class RequestTaskManager {
    fileprivate var dataRequest: DataRequest?
    fileprivate var cache: Bool = false
    fileprivate var cacheKey: String!
    fileprivate var completionClosure: (()->())?
    
    @discardableResult
    fileprivate func request(
        _ url: String,
        method: HTTPMethod = .get,
        params: Parameters? = nil,
        cacheKey: String,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> RequestTaskManager
    {
        self.cacheKey = cacheKey
        dataRequest = Alamofire.request(url, method: method, parameters: params, encoding: encoding, headers: headers)
        return self
    }
    /// 是否缓存数据
    func cache(_ cache: Bool) -> RequestTaskManager {
        self.cache = cache
        return self
    }
    
    /// 获取缓存Data
    @discardableResult
    func cacheData(completion: @escaping (Data)->()) -> DaisyDataResponse {
        let dataResponse = DaisyDataResponse(dataRequest: dataRequest!, cache: cache, cacheKey: cacheKey, completionClosure: completionClosure)
        return dataResponse.cacheData(completion: completion)
    }
    /// 响应Data
    func responseData(completion: @escaping (Alamofire.Result<Data>)->()) {
        let dataResponse = DaisyDataResponse(dataRequest: dataRequest!, cache: cache, cacheKey: cacheKey, completionClosure: completionClosure)
        dataResponse.responseData(completion: completion)
    }
    /// 先获取Data缓存，再响应Data
    func responseCacheAndData(completion: @escaping (YYNetValue<Data>)->()) {
        let dataResponse = DaisyDataResponse(dataRequest: dataRequest!, cache: cache, cacheKey: cacheKey, completionClosure: completionClosure)
        dataResponse.responseCacheAndData(completion: completion)
    }
    /// 获取缓存String
    @discardableResult
    func cacheString(completion: @escaping (String)->()) -> DaisyStringResponse {
        let stringResponse = DaisyStringResponse(dataRequest: dataRequest!, cache: cache, cacheKey: cacheKey, completionClosure: completionClosure)
        return stringResponse.cacheString(completion:completion)
    }
    /// 响应String
    func responseString(completion: @escaping (Alamofire.Result<String>)->()) {
        let stringResponse = DaisyStringResponse(dataRequest: dataRequest!, cache: cache, cacheKey: cacheKey, completionClosure: completionClosure)
        stringResponse.responseString(completion: completion)
    }
    /// 先获取缓存String,再响应String
    func responseCacheAndString(completion: @escaping (YYNetValue<String>)->()) {
        let stringResponse = DaisyStringResponse(dataRequest: dataRequest!, cache: cache, cacheKey: cacheKey, completionClosure: completionClosure)
        stringResponse.responseCacheAndString(completion: completion)
    }
    /// 获取缓存JSON
    @discardableResult
    func cacheJson(completion: @escaping (Any)->()) -> DaisyJsonResponse {
        let jsonResponse = DaisyJsonResponse(dataRequest: dataRequest!, cache: cache, cacheKey: cacheKey, completionClosure: completionClosure)
        return jsonResponse.cacheJson(completion:completion)
    }
    /// 响应JSON
    func responseJson(completion: @escaping (Alamofire.Result<Any>)->()) {
        let jsonResponse = DaisyJsonResponse(dataRequest: dataRequest!, cache: cache, cacheKey: cacheKey, completionClosure: completionClosure)
        jsonResponse.responseJson(completion: completion)
    }
    /// 先获取缓存JSON，再响应JSON
    func responseCacheAndJson(completion: @escaping (YYNetValue<Any>)->()) {
        let jsonResponse = DaisyJsonResponse(dataRequest: dataRequest!, cache: cache, cacheKey: cacheKey, completionClosure: completionClosure)
        jsonResponse.responseCacheAndJson(completion: completion)
    }
}
// MARK: - DaisyBaseResponse
class DaisyResponse {
    fileprivate var dataRequest: DataRequest
    fileprivate var cache: Bool
    fileprivate var cacheKey: String
    fileprivate var completionClosure: (()->())?
    fileprivate init(dataRequest: DataRequest, cache: Bool, cacheKey: String, completionClosure: (()->())?) {
        self.dataRequest = dataRequest
        self.cache = cache
        self.cacheKey = cacheKey
        self.completionClosure = completionClosure
    }
    ///
    fileprivate func response<T>(response: DataResponse<T>, completion: @escaping (Alamofire.Result<T>)->()) {
        responseCache(response: response) { (result) in
            completion(result.result)
        }
    }
    /// isCacheData
    fileprivate func responseCache<T>(response: DataResponse<T>, completion: @escaping (YYNetValue<T>)->()) {
        if completionClosure != nil { completionClosure!() }
        let result = YYNetValue(isCacheData: false, result: response.result)
//        YYLog("========================================")
        switch response.result {
        case .success(let value): YYLog(value)
        if self.cache {/// 写入缓存
            YYNetCacheManager.default.setObject(response.data, forKey: self.cacheKey)
            }
        case .failure(let error): YYLog(error.localizedDescription)
        }
        completion(result)
    }
}
// MARK: - DaisyJsonResponse
class DaisyJsonResponse: DaisyResponse {
    /// 响应JSON
    func responseJson(completion: @escaping (Alamofire.Result<Any>)->()) {
        dataRequest.responseJSON(completionHandler: { response in
            self.response(response: response, completion: completion)
        })
    }
    fileprivate func responseCacheAndJson(completion: @escaping (YYNetValue<Any>)->()) {
        if cache { cacheJson(completion: { (json) in
            let res = YYNetValue(isCacheData: true, result: Alamofire.Result.success(json))
            completion(res)
        }) }
        dataRequest.responseJSON { (response) in
            self.responseCache(response: response, completion: completion)
        }
    }
    @discardableResult
    fileprivate func cacheJson(completion: @escaping (Any)->()) -> DaisyJsonResponse {
        YYNetCacheManager.default.object(ofType: Data.self, forKey: cacheKey) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .value(let data):
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        DispatchQueue.main.async {/// 主线程
//                            YYLog("========================================")
                            YYLog(json)
                            completion(json)
                        }
                    }
                case .error(_):
                    YYLog("读取缓存失败")
                }
            }
        }
        return self
    }
}
// MARK: - DaisyStringResponse
class DaisyStringResponse: DaisyResponse {
    /// 响应String
    func responseString(completion: @escaping (Alamofire.Result<String>)->()) {
        dataRequest.responseString(completionHandler: { response in
            self.response(response: response, completion: completion)
        })
    }
    @discardableResult
    fileprivate func cacheString(completion: @escaping (String)->()) -> DaisyStringResponse {
        YYNetCacheManager.default.object(ofType: Data.self, forKey: cacheKey) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .value(let data):
                    if let str = String(data: data, encoding: .utf8) {
                        completion(str)
                    }
                case .error(_):
                   YYLog("读取缓存失败")
                }
            }
        }
        return self
    }
    fileprivate func responseCacheAndString(completion: @escaping (YYNetValue<String>)->()) {
        if cache { cacheString(completion: { str in
            let res = YYNetValue(isCacheData: true, result: Alamofire.Result.success(str))
            completion(res)
        })}
        dataRequest.responseString { (response) in
            self.responseCache(response: response, completion: completion)
        }
    }
}
// MARK: - DaisyDataResponse
class DaisyDataResponse: DaisyResponse {
    /// 响应Data
    func responseData(completion: @escaping (Alamofire.Result<Data>)->()) {
        dataRequest.responseData(completionHandler: { response in
            self.response(response: response, completion: completion)
        })
    }
    @discardableResult
    fileprivate func cacheData(completion: @escaping (Data)->()) -> DaisyDataResponse {
        YYNetCacheManager.default.object(ofType: Data.self, forKey: cacheKey) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .value(let data):
                    completion(data)
                case .error(_):
                    YYLog("读取缓存失败")
                }
            }
        }
        return self
    }
    fileprivate func responseCacheAndData(completion: @escaping (YYNetValue<Data>)->()) {
        if cache { cacheData(completion: { (data) in
            let res = YYNetValue(isCacheData: true, result: Alamofire.Result.success(data))
            completion(res)
        }) }
        dataRequest.responseData { (response) in
            self.responseCache(response: response, completion: completion)
        }
    }
}
