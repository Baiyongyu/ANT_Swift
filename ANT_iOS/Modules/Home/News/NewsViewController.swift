//
//  NewsViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/29.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class NewsViewController: BaseViewController {
    
    var dataArray = [NewsModel]()
    
    fileprivate static let classTableViewCellIdentifier = "ClassTableViewCell"
    
    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text = "资讯"
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(NavBarHeight, 0, 0, 0));
        }
    }
    
    override func loadData() {
        
        //没有图片的
        let newsData = NewsModel()
        newsData.title = "喜迎十九大，共筑中国梦，习大大棒棒哒"
        newsData.news_source = "大东北帝国"
        newsData.create_date = "2017-10-18"
        newsData.newsTableViewCellType = NewsTableViewCellType.No
        
        
        //显示一张图片的
        let newsData0 = NewsModel()
        newsData0.title = "中华人民共和国北京天安门广场故宫中华人民共和国北京天安门广场故宫"
        newsData0.news_source = "帝都北京"
        newsData0.create_date = "2017-10-18"
        newsData0.newsTableViewCellType = NewsTableViewCellType.OnlyOne
        let imgUrls = "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3117715598,2303270080&fm=200&gp=0.jpg"
        let imgArray = NSMutableArray()
        for imageUrl in imgUrls.components(separatedBy: "(^#~") {
            let imgData = ImageModel()
            imgData.title_image = imageUrl
            imgArray.add(imgData)
        }
        newsData0.imagePathsArray = imgArray
        
        
        // 三张图片
        let newsData1 = NewsModel()
        newsData1.title = "长风破浪会有时，直挂云帆济沧海。加油我的国。"
        newsData1.news_source = "魔都上海"
        newsData1.create_date = "2017-10-18"
        newsData1.newsTableViewCellType = NewsTableViewCellType.Three
        let imgUrls0 = "http://img4.imgtn.bdimg.com/it/u=1176598408,294684300&fm=11&gp=0.jpg(^#~http://img4.imgtn.bdimg.com/it/u=611621945,585367517&fm=27&gp=0.jpg(^#~https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3831640632,3022453093&fm=200&gp=0.jpg"
        let imgArray0 = NSMutableArray()
        for imageUrl in imgUrls0.components(separatedBy: "(^#~") {
            let imgData = ImageModel()
            imgData.title_image = imageUrl
            imgArray0.add(imgData)
        }
        newsData1.imagePathsArray = imgArray0
        
        dataArray = [newsData,newsData0,newsData1,newsData0,newsData,newsData1]
        tableView.reloadData()
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = BaseColor.BackGroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: classTableViewCellIdentifier)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsViewController.classTableViewCellIdentifier, for: indexPath) as! NewsTableViewCell
        cell.newsData = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        // 还不会约束，总是蹦，先这样吧。
        switch indexPath.row {
        case 0:
            return 60
        case 1:
            return 110
        case 2:
            return 170
        case 3:
            return 110
        case 4:
            return 60
        case 5:
            return 170
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        AppCommon.push(NewsDetailsViewController(), animated: true)
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if(cell.responds(to: #selector(setter: UITableViewCell.separatorInset))){
//            cell.separatorInset = .zero
//        }
//        if(cell.responds(to: #selector(setter: UIView.layoutMargins))){
//            cell.layoutMargins = .zero
//        }
//    }
}
