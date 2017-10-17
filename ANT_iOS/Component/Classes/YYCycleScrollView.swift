//
//  YYCycleScrollView.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/17.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit
import Kingfisher

protocol YYCycleScrollViewDelagate: class {
    func YYCycleScrollViewImageSelectedIndex(index:Int)
}

enum YYCycleScrollViewPageContolAliment: Int {
    case Right
    case Center
}

let collectionViewCellID = "collectionViewCellID"

class YYCycleScrollView: UIView {
    
    /// 闭包:回调图片的index
    var callBackWithIndex:((Int)->())?    
    /// 代理
    weak open var delegate: YYCycleScrollViewDelagate?
    /// 文字标题数组
    var titlesGroup = NSArray()
    /// 是否是无限循环 default is True
    var infiniteLoop = Bool()
    /// 标题文字颜色
    var titleLabelTextColor = UIColor()
    /// 标题文字大小
    var titleLabelTextFont = UIFont()
    /// 标题背景颜色
    var titleLabelBackgroundColor = UIColor()
    /// 标题背景高度
    var titleLabelHeight = CGFloat()
    /// 是否在只有一张图时隐藏 pageconrol default is true
    var hidesForSinglePage = Bool()
    /// 占位图 用于网络未加载到图片时
    var placeHolderImage : UIImage?
    /// 指示器的位置 defaule is LLCycleScrollViewPageContolAlimentCenter
    var pageControlAliment = YYCycleScrollViewPageContolAliment(rawValue: 1)
    /// 是否显示分页控件
    var showPageControl : Bool? {
        didSet{
            pageControl?.isHidden = !showPageControl!
        }
    }
    /// 分页控件小圆标颜色 defaule is white
    var dotColor : UIColor? {
        didSet {
            pageControl?.currentPageIndicatorTintColor = dotColor!
        }
    }
    /// 是否是自动滚动 default is true
    var autoScroll = Bool() {
        didSet {
            setAutoScroll()
        }
    }
    /// 时间间隔  default is 2.0
    var autoScrollTimeInterval = CGFloat() {
        didSet {
            setAutoScroll()
        }
    }
    
    public var flowLayout: UICollectionViewFlowLayout?
    public var mainView: UICollectionView?
    public var totalItemsCount = NSInteger()
    public var pageControl: UIPageControl?
    public var timer: Timer?
    /// 网络图片数组
    public var imageURLStringsGroup = NSArray() {
        didSet {
            let images = NSMutableArray.init(capacity: imageURLStringsGroup.count)
            for _ in 0 ..< imageURLStringsGroup.count {
                let image = UIImage.init()
                images.add(image)
            }
            self.imagesGroup = images
            self.loadImageWithImageURLsGroup(imageURLSGroup: imageURLStringsGroup)
        }
    }
    /// 本地图片数组
    public var localizationImagesGroup = NSArray() {
        didSet {
            self.imagesGroup = NSMutableArray.init(array: localizationImagesGroup)
        }
    }
    
    public var imagesGroup = NSMutableArray.init() {
        didSet {
            totalItemsCount = self.infiniteLoop ? self.imagesGroup.count * 100 : self.imagesGroup.count
            
            if imagesGroup.count != 1 {
                self.mainView?.isScrollEnabled = true
                setAutoScroll()
            }else {
                self.mainView?.isScrollEnabled = false
            }
            setupPageControl()
            self.mainView?.reloadData()
        }
    }
    
    /// 初始化方法1 本地图片
    class func cycleScrollView(frame : CGRect,imagesGroup : NSArray) -> YYCycleScrollView {
        let cycleScrollView = YYCycleScrollView.init(frame: frame)
        cycleScrollView.imagesGroup = NSMutableArray.init(array: imagesGroup)
        return cycleScrollView
    }
    /// 初始化方法2 网络图片
    class func cycleScrollView(frame : CGRect,imageURLGroup : NSArray) -> YYCycleScrollView {
        let cycleScrollView = YYCycleScrollView.init(frame: frame)
        cycleScrollView.imageURLStringsGroup = NSMutableArray.init(array: imageURLGroup)
        return cycleScrollView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initConfiguration()
        setupMainView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var frame: CGRect {
        didSet {
            super.frame = frame
            flowLayout?.itemSize = self.frame.size
        }
    }
    
    deinit {
        mainView?.delegate = nil
        mainView?.dataSource = nil
    }
}

//MARK: - Private method
extension YYCycleScrollView {
    
    fileprivate func initConfiguration() {
        pageControlAliment = YYCycleScrollViewPageContolAliment.Center
        autoScrollTimeInterval = 2.0
        titleLabelTextColor = UIColor.white
        titleLabelTextFont = UIFont.systemFont(ofSize: 14)
        titleLabelBackgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        titleLabelHeight = 30
        autoScroll = true
        infiniteLoop = true
        showPageControl = true
        hidesForSinglePage = true
        backgroundColor = UIColor.lightGray
    }
    
    fileprivate func setupMainView() {
        flowLayout = UICollectionViewFlowLayout.init()
        flowLayout?.itemSize = self.frame.size
        flowLayout?.minimumLineSpacing = 0
        flowLayout?.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        mainView = UICollectionView.init(frame: self.frame, collectionViewLayout: flowLayout!)
        mainView?.backgroundColor = UIColor.lightGray
        mainView?.isPagingEnabled = true
        mainView?.showsHorizontalScrollIndicator = false
        mainView?.showsVerticalScrollIndicator = false
        mainView?.register(CycleScrollCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewCellID)
        mainView?.delegate = self
        mainView?.dataSource = self
        self.addSubview(mainView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView?.frame = self.bounds
        if mainView?.contentOffset.x == 0 && totalItemsCount != 0 {
            var targetIndex = 0
            if infiniteLoop {
                targetIndex = Int(CGFloat(totalItemsCount) * 0.5)
            }else {
                targetIndex = 0
            }
            mainView?.scrollToItem(at: IndexPath.init(row: targetIndex, section: 0), at: UICollectionViewScrollPosition(rawValue: 0), animated: false)
        }
        
        var x = SCREEN_WIDTH / 2
        if pageControlAliment == YYCycleScrollViewPageContolAliment.Right {
            x = (self.mainView?.bounds.size.width)! - 20
        }
        let y = (self.mainView?.bounds.size.height)! - 15
        pageControl?.frame = CGRect.init(x: x, y: y, width: x, height: 10)
    }
    
    fileprivate  func loadImageWithImageURLsGroup(imageURLSGroup: NSArray) {
        for i in 0 ..< imageURLSGroup.count {
            loadImageAtIndex(index: i)
        }
    }
    
    fileprivate func loadImageAtIndex(index : Int) {
        let urlStr = self.imageURLStringsGroup.object(at: index)
        let url = NSURL.init(string: urlStr as! String)
        let image = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: urlStr as! String)
        if (image != nil) {
            
            // self.imagesGroup.insert(image as Any, at: index)
            self.imagesGroup.replaceObject(at: index, with: image as Any)
        }else{
            KingfisherManager.shared.downloader.downloadImage(with: url! as URL, options: nil, progressBlock: {(receivedSize, totalSize) in
                
            }, completionHandler: {(_ image: Image?, _ error: NSError?, _ url: URL?, _ originalData: Data?) in
                guard image != nil else {
                    print("获取图片失败")
                    return
                }
                // self.imagesGroup.insert(image as Any, at: index)
                self.imagesGroup.replaceObject(at: index, with: image as Any)
                self.mainView?.reloadData()
            })
        }
    }
    
    fileprivate  func setupPageControl() {
        if (pageControl != nil) {
            pageControl?.removeFromSuperview()
        }
        if imagesGroup.count <= 1 && self.hidesForSinglePage {
            return
        }
        pageControl = UIPageControl.init()
        pageControl?.numberOfPages = self.imagesGroup.count
        pageControl?.currentPageIndicatorTintColor = dotColor
        self.addSubview(pageControl!)
    }
    
    fileprivate func setAutoScroll() {
        timer?.invalidate()
        timer = nil
        if autoScroll {
            setupTimer()
        }
    }
    
    @objc fileprivate func automaticScroll() {
        if totalItemsCount == 0 {
            return
        }
        let currentIndex = NSInteger((mainView?.contentOffset.x)!) / NSInteger((flowLayout?.itemSize.width)!)
        var targetIndex = currentIndex + 1
        if targetIndex == totalItemsCount {
            if (infiniteLoop) {
                targetIndex = Int(CGFloat(totalItemsCount) * 0.5)
            }else{
                targetIndex = 0
            }
            mainView?.scrollToItem(at: NSIndexPath.init(row: targetIndex, section: 0) as IndexPath, at: UICollectionViewScrollPosition(rawValue: 0), animated: false)
        }
        mainView?.scrollToItem(at: NSIndexPath.init(row: targetIndex, section: 0) as IndexPath, at: UICollectionViewScrollPosition(rawValue: 0), animated: true)
    }
    
    fileprivate  func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(autoScrollTimeInterval), target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            timer?.invalidate()
            timer = nil
        }
    }
}

//MARK: - UICollectionViewDelegate UICollectionViewDataSource
extension YYCycleScrollView:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItemsCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID, for: indexPath) as! CycleScrollCollectionViewCell
        let itemIndex = indexPath.item % imagesGroup.count
        var image = self.imagesGroup.object(at: itemIndex)
        
        if (image as AnyObject).size.width == 0 && placeHolderImage != nil {
            image = placeHolderImage as Any
            loadImageAtIndex(index: itemIndex)
        }
        cell.imageView?.image = image as? UIImage
        if titlesGroup.count > 0 {
            if titlesGroup.count == imagesGroup.count{
                cell.titleLabel?.text = titlesGroup.object(at: itemIndex) as? String
            }else{
                print("标题数量和图片数量不一致")
            }
        }
        if !cell.hasConfigured {
            cell.titleLabelBackgroundColor = titleLabelBackgroundColor
            cell.titleLabelHeight = titleLabelHeight
            cell.titleLabelTextColor = titleLabelTextColor
            cell.titleLabelTextFont = titleLabelTextFont
            cell.hasConfigured =  true
        }        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.callBackWithIndex?(indexPath.item % imagesGroup.count)
        if self.delegate != nil {
            self.delegate?.YYCycleScrollViewImageSelectedIndex(index: indexPath.item % imagesGroup.count)
        }
    }
}

//MARK: - scrollViewdelegate
extension YYCycleScrollView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let itemIndex = (scrollView.contentOffset.x + (self.mainView?.bounds.size.width)! * 0.5) / (self.mainView?.bounds.size.width)!
        if self.imagesGroup.count == 0  {
            return
        }
        let indexOnPageControl = Int(itemIndex) % self.imagesGroup.count
        pageControl?.currentPage = indexOnPageControl
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.autoScroll {
            timer?.invalidate()
            timer = nil
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.autoScroll{
            setupTimer()
        }
    }
}


class CycleScrollCollectionViewCell: UICollectionViewCell {    
    var imageView : UIImageView?
    var titleLabel : UILabel?
    var titleLabelHeight : CGFloat?
    var hasConfigured = Bool()
    var titleLabelTextColor = UIColor(){
        didSet{
            titleLabel?.textColor = titleLabelTextColor
        }
    }
    var titleLabelTextFont = UIFont() {
        didSet{
            titleLabel?.font = titleLabelTextFont
        }
    }
    var titleLabelBackgroundColor = UIColor() {
        didSet{
            titleLabel?.backgroundColor = titleLabelBackgroundColor
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupTitleLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImageView() {
        imageView = UIImageView.init()
        addSubview(imageView!)
    }
    
    private func setupTitleLabel() {
        titleLabel = UILabel.init()
        titleLabel?.isHidden = true
        addSubview(titleLabel!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = self.bounds
        
        let titleLabelW = self.bounds.size.width
        let titleLabelH = titleLabelHeight
        let titleLabelX = 0
        let titleLabelY = self.bounds.size.height - titleLabelH!
        titleLabel?.frame = CGRect.init(x: CGFloat(titleLabelX), y: titleLabelY, width: titleLabelW, height: titleLabelH!)
        titleLabel?.isHidden = ((titleLabel?.text) == nil)
    }
}

