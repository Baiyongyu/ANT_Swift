//
//  WebThingsViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/7.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class WebThingsViewController: BaseViewController {

    override func loadSubViews() {
        super.loadSubViews()
        self.titleLabel.text = "物联网"
        self.contentView.addSubview(webView)
    }
    
    override func layoutConstraints() {
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 0, 0));
        }
    }
    
    override func loadData() {
        let path = Bundle.main.path(forResource: "webthing/webthing", ofType: "html")
        let request = NSURLRequest.init(url: NSURL.fileURL(withPath: path!))
        self.webView.loadRequest(request as URLRequest)
    }
    
    func longPressed(recognizer: UITapGestureRecognizer) {
        
        if recognizer.state == .began {
            print("长按响应开始")
            
            let touchPoint: CGPoint = recognizer.location(in: self.webView)
            let js = "document.elementFromPoint(\(touchPoint.x), \(touchPoint.y)).src"
            let urlToSave: String = self.webView.stringByEvaluatingJavaScript(from: js)!
            print(urlToSave)
            
            let alertController = UIAlertController(title: "温馨提示", message: "是否要保存图片?", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "确定", style: .destructive, handler: { (alertController:UIAlertAction) in
                
//                let data = NSData.init(contentsOf: NSURL.init(string: urlToSave)! as URL)
//                let image = UIImage.init(data: data! as Data)
//                UIImageWriteToSavedPhotosAlbum(image!, self, #selector(WebThingsViewController.iamge(image:didFinishSavingWithError:contextInfo:)), nil)
                
            })
            
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(confirm)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
        }else {
            print("长按响应结束")
        }
    }
    
    func iamge(image: UIImage, didFinishSavingWithError error:NSError?, contextInfo: AnyObject) {
        if error != nil {
            
        }
    }

    lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = UIColor.white
        webView.delegate = self
        webView.scalesPageToFit = false
        webView.isOpaque = false
        webView.scrollView.showsVerticalScrollIndicator = false
        
        let longPressed = UILongPressGestureRecognizer.init(target: self, action: #selector(WebThingsViewController.longPressed(recognizer:)))
        longPressed.minimumPressDuration = 0.3
        longPressed.numberOfTouchesRequired = 1
        longPressed.delegate = self
        webView.addGestureRecognizer(longPressed)
        return webView
    }()
}


extension WebThingsViewController: UIWebViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitUserSelect='none';")
        self.webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitTouchCallout='none';")
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
}






