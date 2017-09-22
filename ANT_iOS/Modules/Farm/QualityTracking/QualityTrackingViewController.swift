//
//  QualityTrackingViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/18.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class QualityTrackingViewController: BaseViewController {

    var dataArray = Array<Any>()
    fileprivate static let classTableViewCellIdentifier = "ClassTableViewCell"
    
    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text = "质量溯源"
        rightBtn.isHidden = false
        rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e61e}", size: 20, color: UIColor.black)), for: .normal)
        rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e61e}", size: 20, color: UIColor.gray)), for: .highlighted)
        contentView.addSubview(tableView)
    }
    
    override func layoutConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 0, 0))
        }
    }
    
    override func loadData() {
        let qualityData = QualityTrackModel()
        qualityData.trace_crop_name = "五常稻花香"
        qualityData.trace_crop_pic = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505791341617&di=cb5275bea0a12c26d2449e55392ad180&imgtype=0&src=http%3A%2F%2Fk.zol-img.com.cn%2Fdcbbs%2F23292%2Fa23291659_01000.jpg"
        dataArray = [qualityData,qualityData,qualityData,qualityData,qualityData]
        tableView.reloadData()
    }
    
    func tableHeaderView() -> UIView {
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40))
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 5, width: SCREEN_WIDTH, height: 40))
        let label = NSMutableAttributedString.init(string: "定制个性化高级溯源系统，请联系", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName: UIColor.black])
        let phoneLabel = NSAttributedString.init(string: "13666666666", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 15), NSForegroundColorAttributeName: BaseColor.BlueColor])
        label.append(phoneLabel)
        titleLabel.attributedText = label
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        bgView.addSubview(titleLabel)
        return bgView
    }
    
    override func rightBtnAction() {
        let navigationController = UINavigationController.init(rootViewController: TraceStep1ViewController())
        navigationController.navigationBar.isHidden = true
        present(navigationController, animated: true, completion: nil)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = BaseColor.BackGroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.register(QualityTrackingCell.self, forCellReuseIdentifier: classTableViewCellIdentifier)
        tableView.tableHeaderView = self.tableHeaderView()
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
}

//UITableView - Delegate And DataSource
extension QualityTrackingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QualityTrackingViewController.classTableViewCellIdentifier, for: indexPath) as! QualityTrackingCell
        cell.selectionStyle = .none
        cell.qualityData = self.dataArray[indexPath.row] as? QualityTrackModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        AppCommon.present(QualityTracDetailsViewController(), animated: true)
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

class QualityTrackingCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildCellView()
    }
    
    func buildCellView() {
        backgroundColor = UIColor.clear
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.right.equalTo(contentView).offset(-15)
            make.bottom.equalTo(contentView)
        }
        
        bgView.addSubview(productLabel)
        productLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgView)
            make.top.equalTo(bgView)
            make.height.equalTo(40)
        }
        
        let seperator1 = UIView()
        seperator1.backgroundColor = BaseColor.BackGroundColor
        bgView.addSubview(seperator1)
        seperator1.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(productLabel.snp.bottom)
            make.height.equalTo(2)
        }
        
        bgView.addSubview(productImage)
        productImage.snp.makeConstraints { (make) in
            make.top.equalTo(seperator1.snp.bottom).offset(10)
            make.centerX.equalTo(bgView)
            make.height.width.equalTo(160)
        }
        
        let seperator2 = UIView()
        seperator2.backgroundColor = BaseColor.BackGroundColor
        bgView.addSubview(seperator2)
        seperator2.snp.makeConstraints { (make) in
            make.left.right.equalTo(bgView)
            make.top.equalTo(productImage.snp.bottom).offset(10)
            make.height.equalTo(2)
        }
        
        bgView.addSubview(lookQRcode)
        lookQRcode.snp.makeConstraints { (make) in
            make.top.equalTo(seperator2.snp.bottom)
            make.left.right.equalTo(bgView)
            make.height.equalTo(40)
            make.bottom.equalTo(bgView)
        }
    }
    
    var qualityData: QualityTrackModel? {
        didSet {
            productLabel.text = qualityData?.trace_crop_name
            productImage.kf.setImage(with: NSURL.init(string: (qualityData?.trace_crop_pic)!)! as URL, placeholder: IMAGE_PLACEHOLDER, options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    
    lazy var bgView: UIImageView = {
        let bgView = UIImageView()
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 5
        bgView.layer.shadowOffset = CGSize(width: 0, height: -0.3)
        bgView.layer.shadowColor = UIColor.init(white: 0, alpha: 0.4).cgColor
        bgView.layer.shadowOpacity = 0.5
        return bgView
    }()
    
    lazy var productLabel: UILabel = {
        let productLabel = UILabel()
        productLabel.font = UIFont.systemFont(ofSize: 15)
        productLabel.textAlignment = .center
        return productLabel
    }()
    
    lazy var productImage: UIImageView = {
        let productImage = UIImageView()
        productImage.layer.cornerRadius = 80
        productImage.contentMode = .scaleAspectFill
        productImage.layer.borderColor = UIColor.init(white: 0, alpha: 0.4).cgColor
        productImage.layer.borderWidth = 0.5
        productImage.layer.masksToBounds = true
        return productImage
    }()
    
    lazy var lookQRcode: UIButton = {
        let lookQRcode = UIButton(type: UIButtonType.custom)
        lookQRcode.titleLabel?.textAlignment = .center
        lookQRcode.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        lookQRcode.setTitle("查看二维码", for: .normal)
        lookQRcode.setTitleColor(UIColor.black, for: .normal)
        lookQRcode.setTitleColor(BaseColor.ThemeColor, for: .highlighted)
        return lookQRcode
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
