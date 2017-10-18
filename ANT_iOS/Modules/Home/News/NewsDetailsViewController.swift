//
//  NewsDetailsViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/18.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailsViewController: BaseViewController {
    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text = "喜迎十九大、共筑中国梦"
        rightBtn.isHidden = false
        rightBtn.setTitle("分享", for: .normal)
        contentView.addSubview(webView)
        contentView.addSubview(progressView)
    }
    
    override func layoutConstraints() {
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(NavBarHeight, 0, 0, 0))
        }
        
        progressView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(view)
            make.height.equalTo(2)
        }
    }
    
    override func loadData() {
        let path = Bundle.main.path(forResource: "news", ofType: "html")

        //  运行就蹦，还不知道如何解决
        
//        do {
//            let html = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
//            // 加载js
//            webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
//        } catch { }
    }

    override func leftBtnAction() {
        if webView.canGoBack {
            webView.goBack()
        }else {
            AppCommon.popViewController(animated: true)
        }
    }
    
    override func rightBtnAction() {
        UMSocialSwiftInterface.showShareMenuViewInWindowWithPlatformSelectionBlock { (platformType: UMSocialPlatformType, userInfo: Any) in
            //创建分享消息对象
            let messageObject = UMSocialMessageObject()
            //创建网页内容对象
            let shareTitle = "爱农田"
            let shareDesTitle = "爱农田-让种田更轻松"
            let shareObject = UMShareWebpageObject.shareObject(withTitle: shareTitle, descr: shareDesTitle, thumImage: UIImage.init(named: "ic_settings_logo"))
            //设置网页地址
            shareObject?.webpageUrl = ""
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject
            
            UMSocialSwiftInterface.share(plattype: platformType, messageObject: messageObject, viewController: nil, completion: { (data: Any, error: Error) in
                
                } as! (Any?, Error?) -> Void)
        }
    }
    
    //KVO监听进度条变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            progressView.alpha = 1.0
            let animated = Float(webView.estimatedProgress) > progressView.progress;
            progressView .setProgress(Float(webView.estimatedProgress), animated: animated)
            print(webView.estimatedProgress)
            
            self.progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if Float(webView.estimatedProgress) >= 1.0 {
                //设置动画效果，动画时间长度 1 秒。
                UIView.animate(withDuration: 1, delay:0.01,options:UIViewAnimationOptions.curveEaseOut, animations:{()-> Void in
                    self.progressView.alpha = 0.0
                },completion:{(finished:Bool) -> Void in
                    self.progressView .setProgress(0.0, animated: false)
                })
            }
        }
    }
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = UIColor.white
        webView.isOpaque = true
        //适应你设定的尺寸
        webView.sizeToFit()
        webView.scrollView.showsVerticalScrollIndicator = false
        //设置代理
        webView.navigationDelegate = self
        //kvo 添加进度监控
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        //设置网页的配置文件
        let configuration = WKWebViewConfiguration()
        if #available(iOS 9.0, *) {
            //允许视频播放
            configuration.allowsAirPlayForMediaPlayback = true
            // 允许在线播放
            configuration.allowsInlineMediaPlayback = true
            //开启手势触摸 默认设置就是NO。在ios8系统中会导致手势问题，程序崩溃
            webView.allowsBackForwardNavigationGestures = true
        }
        // 允许可以与网页交互，选择视图
//        configuration.selectionGranularity = true
        configuration.preferences.javaScriptEnabled = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        // web内容处理池
        configuration.processPool = WKProcessPool()
        //自定义配置,一般用于 js调用oc方法(OC拦截URL中的数据做自定义操作)
        let userContentController = WKUserContentController()
        // 是否支持记忆读取
        configuration.suppressesIncrementalRendering = true
        // 允许用户更改网页的设置
        configuration.userContentController = userContentController
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        configuration.userContentController.add(self as WKScriptMessageHandler, name: "vm._getContent")
    
        return webView
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView.init(progressViewStyle: .default)
        progressView.trackTintColor = BaseColor.LineColor
        progressView.progressTintColor = BaseColor.ThemeColor
        return progressView
    }()
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "vm._getContent")
    }
}

extension NewsDetailsViewController: WKNavigationDelegate,WKScriptMessageHandler {
    
    //开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //开始加载的时候，让加载进度条显示
        progressView.isHidden = false
    }
    //网页加载完成
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 获取加载网页的标题
        self.title = webView.title
        // 不执行前段界面弹出列表的JS代码
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
        // 关闭范围提示
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil)
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
    }
    //内容返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    //服务器请求跳转的时候调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    // 内容加载失败时候调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    // 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
//        decisionHandler(WKNavigationResponsePolicy)
    }
    //进度条
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
}
