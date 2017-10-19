//
//  SellFoodViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/18.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class SellFoodViewController: BaseViewController {
    
    var dataArray = NSArray()
    fileprivate static let classTableViewCellIdentifier = "ClassTableViewCell"
    
    var nameField = UITextField()
    var phoneField = UITextField()
    var addressLabel = UILabel()
    var amountField = UITextField()
    var confirmBtn = UIButton()
    var tipLabel = UILabel()
    var inputFinished = Bool()
    
    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text = "卖粮信息"
        contentView.addSubview(tableView)
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 150))
        // 提交按钮
        confirmBtn = UIButton(type: UIButtonType.custom)
        confirmBtn.layer.cornerRadius = 5
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        confirmBtn.clipsToBounds = true
        confirmBtn.setTitle("提交", for: .normal)
        confirmBtn.setTitle("已提交", for: .disabled)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.setTitleColor(UIColor.white, for: .highlighted)
        confirmBtn.setTitleColor(UIColor.white, for: .disabled)
        confirmBtn.setBackgroundImage(creatImageWithColor(color: BaseColor.ThemeColor), for: .normal)
        confirmBtn.setBackgroundImage(creatImageWithColor(color: UIColor.lightGray), for: .highlighted)
        confirmBtn.setBackgroundImage(creatImageWithColor(color: UIColor.gray), for: .disabled)
        confirmBtn.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        footerView.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.equalTo(15)
            make.right.equalTo(footerView).offset(-15)
            make.height.equalTo(44)
        }
        
        //提示语
        tipLabel = UILabel()
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.numberOfLines = 0
        tipLabel.textAlignment = .left
        tipLabel.text = "此信息仅用于想出售粮食的农户填写，请确认信息的准确，提交之后我们将很快与您联系!"
        footerView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(confirmBtn.snp.bottom).offset(20)
            make.left.equalTo(15)
            make.right.equalTo(footerView).offset(-10)
        }
        tableView.tableFooterView = footerView
        confirmBtn.isEnabled = !inputFinished
    }
    
    override func layoutConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(NavBarHeight, 0, 0, 0))
        }
    }
    
    override func loadData() {
        dataArray = ["姓名", "联系方式", "家庭地址", "出售数量"]
        tableView.reloadData()
    }
    
    func confirmAction() {
        inputFinished = true
        tipLabel.text = "提交成功后，相关机构会主动联系您，请耐心等待!"
        tipLabel.textAlignment = .center
        confirmBtn.isEnabled = false
        nameField.isEnabled = false
        phoneField.isEnabled = false
        amountField.isEnabled = false
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = BaseColor.BackGroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: classTableViewCellIdentifier)
        tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
        return tableView
    }()
}

//UITableView - Delegate And DataSource
extension SellFoodViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: SellFoodViewController.classTableViewCellIdentifier)
        cell.textLabel?.text = dataArray[indexPath.row] as? String
        switch indexPath.row {
        case 0:
            nameField = UITextField()
            nameField.font = UIFont.systemFont(ofSize: 14)
            nameField.clearButtonMode = .whileEditing
            nameField.placeholder = "请输入姓名"
            nameField.textAlignment = .right
            cell.contentView.addSubview(nameField)
            nameField.snp.makeConstraints({ (make) in
                make.left.equalTo((cell.textLabel?.snp.right)!).offset(5)
                make.top.bottom.equalTo(cell.contentView)
                make.right.equalTo(cell.contentView).offset(-15)
            })
            nameField.isEnabled = !inputFinished
            
        case 1:
            phoneField = UITextField()
            phoneField.font = UIFont.systemFont(ofSize: 14)
            phoneField.clearButtonMode = .whileEditing
            phoneField.placeholder = "请输入手机号"
            phoneField.textAlignment = .right
            cell.contentView.addSubview(phoneField)
            phoneField.snp.makeConstraints({ (make) in
                make.left.equalTo((cell.textLabel?.snp.right)!).offset(5)
                make.top.bottom.equalTo(cell.contentView)
                make.right.equalTo(cell.contentView).offset(-15)
            })
            phoneField.isEnabled = !inputFinished
            
        case 2:
            cell.accessoryType = .disclosureIndicator
            let addressLabel = UILabel()
            addressLabel.textAlignment = .right
            addressLabel.numberOfLines = 0
            addressLabel.font = UIFont.systemFont(ofSize: 14)
            addressLabel.textColor = BaseColor.GrayColor
            cell.contentView.addSubview(addressLabel)
            addressLabel.snp.makeConstraints({ (make) in
                make.left.equalTo((cell.textLabel?.snp.right)!).offset(5)
                make.top.bottom.equalTo(cell.contentView)
                make.right.equalTo(cell).offset(-30)
            })
            self.addressLabel = addressLabel
            addressLabel.text = "中华人民共和国"
            
        case 3:
            amountField = UITextField()
            amountField.font = UIFont.systemFont(ofSize: 14)
            amountField.placeholder = "请输入数量"
            amountField.textAlignment = .right
            amountField.keyboardType = .decimalPad
            amountField.rightViewMode = .always
            let unitLabel = UILabel()
            unitLabel.textAlignment = .right
            unitLabel.font = UIFont.systemFont(ofSize: 14)
            unitLabel.textColor = BaseColor.GrayColor
            unitLabel.frame = CGRect(x: 0, y: 0, width: 25, height: 44)
            unitLabel.text = "吨"
            amountField.rightView = unitLabel
            cell.contentView.addSubview(amountField)
            amountField.snp.makeConstraints({ (make) in
                make.left.equalTo((cell.textLabel?.snp.right)!).offset(5)
                make.top.bottom.equalTo(cell.contentView)
                make.right.equalTo(cell.contentView).offset(-15)
            })
            amountField.isEnabled = !inputFinished
            
        default:
            print("~~~")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 2 {
            if !inputFinished {
                AppCommon.push(LocationMapViewController(), animated: true)
            }
        }
    }
}
