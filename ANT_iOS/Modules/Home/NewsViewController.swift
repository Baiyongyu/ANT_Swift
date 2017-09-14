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
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(64, 0, 0, 0));
        }
    }
    
    override func loadData() {
        let newsData = NewsModel()
        newsData.title = "爱农田-Swift版"
        newsData.news_source = "大东北帝国"
        newsData.create_date = "2017-6-30"
        newsData.title_image = "http://img2.imgtn.bdimg.com/it/u=960594752,2162202648&fm=26&gp=0.jpg"
        
        let imgData = ImageModel()
        imgData.title_image = "http://img2.imgtn.bdimg.com/it/u=960594752,2162202648&fm=26&gp=0.jpg"
        newsData.imagePathsArray?.adding(imgData)
        
        
        let newsData1 = NewsModel()
        newsData1.title = "爱农田-"
        newsData1.news_source = "芜湖帝国"
        newsData1.create_date = "2017-6-30"
        newsData1.title_image = "http://img2.imgtn.bdimg.com/it/u=960594752,2162202648&fm=26&gp=0.jpg"
        newsData1.imagePathsArray?.adding(imgData)
        dataArray = [newsData,newsData,newsData1,newsData1]
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
        return 170
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
