//
//  PhotoBrowser+CollectionView.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/20.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

extension PhotoBrowser: UICollectionViewDataSource,UICollectionViewDelegate {
    
    var cellID: String {
        return "ItemCell"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleRotation(anim: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleRotation(anim: false)
        collectionView.isHidden = false
        let isZoomType = self.showType == PhotoBrowser.ShowType.ZoomAndDismissWithCancelBtnClick || self.showType == PhotoBrowser.ShowType.ZoomAndDismissWithSingleTap
        
        if self.photoType == PhotoType.Local {
            collectionView.scrollToItem(at: IndexPath.init(item: showIndex, section: 0), at: .left, animated: !isZoomType)
            
        }else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(60)) {
                DispatchQueue.main.async {
                    self.collectionView.scrollToItem(at: IndexPath.init(item: self.showIndex, section: 0), at: .left, animated: !isZoomType)
                }
            }
        }
    }

    /**  准备  */
    func collectionViewPrepare() {
        
        //添加
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, 0, -CFPBExtraWidth))
        }

        //注册cell
        collectionView.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        
        let isZoomType = self.showType == PhotoBrowser.ShowType.ZoomAndDismissWithCancelBtnClick || self.showType == PhotoBrowser.ShowType.ZoomAndDismissWithSingleTap
        
        if isZoomType {
            collectionView.isHidden = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(PhotoBrowser.handleRotation(anim:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath as IndexPath) as! ItemCell
        itemCell.photoType = photoType
        itemCell.isHiddenBar = isHiddenBar
        itemCell.vc = vc
        
        let photoModel = photoModels[indexPath.row]
        photoModel.modelCell = itemCell
        itemCell.photoModel = photoModel
        itemCell.countLabel.text = "\(indexPath.row + 1) / \(photoModels.count)"
        
        if hideMsgForZoomAndDismissWithSingleTap && showType == .ZoomAndDismissWithSingleTap {
            itemCell.toggleDisplayBottomBar(isHidden: true)
        }
        return itemCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let itemCell = cell as! ItemCell
        itemCell.reset()
    }

    
    func handleRotation(anim: Bool){

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            DispatchQueue.main.async {
                let layout = Layout()
                layout.itemSize = self.view.bounds.size.sizeWithExtraWidth
                self.collectionView.setCollectionViewLayout(layout, animated: anim)
                self.collectionView.scrollToItem(at: IndexPath.init(item: self.page, section: 0), at: .left, animated: false)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        page = Int(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5)
    }
}
