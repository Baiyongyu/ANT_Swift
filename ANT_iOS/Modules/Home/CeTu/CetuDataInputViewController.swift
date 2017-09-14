//
//  CetuDataInputViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/12.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class CetuDataInputViewController: BaseViewController {
    
    var cropField = UITextField()
    var typeField = UITextField()
    var yeidField = UITextField()
    var companyField = UITextField()
    
    var cropList = NSArray()
    var shopList = NSArray()
    
    var titleArray = NSArray()
    var dataArray = NSArray()
    
    override func loadSubViews() {
        super.loadSubViews()
        self.titleLabel.text = "免费测追肥"
        self.contentView.addSubview(self.tableView)
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 80)
        
        let tipLabel = UILabel()
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.numberOfLines = 0
        tipLabel.text = "完善信息后会为您提供免费测土服务"
        headerView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10);
            make.right.equalTo(headerView).offset(-10);
            make.centerY.equalTo(headerView);
        }
        self.tableView.tableHeaderView = headerView
        
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 100)
        
        let confirmBtn = UIButton(type: UIButtonType.custom)
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.setTitle("预约成功，等待测土", for: .disabled)
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.backgroundColor = BaseColor.ThemeColor
        confirmBtn.layer.cornerRadius = 5.0
        confirmBtn.clipsToBounds = true
        footerView.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.left.equalTo(10);
            make.centerY.equalTo(footerView);
            make.right.equalTo(footerView).offset(-10);
            make.height.equalTo(44);
        }
        self.tableView.tableFooterView = footerView
    }
    
    override func layoutConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 0, 0));
        }
    }
    
    override func loadData() {
        titleArray = ["种植作物：", "作物品种：", "上季产量：", "测土机构："]
        cropList = ["水果","蔬菜","菠萝"]
        shopList = ["阡陌","腾讯","阿里"]
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
    
    lazy var cropPickerView: PopUpPickerView = {
        let cropPickerView = PopUpPickerView()
        cropPickerView.delegate = self
        cropPickerView.dataSource = self
        return cropPickerView
    }()
    
    lazy var shopPickerView: PopUpPickerView = {
        let shopPickerView = PopUpPickerView()
        shopPickerView.delegate = self
        shopPickerView.dataSource = self
        return shopPickerView
    }()
}

extension CetuDataInputViewController: PopUpMenuDelegate, PopUpMenuDataSource {
    func popUpMenuTitleForRow(popUpMenu: PopUpPickerView, row: NSInteger, component: NSInteger) -> String {
        if component == 0 {
            if popUpMenu == self.cropPickerView {
                return self.cropList[row] as! String
            }
            if popUpMenu == self.shopPickerView {
                return self.shopList[row] as! String
            }
        }
        return ""
    }
    
    func popUpMenuDidSelectRowArray(popUpMenu: PopUpPickerView, rowArray: NSArray) {
        
    }
    
    func popUpMenuNumberOfComponentsInPickerView(popUpMenu: PopUpPickerView) -> NSInteger {
        return 1
    }
    
    func popUpMenuNumberOfRowsInComponent(popUpMenu: PopUpPickerView, component: NSInteger) -> NSInteger {
        if component == 0 {
            if popUpMenu == self.cropPickerView {
                return self.cropList.count
            }
            if popUpMenu == self.shopPickerView {
                return self.shopList.count
            }
        }
        return 0
    }
}

//UITableView - Delegate And DataSource
extension CetuDataInputViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(15);
            make.top.bottom.equalTo(cell);
            make.width.equalTo(80);
        })
        cell.textLabel?.text = titleArray[indexPath.row] as? String
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        
        switch indexPath.row {
        case 0:
            cell.accessoryType = .disclosureIndicator
            cropField.font = UIFont.systemFont(ofSize: 14)
            cropField.isEnabled = false
            cropField.textAlignment = .right
            cell.contentView.addSubview(cropField)
            cropField.snp.makeConstraints({ (make) in
                make.left.equalTo((cell.textLabel?.snp.right)!).offset(5);
                make.top.bottom.equalTo(cell.contentView);
                make.right.equalTo(cell).offset(-40);
            })
            cropField.text = "菠菜"
        case 1:
            typeField.font = UIFont.systemFont(ofSize: 14)
            typeField.textAlignment = .right
            cell.contentView.addSubview(typeField)
            typeField.snp.makeConstraints({ (make) in
                make.left.equalTo((cell.textLabel?.snp.right)!).offset(5);
                make.top.bottom.equalTo(cell.contentView);
                make.right.equalTo(cell).offset(-40);
            })
            typeField.text = "蔬菜"
        case 2:
            yeidField.font = UIFont.systemFont(ofSize: 14)
            yeidField.keyboardType = .decimalPad
            yeidField.clearButtonMode = .whileEditing
            yeidField.placeholder = "请输入种植亩数"
            yeidField.textAlignment = .right
            cell.contentView.addSubview(yeidField)
            yeidField.snp.makeConstraints({ (make) in
                make.right.equalTo(cell).offset(-20);
                make.width.equalTo(200);
                make.top.bottom.equalTo(cell.contentView);
            })
            yeidField.rightViewMode = .always
            let unitLabel = UILabel()
            unitLabel.textAlignment = .right
            unitLabel.font = UIFont.systemFont(ofSize: 14)
            unitLabel.textColor = UIColor.lightGray
            unitLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
            unitLabel.text = "公斤/亩"
            yeidField.rightView = unitLabel
            yeidField.text = "100"
        case 3:
            cell.accessoryType = .disclosureIndicator
            companyField.font = UIFont.systemFont(ofSize: 14)
            companyField.textAlignment = .right
            companyField.isEnabled = false
            cell.contentView.addSubview(companyField)
            companyField.snp.makeConstraints({ (make) in
                make.left.equalTo((cell.textLabel?.snp.right)!).offset(5);
                make.top.bottom.equalTo(cell.contentView);
                make.right.equalTo(cell).offset(-40);
            })
            companyField.text = "阡陌"
        default: break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            self.view.endEditing(true)
            self.cropPickerView.show()
        }
        if indexPath.row == 3 {
            self.view.endEditing(true)
            self.shopPickerView.show()
        }
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
