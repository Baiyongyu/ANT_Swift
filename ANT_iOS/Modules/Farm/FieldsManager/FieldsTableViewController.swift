//
//  FieldsTableViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/13.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class FieldsTableViewController: UITableViewController {

    var dataArray = NSArray() {
        didSet {
            dataArray.copy()
//            dataArray.setValue(true, forKey: "isOpen")
            tableView.reloadData()
        }
    }
    var section = NSNumber()
    fileprivate static let classTableViewCellIdentifier = "ClassTableViewCell"
    fileprivate static let TableViewHeaderIdentifier = "TableViewHeaderIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(FieldCell.self, forCellReuseIdentifier: FieldsTableViewController.classTableViewCellIdentifier)
        tableView.register(FieldsGroupHeaderView.self, forHeaderFooterViewReuseIdentifier: FieldsTableViewController.TableViewHeaderIdentifier)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var fieldGroupData = FieldGroupModel()
        fieldGroupData = dataArray[section] as! FieldGroupModel
//        return fieldGroupData.isOpen! ? (fieldGroupData.field_list?.count)! : 0
        return (fieldGroupData.field_list?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FieldsTableViewController.classTableViewCellIdentifier, for: indexPath) as! FieldCell
        
        var fieldGroupData = FieldGroupModel()
        fieldGroupData = dataArray[indexPath.section] as! FieldGroupModel
        var fieldData = FieldModel()
        fieldData = fieldGroupData.field_list?[indexPath.row] as! FieldModel
        fieldData.group_name = fieldGroupData.group_name
        cell.fieldData = fieldData;
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FieldsTableViewController.TableViewHeaderIdentifier) as! FieldsGroupHeaderView
        headerView.section = section as NSNumber
        headerView.fieldGroupData = dataArray[section] as? FieldGroupModel
//        headerView.spreadStatusChangeBlock = { ( objc ) -> Void in
//            var section = NSInteger()
//            section = objc as! NSInteger
//            var fieldGroupData = FieldGroupModel()
//            fieldGroupData = self.dataArray[section] as! FieldGroupModel
//            fieldGroupData.isOpen = !fieldGroupData.isOpen!
//            self.tableView.reloadData()
//        }
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(cell.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            cell.separatorInset = .zero
        }
        if(cell.responds(to: #selector(setter: UIView.layoutMargins))){
            cell.layoutMargins = .zero
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class FieldsGroupHeaderView: UITableViewHeaderFooterView {
    
    var section: NSNumber?
    typealias SpreadStatusChangeBlock = (_ objc: AnyObject) -> Void
    var spreadStatusChangeBlock: SpreadStatusChangeBlock?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        contentView.addLineOnBottom()
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(spreadBtn)
        
        let topSeperator = UIView()
        topSeperator.backgroundColor = BaseColor.BackGroundColor
        contentView.addSubview(topSeperator)
        topSeperator.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.bottom.equalTo(contentView)
            make.left.equalTo(10)
            make.right.lessThanOrEqualTo(spreadBtn.snp.left);
        }
        
        spreadBtn.frame = CGRect(x: SCREEN_WIDTH-44, y: 10, width: 44, height: 44)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(spreadAction))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    func spreadAction() {
        spreadBtn.isSelected = !spreadBtn.isSelected
        if spreadStatusChangeBlock != nil {
            spreadStatusChangeBlock!(section!)
        }
    }
    
    var fieldGroupData: FieldGroupModel? {
        didSet {
            titleLabel.text = "\(String(describing: (fieldGroupData?.group_name)!)) ：共" + "\(String(describing: (fieldGroupData?.field_list?.count)!))块田，" + "\(String(describing: (fieldGroupData?.total_area_size)!))亩"
        }
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        return titleLabel
    }()
    
    lazy var spreadBtn: UIButton = {
        let spreadBtn = UIButton(type: UIButtonType.custom)
        spreadBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e618}", size: 15, color: UIColor.black)), for: .normal)
        spreadBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e63a}", size: 15, color: UIColor.black)), for: .selected)
        
        return spreadBtn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FieldCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(fieldImageView)
        contentView.addSubview(fieldNameLabel)
        contentView.addSubview(fieldAcreageLabel)
        contentView.addSubview(fieldCropLabel)
        layoutConstraints()
    }
    
    func layoutConstraints() {
        fieldImageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(80)
        }
        
        fieldNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(fieldImageView.snp.right).offset(15)
            make.top.equalTo(fieldImageView)
            make.right.equalTo(contentView).offset(-10)
        }
        
        fieldAcreageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(fieldImageView);
            make.right.equalTo(contentView).offset(-10);
        }
        
        fieldCropLabel.snp.makeConstraints { (make) in
            make.left.equalTo(fieldImageView.snp.right).offset(15);
            make.top.equalTo(fieldNameLabel.snp.bottom).offset(22);
            make.right.equalTo(contentView).offset(-10);
        }
    }
    
    var fieldData: FieldModel? {
        didSet {
            fieldImageView.kf.setImage(with: NSURL.init(string: (fieldData?.thumbnail_url)!)! as URL, placeholder: IMAGE_PLACEHOLDER, options: nil, progressBlock: nil, completionHandler: nil)
            fieldNameLabel.text = fieldData?.field_name
            fieldAcreageLabel.text = "\(String(describing: (fieldData?.area_size)!))亩"
            fieldCropLabel.text = fieldData?.crop_list.value(forKey: "plant_crop_nam") as? String
        }
    }
    
    lazy var fieldImageView: UIImageView = {
        let fieldImageView = UIImageView()
        fieldImageView.contentMode = .scaleAspectFit
        return fieldImageView
    }()
    
    lazy var fieldNameLabel: UILabel = {
        let fieldNameLabel = UILabel()
        fieldNameLabel.font = UIFont.systemFont(ofSize: 14)
        return fieldNameLabel
    }()
    
    lazy var fieldAcreageLabel: UILabel = {
        let fieldAcreageLabel = UILabel ()
        fieldAcreageLabel.font = UIFont.systemFont(ofSize: 14)
        fieldAcreageLabel.textAlignment = .right
        return fieldAcreageLabel
    }()
    
    lazy var fieldCropLabel: UILabel = {
        let fieldCropLabel = UILabel()
        fieldCropLabel.font = UIFont.systemFont(ofSize: 14)
        return fieldCropLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

