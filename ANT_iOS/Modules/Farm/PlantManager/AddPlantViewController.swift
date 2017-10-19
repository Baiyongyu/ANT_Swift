//
//  AddPlantViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/19.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

enum PlantInfoType {
    case add    //新增种植信息
    case edit   //编辑种植信息
}

class AddPlantViewController: BaseViewController {

    var plantInfoType: PlantInfoType?
    
    fileprivate static let classTableViewCellIdentifier = "ClassTableViewCell"
    //种植种类
    var plantTypeField = UITextField()
    //种植品种
    var plantVarietyField = UITextField()
    //选择田块
    var addressLabel = UILabel()
    //作物数据
    var cropList = NSArray()
    
    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text =  plantInfoType == PlantInfoType.add ? "添加种植" : "编辑详情"
        rightBtn.isHidden = false
        rightBtn.setTitle("保存", for: .normal)
        contentView.addSubview(tableView)
    }
    
    override func layoutConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(NavBarHeight, 0, 0, 0))
        }
    }
    
    override func loadData() {
        cropList = ["水果","蔬菜","菠萝"]
        tableView.reloadData()
    }
    
    override func rightBtnAction() {
        mainWindow().endEditing(true)
        AppCommon.popViewController(animated: true)
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
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
        return tableView
    }()
    
    lazy var cropPickerView: PopUpPickerView = {
        let cropPickerView = PopUpPickerView()
        cropPickerView.delegate = self
        cropPickerView.dataSource = self
        return cropPickerView
    }()
}

extension AddPlantViewController: PopUpMenuDelegate, PopUpMenuDataSource {
    func popUpMenuTitleForRow(popUpMenu: PopUpPickerView, row: NSInteger, component: NSInteger) -> String {
        if component == 0 {
            if popUpMenu == self.cropPickerView {
                return self.cropList[row] as! String
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
        }
        return 0
    }
}

//UITableView - Delegate And DataSource
extension AddPlantViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: AddPlantViewController.classTableViewCellIdentifier)
        
        switch indexPath.section {
        case 0: // 第一组
            cell.textLabel?.text = "种植作物"
            
            cell.accessoryType = .disclosureIndicator
            plantTypeField = UITextField()
            plantTypeField.font = UIFont.systemFont(ofSize: 14)
            plantTypeField.clearButtonMode = .whileEditing
            plantTypeField.placeholder = "请选择种植种类"
            plantTypeField.textAlignment = .right
            plantTypeField.isEnabled = false
            cell.contentView.addSubview(plantTypeField)
            plantTypeField.snp.makeConstraints({ (make) in
                make.left.equalTo((cell.textLabel?.snp.right)!).offset(5)
                make.top.bottom.equalTo(cell.contentView)
                make.right.equalTo(cell.contentView)
            })
            
        case 1: // 第二组
            switch indexPath.row {
            case 0: // row1
                cell.textLabel?.text = "作物品种"
                
                plantVarietyField = UITextField()
                plantVarietyField.font = UIFont.systemFont(ofSize: 14)
                plantVarietyField.clearButtonMode = .whileEditing
                plantVarietyField.placeholder = "请输入作物品种"
                plantVarietyField.textAlignment = .right
                cell.contentView.addSubview(plantVarietyField)
                plantVarietyField.snp.makeConstraints({ (make) in
                    make.left.equalTo((cell.textLabel?.snp.right)!).offset(5)
                    make.top.bottom.equalTo(cell.contentView)
                    make.right.equalTo(cell.contentView).offset(-15)
                })
            case 1: //  row2
                cell.textLabel?.text = "选择田块"
                
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
                addressLabel.text = "已选择66块田"
            default:
                print("~~~")
            }
            
        default:
            print("~~~")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "必填项" : "选填项"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = BaseColor.BackGroundColor
        let header = UITableViewHeaderFooterView()
        header.contentView.backgroundColor = BaseColor.BackGroundColor
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.systemFont(ofSize: 13)
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = BaseColor.BackGroundColor
        let header = UITableViewHeaderFooterView()
        header.contentView.backgroundColor = BaseColor.BackGroundColor
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 10 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            mainWindow().endEditing(true)
            self.cropPickerView.show()
        default:
            print("~~")
        }
    }
}
