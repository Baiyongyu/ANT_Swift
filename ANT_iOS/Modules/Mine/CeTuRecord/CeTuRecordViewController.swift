//
//  CeTuRecordViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/19.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class CeTuRecordViewController: BaseViewController {
    
    var dataArray = NSArray()
    var desArray = NSArray()
    
    fileprivate static let classTableViewCellIdentifier = "ClassTableViewCell"
    
    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text = "测土配肥记录"
        contentView.addSubview(tableView)
    }
    
    override func layoutConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(NavBarHeight, 0, 0, 0))
        }
    }
    
    override func loadData() {
        dataArray = ["基肥测土申请(阡陌科技)", "基肥测土申请(阡陌科技)", "追肥测土申请(阡陌科技)", "追肥测土申请(阡陌科技)",
                     "基肥测土申请(阡陌科技)", "基肥测土申请(阡陌科技)", "追肥测土申请(阡陌科技)", "追肥测土申请(阡陌科技)"]
        desArray = ["2017-10-19", "2017-10-19", "2017-10-19", "2017-10-19",
                    "2017-10-19", "2017-10-19", "2017-10-19", "2017-10-19"]
        tableView.reloadData()
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = BaseColor.BackGroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: classTableViewCellIdentifier)
        tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
}

//UITableView - Delegate And DataSource
extension CeTuRecordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: CeTuRecordViewController.classTableViewCellIdentifier)
        cell.textLabel?.textColor = BaseColor.GrayColor
        cell.textLabel?.text = dataArray[indexPath.row] as? String
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.detailTextLabel?.textColor = BaseColor.LightGrayColor
        cell.detailTextLabel?.text = desArray[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
