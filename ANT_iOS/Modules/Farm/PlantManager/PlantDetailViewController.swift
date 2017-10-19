//
//  PlantDetailViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/18.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

enum IntoPlantDetailType {
    case current    //当前种植
    case history    //历史种植
}

class PlantDetailViewController: BaseViewController {

    var titleArray = NSArray()
    var desArray = NSArray()
    var dataArray = NSArray()
    
    fileprivate static let classHeadViewTableViewCellIdentifier = "ClassHeadViewTableViewCell"
    fileprivate static let classSystomTableViewCellIdentifier = "ClassSystomTableViewCell"
    fileprivate static let classCustomTableViewCellIdentifier = "ClassCustomTableViewCell"
    
    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text = "种植详情"
        rightBtn.isHidden = false
        rightBtn.setTitle("编辑", for: .normal)
        contentView.addSubview(tableView)
    }
    
    override func layoutConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(NavBarHeight, 0, 64, 0))
        }
        
        contentView.addSubview(clickBtn)
        clickBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.bottom.equalTo(view).offset(IS_IPHONE_iPX ? -34 : -10)
            make.height.equalTo(44)
        }
    }
    
    override func loadData() {
        titleArray = ["种植作物", "种植品种", "种植面积", "种植类型"]
        desArray = ["小苹果", "水果", "500W", "当前种植"]
        
        let fieldGroupData = GroupListModel()
        fieldGroupData.group_name = "天宫一号"
        fieldGroupData.field_name = "1号田，2号田，3号田，4号田，5号田，6号田，"
        dataArray = [fieldGroupData,fieldGroupData,fieldGroupData,fieldGroupData,fieldGroupData]
        
        tableView.reloadData()
    }
    
    func clickAction() {
        YYSheetView.actionSheet().showActionSheetWithTitles(["种植结束，进入休耕期，可在历史种植中查询","休耕"], { (index) in
            switch index {
            case 0:
                AppCommon.push(PublishViewController(), animated: true)
            case 1:
                AppCommon.push(PublishViewController(), animated: true)
            default:
                break
            }
        })
    }
    
    override func rightBtnAction() {
        let addPlant = AddPlantViewController()
        addPlant.plantInfoType = PlantInfoType.edit
        AppCommon.push(addPlant, animated: true)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = BaseColor.BackGroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.register(PlantDetailHeaderView.self, forHeaderFooterViewReuseIdentifier: classHeadViewTableViewCellIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: classSystomTableViewCellIdentifier)
        tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        tableView.tableFooterView = UIView(frame: .zero)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
        return tableView
    }()
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton(type: UIButtonType.custom)
        clickBtn.backgroundColor = BaseColor.ThemeColor
        clickBtn.setTitle("休  耕", for: .normal)
        clickBtn.setTitleColor(UIColor.white, for: .normal)
        clickBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        clickBtn.layer.cornerRadius = 3
        clickBtn.layer.shadowOffset = CGSize(width: 0, height: -0.3)
        clickBtn.layer.shadowColor = UIColor.init(white: 0, alpha: 0.4).cgColor
        clickBtn.layer.shadowOpacity = 0.5
        clickBtn.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        return clickBtn
    }()
}

//UITableView - Delegate And DataSource
extension PlantDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? titleArray.count : dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: PlantDetailViewController.classSystomTableViewCellIdentifier)
            cell.selectionStyle = .none
            cell.textLabel?.text = titleArray[indexPath.row] as? String
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.detailTextLabel?.text = desArray[indexPath.row] as? String
            return cell
        }
        let cell = LocationFieldCell(style: .value1, reuseIdentifier: PlantDetailViewController.classCustomTableViewCellIdentifier)
        cell.fieldGroupData = dataArray[indexPath.row] as? GroupListModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 44 : 66
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PlantDetailViewController.classHeadViewTableViewCellIdentifier) as! PlantDetailHeaderView
            headerView.valueTitle = "共66块田"
            headerView.valueLabel.textColor = UIColor.gray
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.01 : 54
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// 分组组头
class PlantDetailHeaderView: UITableViewHeaderFooterView {
    
    var valueTitle: String? {
        didSet {
            self.valueLabel.text = valueTitle
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.white
        contentView.addLineOnBottom()
        
        let topSeperator = UIView()
        topSeperator.backgroundColor = BaseColor.BackGroundColor
        contentView.addSubview(topSeperator)
        topSeperator.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(10)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.height.equalTo(44)
            make.bottom.equalTo(contentView)
        }
        
        contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.equalTo(-15)
            make.height.equalTo(44)
            make.bottom.equalTo(contentView)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "所在田块"
        return titleLabel
    }()
    
    lazy var valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.font = UIFont.systemFont(ofSize: 14)
        return valueLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 田块cell
class LocationFieldCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        buildCellView()
    }
    
    func buildCellView() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.width.greaterThanOrEqualTo(200)
        }
        
        contentView.addSubview(desLabel)
        desLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5);
            make.left.equalTo(15);
            make.right.equalTo(-15);
            make.bottom.equalTo(-10);
            make.height.greaterThanOrEqualTo(1);
        }
        desLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH - 30)
        desLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: UILayoutConstraintAxis.horizontal)
    }
    
    var fieldGroupData: GroupListModel? {
        didSet {
            titleLabel.text = fieldGroupData?.group_name
            desLabel.text = fieldGroupData?.field_name
        }
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        return titleLabel
    }()
    
    lazy var desLabel: UILabel = {
        let desLabel = UILabel()
        desLabel.font = UIFont.systemFont(ofSize: 14)
        desLabel.numberOfLines = 0
        return desLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

