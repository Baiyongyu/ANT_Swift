//
//  YYNetWork.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/12/2.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit
import Alamofire
import Cache

// MARK: - 网络请求

class YYNetWork: NSObject {
    override init() {
        
    }
    
    func request(
        _ url: String,
        method: HTTPMethod = .get,
        params: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> RequestTaskManager
    {
        return YYRequestManager.default.request(url, method: method, params: params, encoding: encoding, headers: headers)
    }
    
    /// 取消请求
    func cancel(_ url: String, params: Parameters? = nil) {
        YYRequestManager.default.cancel(url, params: params)
    }
    
    /// 清除所有缓存
    func removeAllCache(completion: @escaping (Bool)->()) {
        YYRequestManager.default.removeAllCache(completion: completion)
    }
    
    /// 根据url和params清除缓存
    func removeObjectCache(_ url: String, params: [String: Any]? = nil, completion: @escaping (Bool)->()) {
        YYRequestManager.default.removeObjectCache(url, params: params, completion: completion)
    }
    
    // MARK: - 下载
    
    /// 下载
    func download(
        _ url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DownloadTaskManager
    {
        return YYDownloadManager.default.download(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
    
    /// 取消下载
    ///
    /// - Parameter url: url
    func downloadCancel(_ url: String) {
        YYDownloadManager.default.cancel(url)
    }
    
    /// 下载百分比
    ///
    /// - Parameter url: url
    /// - Returns: percent
    func downloadPercent(_ url: String) -> Double {
        return YYDownloadManager.default.downloadPercent(url)
    }
    
    /// 删除某个下载
    ///
    /// - Parameters:
    ///   - url: url
    ///   - completion: download success/failure
    func downloadDelete(_ url: String) {
        YYDownloadManager.default.delete(url)
    }
    
    /// 下载状态
    ///
    /// - Parameter url: url
    /// - Returns: status
    func downloadStatus(_ url: String) -> DownloadStatus {
        return YYDownloadManager.default.downloadStatus(url)
    }
    
    /// 下载完成后，文件所在位置
    ///
    /// - Parameter url: url
    /// - Returns: file URL
    func downloadFilePath(_ url: String) -> URL? {
        return YYDownloadManager.default.downloadFilePath(url)
    }
    
    /// 下载中的进度,任务下载中时，退出当前页面,再次进入时继续下载
    ///
    /// - Parameters:
    ///   - url: url
    ///   - progress: 进度
    /// - Returns: taskManager
    @discardableResult
    func downloadProgress(_ url: String, progress: @escaping ((Double)->())) -> DownloadTaskManager? {
        return YYDownloadManager.default.downloadProgress(url, progress: progress)
    }
}


