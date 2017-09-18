//
//  YYAdvertScrollView.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/18.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

enum YYAdvertScrollViewStyle {
    case normal
    case two
}

protocol YYAdvertScrollViewDelegate {
    func advertScrollView(advertScrollView: YYAdvertScrollView, didSelectedItemAtIndex index: NSInteger)
}

let SGMargin = 10
let SGMaxSections = 100

class YYAdvertScrollViewOneCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        contentView.addSubview(tipsLabel)
    }

    override func layoutSubviews() {
        tipsLabel.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    lazy var tipsLabel: UILabel = {
        let tipsLabel = UILabel()
        tipsLabel.numberOfLines = 2
        tipsLabel.textColor = UIColor.black
        tipsLabel.font = UIFont.systemFont(ofSize: 12)
        return tipsLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class YYAdvertScrollViewTwoCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        contentView.addSubview(topLabel)
        contentView.addSubview(signImageView)
        contentView.addSubview(bottomLabel)
    }
    
    override func layoutSubviews() {
        let margin = 5
        
        let topLabelX = 0
        let topLabelY = margin
        let topLabelW = self.frame.size.width
        let topLabelH = 0.5 * (self.frame.size.height - 2 * CGFloat(topLabelY))
        topLabel.frame = CGRect(x: CGFloat(topLabelX), y: CGFloat(topLabelY), width: topLabelW, height: topLabelH)
        
        let signImageViewW = self.signImageView.image?.size.width
        let signImageViewH = self.signImageView.image?.size.height
        let signImageViewX = 0
        let signImageViewY = self.topLabel.height
        signImageView.frame = CGRect(x: CGFloat(signImageViewX), y: signImageViewY, width: signImageViewW!, height: signImageViewH!)
        
        let bottomLabelX = self.signImageView.width
        let bottomLabelY = self.topLabel.height
        let bottomLabelW = self.frame.size.width - bottomLabelX
        let bottomLabelH = topLabelH
        bottomLabel.frame = CGRect(x: bottomLabelX, y: bottomLabelY, width: bottomLabelW, height: bottomLabelH)
    }
    
    lazy var topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.numberOfLines = 2
        topLabel.textColor = UIColor.black
        topLabel.font = UIFont.systemFont(ofSize: 12)
        return topLabel
    }()
    
    lazy var signImageView: UIImageView = {
        let signImageView = UIImageView()
        return signImageView
    }()
    
    lazy var bottomLabel: UILabel = {
        let bottomLabel = UILabel()
        bottomLabel.numberOfLines = 2
        bottomLabel.textColor = UIColor.black
        bottomLabel.font = UIFont.systemFont(ofSize: 12)
        return bottomLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class YYAdvertScrollView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    /** delegate_SG */
    var delegateAdvertScrollView: YYAdvertScrollViewDelegate?
    /** AdvertScrollViewStyle */
    var advertScrollViewStyle: YYAdvertScrollViewStyle?
    /** 设置滚动时间间隔(默认 3s) */
    var scrollTimeInterval: CGFloat? {
        didSet {
            addTimer()
        }
    }
    /** 左边提示图片 */
    var leftImageString: String? {
        didSet {
            if (leftImageString?.hasPrefix("http"))! {
                imageView.kf.setImage(with: NSURL.init(string: leftImageString!)! as URL)
            }else {
                imageView.image = UIImage.init(named: leftImageString!)
            }
        }
    }
    /** 右边标题数组，当 SGAdvertScrollViewStyle 为 SGAdvertScrollViewStyleTwo, 此标题数组为 topLabel 标题数组 */
    var titles: NSArray? {
        didSet {
            if titles?.count == 0 || titles?.count == 1 { // 数组为空或者数组个数为 1，停止滚动状态
                removeTimer()
            }
            tempTitleArr = NSArray.init(array: titles!)
            collectionView?.reloadData()
        }
    }
    /** 左边标志图片数组，只有 SGAdvertScrollViewStyleTwo 样式时，才有效 */
    var signImages: NSArray? {
        didSet {
            tempImageArr = NSArray.init(array: signImages!)
        }
    }
    /** 左边底部标题数组，只有 SGAdvertScrollViewStyleTwo 样式时，才有效 */
    var bottomTitles: NSArray? {
        didSet {
            tempBottomTitleArr = NSArray.init(array: bottomTitles!)
        }
    }
    /** 标题字体大小(默认 12), 当 SGAdvertScrollViewStyle 为 SGAdvertScrollViewStyleTwo, 此 titleFont 为 topLabel 文字颜色 */
    var titleFont: UIFont?
    /** 标题字体颜色(默认 黑色), 当 SGAdvertScrollViewStyle 为 SGAdvertScrollViewStyleTwo, 此 titleColor 为 topLabel 文字颜色 */
    var titleColor: UIColor?
    /** 标题字体大小(默认 12), 只有 SGAdvertScrollViewStyleTwo 样式时，才有效 */
    var bottomTitleFont: UIFont?
    /** 标题字体颜色(默认 黑色), 只有 SGAdvertScrollViewStyleTwo 样式时，才有效 */
    var bottomTitleColor: UIColor?
    /** 是否显示分割线(默认为 YES) */
    var isShowSeparator: Bool? {
        didSet {
            if isShowSeparator == false {
                separator.removeFromSuperview()
            }
        }
    }
    /** 分割线颜色(默认 浅灰色) */
    var separatorColor: UIColor? {
        didSet {
            separator.backgroundColor = separatorColor
        }
    }
    
    
    var imageView = UIImageView()
    var separator = UIView()
    var flowLayout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView?
    
    fileprivate static let advertScrollViewOneCell = "AdvertScrollViewOneCell"
    fileprivate static let advertScrollViewTwoCell = "AdvertScrollViewTwoCell"
    var timer = Timer()
    var tempTitleArr = NSArray()
    var tempImageArr = NSArray()
    var tempBottomTitleArr = NSArray()

    override func awakeFromNib() {
        super.awakeFromNib()
        initialization()
        setupSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
        setupSubviews()
    }
    
    func initialization() {
        scrollTimeInterval = 3.0
        isShowSeparator = true
        addTimer()
        advertScrollViewStyle = YYAdvertScrollViewStyle.normal
    }
    
    func setupSubviews() {
        backgroundColor = UIColor.white
        setupLeftImageView()
        setupCollectionView()
    }
    
    func setupLeftImageView() {
        addSubview(imageView)
        separator.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        addSubview(separator)
    }
    
    func setupCollectionView() {
        flowLayout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.scrollsToTop = false
        collectionView?.isScrollEnabled = false
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.register(YYAdvertScrollViewOneCell.self, forCellWithReuseIdentifier: YYAdvertScrollView.advertScrollViewOneCell)
        collectionView?.register(YYAdvertScrollViewTwoCell.self, forCellWithReuseIdentifier: YYAdvertScrollView.advertScrollViewTwoCell)
        addSubview(collectionView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置图片尺寸
        if advertScrollViewStyle == YYAdvertScrollViewStyle.two { // 左边提示图片根据图片尺寸距离顶部、底部间距为 5
            let imageViewX = SGMargin
            let imageViewY = 0.5 * CGFloat(SGMargin)
            let imageViewH = self.frame.size.height - 2 * imageViewY
            let imageViewW = imageViewH
            imageView.frame = CGRect(x: CGFloat(imageViewX), y: imageViewY, width: imageViewW, height: imageViewH)
        }else { // 左边提示图片根据图片尺寸自适应
//            let imageViewH = imageView.image?.size.height
//            let imageViewW = imageView.image?.size.width
//            let imageViewY = 0.5 * CGFloat(self.frame.size.height - imageViewH!)
            let imageViewH = 30
            let imageViewW = 10
            let imageViewX = 0
            let imageViewY = 20
            imageView.frame = CGRect(x: CGFloat(imageViewX), y: CGFloat(imageViewY), width: CGFloat(imageViewW), height: CGFloat(imageViewH))
        }
        
        // 设置分割线尺寸
        let separatorX = imageView.width + 0.5 * CGFloat(SGMargin)
        let separatorY = 0.7 * CGFloat(SGMargin)
        let separatorW = 1
        let separatorH = self.frame.size.height - 2 * separatorY
        separator.frame = CGRect(x: separatorX, y: separatorY, width: CGFloat(separatorW), height: separatorH)
        
        // 设置 collectionView 尺寸
        var collectionViewX = 0
        let collectionViewY = 0
        if isShowSeparator == false {
            collectionViewX = Int(imageView.width + CGFloat(SGMargin))
        }else {
            collectionViewX = Int(separator.width + CGFloat(SGMargin))
        }
        let collectionViewW = self.frame.size.width - CGFloat(collectionViewX) - CGFloat(SGMargin)
        let collectionViewH = self.frame.size.height
        collectionView?.frame = CGRect(x: CGFloat(collectionViewX), y: CGFloat(collectionViewY), width: collectionViewW, height: collectionViewH)
        
        // 设置 UICollectionViewFlowLayout 尺寸
        flowLayout.itemSize = CGSize(width: (collectionView?.frame.size.width)!, height: (collectionView?.frame.size.height)!)
        
        // 默认显示最中间的那组
        defaultSelectedScetion()
    }
    
    // 默认选中的组
    func defaultSelectedScetion() {
        if tempTitleArr.count == 0 { // 为解决加载数据延迟问题
            return
        }
        // 默认显示最中间的那组
        collectionView?.scrollToItem(at: IndexPath.init(item: 0, section: SGMaxSections/2), at: .bottom, animated: false)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SGMaxSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempTitleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if advertScrollViewStyle == YYAdvertScrollViewStyle.two {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YYAdvertScrollView.advertScrollViewTwoCell, for: indexPath) as! YYAdvertScrollViewTwoCell
            cell.topLabel.text = tempTitleArr[indexPath.row] as? String
            let imagePath = tempImageArr[indexPath.row] as! String
            
            if imagePath.hasPrefix("http") {
                cell.signImageView.kf.setImage(with: NSURL.init(string: imagePath)! as URL)
            }else {
                cell.signImageView.image = UIImage.init(named: imagePath)
            }
            cell.bottomLabel.text = (tempBottomTitleArr[indexPath.row] as! String)
            if titleFont != nil {
                cell.topLabel.font = titleFont
            }
            if titleColor != nil {
                cell.topLabel.textColor = titleColor
            }
            if bottomTitleFont != nil {
                cell.bottomLabel.font = bottomTitleFont
            }
            if bottomTitleColor != nil {
                cell.bottomLabel.textColor = bottomTitleColor
            }
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YYAdvertScrollView.advertScrollViewOneCell, for: indexPath) as! YYAdvertScrollViewOneCell
            cell.tipsLabel.text = tempTitleArr[indexPath.row] as? String
            if titleFont != nil {
                cell.tipsLabel.font = titleFont
            }
            if titleColor != nil {
                cell.tipsLabel.textColor = titleColor
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateAdvertScrollView?.advertScrollView(advertScrollView: self, didSelectedItemAtIndex: indexPath.item)
    }
    
    /// 创建定时器
    func addTimer() {
        removeTimer()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(CGFloat(scrollTimeInterval!)), target: self, selector: #selector(beginUpdateUI), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    
    /// 移除定时器
    func removeTimer() {
        timer.invalidate()
//        timer = nil
    }
    // MARK: 定时器执行方法 - 更新UI
    func beginUpdateUI() {
        if tempTitleArr.count == 0 { // 为解决加载网络图片延迟问题
            return
        }
        // 1、当前正在展示的位置
        let currentIndexPath = collectionView?.indexPathsForVisibleItems.last
        
        // 马上显示回最中间那组的数据
        let resetCurrentIndexPath = IndexPath.init(item: (currentIndexPath?.item)!, section: SGMaxSections/2)
        collectionView?.scrollToItem(at: resetCurrentIndexPath, at: .bottom, animated: false)
        
        // 2、计算出下一个需要展示的位置
        var nextItem = resetCurrentIndexPath.item + 1
        var nextSection = resetCurrentIndexPath.section
        if nextItem == tempTitleArr.count {
            nextItem = 0
            nextSection += 1
        }
        let nextIndexPath = IndexPath.init(item: nextItem, section: nextSection)
        // 3、通过动画滚动到下一个位置
        collectionView?.scrollToItem(at: nextIndexPath, at: .bottom, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
