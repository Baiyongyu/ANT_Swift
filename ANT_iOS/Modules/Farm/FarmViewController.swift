//
//  FarmViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/2.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class FarmViewController: BaseViewController {

    
    var titleArray = NSArray()
    var iconArray = NSArray()
    
    fileprivate static let classCollectionViewCellIdentifier = "ClassCollectionViewCell"
    fileprivate static let reuseHeaderIdentifier = "collectionViewHeader"
    
    
    override func loadSubViews() {
        super.loadSubViews()
        self.titleLabel.text = "农田"
        
        self.contentView.addSubview(collectionView)
    }
    
    override func loadData() {
        self.titleArray = ["田块管理","种植管理","农事管理","物联网","质量追溯","账本管理","报表","",""];
        self.iconArray = ["field_manager","crop_manager","farm_manager","web_thing","quality_ retrospect","account_manager","statement_manager","",""];
    }
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: SCREEN_WIDTH/3-2, height: 117)
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: -20, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = BaseColor.BackGroundColor
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        collectionView.register(FarmLandCollectionCell.self, forCellWithReuseIdentifier: classCollectionViewCellIdentifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        return collectionView
    }()
}

extension FarmViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FarmViewController.classCollectionViewCellIdentifier, for: indexPath) as! FarmLandCollectionCell
        cell.titleLabel.text = self.titleArray[indexPath.row] as? String
        cell.iconImageView.image = UIImage.init(named: (self.iconArray[indexPath.row] as? String)!)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: FarmViewController.reuseHeaderIdentifier, for: indexPath)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 150))
        headerView.backgroundColor = UIColor.orange
        reusableView.addSubview(headerView)
        
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


class FarmLandCollectionCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        
        self.contentView.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(29);
            make.centerX.equalTo(self.contentView);
            make.width.height.equalTo(32);
        }
        
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconImageView.snp.bottom).offset(15);
            make.centerX.equalTo(self.contentView);
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
