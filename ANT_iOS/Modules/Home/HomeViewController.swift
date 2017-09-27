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
        self.rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e616}", size: 20, color: UIColor.black)), for: .normal)
        self.rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e616}", size: 20, color: UIColor.gray)), for: .highlighted)
        self.navBar.alpha = 0
        self.contentView.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, TabBarHeight, 0))
        }
        self.contentView.addSubview(self.tableView)
        let messageBtn = UIButton(type: UIButtonType.custom)
        self.contentView.addSubview(messageBtn)
        messageBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e616}", size: 20, color: UIColor.white)), for: .normal)
        messageBtn.addTarget(self, action: #selector(HomeViewController.rightBtnAction), for: .touchUpInside)
        messageBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(IS_IPHONE_iPX ? 43 : 20)
            make.width.equalTo(50)
            make.height.equalTo(40)
        }
        
        self.headerView.backgroundColor = UIColor.white
        self.headerView.addSubview(self.cycleScrollView)
        self.cycleScrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self.headerView)
            make.height.equalTo(240)
        }
        
        let seperator1 = UIView()
        self.headerView.addSubview(seperator1)
        seperator1.backgroundColor = BaseColor.BackGroundColor
        seperator1.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.headerView)
            make.top.equalTo(self.cycleScrollView.snp.bottom)
            make.height.equalTo(10)
        }
        
        let moduleCollectionView = HomeModuleCollectionView()
        self.headerView.addSubview(moduleCollectionView)
        moduleCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.headerView)
            make.top.equalTo(seperator1.snp.bottom)
            make.height.equalTo(90)
        }
        
        let seperator2 = UIView()
        self.headerView.addSubview(seperator2)
        seperator2.backgroundColor = BaseColor.BackGroundColor
        seperator2.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.headerView)
            make.top.equalTo(moduleCollectionView.snp.bottom)
            make.height.equalTo(10)
        }
        
        // 农业头条
        let hotImage = UIImageView()
        hotImage.image = UIImage.init(named: "hot_news")
        self.headerView.addSubview(hotImage)
        hotImage.snp.makeConstraints { (make) in
            make.top.equalTo(seperator2.snp.bottom).offset(10)
            make.left.equalTo(10)
        }
        
        let line1 = UIView()
        line1.backgroundColor = BaseColor.BackGroundColor
        self.headerView.addSubview(line1)
        line1.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.headerView)
            make.top.equalTo(hotImage.snp.bottom).offset(10)
            make.height.equalTo(0.5)
        }
        
        self.headerView.addSubview(advertScrollView)
        advertScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(line1.snp.bottom)
            make.left.equalTo(-10)
            make.right.equalTo(self.headerView)
            make.height.equalTo(44)
        }
        
        //当前种植
        let seperator3 = UIView()
        self.headerView.addSubview(seperator3)
        seperator3.backgroundColor = BaseColor.BackGroundColor
        seperator3.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.headerView)
            make.top.equalTo(advertScrollView.snp.bottom)
            make.height.equalTo(10)
        }
        
        self.headerView.addSubview(cropsCollectionView)
        cropsCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.headerView)
            make.top.equalTo(seperator3.snp.bottom)
        }
        
        //当前种植
        let seperator4 = UIView()
        self.headerView.addSubview(seperator4)
        seperator4.backgroundColor = BaseColor.BackGroundColor
        seperator4.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.headerView)
            make.top.equalTo(cropsCollectionView.snp.bottom)
            make.height.equalTo(15)
            make.bottom.equalTo(self.headerView)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, TabBarHeight, 0))
        }
        
        self.headerView.layoutIfNeeded()
        updateHeaderViewHeight()
    }
    
    override func loadData() {
        // 头部滚动视图
        self.cycleScrollView.imageURLStringsGroup = ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497949214433&di=ae83cb8483d9df8c4f8702d5f23ce45d&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201201%2F21%2F20120121164629_HAcYw.jpg",
                                                     "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497949236536&di=9ee3b94520d0d468e7965d089738a51d&imgtype=0&src=http%3A%2F%2Fimg1.gamersky.com%2Fimage2014%2F03%2F20140307zx_2%2Fgamersky_31small_62_20143710179F3.jpg",
                                                     "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1497949253080&di=830853049c767682059db6bd995b08c3&imgtype=0&src=http%3A%2F%2Fwenwen.soso.com%2Fp%2F20110516%2F20110516210729-212837478.jpg"]
        // 新闻滚动
        self.advertScrollView.titles = ["杀了一个产品🐶祭天","永远不要相信产品说的话","XXX你个产品汪"]
        
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
        let cycleScrollView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 240), delegate: self, placeholderImage: IMAGE_PLACEHOLDER)
        return cycleScrollView!
    }()
    
    lazy var advertScrollView: YYAdvertScrollView = {
        let advertScrollView = YYAdvertScrollView()
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
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
        return tableView
    }()
}

//SDCycleScrollView - Delegate
extension HomeViewController: SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
//        http://h5.eqxiu.com/s/NABANe?eqrcode=1&from=timeline&isappinstalled=0
        AppCommon.push(WebThingsViewController(), animated: true)
    }
}

//AdvertScrollView - Delegate
extension HomeViewController: YYAdvertScrollViewDelegate {
    func advertScrollView(advertScrollView: YYAdvertScrollView, didSelectedItemAtIndex index: NSInteger) {
        AppCommon.push(NewsViewController(), animated: true)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.contentOffset.y >= 64 {
            self.navBar.alpha = 1
            UIApplication.shared.setStatusBarStyle(.default, animated: true)
            return
        }
        self.navBar.alpha = tableView.contentOffset.y/64;
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.setStatusBarStyle(self.tableView.contentOffset.y>=64 ? .default : .lightContent, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIApplication.shared.setStatusBarStyle(self.tableView.contentOffset.y>=64 ? .default : .lightContent, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
    }
}


