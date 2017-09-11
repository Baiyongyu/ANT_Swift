//
//  NewsTableViewCell.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/30.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildCellView()
    }
    
    func buildCellView() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(15)
//            make.height.greaterThanOrEqualTo(45)
        }
        
        contentView.addSubview(formAndTimeLabel)
        formAndTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(15)
//            make.height.greaterThanOrEqualTo(45)
        }
    }
    
    var newsData: NewsModel? {
        didSet {
            titleLabel.text = newsData?.title
            formAndTimeLabel.text = (newsData?.news_source)! + "  " + (newsData?.create_date)!
        }
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = BaseColor.BlackColor
        return titleLabel
    }()
    
    lazy var formAndTimeLabel: UILabel = {
        let formAndTimeLabel = UILabel()
        formAndTimeLabel.font = UIFont.systemFont(ofSize: 12)
        formAndTimeLabel.numberOfLines = 0
        formAndTimeLabel.textColor = BaseColor.LightGrayColor
        return formAndTimeLabel
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

class NewsTableViewCell1: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildCellView()
    }
    
    func buildCellView() {
        
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.equalTo(-10)
            make.width.equalTo(130)
            make.height.equalTo(90)
            make.bottom.equalTo(-10)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.right.equalTo(imgView.snp.left).offset(-20)
        }
        
        contentView.addSubview(formAndTimeLabel)
        formAndTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(15)
            make.right.equalTo(imgView.snp.left).offset(-20)
            make.bottom.equalTo(-10)
        }
    }
    
    var newsData: NewsModel? {
        didSet {
            titleLabel.text = newsData?.title
            formAndTimeLabel.text = (newsData?.news_source)! + "  " + (newsData?.create_date)!
//            imgView.kf.setImage(with: NSURL.init(string: (newsData?.title_image)!)! as URL, placeholder: IMAGE_PLACEHOLDER, options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.borderColor = UIColor.lightGray.cgColor;
        imgView.layer.borderWidth = 0.5;
        imgView.layer.cornerRadius = 2.0;
        imgView.clipsToBounds = true;
        return imgView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = BaseColor.BlackColor
        return titleLabel
    }()
    
    lazy var formAndTimeLabel: UILabel = {
        let formAndTimeLabel = UILabel()
        formAndTimeLabel.font = UIFont.systemFont(ofSize: 12)
        formAndTimeLabel.numberOfLines = 0
        formAndTimeLabel.textColor = BaseColor.LightGrayColor
        return formAndTimeLabel
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
