//
//  MineViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/2.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

import Kingfisher

class MineViewController: BaseViewController {

    var headerView = UIView()
    var imageView = UIImageView()
    var avatarImageView = UIImageView()
    var nameLabel = UILabel()
    
    var titleArray = Array<Any>()
    var iconArray = Array<Any>()
    var colorArray = Array<Any>()
    
    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text = "我的"
        contentView.addSubview(tableView)
        navBar.alpha = 0;
        contentView.snp.updateConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, 49, 0));
        }
    }
    
    override func layoutConstraints() {
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, 49, 0));
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
            make.height.equalTo(180);
        }
        
        headerView.addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = 40
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerView);
            make.left.equalTo(20);
            make.width.height.equalTo(80);
        }
        
        headerView.addSubview(nameLabel)
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.white
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(20);
            make.right.equalTo(-20);
            make.centerY.equalTo(headerView);
        }
        
        let seperator = UIView()
        headerView.addSubview(seperator)
        seperator.backgroundColor = BaseColor.BackGroundColor
        seperator.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom);
            make.left.right.equalTo(headerView);
            make.height.equalTo(10);
            make.bottom.equalTo(headerView);
        }
        
        headerView.frame.size.height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        tableView.tableHeaderView = headerView
    }
    
    override func loadData() {
        titleArray = ["我发布的","我的订单","测土配肥记录","消费记录","收货地址","客服热线","意见反馈","设置"]
        iconArray = ["\u{e646}","\u{e63f}","\u{e635}","\u{e641}","\u{e640}","\u{e63e}","\u{e634}","\u{e637}"]
        colorArray = [UIColor.HexColor(0x1264ed),UIColor.HexColor(0x389644),UIColor.HexColor(0x8260f1),UIColor.HexColor(0xe16352),
                      UIColor.HexColor(0x8dd502),UIColor.HexColor(0xff520c),UIColor.HexColor(0xbb1d1d),UIColor.HexColor(0x309e66)]
        
        avatarImageView.kf.setImage(with: NSURL.init(string: "http://img2.imgtn.bdimg.com/it/u=960594752,2162202648&fm=26&gp=0.jpg")! as URL, placeholder: IMAGE_AVATAR_PLACEHOLDER, options: [.transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
        nameLabel.text = "我是路飞，要成为海贼王的男人！"
        tableView.reloadData()
    }

    
    func tapHeaderAction() {
//        print("点击头像")
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
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
        cell.imageView?.image = UIImage.icon(with: TBCityIconInfo.init(text: iconArray[indexPath.row] as! String, size: 18, color: colorArray[indexPath.row] as! UIColor))
        cell.textLabel?.text = titleArray[indexPath.row] as? String
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        
        if cell.textLabel?.text == "客服热线" {
            cell.accessoryType = .none
            let hotlineLabel = UILabel()
            hotlineLabel.font = UIFont.systemFont(ofSize: 14)
            hotlineLabel.textColor = UIColor.gray
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
        
        switch indexPath.row {
        case 4:
            AppCommon.push(AddressListViewController(), animated: true)
        case 5:
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
        case 7:
            AppCommon.push(SettingsViewController(), animated: true)
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
    }
}


