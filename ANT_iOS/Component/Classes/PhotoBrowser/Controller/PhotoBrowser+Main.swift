//
//  PhotoBrowser+Main.swift
//  PhotoBrowser
//
//  Created by 成林 on 15/7/29.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import UIKit

extension PhotoBrowser {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**  准备  */
        collectionViewPrepare()
        
        /**  控制器准备  */
        vcPrepare()
        
        self.edgesForExtendedLayout = UIRectEdge.all
        view.backgroundColor = UIColor.black
    }
    
    /**  控制器准备  */
    func vcPrepare() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoBrowser.singleTapAction), name: NSNotification.Name(rawValue: CFPBSingleTapNofi), object: nil)
    
        if showType != PhotoBrowser.ShowType.ZoomAndDismissWithSingleTap {
            
            dismissBtn = UIButton(frame: CGRect(x: 0, y: 20, width: 40, height: 40))
            dismissBtn.setBackgroundImage(UIImage(named: "pic.bundle/cancel"), for: .normal)
            dismissBtn.addTarget(self, action: #selector(PhotoBrowser.dismissPrepare), for: .touchUpInside)
            self.view.addSubview(dismissBtn)
        
            //保存按钮
            saveBtn = UIButton()
            saveBtn.setBackgroundImage(UIImage(named: "pic.bundle/save"), for: .normal)
            saveBtn.addTarget(self, action: #selector(PhotoBrowser.saveAction), for: .touchUpInside)
            self.view.addSubview(saveBtn)
            saveBtn.snp.makeConstraints({ (make) in
                make.top.equalTo(20)
                make.right.equalToSuperview()
                make.width.equalTo(40)
                make.height.equalTo(40)
            })
        }
    }
    
    /** 保存 */
    func saveAction() {
        
        if photoArchiverArr.contains(page) {
            print("已经保存")
            return
        }
        let itemCell = collectionView.cellForItem(at: IndexPath.init(item: page, section: 0)) as! ItemCell
        
        if itemCell.imageV.image == nil {
//            showHUD(text: "图片未下载", autoDismiss: 2);
            return
        }
        
        if !itemCell.hasHDImage {
//            showHUD(text: "图片未下载", autoDismiss: 2);
            return
        }
        
//        showHUD(text: "保存中", autoDismiss: -1)
        UIImageWriteToSavedPhotosAlbum(itemCell.imageV.image!, self, #selector(PhotoBrowser.image(image:didFinishSavingWithError:contextInfo:)), nil)
        self.view.isUserInteractionEnabled = false
    }

    /** come on */
    func image(image: UIImage, didFinishSavingWithError: NSError, contextInfo:UnsafeRawPointer){
     
        self.view.isUserInteractionEnabled = true
        
        if (didFinishSavingWithError as NSError?) == nil {
//            showHUD("保存失败", autoDismiss: 2)
        }
        else{
//            showHUD("保存成功", autoDismiss: 2)
            //记录
            photoArchiverArr.append(page)
        }
    }
    
    
    /**  单击事件  */
    func singleTapAction(){
        
        if showType != PhotoBrowser.ShowType.ZoomAndDismissWithSingleTap {
        
            isHiddenBar = !isHiddenBar
            dismissBtn.isHidden = isHiddenBar
            saveBtn.isHidden = isHiddenBar
            
            //取出cell
            let cell = collectionView.cellForItem(at: IndexPath.init(item: page, section: 0)) as! ItemCell
            cell.toggleDisplayBottomBar(isHidden: isHiddenBar)
            
        }else {
            dismissPrepare()
        }
    }

    func dismissAction(isZoomType: Bool) {
        
//        UIApplication.shared.isStatusBarHidden = isStatusBarHidden
//
//        if vc.navigationController != nil {
//            vc.navigationController?.isNavigationBarHidden = isNavBarHidden
//        }
//
//        if vc.tabBarController != nil {
//            vc.tabBarController?.tabBar.isHidden = isTabBarHidden
//        }
        
        if showType == ShowType.Push || showType == ShowType.Modal {return}
        
        /** 关闭动画 */
        zoomOutWithAnim(page: page)
        
        UserDefaults.standard.set(false, forKey: CFPBShowKey)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PhotoBrowserDidDismissNoti), object: self)
    }
    
    func dismissPrepare() {
        
        if showType == .Push {
//            self.navigationController?.popViewController(animated: true)
            AppCommon.popViewController(animated: true)
            dismissAction(isZoomType: false)
            
        }else if showType == .Modal {
            self.dismiss(animated: true, completion: nil)
            dismissAction(isZoomType: false)
            
        } else if showType == ShowType.ZoomAndDismissWithSingleTap {
            dismissAction(isZoomType: true)
            
        }else {
            dismissAction(isZoomType: true)
        }
    }
    
    func show(inVC vc: UIViewController,index: Int) {
        assert(showType != nil, "Error: You Must Set showType!")
        assert(photoType != nil, "Error: You Must Set photoType!")
        assert(photoModels != nil, "Error: You Must Set DataModels!")
        assert(index <= photoModels.count - 1, "Error: Index is Out of DataModels' Boundary!")
        
        UserDefaults.standard.set(true, forKey: CFPBShowKey)
//        isStatusBarHidden = UIApplication.shared.isStatusBarHidden
//        UIApplication.shared.isStatusBarHidden = true
        
        //记录index
        showIndex = index
        
        //记录
        self.vc = vc as! BaseViewController
        
        let navVC = vc.navigationController
        
        if vc.navigationController != nil {
            isNavBarHidden = vc.navigationController?.isNavigationBarHidden
        }
        
        if vc.tabBarController != nil {
            isTabBarHidden = vc.tabBarController?.tabBar.isHidden
        }
        
        navVC?.isNavigationBarHidden = true
//        vc.tabBarController?.tabBar.isHidden = true
        
        if showType == .Push {//push
            vc.hidesBottomBarWhenPushed = true
            vc.navigationController?.pushViewController(self, animated: true)
            
        }else if showType == .Modal {
            AppCommon.present(self, animated: true)
//            vc.present(self, animated: true, completion: nil)
            
        }else {
            
            //添加子控制器
            vc.view.addSubview(self.view)
            
            //添加约束
            self.view.snp.makeConstraints({ (make) in
                make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, 0, 0));
            })
            
            vc.addChildViewController(self)
            /** 展示动画 */
            zoomInWithAnim(page: index)
            
            if showType == PhotoBrowser.ShowType.ZoomAndDismissWithSingleTap && hideMsgForZoomAndDismissWithSingleTap {
                /** pagecontrol准备 */
                pagecontrolPrepare()
                pagecontrol.currentPage = index
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PhotoBrowserDidShowNoti), object: self)
    }
}
