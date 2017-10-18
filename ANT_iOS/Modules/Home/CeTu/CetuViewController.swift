//
//  CetuViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/12.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class CetuViewController: BaseViewController {
    
    var headerView = UIView()
    var shopName = String("阡陌")
    var tipLabel = UILabel()
    var footerTipLabel = UILabel()
    var dataArray = NSArray()
    fileprivate static let classTableViewCellIdentifier = "ClassTableViewCell"
    
    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text = "免费测基肥"
        rightBtn.isHidden = false
        rightBtn.setTitle("重新测土", for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(tableView)
        
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.numberOfLines = 0
        headerView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(headerView).offset(-10)
            make.top.equalTo(headerView).offset(10)
            make.bottom.equalTo(headerView).offset(-10)
        }
        tipLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH - 10 * 2)
        tipLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: UILayoutConstraintAxis.vertical)
        
        headerView.layoutIfNeeded()
        updateHeaderViewHeight()
        
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 20)
        footerTipLabel.font = UIFont.systemFont(ofSize: 14)
        footerTipLabel.textAlignment = .center
        footerView.addSubview(footerTipLabel)
        footerTipLabel.snp.makeConstraints { (make) in
            make.center.equalTo(footerView)
        }
        tableView.tableFooterView = footerView
    }
    
    override func layoutConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(NavBarHeight, 0, 0, 0))
        }
        
        //使用updateConstraints 这个方法直接崩溃，不知道什么鬼
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(navBar).offset(-10)
            make.bottom.equalTo(-5)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }
    
    func updateHeaderViewHeight() {
        headerView.height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        tableView.tableHeaderView = headerView
    }
    
    override func loadData() {
        
        let formulaData = FormulaModel()
        formulaData.field_name = "007"
        formulaData.n_percent = "1"
        formulaData.p_percent = "2"
        formulaData.k_percent = "3"
        formulaData.per_quantity = "15.00"
        
        tipLabel.text = "根据您的土壤检测结果，推荐您购买以下配方肥使用"
        footerTipLabel.text = "以上信息由 阡陌科技 提供"
        updateHeaderViewHeight()
        
        dataArray = [formulaData,formulaData,formulaData]
        tableView.reloadData()
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = BaseColor.BackGroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(CetuRecommendCell.self, forCellReuseIdentifier: classTableViewCellIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    override func rightBtnAction() {
        print("重新测土")
    }
}

//UITableView - Delegate And DataSource
extension CetuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CetuViewController.classTableViewCellIdentifier, for: indexPath) as! CetuRecommendCell
        cell.selectionStyle = .none
        cell.formulaData = dataArray[indexPath.row] as? FormulaModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


class CetuRecommendCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildCellView()
    }
    
    func buildCellView() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10);
            make.height.equalTo(30);
            make.top.equalTo(contentView);
        }
        
        let line1 = UIView()
        line1.backgroundColor = BaseColor.BackGroundColor
        contentView.addSubview(line1)
        line1.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView);
            make.top.equalTo(nameLabel.snp.bottom);
            make.height.equalTo(0.5);
        }
        
        //npk背景
        let npkBgView = UIView()
        contentView.addSubview(npkBgView)
        npkBgView.snp.makeConstraints { (make) in
            make.left.equalTo(10);
            make.right.equalTo(contentView).offset(-10);
            make.top.equalTo(line1.snp.bottom).offset(10);
            make.height.equalTo(88);
        }
        
        let width = (SCREEN_WIDTH-20-20)/3
        let npkTitleArray = ["氮(尿素)","磷(磷酸二胺)","钾(氯化钾)"]
        let valueLabelArray = [nRatioLabel, pRatioLabel, kRatioLabel]
        
        for i in 0 ..< npkTitleArray.count {
            let npkTitleLabel = UILabel()
            npkTitleLabel.font = UIFont.systemFont(ofSize: 14)
            npkTitleLabel.textAlignment = .center
            npkTitleLabel.backgroundColor = UIColor.HexColor(0xc9c8c9)
            npkTitleLabel.text = npkTitleArray[i]
            npkBgView.addSubview(npkTitleLabel)
            npkTitleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo((width+10) * CGFloat(i));
                make.width.equalTo(width);
                make.top.equalTo(npkBgView);
                make.height.equalTo(44);
            })
            npkBgView.layoutIfNeeded()
            npkTitleLabel.addRounded(corners: [UIRectCorner.topLeft, UIRectCorner.topRight], radii: CGSize(width: 5.0, height: 5.0))
            
            var valueLabel = UILabel()
            valueLabel = valueLabelArray[i]
            valueLabel.font = UIFont.systemFont(ofSize: 14)
            valueLabel.textAlignment = .center
            valueLabel.backgroundColor = UIColor.HexColor(0xf8f8f8)
            npkBgView.addSubview(valueLabel)
            valueLabel.snp.makeConstraints({ (make) in
                make.left.right.equalTo(npkTitleLabel);
                make.top.equalTo(npkTitleLabel.snp.bottom);
                make.bottom.equalTo(npkBgView);
            })
        }
        contentView.addSubview(fertilizerAmountLabel)
        contentView.addSubview(addToCartBtn)
        fertilizerAmountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10);
            make.right.equalTo(addToCartBtn.snp.left).offset(-10);
            make.top.equalTo(npkBgView.snp.bottom).offset(5);
            make.height.equalTo(20);
        }
        
        let tipLabel = UILabel()
        tipLabel.font = UIFont.systemFont(ofSize: 13)
        tipLabel.textColor = UIColor.lightGray
        tipLabel.text = "每亩按667平方米计算"
        contentView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10);
            make.top.equalTo(fertilizerAmountLabel.snp.bottom).offset(5);
            make.height.equalTo(15);
        }
        
        let line2 = UIView()
        line2.backgroundColor = BaseColor.BackGroundColor
        contentView.addSubview(line2)
        line2.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView);
            make.bottom.equalTo(tipLabel).offset(5);
            make.height.equalTo(0.5);
        }
        
        addToCartBtn.snp.makeConstraints { (make) in
            make.right.equalTo(fertilizerAmountLabel);
            make.top.equalTo(npkBgView.snp.bottom).offset(8);
            make.height.equalTo(35);
            make.width.equalTo(100);
            make.right.equalTo(contentView).offset(-10);
        }
        
        let recommendBtn = UIButton(type: UIButtonType.custom)
        recommendBtn.setTitle("查看施肥建议", for: .normal)
        recommendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        recommendBtn.setTitleColor(UIColor.red, for: .normal)
        recommendBtn.addTarget(self, action: #selector(recommendAction), for: .touchUpInside)
        contentView.addSubview(recommendBtn)
        recommendBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView);
            make.top.equalTo(tipLabel.snp.bottom).offset(5);
            make.height.equalTo(44);
        }
        
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = BaseColor.BackGroundColor
        contentView.addSubview(bottomLineView)
        bottomLineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView);
            make.top.equalTo(recommendBtn.snp.bottom);
            make.height.equalTo(10);
            make.bottom.equalTo(contentView);
        }
    }
    
    var formulaData: FormulaModel? {
        didSet {
            nameLabel.text = formulaData?.field_name
            nRatioLabel.text = formulaData?.n_percent
            pRatioLabel.text = formulaData?.p_percent
            kRatioLabel.text = formulaData?.k_percent
            fertilizerAmountLabel.text = "建议施肥量" + (formulaData?.per_quantity)! + "公斤/亩"
        }
    }
    
    func recommendAction() {
        let adviceVC = CeTuAdviceViewController()
        AppCommon.push(adviceVC, animated: true)
    }
    
    func addToCartAction() {
        self.buyPopView.showWithGoodsData(goodsData: self.formulaData!)
    }
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        return nameLabel
    }()
    
    lazy var nRatioLabel: UILabel = {
        let nRatioLabel = UILabel()
        return nRatioLabel
    }()
    
    lazy var pRatioLabel: UILabel = {
        let pRatioLabel = UILabel()
        return pRatioLabel
    }()
    
    lazy var kRatioLabel: UILabel = {
        let kRatioLabel = UILabel()
        return kRatioLabel
    }()
    
    lazy var fertilizerAmountLabel: UILabel = {
        let fertilizerAmountLabel = UILabel()
        fertilizerAmountLabel.font = UIFont.systemFont(ofSize: 14)
        return fertilizerAmountLabel
    }()
    
    lazy var addToCartBtn: UIButton = {
        let addToCartBtn = UIButton(type: UIButtonType.custom)
        addToCartBtn.setTitle("立即购买", for: .normal)
        addToCartBtn.setTitle("已加入购物车", for: .disabled)
        addToCartBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        addToCartBtn.setTitleColor(UIColor.white, for: .normal)
        addToCartBtn.backgroundColor = UIColor.red
        addToCartBtn.layer.cornerRadius = 3.0
        addToCartBtn.clipsToBounds = true
        addToCartBtn.addTarget(self, action: #selector(addToCartAction), for: .touchUpInside)
        return addToCartBtn
    }()
    
    lazy var buyPopView: BuyFormulaPopView = {
        let buyPopView = BuyFormulaPopView()
        return buyPopView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
