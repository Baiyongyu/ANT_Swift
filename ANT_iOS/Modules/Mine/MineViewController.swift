//
//  MineViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/2.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class MineViewController: BaseViewController {

    
    var headerView = UIView()
    var imageView = UIImageView()
    var avatarImageView = UIImageView()
    var nameLabel = UILabel()
    
    var titleArray = NSArray()
    var iconArray = NSArray()

    override func loadSubViews() {
        super.loadSubViews()
        self.titleLabel.text = "我的"
        self.contentView.addSubview(tableView)
    }
    
    override func layoutConstraints() {
        
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 49, 0));
        }
        
        headerView.backgroundColor = UIColor.white
        
        imageView.image = UIImage.init(named: "ic_mine_bg")
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(MineViewController.tapHeaderAction))
        imageView.addGestureRecognizer(tapGesture)
        headerView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(headerView);
            make.height.equalTo(140);
        }
        
        headerView.addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = 40
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.headerView);
            make.left.equalTo(20);
            make.width.height.equalTo(80);
        }
        
        headerView.addSubview(nameLabel)
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.white
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarImageView.snp.right).offset(20);
            make.right.equalTo(-20);
            make.centerY.equalTo(self.headerView);
        }
        
        let seperator = UIView()
        self.headerView.addSubview(seperator)
        seperator.backgroundColor = BaseColor.BackGroundColor
        seperator.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom);
            make.left.right.equalTo(self.headerView);
            make.height.equalTo(15);
            make.bottom.equalTo(self.headerView);
        }
        
        self.headerView.frame.size.height = self.headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        self.tableView.tableHeaderView = self.headerView
    }
    
    override func loadData() {
        titleArray = ["我的订单","测土配肥记录","消费记录","收货地址","客服热线","设置"]
        iconArray = ["ic_mine_order","ic_mine_cetu","ic_mine_payrecord","ic_mine_address","ic_mine_hotline","ic_mine_settings"]
        
        avatarImageView.sd_setImage(with: NSURL.init(string: "http://img2.imgtn.bdimg.com/it/u=960594752,2162202648&fm=26&gp=0.jpg")! as URL, placeholderImage: IMAGE_AVATAR_PLACEHOLDER)
        nameLabel.text = "我是路飞，要成为海贼王的男人！"
        self.tableView.reloadData()
    }

    
    func tapHeaderAction() {
        print("点击头像")
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

}

//UITableView - Delegate And DataSource
extension MineViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage.init(named: iconArray[indexPath.row] as! String)
        cell.textLabel?.text = titleArray[indexPath.row] as? String
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        
        if cell.textLabel?.text == "客服热线" {
            cell.accessoryType = .none
            let hotlineLabel = UILabel()
            hotlineLabel.font = UIFont.systemFont(ofSize: 14)
            hotlineLabel.textColor = UIColor.orange
            hotlineLabel.text = PhoneNumber
            cell.contentView.addSubview(hotlineLabel)
            hotlineLabel.snp.makeConstraints({ (make) in
                make.right.equalTo(cell.contentView).offset(-20);
                make.centerY.equalTo(cell.contentView);
            })
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
        if(cell.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            cell.separatorInset = .zero
        }
        
        if(cell.responds(to: #selector(setter: UIView.layoutMargins))){
            cell.layoutMargins = .zero
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset_y: CGFloat = tableView.contentOffset.y
        if offset_y < 0 {
            let totalOffset: CGFloat = self.headerView.bounds.size.height - offset_y
            let scale: CGFloat = totalOffset / self.headerView.bounds.size.height
            let width: CGFloat = SCREEN_WIDTH
            self.imageView.frame = CGRect(x: -(width * scale - width) / 2, y: offset_y, width: width * scale, height: totalOffset)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 4 {
            let urlString = "tel://" + PhoneNumber
            if let url = URL(string: urlString) {
                //根据iOS系统版本，分别处理
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: {
                                                (success) in
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        if indexPath.row == 5 {
            AppCommon.push(SettingsViewController(), animated: true)
        }
    }
}


