//
//  HomeModuleCollectionView.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/4.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class HomeModuleCollectionView: UIView {

    var titleArray = NSArray()
    var iconArray = NSMutableArray()
    
    fileprivate static let classCollectionViewCellIdentifier = "ClassCollectionViewCell"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
        loadData()
    }
    
    func loadData() {
        self.iconArray = ["ic_home_daikuan","ic_home_nongzi","ic_home_nongji","ic_home_cetu","ic_home_baoxian"];
        self.titleArray = ["办贷款","买农资","买农机","测土配肥","买保险"];
        self.collectionView.performBatchUpdates({ 
            self.collectionView.reloadData()
        }) { (true) in
            self.collectionView.snp.makeConstraints({ (make) in
                make.left.right.top.equalTo(self);
                make.height.equalTo(self.collectionView.contentSize.height);
                make.bottom.equalTo(self);
            })
        }
    }
    
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: SCREEN_WIDTH/5, height: 90)
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 90), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        collectionView.register(HomeModuleCell.self, forCellWithReuseIdentifier: classCollectionViewCellIdentifier)
        return collectionView
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HomeModuleCollectionView: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.iconArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:HomeModuleCollectionView.classCollectionViewCellIdentifier, for: indexPath) as! HomeModuleCell
        cell.titleLabel.text = self.titleArray[indexPath.row] as? String
        cell.iconImageView.image = UIImage.init(named: (self.iconArray[indexPath.row] as? String)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.item {
        case 0:
            let loanVC = LoanInsureViewController()
            loanVC.selectType = .loan
            AppCommon.push(loanVC, animated: true)
        case 1,2:
            AppCommon.push(ShopListViewController(), animated: true)
        case 3:
            AppCommon.push(CetuTypeViewController(), animated: true)
        case 4:
            let loanVC = LoanInsureViewController()
            loanVC.selectType = .insure
            AppCommon.push(loanVC, animated: true)
        default:
            break
        }
    }
}


class HomeModuleCell: UICollectionViewCell {
    
    var bgView = UIView()
    var bgColor = UIColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        self.contentView.addSubview(bgView)
        bgView.backgroundColor = BaseColor.ThemeColor
        bgView.layer.cornerRadius = 24
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(10);
            make.centerX.equalTo(self.contentView);
            make.width.height.equalTo(48);
        }
        
        bgView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.bgView);
        }
        
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.contentView).offset(-10);
            make.centerX.equalTo(self.contentView);
        }
    }
    
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill
        return iconImageView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
