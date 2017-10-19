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
        titleLabel.text = "首页"
        leftBtn.isHidden = true
        rightBtn.isHidden = false
        rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e616}", size: 20, color: UIColor.black)), for: .normal)
        rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e616}", size: 20, color: UIColor.gray)), for: .highlighted)
        navBar.alpha = 0
        contentView.snp.updateConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, TabBarHeight, 0))
        }
        contentView.addSubview(tableView)
        let messageBtn = UIButton(type: UIButtonType.custom)
        contentView.addSubview(messageBtn)
        messageBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e616}", size: 20, color: UIColor.white)), for: .normal)
        messageBtn.addTarget(self, action: #selector(HomeViewController.rightBtnAction), for: .touchUpInside)
        messageBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view)
            make.top.equalTo(view).offset(IS_IPHONE_iPX ? 43 : 19)
            make.width.equalTo(50)
            make.height.equalTo(40)
        }
        
        headerView.backgroundColor = UIColor.white
        headerView.addSubview(cycleScrollView)
        cycleScrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(headerView)
            make.height.equalTo(240)
        }
        
        let seperator1 = UIView()
        headerView.addSubview(seperator1)
        seperator1.backgroundColor = BaseColor.BackGroundColor
        seperator1.snp.makeConstraints { (make) in
            make.left.right.equalTo(headerView)
            make.top.equalTo(cycleScrollView.snp.bottom)
            make.height.equalTo(10)
        }
        
        let moduleCollectionView = HomeModuleCollectionView()
        headerView.addSubview(moduleCollectionView)
        moduleCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(headerView)
            make.top.equalTo(seperator1.snp.bottom)
            make.height.equalTo(90)
        }
        
        let seperator2 = UIView()
        headerView.addSubview(seperator2)
        seperator2.backgroundColor = BaseColor.BackGroundColor
        seperator2.snp.makeConstraints { (make) in
            make.left.right.equalTo(headerView)
            make.top.equalTo(moduleCollectionView.snp.bottom)
            make.height.equalTo(10)
        }
        
        // 农业头条
        let hotImage = UIImageView()
        hotImage.image = UIImage.init(named: "hot_news")
        headerView.addSubview(hotImage)
        hotImage.snp.makeConstraints { (make) in
            make.top.equalTo(seperator2.snp.bottom).offset(10)
            make.left.equalTo(10)
        }
        
        let line1 = UIView()
        line1.backgroundColor = BaseColor.BackGroundColor
        headerView.addSubview(line1)
        line1.snp.makeConstraints { (make) in
            make.left.right.equalTo(headerView)
            make.top.equalTo(hotImage.snp.bottom).offset(10)
            make.height.equalTo(0.5)
        }
        
        headerView.addSubview(advertScrollView)
        advertScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(line1.snp.bottom)
            make.left.equalTo(-10)
            make.right.equalTo(headerView)
            make.height.equalTo(44)
        }
        
        //当前种植
        let seperator3 = UIView()
        headerView.addSubview(seperator3)
        seperator3.backgroundColor = BaseColor.BackGroundColor
        seperator3.snp.makeConstraints { (make) in
            make.left.right.equalTo(headerView)
            make.top.equalTo(advertScrollView.snp.bottom)
            make.height.equalTo(10)
        }
        
        headerView.addSubview(cropsCollectionView)
        cropsCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(headerView)
            make.top.equalTo(seperator3.snp.bottom)
        }
        
        //当前种植
        let seperator4 = UIView()
        headerView.addSubview(seperator4)
        seperator4.backgroundColor = BaseColor.BackGroundColor
        seperator4.snp.makeConstraints { (make) in
            make.left.right.equalTo(headerView)
            make.top.equalTo(cropsCollectionView.snp.bottom)
            make.height.equalTo(10)
            make.bottom.equalTo(headerView)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, TabBarHeight, 0))
        }
        
        headerView.layoutIfNeeded()
        updateHeaderViewHeight()
        
        contentView.addSubview(floatBtn)
        floatBtn.snp.makeConstraints { (make) in
            make.right.equalTo(view).offset(-10)
            make.bottom.equalTo(view).offset(IS_IPHONE_iPX ? -100 : -60)
            make.width.equalTo(100)
            make.height.equalTo(90)
        }
    }
    
    override func loadData() {
        // 头部滚动视图
        cycleScrollView.imageURLStringsGroup = ["http://img4.imgtn.bdimg.com/it/u=902359164,2443257076&fm=11&gp=0.jpg",
                                                "http://img1.imgtn.bdimg.com/it/u=39962520,1910906011&fm=27&gp=0.jpg",
                                                "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3831640632,3022453093&fm=200&gp=0.jpg"]

        // 新闻滚动
        advertScrollView.titles = ["杀了一个产品🐶祭天","永远不要相信产品说的话","XXX你个产品汪"]
        
        // 当前种植
        let plantData = PlantModel()
        plantData.plant_crop_name = "水果"
        plantData.crop_variety = "爱谁谁"
        cropsCollectionView.dataArray = [plantData,plantData,plantData,plantData,plantData]
        
        //农事活动
        let activityData = FarmActivityModel()
        activityData.created_at = "2017-6-6"
        activityData.activity_ame = "爱农田-Swift版"
        activityData.name = "阡陌"
        activityData.ammount = "100"
        dataArray = [activityData]
        tableView.reloadData()
    }
    
    func updateHeaderViewHeight() {
        headerView.frame.size.height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        tableView.tableHeaderView = headerView
    }
    
    override func rightBtnAction() {
        self.navigationController?.pushViewController(NotificationViewController(), animated: true)
    }
    
    func sellFoodAction() {
        AppCommon.push(SellFoodViewController(), animated: true)
    }
    
    lazy var cycleScrollView: YYCycleScrollView = {
        let cycleScrollView = YYCycleScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 240))
        cycleScrollView.placeHolderImage = IMAGE_PLACEHOLDER
        cycleScrollView.showPageControl = true
        cycleScrollView.callBackWithIndex = { (index : Int) in
//            print("当前网络图片 Index:\(index)")
            AppCommon.push(WebThingsViewController(), animated: true)
        }
        return cycleScrollView
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
    
    lazy var floatBtn: UIButton = {
        let floatBtn = UIButton(type: UIButtonType.custom)
//        floatBtn.isHidden = true
        floatBtn.setImage(UIImage.init(named: "ic_sell_food"), for: .normal)
        floatBtn.addTarget(self, action: #selector(sellFoodAction), for: .touchUpInside)
        return floatBtn
    }()
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
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewController.classTableViewCellIdentifier, for: indexPath) as! FarmRecordCell
        cell.selectionStyle = .none
        cell.activityData = dataArray[indexPath.row] as? FarmActivityModel
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


