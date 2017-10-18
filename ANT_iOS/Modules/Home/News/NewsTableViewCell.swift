//
//  NewsTableViewCell.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/30.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

enum NewsTableViewCellType {
    case No
    case OnlyOne
    case Three
}

class NewsTableViewCell: UITableViewCell {
    
    var imageViewArray = NSMutableArray()
    var imgView = UIImageView()
    var newsType: NewsTableViewCellType? {
        didSet {
            // 防止布局错乱
            for image in imageViewArray {
                (image as AnyObject).removeFromSuperview()
            }
        }
    }
    var imageArray = NSArray() {
        didSet {
            if imageArray.count == 0 {
                newsType = NewsTableViewCellType.No
            }else if imageArray.count == 1 || imageArray.count == 2 {
                newsType = NewsTableViewCellType.OnlyOne
            }else {
                newsType = NewsTableViewCellType.Three
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        buildCellView()
    }
    
    func buildCellView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(formAndTimeLabel)
        contentView.addSubview(bottomLine)
    }
    
    var newsData: NewsModel? {
        didSet {
            titleLabel.text = newsData?.title
            formAndTimeLabel.text = (newsData?.news_source)! + "  " + (newsData?.create_date)!
            imageArray = (newsData?.imagePathsArray)!
            
            let imageWidth = (SCREEN_WIDTH - 60) / 3
            let imageHeight = 90
            let titleHeight = 20
            
            if newsType == NewsTableViewCellType.No { //没有图片
                titleLabel.frame = CGRect(x: 15, y: 10, width: Int(SCREEN_WIDTH-30), height: titleHeight)
                formAndTimeLabel.frame = CGRect(x: 15, y: titleLabel.bottom+5, width: SCREEN_WIDTH, height: 20)
                
            }else if newsType == NewsTableViewCellType.OnlyOne { //一张图片
                
                imgView = UIImageView.init(frame: CGRect(x: Int(SCREEN_WIDTH-15-130), y: 10, width: 130, height: imageHeight))
                imgView.layer.cornerRadius = 2.0
                imgView.layer.masksToBounds = true
                imgView.layer.borderColor = BaseColor.LineColor.cgColor
                imgView.layer.borderWidth = 0.5
                imgView.contentMode = .scaleAspectFill
                imgView.kf.setImage(with: NSURL.init(string: (imageArray[0] as AnyObject).value(forKey: "title_image") as! String)! as URL, placeholder: IMAGE_PLACEHOLDER, options: nil, progressBlock: nil, completionHandler: nil)
                contentView.addSubview(imgView)
                imageViewArray.add(imgView)
                
                titleLabel.frame = CGRect(x: 15, y: Int(imgView.top), width: Int(SCREEN_WIDTH-45-130), height: imageHeight-30)
                formAndTimeLabel.frame = CGRect(x: 15, y: Int(imgView.bottom-15), width: Int(SCREEN_WIDTH-45-130), height: 20)
                
            }else { //三张图片
                titleLabel.frame = CGRect(x: 15, y: 10, width: Int(SCREEN_WIDTH-30), height: titleHeight)
                for i in 0 ..< 3 {
                    imgView = UIImageView.init(frame: CGRect(x: i * Int((imageWidth+10))+15, y: Int(titleLabel.bottom+10), width: Int(imageWidth), height: imageHeight))
                    imgView.layer.cornerRadius = 2.0
                    imgView.layer.masksToBounds = true
                    imgView.layer.borderColor = BaseColor.LineColor.cgColor
                    imgView.layer.borderWidth = 0.5
                    imgView.contentMode = .scaleAspectFill
                    imgView.kf.setImage(with: NSURL.init(string: (imageArray[i] as AnyObject).value(forKey: "title_image") as! String)! as URL, placeholder: IMAGE_PLACEHOLDER, options: nil, progressBlock: nil, completionHandler: nil)
                    contentView.addSubview(imgView)
                    imageViewArray.add(imgView)
                }
                formAndTimeLabel.frame = CGRect(x: 15, y: Int(imgView.bottom+10), width: Int(SCREEN_WIDTH), height: 20)
            }
            
            bottomLine.snp.makeConstraints { (make) in
                make.top.equalTo(formAndTimeLabel.snp.bottom).offset(10)
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.width.equalTo(1)
                make.bottom.equalTo(-0.1)
            }
        }
    }
    
    func cellHeight() -> CGFloat {
        return bottomLine.height
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
    
    lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.white
        return bottomLine
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

