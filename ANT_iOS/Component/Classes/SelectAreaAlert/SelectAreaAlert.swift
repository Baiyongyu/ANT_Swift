//
//  SelectAreaAlert.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/8.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class SelectAreaAlert: UIView {

    //地区名称数组
    var titles = NSArray()
    //地区id数组
    var codes = NSArray()
    
    var alertHeight: CGFloat?
    var buttonHeight: CGFloat?
    
    fileprivate static let classCollectionViewCellIdentifier = "ClassCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        alertHeight = 250
        buttonHeight = 40
        self.addSubview(alertView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(closeButton)
        alertView.addSubview(lineView)
        alertView.addSubview(selectCollectionView)
        
        layoutConstraints()
        show()
    }

    func layoutConstraints() {
        
        alertView.frame = CGRect(x: 50, y: (SCREEN_HEIGHT - alertHeight!)/2.0, width: SCREEN_WIDTH - 100, height: alertHeight!)
        titleLabel.frame = CGRect(x: 15, y: 0, width: alertView.frame.size.width, height: 44)
        closeButton.frame = CGRect(x: alertView.frame.size.width - 30, y: 10, width: 20, height: 20)
        lineView.frame = CGRect(x: 0, y: titleLabel.frame.size.height, width: SCREEN_WIDTH, height: 1)
        selectCollectionView.frame = CGRect(x: 20, y: lineView.frame.size.height+50, width: alertView.frame.size.width - 40, height: alertView.frame.size.height - 80)
    }
    
    //外部调用的方法
    public func selectAreaAlert(title: String, titles: NSArray, codes: NSArray) {
        self.titleLabel.text = title
        self.titles = titles
        self.codes = codes
    }
    
    func show() {
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        UIApplication.shared.keyWindow?.addSubview(self)
        
        alertView.alpha = 0.0
        UIView.animate(withDuration: 0.05) {
            self.alertView.alpha = 1.0
        }
        CommonUtils().setCAKeyframeAnimation(view: self.alertView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.closeAction()
    }
    
    func closeAction() {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0
        }) { (true) in
            self.removeFromSuperview()
        }
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.white
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        return titleLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = BaseColor.BackGroundColor
        return lineView
    }()
    
    lazy var alertView: UIView = {
        let alertView = UIView()
        alertView.backgroundColor = UIColor.white
        alertView.layer.cornerRadius = 8
        alertView.layer.masksToBounds = true
        return alertView
    }()
    
    lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: UIButtonType.custom)
        closeButton.setImage(UIImage.init(named: "ic_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return closeButton
    }()
    
    
    lazy var selectCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 32)
        
        let selectCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), collectionViewLayout: layout)
        selectCollectionView.delegate = self
        selectCollectionView.dataSource = self
        selectCollectionView.backgroundColor = UIColor.white
        selectCollectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10)
        selectCollectionView.register(AreaLabelCell.self, forCellWithReuseIdentifier: classCollectionViewCellIdentifier)
        
        return selectCollectionView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 地区colection 代理
extension SelectAreaAlert: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectAreaAlert.classCollectionViewCellIdentifier, for: indexPath) as! AreaLabelCell
        cell.areaLabel.text = self.titles[indexPath.row] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// 地区 cell
class AreaLabelCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(areaLabel)
        areaLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView);
        }
    }
    
    lazy var areaLabel: UILabel = {
        let areaLabel = UILabel()
        areaLabel.font = UIFont.systemFont(ofSize: 14)
        areaLabel.textColor = UIColor.orange
        areaLabel.textAlignment = .center
        areaLabel.layer.cornerRadius = 2.0
        areaLabel.layer.borderColor = UIColor.orange.cgColor
        areaLabel.layer.borderWidth = 0.5
        areaLabel.clipsToBounds = true
        return areaLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
