//
//  HomeViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/2.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit


class HomeViewController: BaseViewController {
    
    var headerView = UIView()
    var dataArray = NSArray()
    
    fileprivate static let classTableViewCellIdentifier = "ClassTableViewCell"

    override func loadSubViews() {
        super.loadSubViews()
        self.titleLabel.text = "首页"
        self.leftBtn.isHidden = true
        self.rightBtn.isHidden = false
        self.rightBtn .setImage(UIImage.init(named: "ic_home_message"), for: .normal)
        self.headerView.backgroundColor = UIColor.white
        
        self.headerView.addSubview(self.cycleScrollView)
        self.cycleScrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self.headerView);
            make.height.equalTo(160);
        }
        
        let seperator1 = UIView()
        self.headerView.addSubview(seperator1)
        seperator1.backgroundColor = BaseColor.BackGroundColor
        seperator1.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.headerView);
            make.top.equalTo(self.cycleScrollView.snp.bottom);
            make.height.equalTo(15);
        }
        
        let moduleCollectionView = HomeModuleCollectionView()
        self.headerView.addSubview(moduleCollectionView)
        moduleCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.headerView);
            make.top.equalTo(seperator1.snp.bottom);
            make.height.equalTo(90);
        }
        
        let seperator2 = UIView()
        self.headerView.addSubview(seperator2)
        seperator2.backgroundColor = BaseColor.BackGroundColor
        seperator2.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.headerView);
            make.top.equalTo(moduleCollectionView.snp.bottom);
            make.height.equalTo(15);
        }
        
        // 农业头条
        let hotImage = UIImageView()
        hotImage.image = UIImage.init(named: "hot_news")
        self.headerView.addSubview(hotImage)
        hotImage.snp.makeConstraints { (make) in
            make.top.equalTo(seperator2.snp.bottom).offset(10);
            make.left.equalTo(10);
        }
        
        let line1 = UIView()
        line1.backgroundColor = BaseColor.BackGroundColor
        self.headerView.addSubview(line1)
        line1.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.headerView);
            make.top.equalTo(hotImage.snp.bottom).offset(10);
            make.height.equalTo(0.5);
        }
        
        self.headerView.addSubview(advertScrollView)
        advertScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(line1.snp.bottom);
            make.left.equalTo(self.headerView);
            make.right.equalTo(self.headerView);
            make.height.equalTo(44);
        }
        
        //当前种植
        let seperator3 = UIView()
        self.headerView.addSubview(seperator3)
        seperator3.backgroundColor = BaseColor.BackGroundColor
        seperator3.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.headerView);
            make.top.equalTo(advertScrollView.snp.bottom);
            make.height.equalTo(15);
        }
        
        self.headerView.addSubview(cropsCollectionView)
        cropsCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.headerView);
            make.top.equalTo(seperator3.snp.bottom);
        }
        
        //当前种植
        let seperator4 = UIView()
        self.headerView.addSubview(seperator4)
        seperator4.backgroundColor = BaseColor.BackGroundColor
        seperator4.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.headerView);
            make.top.equalTo(cropsCollectionView.snp.bottom);
            make.height.equalTo(15);
            make.bottom.equalTo(self.headerView);
        }
        

        self.contentView.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 49, 0));
        }
        
        self.headerView.layoutIfNeeded()
        updateHeaderViewHeight()
    }
    
    override func loadData() {
        // 头部滚动视图
        self.cycleScrollView.imageURLStringsGroup = ["https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/logo_white_fe6da1ec.png",
                                                     "https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/logo_white_fe6da1ec.png",
                                                     "https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/logo_white_fe6da1ec.png"]
        // 新闻滚动
        self.advertScrollView.titles = ["曹勇就是个大坑货","永远不要相信产品说的话","大勇你个产品汪"]
        
        // 当前种植
        let plantData = PlantModel()
        plantData.plant_crop_nam = "水果"
        plantData.crop_variety = "爱谁谁"
        self.cropsCollectionView.dataArray = [plantData,plantData,plantData,plantData,plantData]
        
        //农事活动
        let activityData = FarmActivityModel()
        activityData.created_at = "2017-6-6"
        activityData.activity_ame = "爱农田-Swift版"
        activityData.name = "阡陌"
        activityData.ammount = "100"
        self.dataArray = [activityData]
        self.tableView.reloadData()
    }
    
    func updateHeaderViewHeight() {
        self.headerView.frame.size.height = self.headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        self.tableView.tableHeaderView = self.headerView
    }
    
    override func rightBtnAction() {
        self.navigationController?.pushViewController(NotificationViewController(), animated: true)
    }
    
    lazy var cycleScrollView: SDCycleScrollView = {
        let cycleScrollView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 44 - 64), delegate: self, placeholderImage: UIImage.init(named: "ic_default_image"))
        return cycleScrollView!
    }()
    
    lazy var advertScrollView: AdvertScrollView = {
        let advertScrollView = AdvertScrollView()
        advertScrollView.titleColor = UIColor.black.withAlphaComponent(0.5)
        advertScrollView.scrollTimeInterval = 3
        advertScrollView.titleFont = UIFont.systemFont(ofSize: 14)
        advertScrollView.delegateAdvertScrollView = self
        advertScrollView.isShowSeparator = false
        return advertScrollView
    }()
    
    lazy var cropsCollectionView: CropsCollectionView = {
        let cropsCollectionView = CropsCollectionView()
        return cropsCollectionView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = BaseColor.BackGroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.register(FarmRecordCell.self, forCellReuseIdentifier: classTableViewCellIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
}

//SDCycleScrollView - Delegate
extension HomeViewController: SDCycleScrollViewDelegate {
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        
    }
}

//AdvertScrollView - Delegate
extension HomeViewController: AdvertScrollViewDelegate {
    func advertScrollView(_ advertScrollView: AdvertScrollView!, didSelectedItemAt index: Int) {
        print("新闻详情")
    }
}

//UITableView - Delegate And DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewController.classTableViewCellIdentifier, for: indexPath) as! FarmRecordCell
        cell.selectionStyle = .none
        cell.activityData = self.dataArray[indexPath.row] as? FarmActivityModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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


