//
//  AddressListViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/8.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class AddressListViewController: BaseViewController, AddressUpdateDelegate {

    var dataArray = NSMutableArray()
    var currentIndexPath = NSIndexPath()
    
    fileprivate static let classTableViewCellIdentifier = "ClassTableViewCell"
    
    override func loadSubViews() {
        super.loadSubViews()
        self.titleLabel.text = "地址列表"
        self.contentView.addSubview(self.tableView)
    }
    
    override func layoutConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 0, 0));
        }
        
        self.contentView.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view);
            make.height.equalTo(50);
        }
        
        self.contentView.addSubview(clickBtn)
        clickBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.bottomBar).offset(10);
            make.right.equalTo(self.bottomBar).offset(-10);
            make.bottom.equalTo(self.bottomBar).offset(-5);
            make.top.equalTo(self.bottomBar).offset(5);
        }
    }
    
    override func loadData() {
        let addressData = AddressModel()
        addressData.receiver_name = "宇玄"
        addressData.receiver_phone = "13520245101"
        addressData.address_detail = "中华人民共和国黑龙江省哈尔滨尚志市"
        addressData.is_default = true
        
        let addressData1 = AddressModel()
        addressData1.receiver_name = "阡陌"
        addressData1.receiver_phone = "13666666666"
        addressData1.address_detail = "中华人民共和国安徽省芜湖市"
        addressData1.is_default = false
    
        self.dataArray = [addressData,addressData1]
        self.tableView.reloadData()
    }
    
    func updateAddress(addressInfo: AddressModel, actionType: AddressActionType) {
        
        switch actionType {
            case .Default:
                print("设为默认")
                break
            case .Edit:
                AppCommon.push(AddressEditViewController(), animated: true)
                break
            case .Delete:
                let alertController = UIAlertController(title: "确定要删除该地址吗?", message: nil, preferredStyle: .alert)
                let confirm = UIAlertAction(title: "确定", style: .destructive, handler: { (alertController:UIAlertAction) in
                    print("删除地址")
                    self.dataArray.removeAllObjects()
                    self.tableView.reloadData()
                })
            
                let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alertController.addAction(confirm)
                alertController.addAction(cancel)
                self.present(alertController, animated: true, completion: nil)
                break
        }
    }
    
    func addAddressAction() {
        AppCommon.push(AddressEditViewController(), animated: true)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = BaseColor.BackGroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.register(AddressCell.self, forCellReuseIdentifier: classTableViewCellIdentifier)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    lazy var bottomBar: UIView = {
        let bottomBar = UIView()
        bottomBar.backgroundColor = UIColor.white
        bottomBar.layer.shadowOffset = CGSize(width: 0, height: -0.3)
        bottomBar.layer.shadowColor = UIColor.init(white: 0, alpha: 0.4).cgColor
        bottomBar.layer.shadowOpacity = 0.5
        return bottomBar
    }()
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton(type: UIButtonType.custom)
        clickBtn.backgroundColor = UIColor.orange
        clickBtn.setTitle("添加新地址", for: .normal)
        clickBtn.setTitleColor(UIColor.white, for: .normal)
        clickBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        clickBtn.layer.cornerRadius = 3.0
        clickBtn.addTarget(self, action: #selector(addAddressAction), for: .touchUpInside)
        return clickBtn
    }()
}

extension AddressListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressListViewController.classTableViewCellIdentifier, for: indexPath) as! AddressCell
        cell.delegate = self as AddressUpdateDelegate
        cell.addressData = self.dataArray[indexPath.row] as? AddressModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if(cell.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            cell.separatorInset = .zero
        }
        if(cell.responds(to: #selector(setter: UIView.layoutMargins))){
            cell.layoutMargins = .zero
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

enum AddressActionType {
    case Default       //设为默认
    case Edit          //编辑
    case Delete        //删除
}

// 声明协议
protocol AddressUpdateDelegate {
    //协议方法
    func updateAddress(addressInfo: AddressModel, actionType: AddressActionType)
}

class AddressCell: UITableViewCell {
    
    // 声明代理
    var delegate:AddressUpdateDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameAndTelLabel)
        nameAndTelLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.equalTo(15);
        }
        
        contentView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameAndTelLabel.snp.bottom).offset(10);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.greaterThanOrEqualTo(40);
        }
        
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(self.addressLabel.snp.bottom).offset(10);
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(0.5);
        }
        
        contentView.addSubview(defaultBtn)
        defaultBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.lineView.snp.bottom);
            make.left.equalTo(self.contentView).offset(20);
            make.height.equalTo(40);
            make.width.greaterThanOrEqualTo(80);
            make.bottom.equalTo(self.contentView);
        }
        
        contentView.addSubview(deleteBtn)
        deleteBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.lineView.snp.bottom);
            make.right.equalTo(self.contentView).offset(-10);
            make.width.greaterThanOrEqualTo(50);
            make.height.equalTo(40);
            make.bottom.equalTo(self.contentView);
        }
        
        contentView.addSubview(editBtn)
        editBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.lineView.snp.bottom);
            make.right.equalTo(self.deleteBtn.snp.left).offset(-10);
            make.width.greaterThanOrEqualTo(50);
            make.height.equalTo(40);
            make.bottom.equalTo(self.contentView);
        }
    }
    
    
    var addressData: AddressModel? {
        didSet {
            nameAndTelLabel.text = (addressData?.receiver_name)! + (addressData?.receiver_phone)!
            addressLabel.text = addressData?.address_detail
            if (addressData?.is_default)! {
                self.defaultBtn.isSelected = true
            }else {
                self.defaultBtn.isSelected = false
            }
        }
    }
    
    func defaultBtnAction(_ button: UIButton) {
        self.delegate?.updateAddress(addressInfo: addressData!, actionType: AddressActionType.Default)
    }
    func editBtnAction(_ button: UIButton) {
        self.delegate?.updateAddress(addressInfo: addressData!, actionType: AddressActionType.Edit)
    }
    func deleteBtnAction(_ button: UIButton) {
        self.delegate?.updateAddress(addressInfo: addressData!, actionType: AddressActionType.Delete)
    }
    
    lazy var nameAndTelLabel: UILabel = {
        let nameAndTelLabel = UILabel()
        nameAndTelLabel.font = UIFont.systemFont(ofSize: 16)
        nameAndTelLabel.textColor = BaseColor.BlackColor
        return nameAndTelLabel
    }()
    
    
    lazy var addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.font = UIFont.systemFont(ofSize: 14)
        addressLabel.numberOfLines = 0
        addressLabel.textColor = UIColor.lightGray
        return addressLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = BaseColor.BackGroundColor
        return lineView
    }()
    
    lazy var defaultBtn: UIButton = {
        let defaultBtn = UIButton(type: UIButtonType.custom)
        defaultBtn.setTitle("  设为默认", for: .normal)
        defaultBtn.setTitle("  默认地址", for: .selected)
        defaultBtn.setTitleColor(UIColor.black, for: .normal)
        defaultBtn.setTitleColor(UIColor.orange, for: .selected)
        defaultBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        defaultBtn.setImage(UIImage(named: "ic_unselected"), for: .normal)
        defaultBtn.setImage(UIImage(named: "ic_selected"), for: .selected)
        defaultBtn.addTarget(self, action: #selector(defaultBtnAction(_:)), for: .touchUpInside)
        return defaultBtn
    }()
    
    lazy var editBtn: UIButton = {
        let editBtn = UIButton(type: UIButtonType.custom)
        editBtn.setTitle("  编辑", for: .normal)
        editBtn.setTitleColor(UIColor.black, for: .normal)
        editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        editBtn.setImage(UIImage(named: "IC_user_bianji"), for: .normal)
        editBtn.addTarget(self, action: #selector(editBtnAction(_:)), for: .touchUpInside)
        return editBtn
    }()
    
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton(type: UIButtonType.custom)
        deleteBtn.setTitle("  删除", for: .normal)
        deleteBtn.setTitleColor(UIColor.black, for: .normal)
        deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        deleteBtn.setImage(UIImage(named: "IC_user_shanchu"), for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteBtnAction(_:)), for: .touchUpInside)
        return deleteBtn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



