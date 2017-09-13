//
//  NotificationViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/4.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class NotificationViewController: BaseViewController {

    var dataArray = NSArray()
    fileprivate static let classTableViewCellIdentifier = "ClassTableViewCell"
    
    override func loadSubViews() {
        super.loadSubViews()
        self.titleLabel.text = "通知"
        self.contentView.addSubview(self.tableView)
    }
    
    override func layoutConstraints() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 0, 0));
        }
    }
    
    override func loadData() {
        let messData = MessageModel()
        messData.title = "阡陌爱农田"
        messData.content = "阡陌科技旗下的爱农田产品，是世界一流的农服务农产品，功能强大，要啥有啥，屌的一逼，值得下载！"
        self.dataArray = [messData,messData,messData]
        self.tableView.reloadData()
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = BaseColor.BackGroundColor
        tableView.register(NotificationCell.self, forCellReuseIdentifier: classTableViewCellIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
}

extension NotificationViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationViewController.classTableViewCellIdentifier, for: indexPath) as! NotificationCell
        cell.messageData = self.dataArray[indexPath.row] as? MessageModel
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


class NotificationCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10);
            make.top.equalTo(15);
            make.right.equalTo(self.contentView).offset(-10);
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.preferredMaxLayoutWidth = (SCREEN_WIDTH - 20)/2
        contentLabel.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10);
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5);
            make.right.equalTo(self.contentView).offset(-10);
        }
        
        let line = UIView()
        line.backgroundColor = BaseColor.BackGroundColor
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(15);
            make.height.equalTo(0.5);
            make.left.right.bottom.equalTo(self.contentView);
        }
    }
    
    var messageData: MessageModel? {
        didSet {
            titleLabel.text = messageData?.title
            contentLabel.text = messageData?.content
        }
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        return titleLabel
    }()
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        
        return contentLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
