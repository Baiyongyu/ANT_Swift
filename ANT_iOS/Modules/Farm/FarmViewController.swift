//
//  FarmViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/2.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class FarmViewController: BaseViewController {

    var titleArray = Array<Any>()
    var iconArray = Array<Any>()
    var colorArray = Array<Any>()
    
    fileprivate static let classCollectionViewCellIdentifier = "ClassCollectionViewCell"
    fileprivate static let reuseHeaderIdentifier = "collectionViewHeader"

    override func loadSubViews() {
        super.loadSubViews()
        navBar.alpha = 0
        titleLabel.text = "农田"
        contentView.addSubview(collectionView)
    }
    
    override func layoutConstraints() {
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, TabBarHeight, 0))
        }
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, TabBarHeight, 0))
        }
    }
    
    override func loadData() {
        titleArray = ["田块管理","种植管理","农事管理","物联网","质量追溯","账本管理","运营分析","农场信息",""]
        iconArray = ["\u{e60c}","\u{e620}","\u{e633}","\u{e615}",
                     "\u{e61b}","\u{e61a}","\u{e625}","\u{e632}",""]
        colorArray = [UIColor.HexColor(0xb0d259),UIColor.HexColor(0xf9961f),UIColor.HexColor(0xf38a30),UIColor.HexColor(0x2374b4),
                      UIColor.HexColor(0xe85351),UIColor.HexColor(0x6a8fdc),UIColor.HexColor(0x19c041),UIColor.HexColor(0x56ab2f),
                      UIColor.HexColor(0x56ab2f)]
    }
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (SCREEN_WIDTH-2)/3, height: 117)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = BaseColor.BackGroundColor
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        collectionView.register(FarmLandCollectionCell.self, forCellWithReuseIdentifier: classCollectionViewCellIdentifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.scrollIndicatorInsets = collectionView.contentInset
        }
        return collectionView
    }()
}

extension FarmViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FarmViewController.classCollectionViewCellIdentifier, for: indexPath) as! FarmLandCollectionCell
        cell.titleLabel.text = titleArray[indexPath.row] as? String
        cell.iconImageView.image = UIImage.icon(with: TBCityIconInfo.init(text: iconArray[indexPath.row] as! String, size: 32, color: colorArray[indexPath.row] as! UIColor))
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: FarmViewController.reuseHeaderIdentifier, for: indexPath)
        
        let bgView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 200))
        bgView.image = UIImage.init(named: "ic_weather_bg")
        reusableView.addSubview(bgView)
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.item {
        case 0:
            AppCommon.push(FieldsManagerViewController(), animated: true)
        case 1:
            AppCommon.push(PlantManagerViewController(), animated: true)
        case 3:
            AppCommon.push(WebThingViewController(), animated: true)
        case 4:
            AppCommon.push(QualityTrackingViewController(), animated: true)
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
    }
}


class FarmLandCollectionCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.white
        
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(29);
            make.centerX.equalTo(contentView);
            make.width.height.equalTo(32);
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.bottom).offset(15);
            make.centerX.equalTo(contentView);
        }
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = BaseColor.BlackColor
        return titleLabel
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.layer.masksToBounds = true
        return iconImageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
