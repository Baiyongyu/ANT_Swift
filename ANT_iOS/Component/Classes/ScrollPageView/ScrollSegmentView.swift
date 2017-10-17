//
//  TopScrollView.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/17.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

public class ScrollSegmentView: UIView {

    // 1. 实现颜色填充效果
    
    
    /// 所有的title设置(style setting)
    public var segmentStyle: SegmentStyle
    
    /// 点击响应的closure(click title)
    public var titleBtnOnClick:((_ label: UILabel, _ index: Int) -> Void)?
    /// 附加按钮点击响应(click extraBtn)
    public var extraBtnOnClick: ((_ extraBtn: UIButton) -> Void)?
    /// self.bounds.size.width
    private var currentWidth: CGFloat = 0

    /// 遮盖x和文字x的间隙
    private var xGap = 5
    /// 遮盖宽度比文字宽度多的部分
    private var wGap: Int {
        return 2 * xGap
    }

    /// 缓存标题labels( save labels )
    private var labelsArray: [UILabel] = []
    /// 记录当前选中的下标
    private var currentIndex = 0
    /// 记录上一个下标
    private var oldIndex = 0
    /// 用来缓存所有标题的宽度, 达到根据文字的字数和font自适应控件的宽度(save titles; width)
    private var titlesWidthArray: [CGFloat] = []
    /// 所有的标题
    private var titles:[String]
    /// 管理标题的滚动
    private lazy var scrollView: UIScrollView = {
        let scrollV = UIScrollView()
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.bounces = true
        scrollV.isPagingEnabled = false
        scrollV.scrollsToTop = false
        return scrollV
        
    }()
    
    /// 滚动条
    private lazy var scrollLine: UIView? = {[unowned self] in
        let line = UIView()
        return self.segmentStyle.showLine ? line : nil
    }()
    /// 遮盖
    private lazy var coverLayer: UIView? = {[unowned self] in
        
        if !self.segmentStyle.showCover {
            return nil
        }
        let cover = UIView()
        cover.layer.cornerRadius = self.segmentStyle.coverCornerRadius
        // 这里只有一个cover 需要设置圆角, 故不用考虑离屏渲染的消耗, 直接设置 masksToBounds 来设置圆角
        cover.layer.masksToBounds = true
        return cover
    
    }()
    
    /// 附加的按钮
    private lazy var extraButton: UIButton? = {[unowned self] in
        if !self.segmentStyle.showExtraButton {
            return nil
        }
        let btn = UIButton()
        btn.addTarget(self, action: #selector(self.extraBtnOnClick(btn:)), for: .touchUpInside)
        // 默认 图片名字
        let imageName = self.segmentStyle.extraBtnBackgroundImageName ?? ""
        btn.setImage(UIImage(named:imageName), for: .normal)
        btn.backgroundColor = UIColor.white
        // 设置边缘的阴影效果
        btn.layer.shadowColor = UIColor.white.cgColor
        btn.layer.shadowOffset = CGSize(width: -5, height: 0)
        btn.layer.shadowOpacity = 1
        return btn
    }()
    
    
    /// 懒加载颜色的rgb变化值, 不要每次滚动时都计算
    private lazy var rgbDelta: (deltaR: CGFloat, deltaG: CGFloat, deltaB: CGFloat) = {[unowned self] in
        let normalColorRgb = self.normalColorRgb
        let selectedTitleColorRgb = self.selectedTitleColorRgb
        let deltaR = normalColorRgb.r - selectedTitleColorRgb.r
        let deltaG = normalColorRgb.g - selectedTitleColorRgb.g
        let deltaB = normalColorRgb.b - selectedTitleColorRgb.b
        
        return (deltaR: deltaR, deltaG: deltaG, deltaB: deltaB)
    }()
    
    /// 懒加载颜色的rgb变化值, 不要每次滚动时都计算
    private lazy var normalColorRgb: (r: CGFloat, g: CGFloat, b: CGFloat) = {
        
        if let normalRgb = self.getColorRGB(color: self.segmentStyle.normalTitleColor) {
            return normalRgb
        } else {
            fatalError("设置普通状态的文字颜色时 请使用RGB空间的颜色值")
        }
    }()
    
    private lazy var selectedTitleColorRgb: (r: CGFloat, g: CGFloat, b: CGFloat) =  {
        
        if let selectedRgb = self.getColorRGB(color: self.segmentStyle.selectedTitleColor) {
            return selectedRgb
        } else {
            fatalError("设置选中状态的文字颜色时 请使用RGB空间的颜色值")
        }
    }()
    
    //FIXME: 如果提供的不是RGB空间的颜色值就可能crash
    private func getColorRGB(color: UIColor) -> (r: CGFloat, g: CGFloat, b: CGFloat)? {
        
//         print(UIColor.getRed(color))
        let numOfComponents = CGColorGetNumberOfComponents(color.cgColor)
        if numOfComponents == 4 {
            
            let componemts = CGColorGetComponents(color.cgColor)
//            print("\(componemts[0]) --- \(componemts[1]) ---- \(componemts[2]) --- \(componemts[3])")

            return (r: componemts[0], g: componemts[1], b: componemts[2])

        }
        return nil
        
        
    }
    /// 背景图片
    public var backgroundImage: UIImage? = nil {
        didSet {
            // 在设置了背景图片的时候才添加imageView
            if let image = backgroundImage {
                backgroundImageView.image = image
                insertSubview(backgroundImageView, at: 0)

            }
        }
    }
    private lazy var backgroundImageView: UIImageView = {[unowned self] in
        let imageView = UIImageView(frame: self.bounds)
        return imageView
    }()
    

//MARK:- life cycle
    public init(frame: CGRect, segmentStyle: SegmentStyle, titles: [String]) {
        self.segmentStyle = segmentStyle
        self.titles = titles
        super.init(frame: frame)
        if !self.segmentStyle.scrollTitle { // 不能滚动的时候就不要把缩放和遮盖或者滚动条同时使用, 否则显示效果不好

            self.segmentStyle.scaleTitle = !(self.segmentStyle.showCover || self.segmentStyle.showLine)
        }
        
        addSubview(scrollView)
        // 添加附加按钮
        if let extraBtn = extraButton {
            addSubview(extraBtn)
        }
        // 根据titles添加相应的控件
        setupTitles()
        // 设置frame
        setupUI()
    }
    

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func titleLabelOnClick(tapGes: UITapGestureRecognizer) {
        guard let currentLabel = tapGes.view as? CustomLabel else { return }
        currentIndex = currentLabel.tag
        
        adjustUIWhenBtnOnClickWithAnimate(animated: true)

    }

    @objc func extraBtnOnClick(btn: UIButton) {
        extraBtnOnClick?(btn)
    }

    deinit {
        print("\(self.debugDescription) --- 销毁")
    }
    

}

//MARK: - public helper
extension ScrollSegmentView {
    ///  对外界暴露设置选中的下标的方法 可以改变设置下标滚动后是否有动画切换效果
    public func selectedIndex(selectedIndex: Int, animated: Bool) {
        assert(!(selectedIndex < 0 || selectedIndex >= titles.count), "设置的下标不合法!!")
        
        if selectedIndex < 0 || selectedIndex >= titles.count {
            return
        }
        
        // 自动调整到相应的位置
        currentIndex = selectedIndex
        
        //        print("\(oldIndex) ------- \(currentIndex)")
        // 可以改变设置下标滚动后是否有动画切换效果
        adjustUIWhenBtnOnClickWithAnimate(animated: animated)
    }
    
    // 暴露给外界来刷新标题的显示
    public func reloadTitlesWithNewTitles(titles: [String]) {
        // 移除所有的scrollView子视图
        scrollView.subviews.forEach { (subview) in
            subview.removeFromSuperview()
        }
        // 移除所有的label相关
        titlesWidthArray.removeAll()
        labelsArray.removeAll()
        
        // 重新设置UI
        self.titles = titles
        setupTitles()
        setupUI()
        // default selecte the first tag
        selectedIndex(selectedIndex: 0, animated: true)
    }
}



//MARK: - private helper
extension ScrollSegmentView {
    private func setupTitles() {
        for (index, title) in titles.enumerated() {
            
            let label = CustomLabel(frame: .zero)
            label.tag = index
            label.text = title
            label.textColor = segmentStyle.normalTitleColor
            label.font = segmentStyle.titleFont
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            
            // 添加点击手势
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelOnClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
            // 计算文字尺寸
            let size = (title as NSString).boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT), 0.0), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil)
            // 缓存文字宽度
            titlesWidthArray.append(size.width)
            // 缓存label
            labelsArray.append(label)
            // 添加label
            scrollView.addSubview(label)
        }
    }
    
    private func setupUI() {
        
        // 设置extra按钮
        setupScrollViewAndExtraBtn()
        
        // 先设置label的位置
        setUpLabelsPosition()
        // 再设置滚动条和cover的位置
        setupScrollLineAndCover()
        
        if segmentStyle.scrollTitle { // 设置滚动区域
            if let lastLabel = labelsArray.last {
                scrollView.contentSize = CGSize(width: CGRectGetMaxX(lastLabel.frame) + segmentStyle.titleMargin, height: 0)
                
            }
        }
        
    }
    
    private func setupScrollViewAndExtraBtn() {
        currentWidth = bounds.size.width
        let extraBtnW: CGFloat = 44.0
        let extraBtnY: CGFloat = 5.0
        let scrollW = extraButton == nil ? currentWidth : currentWidth - extraBtnW
        scrollView.frame = CGRect(x: 0.0, y: 0.0, width: scrollW, height: bounds.size.height)
        extraButton?.frame = CGRect(x: scrollW, y: extraBtnY, width: extraBtnW, height: bounds.size.height - 2*extraBtnY)
    }
    // 先设置label的位置
    private func setUpLabelsPosition() {
        var titleX: CGFloat = 0.0
        let titleY: CGFloat = 0.0
        var titleW: CGFloat = 0.0
        let titleH = bounds.size.height - segmentStyle.scrollLineHeight
        
        if !segmentStyle.scrollTitle {// 标题不能滚动, 平分宽度
            titleW = currentWidth / CGFloat(titles.count)
            
            for (index, label) in labelsArray.enumerated() {
                
                titleX = CGFloat(index) * titleW
                
                label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
                
                
            }
            
        } else {
            
            for (index, label) in labelsArray.enumerated() {
                titleW = titlesWidthArray[index]
                
                titleX = segmentStyle.titleMargin
                if index != 0 {
                    let lastLabel = labelsArray[index - 1]
                    titleX = CGRectGetMaxX(lastLabel.frame) + segmentStyle.titleMargin
                }
                label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
                
            }
            
        }
        
        if let firstLabel = labelsArray[0] as? CustomLabel {
            
            // 缩放, 设置初始的label的transform
            if segmentStyle.scaleTitle {
                firstLabel.currentTransformSx = segmentStyle.titleBigScale
            }
            // 设置初始状态文字的颜色
            firstLabel.textColor = segmentStyle.selectedTitleColor
        }
        
        
    }
    
    // 再设置滚动条和cover的位置
    private func setupScrollLineAndCover() {
        if let line = scrollLine {
            line.backgroundColor = segmentStyle.scrollLineColor
            scrollView.addSubview(line)
            
        }
        if let cover = coverLayer {
            cover.backgroundColor = segmentStyle.coverBackgroundColor
            scrollView.insertSubview(cover, atIndex: 0)
            
        }
        let coverX = labelsArray[0].frame.origin.x
        let coverW = labelsArray[0].frame.size.width
        let coverH: CGFloat = segmentStyle.coverHeight
        let coverY = (bounds.size.height - coverH) / 2
        if segmentStyle.scrollTitle {
            // 这里x-xGap width+wGap 是为了让遮盖的左右边缘和文字有一定的距离
            coverLayer?.frame = CGRect(x: coverX - CGFloat(xGap), y: coverY, width: coverW + CGFloat(wGap), height: coverH)
        } else {
            coverLayer?.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        }
        
        scrollLine?.frame = CGRect(x: coverX, y: bounds.size.height - segmentStyle.scrollLineHeight, width: coverW, height: segmentStyle.scrollLineHeight)
        
        
    }
    

}

extension ScrollSegmentView {
    // 自动或者手动点击按钮的时候调整UI
    public func adjustUIWhenBtnOnClickWithAnimate(animated: Bool) {
        // 重复点击时的相应, 这里没有处理, 可以传递给外界来处理
        if currentIndex == oldIndex { return }
        
        let oldLabel = labelsArray[oldIndex] as! CustomLabel
        let currentLabel = labelsArray[currentIndex] as! CustomLabel
        
        adjustTitleOffSetToCurrentIndex(currentIndex)
        
        let animatedTime = animated ? 0.3 : 0.0
        UIView.animateWithDuration(animatedTime) {[unowned self] in
            
            // 设置文字颜色
            oldLabel.textColor = self.segmentStyle.normalTitleColor
            currentLabel.textColor = self.segmentStyle.selectedTitleColor
            
            // 缩放文字
            if self.segmentStyle.scaleTitle {
                oldLabel.currentTransformSx = self.segmentStyle.titleOriginalScale
                
                currentLabel.currentTransformSx = self.segmentStyle.titleBigScale
                
            }
            
            
            // 设置滚动条的位置
            self.scrollLine?.frame.origin.x = currentLabel.frame.origin.x
            // 注意, 通过bounds 获取到的width 是没有进行transform之前的 所以使用frame
            self.scrollLine?.frame.size.width = currentLabel.frame.size.width
            
            // 设置遮盖位置
            if self.segmentStyle.scrollTitle {
                self.coverLayer?.frame.origin.x = currentLabel.frame.origin.x - CGFloat(self.xGap)
                self.coverLayer?.frame.size.width = currentLabel.frame.size.width + CGFloat(self.wGap)
            } else {
                self.coverLayer?.frame.origin.x = currentLabel.frame.origin.x
                self.coverLayer?.frame.size.width = currentLabel.frame.size.width
            }
            
        }
        oldIndex = currentIndex
        
        titleBtnOnClick?(label: currentLabel, index: currentIndex)
    }
    
    // 手动滚动时需要提供动画效果
    public func adjustUIWithProgress(progress: CGFloat,  oldIndex: Int, currentIndex: Int) {
        // 记录当前的currentIndex以便于在点击的时候处理
        self.oldIndex = currentIndex
        
        //        print("\(currentIndex)------------currentIndex")
        
        let oldLabel = labelsArray[oldIndex] as! CustomLabel
        let currentLabel = labelsArray[currentIndex] as! CustomLabel
        
        // 从一个label滚动到另一个label 需要改变的总的距离 和 总的宽度
        let xDistance = currentLabel.frame.origin.x - oldLabel.frame.origin.x
        let wDistance = currentLabel.frame.size.width - oldLabel.frame.size.width
        
        // 设置滚动条位置 = 最初的位置 + 改变的总距离 * 进度
        scrollLine?.frame.origin.x = oldLabel.frame.origin.x + xDistance * progress
        // 设置滚动条宽度 = 最初的宽度 + 改变的总宽度 * 进度
        scrollLine?.frame.size.width = oldLabel.frame.size.width + wDistance * progress
        
        
        // 设置 cover位置
        if segmentStyle.scrollTitle {
            coverLayer?.frame.origin.x = oldLabel.frame.origin.x + xDistance * progress - CGFloat(xGap)
            coverLayer?.frame.size.width = oldLabel.frame.size.width + wDistance * progress + CGFloat(wGap)
        } else {
            coverLayer?.frame.origin.x = oldLabel.frame.origin.x + xDistance * progress
            coverLayer?.frame.size.width = oldLabel.frame.size.width + wDistance * progress
        }
    
//        print(progress)
        // 文字颜色渐变
        if segmentStyle.gradualChangeTitleColor {
            
            oldLabel.textColor = UIColor(red:selectedTitleColorRgb.r + rgbDelta.deltaR * progress, green: selectedTitleColorRgb.g + rgbDelta.deltaG * progress, blue: selectedTitleColorRgb.b + rgbDelta.deltaB * progress, alpha: 1.0)
            
            currentLabel.textColor = UIColor(red: normalColorRgb.r - rgbDelta.deltaR * progress, green: normalColorRgb.g - rgbDelta.deltaG * progress, blue: normalColorRgb.b - rgbDelta.deltaB * progress, alpha: 1.0)
            
        }
        
        
        // 缩放文字
        if !segmentStyle.scaleTitle {
            return
        }
        
        // 注意左右间的比例是相关连的, 加减相同
        // 设置文字缩放
        let deltaScale = (segmentStyle.titleBigScale - segmentStyle.titleOriginalScale)
        
        oldLabel.currentTransformSx = segmentStyle.titleBigScale - deltaScale * progress
        currentLabel.currentTransformSx = segmentStyle.titleOriginalScale + deltaScale * progress
        
        
    }
    // 居中显示title
    public func adjustTitleOffSetToCurrentIndex(currentIndex: Int) {
        
        let currentLabel = labelsArray[currentIndex]
        
        labelsArray.enumerate().forEach {[unowned self] in
            if $0.index != currentIndex {
                $0.element.textColor = self.segmentStyle.normalTitleColor
            }
        }
        // 目标是让currentLabel居中显示
        var offSetX = currentLabel.center.x - currentWidth / 2
        if offSetX < 0 {
            // 最小为0
            offSetX = 0
        }
        // considering the exist of extraButton
        let extraBtnW = extraButton?.frame.size.width ?? 0.0
        var maxOffSetX = scrollView.contentSize.width - (currentWidth - extraBtnW)
        
        // 可以滚动的区域小余屏幕宽度
        if maxOffSetX < 0 {
            maxOffSetX = 0
        }
        
        if offSetX > maxOffSetX {
            offSetX = maxOffSetX
        }
        
        scrollView.setContentOffset(CGPoint(x:offSetX, y: 0), animated: true)
        
        // 没有渐变效果的时候设置切换title时的颜色
        if !segmentStyle.gradualChangeTitleColor {
            
            
            for (index, label) in labelsArray.enumerate() {
                if index == currentIndex {
                    label.textColor = segmentStyle.selectedTitleColor
                    
                } else {
                    label.textColor = segmentStyle.normalTitleColor
                    
                }
            }
        }
//        print("\(oldIndex) ------- \(currentIndex)")
        
        
    }
}

public class CustomLabel: UILabel {
    /// 用来记录当前label的缩放比例
    public var currentTransformSx:CGFloat = 1.0 {
        didSet {
            transform = CGAffineTransformMakeScale(currentTransformSx, currentTransformSx)
        }
    }
}


