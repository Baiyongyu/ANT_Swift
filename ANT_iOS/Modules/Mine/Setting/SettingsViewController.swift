//
//  SettingsViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/6.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    var headerView = UIView()
    var logoImageView = UIImageView()
    var versionLabel = UILabel()
    var companyLabel = UILabel()
    
    var titleArray = Array<Any>()
    var iconArray = Array<Any>()
    var colorArray = Array<Any>()
    
    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text = "设置"
        contentView.addSubview(tableView)
    }
    
    override func layoutConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(NavBarHeight, 0, 0, 0))
        }
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 250)
        
        headerView.addSubview(logoImageView)
        logoImageView.image = UIImage.init(named: "ic_settings_logo")
        logoImageView.layer.cornerRadius = 40
        logoImageView.clipsToBounds = true
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.snp.makeConstraints { (make) in
            make.center.equalTo(headerView)
            make.width.height.equalTo(130)
        }
        
        headerView.addSubview(versionLabel)
        versionLabel.text = "版本号" + CurrentVersion
        versionLabel.font = UIFont.systemFont(ofSize: 12)
        versionLabel.textAlignment = .center
        versionLabel.textColor = UIColor.lightGray
        versionLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(headerView)
            make.top.equalTo(logoImageView.snp.bottom).offset(5)
        }
        
        headerView.addSubview(companyLabel)
        companyLabel.text = "安徽阡陌网络科技有限公司"
        companyLabel.font = UIFont.systemFont(ofSize: 12)
        companyLabel.textAlignment = .center
        companyLabel.textColor = UIColor.lightGray
        companyLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(headerView)
            make.top.equalTo(versionLabel.snp.bottom).offset(10)
        }
        tableView.tableHeaderView = headerView
    }
    
    override func loadData() {
        iconArray = ["\u{e644}","\u{e643}"]
        titleArray = ["清理缓存","退出",]
        colorArray = [UIColor.HexColor(0x52c3ef),UIColor.HexColor(0xfca51a)]
        tableView.reloadData()
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = BaseColor.BackGroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
}

//UITableView - Delegate And DataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.imageView?.image = UIImage.icon(with: TBCityIconInfo.init(text: iconArray[indexPath.row] as! String, size: 18, color: colorArray[indexPath.row] as! UIColor))
        cell.textLabel?.text = titleArray[indexPath.row] as? String
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.detailTextLabel?.text = indexPath.row == 0 ? CacheManager.cacheSize : ""
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(cell.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            cell.separatorInset = .zero
        }
        if(cell.responds(to: #selector(setter: UIView.layoutMargins))){
            cell.layoutMargins = .zero
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let alertView = YYAlertView()
            alertView.initWithTitle(titles: "清理缓存", message: "缓存大小为" + CacheManager.cacheSize + ", 确定要清理吗?", sureTitle: "确定", cancleTitle: "取消")
            alertView.alertSelectIndex = { (index) -> Void in
                if index == 2 {
                    if CacheManager.clearCache() {
                        self.tableView.reloadData()
                    }
                }
            }
            alertView.showAlertView()
            break
        case 1:
            let alertView = YYAlertView()
            alertView.initWithTitle(titles: "退出当前账号？", message: "", sureTitle: "确定", cancleTitle: "取消")
            alertView.alertSelectIndex = { (index) -> Void in
                if index == 2 {
                }
            }
            alertView.showAlertView()
            break
        default:
            break
        }
    }
}
