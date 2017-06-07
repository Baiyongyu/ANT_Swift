//
//  CropsCollectionView.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/5.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class CropsCollectionView: UIView {
    
    fileprivate static let classCollectionViewCellIdentifier = "ClassCollectionViewCell"
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.text = "  当前种植"
        titleLabel.textColor = UIColor.black
        titleLabel.backgroundColor = UIColor.white
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(10);
        }
        
        let line = UIView()
        line.backgroundColor = BaseColor.BackGroundColor
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10);
            make.left.right.equalTo(self);
            make.height.equalTo(0.5);
        }
        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self);
            make.top.equalTo(line.snp.bottom);
            make.height.equalTo(63);
            make.bottom.equalTo(self);
        }
        
    }
    
    var dataArray: [PlantModel] = [] {
        didSet {
            self.collectionView.reloadData()
            self.collectionView.performBatchUpdates({
                self.collectionView.reloadData()
            }) { (true) in
                
            }
        }
    }

    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: (SCREEN_WIDTH - 50)/3, height: 43)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 63), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
        collectionView.register(CropsCollectionCell.self, forCellWithReuseIdentifier: classCollectionViewCellIdentifier)
        return collectionView
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CropsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CropsCollectionView.classCollectionViewCellIdentifier, for: indexPath) as! CropsCollectionCell
        cell.plantData = self.dataArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


class CropsCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.backgroundColor = UIColor.HexColor(0xf8f8f8)
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderColor = UIColor.HexColor(0xdfdfdf).cgColor;
        self.contentView.layer.borderWidth = 1.0
        
        self.contentView.addSubview(goodsNameLabel)
        goodsNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(6);
            make.centerX.equalTo(self.contentView);
            make.height.equalTo(13);
            make.width.equalTo(100);
        }
        
        self.contentView.addSubview(varietyLabel)
        varietyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.goodsNameLabel.snp.bottom).offset(5);
            make.centerX.equalTo(self.contentView);
            make.height.equalTo(17);
            make.width.equalTo(100);
            make.bottom.equalTo(-6);
        }
    }
    
    var plantData: PlantModel? {
        didSet {
            goodsNameLabel.text = plantData?.plant_crop_nam
            varietyLabel.text = plantData?.crop_variety
        }
    }
    
    
    
    lazy var goodsNameLabel: UILabel = {
        let goodsNameLabel = UILabel()
        goodsNameLabel.font = UIFont.systemFont(ofSize: 14)
        goodsNameLabel.textAlignment = .center
        goodsNameLabel.textColor = UIColor.black
        return goodsNameLabel
    }()

    lazy var varietyLabel: UILabel = {
        let varietyLabel = UILabel()
        varietyLabel.font = UIFont.systemFont(ofSize: 14)
        varietyLabel.textAlignment = .center
        varietyLabel.textColor = UIColor.lightGray
        return varietyLabel
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
