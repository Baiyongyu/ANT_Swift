//
//  PlantManagerViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/13.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class PlantManagerViewController: BaseViewController {
    
    var dataArray = NSArray()
    fileprivate static let classTableViewCellIdentifier = "ClassTableViewCell"
    
    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text = "种植管理"
        rightBtn.isHidden = false
        rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e61e}", size: 20, color: UIColor.black)), for: .normal)
        rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e61e}", size: 20, color: UIColor.gray)), for: .highlighted)
        contentView.addSubview(menuContainer)
    }
    override func layoutConstraints() {
        menuContainer.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(64, 0, 0, 0));
        }
    }
    
    override func loadData() {
        
        self.menuContainer.childViews = [self.tableView, self.tableView];
        let plantData = PlantModel()
        plantData.plant_crop_nam = "水稻 · 稻花香"
        plantData.crop_variety = "1块田，共500W亩"
        dataArray = [plantData,plantData,plantData]
        tableView.reloadData()
    }
    
    override func rightBtnAction() {
        print("添加种植信息")
    }
    
    lazy var menuContainer: MenuContainer = {
        let menuContainer = MenuContainer()
        menuContainer.menuCtrl.indicatorInset = (SCREEN_WIDTH/2.0-70)/2.0
        menuContainer.menuCtrl.titles = ["当前种植","历史种植"];
        menuContainer.scrollAnimated = false;
        return menuContainer
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = BaseColor.BackGroundColor
        tableView.register(PlantCell.self, forCellReuseIdentifier: classTableViewCellIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
}

extension PlantManagerViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlantManagerViewController.classTableViewCellIdentifier, for: indexPath) as! PlantCell
        cell.plantData = dataArray[indexPath.row] as? PlantModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


class PlantCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10);
            make.top.equalTo(10);
            make.right.equalTo(contentView).offset(-10);
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH - 20)/2
        contentLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10);
            make.top.equalTo(titleLabel.snp.bottom).offset(10);
            make.right.equalTo(contentView).offset(-10);
        }
        
        let line = UIView()
        line.backgroundColor = BaseColor.BackGroundColor
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(contentLabel.snp.bottom).offset(15);
            make.height.equalTo(0.5);
            make.left.right.bottom.equalTo(contentView);
        }
    }
    
    var plantData: PlantModel? {
        didSet {
            titleLabel.text = plantData?.plant_crop_nam
            contentLabel.text = plantData?.crop_variety
        }
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        return titleLabel
    }()
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = BaseColor.GrayColor
        return contentLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
