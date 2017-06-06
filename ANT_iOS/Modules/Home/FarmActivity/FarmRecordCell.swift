//
//  FarmRecordCell.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/6.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class FarmRecordCell: UITableViewCell {


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10);
            make.left.equalTo(10);
            make.width.greaterThanOrEqualTo(200);
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10);
            make.right.equalTo(-15);
            make.width.greaterThanOrEqualTo(200);
        }
        
        let line = UIView()
        line.backgroundColor = BaseColor.BackGroundColor
        contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView);
            make.top.equalTo(titleLabel.snp.bottom).offset(10);
            make.height.equalTo(0.5);
        }
        
        contentView.addSubview(activityNameLabel)
        activityNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10);
            make.right.equalTo(-20);
            make.top.equalTo(line.snp.bottom).offset(10);
        }
        
        contentView.addSubview(inputsQuantityLabel)
        contentView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(activityNameLabel.snp.bottom).offset(10);
            make.left.equalTo(10);
            make.right.equalTo(inputsQuantityLabel.snp.left).offset(-5);
            make.bottom.equalTo(-10)
        }
        
        inputsQuantityLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel);
            make.right.equalTo(-20);
            make.bottom.equalTo(-10)
        }
        
    }
    
    var activityData: FarmActivityModel? {
        didSet {
            timeLabel.text = activityData?.created_at
            activityNameLabel.text = activityData?.activity_ame
            nameLabel.text = activityData?.name
            inputsQuantityLabel.text = activityData?.ammount
        }
    }

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "农事活动"
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        return titleLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = BaseColor.LightGrayColor
        timeLabel.textAlignment = .right
        return timeLabel
    }()
    
    lazy var activityNameLabel: UILabel = {
        let activityNameLabel = UILabel()
        activityNameLabel.font = UIFont.systemFont(ofSize: 14)
        activityNameLabel.numberOfLines = 0
        return activityNameLabel
    }()
    
    lazy var inputsQuantityLabel: UILabel = {
        let inputsQuantityLabel = UILabel()
        inputsQuantityLabel.font = UIFont.systemFont(ofSize: 14)
        inputsQuantityLabel.numberOfLines = 0
        return inputsQuantityLabel
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.numberOfLines = 0
        return nameLabel
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
