//
//  ShopListViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/7.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class ShopListViewController: BaseViewController {

    var dataArray = NSArray()
    fileprivate static let classTableViewCellIdentifier = "ClassTableViewCell"
    
    override func loadSubViews() {
        super.loadSubViews()
        self.titleLabel.text = "买农资"
        self.contentView.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 0, 0));
        }
    }
    
    override func loadData() {
        let shopData = ShopModel()
        shopData.shopImageUrl = "http://img2.imgtn.bdimg.com/it/u=960594752,2162202648&fm=26&gp=0.jpg"
        shopData.shopName = "阡陌"
        shopData.shopIntro = "阡陌科技旗下的爱农田产品，是世界一流的农服务农产品，功能强大，要啥有啥，屌的一逼，值得下载！"
        shopData.distance = "2.32"
        shopData.isAuthenticated = true
        self.dataArray = [shopData,shopData,shopData,shopData]
        self.tableView.reloadData()
        
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = BaseColor.BackGroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ShopCell.self, forCellReuseIdentifier: classTableViewCellIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()

}


extension ShopListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShopListViewController.classTableViewCellIdentifier, for: indexPath) as! ShopCell
        cell.shopData = self.dataArray[indexPath.row] as? ShopModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(cell.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            cell.separatorInset = .zero
        }
        if(cell.responds(to: #selector(setter: UIView.layoutMargins))){
            cell.layoutMargins = .zero
        }
    }
}


class ShopCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        
        let seperator = UIView()
        seperator.backgroundColor = BaseColor.BackGroundColor
        contentView.addSubview(seperator)
        seperator.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.contentView);
            make.height.equalTo(15);
        }
        
        contentView.addSubview(shopImageView)
        shopImageView.snp.makeConstraints { (make) in
            make.left.equalTo(10);
            make.top.equalTo(seperator.snp.bottom).offset(10);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.width.height.equalTo(80);
        }
        
        contentView.addSubview(shopNameLabel)
        shopNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.shopImageView.snp.right).offset(20);
            make.top.equalTo(self.shopImageView);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.equalTo(15);
        }
        
        contentView.addSubview(shopIntroLabel)
        shopIntroLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.shopNameLabel.snp.bottom).offset(5);
            make.left.equalTo(self.shopImageView.snp.right).offset(20);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.equalTo(40);
        }
        
        contentView.addSubview(distanceLabel)
        distanceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.shopIntroLabel.snp.bottom).offset(5);
            make.left.equalTo(self.shopImageView.snp.right).offset(20);
            make.height.equalTo(12);
        }
        
        contentView.addSubview(authenticatedLabel)
        authenticatedLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.shopImageView);
            make.height.equalTo(20);
        }
        
    }
    
    var shopData: ShopModel? {
        didSet {
            shopImageView.kf.setImage(with: NSURL.init(string: (shopData?.shopImageUrl)!)! as URL, placeholder: IMAGE_PLACEHOLDER, options: nil, progressBlock: nil, completionHandler: nil)
            shopNameLabel.text = shopData?.shopName
            shopIntroLabel.text = shopData?.shopIntro
            distanceLabel.text = shopData?.distance
            authenticatedLabel.isHidden = !(shopData?.isAuthenticated)!
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var shopImageView: UIImageView = {
        let shopImageView = UIImageView()
        shopImageView.clipsToBounds = true
        shopImageView.contentMode = .scaleAspectFill
        shopImageView.layer.borderWidth = 0.5
        shopImageView.layer.borderColor = BaseColor.BackGroundColor.cgColor
        return shopImageView
    }()
    
    lazy var shopNameLabel: UILabel = {
        let shopNameLabel = UILabel()
        shopNameLabel.font = UIFont.systemFont(ofSize: 15)
        shopNameLabel.numberOfLines = 0
        return shopNameLabel
    }()
    
    lazy var shopIntroLabel: UILabel = {
        let shopIntroLabel = UILabel()
        shopIntroLabel.font = UIFont.systemFont(ofSize: 14)
        shopIntroLabel.numberOfLines = 2
        return shopIntroLabel
    }()
    
    lazy var distanceLabel: UILabel = {
        let distanceLabel = UILabel()
        distanceLabel.font = UIFont.systemFont(ofSize: 14)
        distanceLabel.textColor = BaseColor.ThemeColor
        return distanceLabel
    }()
    
    lazy var authenticatedLabel: UILabel = {
        let authenticatedLabel = UILabel()
        authenticatedLabel.font = UIFont.systemFont(ofSize: 12)
        authenticatedLabel.textColor = UIColor.white
        authenticatedLabel.textAlignment = .center
        authenticatedLabel.text = "认证商家"
        authenticatedLabel.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        return authenticatedLabel
    }()
}
