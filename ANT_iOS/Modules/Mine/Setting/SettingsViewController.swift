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
    
    var titleArray = NSArray()
    var iconArray = NSArray()
    
    override func loadSubViews() {
        super.loadSubViews()
        self.titleLabel.text = "设置"
        self.contentView.addSubview(tableView)
    }
    
    override func layoutConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 0, 0));
        }
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 250)
        
        headerView.addSubview(logoImageView)
        logoImageView.image = UIImage.init(named: "ic_settings_logo")
        logoImageView.layer.cornerRadius = 40
        logoImageView.clipsToBounds = true
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.snp.makeConstraints { (make) in
            make.center.equalTo(headerView);
            make.width.height.equalTo(130);
        }
        
        headerView.addSubview(versionLabel)
        versionLabel.text = "版本号" + currentVersion
        versionLabel.font = UIFont.systemFont(ofSize: 12)
        versionLabel.textAlignment = .center
        versionLabel.textColor = UIColor.lightGray
        versionLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(headerView);
            make.top.equalTo(logoImageView.snp.bottom).offset(5);
        }
        
        headerView.addSubview(companyLabel)
        companyLabel.text = "安徽阡陌网络科技有限公司"
        companyLabel.font = UIFont.systemFont(ofSize: 12)
        companyLabel.textAlignment = .center
        companyLabel.textColor = UIColor.lightGray
        companyLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(headerView);
            make.top.equalTo(versionLabel.snp.bottom).offset(10);
        }
        self.tableView.tableHeaderView = self.headerView
        
    }
    
    override func loadData() {
        self.iconArray = ["ic_settings_clean","ic_settings_logout"];
        self.titleArray = ["清理缓存","退出",];
        self.tableView.reloadData()
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
        return self.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        
        cell.imageView?.image = UIImage.init(named: iconArray[indexPath.row] as! String)
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
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: "清理缓存", message: "缓存大小为" + CacheManager.cacheSize + ", 确定要清理吗?", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "确定", style: .destructive, handler: { (alertController:UIAlertAction) in
                if CacheManager.clearCache() {
                    self.tableView.reloadData()
                }
            })
            
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(confirm)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
