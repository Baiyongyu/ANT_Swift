//
//  TraceStep1ViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/19.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class TraceStep1ViewController: BaseViewController {

    var dataArray = Array<Any>()
    fileprivate static let classTableViewCellIdentifier = "ClassTableViewCell"
    
    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text = "第一步"
        contentView.backgroundColor = UIColor.white
        
        leftBtn.isHidden = false
        leftBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e611}", size: 25, color: UIColor.black)), for: .normal)
        leftBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e611}", size: 25, color: UIColor.gray)), for: .highlighted)
        
        let traceStepView = TraceStepView(style: .default, reuseIdentifier: "")
        traceStepView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 220)
        traceStepView.centerX = view.centerX
        
        let stepData = StepGuideModel()
        stepData.server_name = "小陌"
        stepData.server_image = ""
        stepData.step_title = "选择你要添加的追溯的作物吧,\n已经生成溯源的选不到哦"
        traceStepView.stepData = stepData
        contentView.addSubview(traceStepView)
        
        contentView.addSubview(tableView)
    }
    
    override func layoutConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(290, 0, 0, 0))
        }
        
        contentView.addSubview(nextStepkBtn)
        nextStepkBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30);
            make.right.equalTo(view).offset(-30);
            make.bottom.equalTo(view).offset(-40);
            make.height.equalTo(44);
        }
    }
    
    override func loadData() {
        let plantData = PlantModel()
        plantData.plant_crop = "水稻 · 稻花香"
        plantData.year = "2017.9.19"
        dataArray = [plantData,plantData,plantData]
        tableView.reloadData()
    }
    
    override func leftBtnAction() {
        let alertView = YYAlertView()
        alertView.initWithTitle(titles: "退出后已经填写的信息将不会被保存，确定要退出吗？", message: "", sureTitle: "确定", cancleTitle: "取消")
        alertView.alertSelectIndex = { (index) -> Void in
            if index == 2 {
                self.dismiss(animated: true, completion: nil)
            }
        }
        alertView.showAlertView()
    }
    
    func nextStepkBtnAction() {
        let step2 = TraceStep2ViewController()
        self.navigationController?.pushViewController(step2, animated: true)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(StepPlantInfoCell.self, forCellReuseIdentifier: classTableViewCellIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    lazy var nextStepkBtn: UIButton = {
        let nextStepkBtn = UIButton(type: UIButtonType.custom)
        nextStepkBtn.setTitle("下一步", for: .normal)
        nextStepkBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextStepkBtn.setTitleColor(UIColor.white, for: .normal)
        nextStepkBtn.setTitleColor(BaseColor.GrayColor, for: .highlighted)
        nextStepkBtn.backgroundColor = BaseColor.ThemeColor
        nextStepkBtn.layer.cornerRadius = 5
        nextStepkBtn.clipsToBounds = true
        nextStepkBtn.addTarget(self, action: #selector(nextStepkBtnAction), for: .touchUpInside)
        return nextStepkBtn
    }()
}

//UITableView - Delegate And DataSource
extension TraceStep1ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TraceStep1ViewController.classTableViewCellIdentifier, for: indexPath) as! StepPlantInfoCell
        cell.selectionStyle = .none
        cell.plantData = self.dataArray[indexPath.row] as? PlantModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


class StepPlantInfoCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildCellView()
    }
    
    func buildCellView() {
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.bottom.equalTo(contentView)
        }
        
        bgView.addSubview(cropsLabel)
        cropsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20);
            make.height.equalTo(44);
            make.centerY.equalTo(bgView);
            make.width.lessThanOrEqualTo(200);
        }
        
        bgView.addSubview(selectedIcon)
        selectedIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView);
            make.right.equalTo(bgView).offset(-10);
            make.width.height.equalTo(20);
        }
        
        bgView.addSubview(yearLabel)
        yearLabel.snp.makeConstraints { (make) in
            make.left.equalTo(cropsLabel.snp.right).offset(15);
            make.centerY.equalTo(bgView);
        }
    }
    var plantData: PlantModel? {
        didSet {
            cropsLabel.text = plantData?.plant_crop
            yearLabel.text = plantData?.year
        }
    }
    
    lazy var bgView: UIImageView = {
        let bgView = UIImageView()
        bgView.backgroundColor = UIColor.white
        bgView.layer.borderColor = BaseColor.LineColor.cgColor
        bgView.layer.borderWidth = 0.5
        bgView.layer.cornerRadius = 25
        bgView.isUserInteractionEnabled = true
        return bgView
    }()
    
    lazy var cropsLabel: UILabel = {
        let cropsLabel = UILabel()
        cropsLabel.font = UIFont.systemFont(ofSize: 15)
        return cropsLabel
    }()
    
    lazy var selectedIcon: UIImageView = {
        let selectedIcon = UIImageView()
        selectedIcon.image = UIImage.icon(with: TBCityIconInfo.init(text: "\u{e630}", size: 20, color: UIColor.black))
        selectedIcon.isHidden = true
        return selectedIcon
    }()
    
    lazy var yearLabel: UILabel = {
        let yearLabel = UILabel()
        yearLabel.font = UIFont.systemFont(ofSize: 12)
        yearLabel.backgroundColor = BaseColor.BackGroundColor
        yearLabel.layer.cornerRadius = 3
        yearLabel.layer.masksToBounds = true
        return yearLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
