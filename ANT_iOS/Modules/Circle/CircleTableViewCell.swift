//
//  CircleTableViewCell.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/20.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

typealias heightChange = (_ cellFlag:Bool) -> Void
typealias likeChange = (_ cellFlag:Bool) -> Void
typealias commentChange = () -> Void

class CircleTableViewCell: UITableViewCell {
    var flag = true
    var show = false
    var likeflag = true
    var nameLabel = UILabel()
    var avatorImage:UIImageView!
    let pbVC = PhotoBrowser()
    var contentLabel = UILabel()
    let displayView = DisplayView()
    var remoteThumbImage = [NSIndexPath:[String]]()
    var remoteImage: [String] = []
    var timeLabel = UILabel()
    var btn = UIButton()
    let menuview = Menu()
    var zhankaiBtn:UIButton!
    var collectionViewFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var cellflag1 = false
    var heightZhi: heightChange?
    var likechange: likeChange?
    var commentchange: commentChange?
    var likeView = Comment_Like_View()
    
    var likeLabelArray: [String] = []
    var commentView = pingLunFun()
    var commentNameLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        if avatorImage == nil {
            avatorImage = UIImageView(frame: CGRect(x: 10, y: 10, width: 45, height: 45))
            self.contentView.addSubview(avatorImage)
        }
        
        nameLabel.frame = CGRect(x: 65, y: 8, width: 100, height: 17)
        nameLabel.textColor = UIColor(red: 74/255, green: 83/255, blue: 130/255, alpha: 1)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        self.contentView.addSubview(nameLabel)
        contentLabel.numberOfLines = 0
        contentLabel.textColor = UIColor.black
        contentLabel.font = UIFont.systemFont(ofSize: 13)
        contentLabel.textAlignment = .justified
        contentLabel.sizeToFit()
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = UIColor.gray
        timeLabel.text = "两小时前"
        btn.setImage(UIImage(named:"menu"), for: .normal)
        btn.addTarget(self, action: #selector(CircleTableViewCell.click), for: .touchUpInside)
        
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(displayView)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(btn)
    }
    
    func click(){
        menuview.clickMenu()
    }
    
    func setData(name: String, imagePic: String, content: String, imgData: [String], indexRow: NSIndexPath, selectItem: Bool, like: [String], likeItem: Bool, CommentNameArray: [String], CommentArray: [String]) {
        
        var h = cellHeightByData(data: content)
        let h1 = cellHeightByData1(imageNum: imgData.count)
        var h2: CGFloat = 0.0
        nameLabel.text = name
        avatorImage.image = UIImage(named: imagePic)
        
        if h < 13*5 {
            contentLabel.frame = CGRect(x: 65, y: 25, width: SCREEN_WIDTH-65-10, height: h)
            collectionViewFrame = CGRect(x: 60, y: h+10+15, width: 230, height: h1)
            h2 = h1 + h + 27
            
        }else {
            if !selectItem {
                cellflag1 = !selectItem
                h = 13*5
                contentLabel.frame = CGRect(x: 65, y: 25, width: SCREEN_WIDTH-65-10, height: h)
                zhankaiBtn = UIButton(frame: CGRect(x: 60, y: h+10+17, width: 60, height: 15))
                zhankaiBtn.setTitle("展开全文", for: .normal)
                zhankaiBtn.addTarget(self, action: #selector(CircleTableViewCell.clickDown(sender:)), for: .touchUpInside)
                zhankaiBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                zhankaiBtn.setTitleColor(UIColor(red: 74/255, green: 83/255, blue: 130/255, alpha: 1), for: .normal)
                self.contentView.addSubview(zhankaiBtn)
                collectionViewFrame = CGRect(x: 60, y: h+10+15+15, width: 230, height: h1)
                h2 = h1 + h + 27 + 12
            }
            if selectItem {
                cellflag1 = !selectItem
                contentLabel.frame = CGRect(x: 65, y: 25, width: SCREEN_WIDTH-65-10, height: h)
                zhankaiBtn = UIButton(frame: CGRect(x: 60, y: h+10+17, width: 60, height: 15))
                zhankaiBtn.setTitle("点击收起", for: .normal)
                zhankaiBtn.addTarget(self, action: #selector(CircleTableViewCell.clickDown(sender:)), for: .touchUpInside)
                zhankaiBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                zhankaiBtn.setTitleColor(UIColor(red: 74/255, green: 83/255, blue: 130/255, alpha: 1), for: .normal)
                self.contentView.addSubview(zhankaiBtn)
                collectionViewFrame = CGRect(x: 60, y: h+10+15+15, width: 230, height: h1)
                h2 = h1 + h + 27 + 12
            }
        }
        contentLabel.text = content
        displayView.frame = collectionViewFrame
        
        timeLabel.frame = CGRect(x: 65, y: h2, width: 100, height: 15)
        btn.frame = CGRect(x: SCREEN_WIDTH-15-10, y: h2, width: 15, height: 12)
        
        self.menuview.frame = CGRect(x: SCREEN_WIDTH-15-10, y: h2-8, width: 14.5, height: 0)
        self.menuview.likeBtn.setImage(UIImage(named: "likewhite"), for: .normal)
        if !likeItem {
            self.menuview.likeBtn.setTitle("赞", for: .normal)
            likeflag = !likeItem
        }
        if likeItem {
            self.menuview.likeBtn.setTitle("取消赞", for: .normal)
            likeflag = !likeItem
        }
        
        self.menuview.likeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.menuview.commentBtn.setImage(UIImage(named: "c"), for: .normal)
        self.menuview.commentBtn.setTitle("评论", for: .normal)
        self.menuview.commentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.menuview.likeBtn.tag = indexRow.row
        self.menuview.likeBtn.addTarget(self, action: #selector(CircleTableViewCell.LikeBtn(sender:)), for: .touchUpInside)
        self.menuview.commentBtn.addTarget(self, action: #selector(CircleTableViewCell.CommentBtn(sender:)), for: .touchUpInside)
        
        for i in 0 ..< imgData.count {
            let imgUrl = imgData[i]
            self.remoteImage.append(imgUrl)
        }
        self.remoteThumbImage[indexRow] = self.remoteImage
        displayView.imgsPrepare(imgs: remoteThumbImage[indexRow]!, isLocal: false)
        pbVC.showType = .Modal
        pbVC.photoType = PhotoBrowser.PhotoType.Host
        pbVC.hideMsgForZoomAndDismissWithSingleTap = true
        var models: [PhotoBrowser.PhotoModel] = []
        
        for i in 0 ..< self.remoteThumbImage[indexRow]!.count {
            let model = PhotoBrowser.PhotoModel(hostHDImgURL:self.remoteThumbImage[indexRow]![i], hostThumbnailImg: (displayView.subviews[i] as! UIImageView).image, titleStr: "", descStr: "", sourceView: displayView.subviews[i])
            models.append(model)
        }
        pbVC.photoModels = models
        if like.count > 0 {
            self.likeView.frame = CGRect(x: 65, y: h2+19.5, width: SCREEN_WIDTH-15-65, height: 40)
            
            for i in 0 ..< like.count {
                likeLabelArray.append(like[i])
            }
            self.likeView.likeLabel.text = likeLabelArray.joined(separator: ",")
            self.contentView.addSubview(self.likeView)
        }
        if CommentNameArray.count > 0 {
            var h3 = h2+19.5+20
            if like.count == 0 {
                 h3 = h2+19.5
            }
            for i in 0 ..< CommentNameArray.count {
                
                let comment_view = CommentView()
                comment_view.frame = CGRect(x: 65, y: h3+(CGFloat(i*20)), width: SCREEN_WIDTH-15-65, height: 25)
                comment_view.nameLabel.text = CommentNameArray[i]
                comment_view.commentLabel.text = " 回复：\(CommentArray[i])"
                self.contentView.addSubview(comment_view)
            }
        }
        self.contentView.addSubview(self.menuview)
    }
        
    func clickDown(sender:UIButton) {
        if flag {
            flag = false
            if self.heightZhi != nil {
                self.heightZhi!(self.cellflag1)
            }
        }else {
            flag = true
            if self.heightZhi != nil {
                self.heightZhi!(self.cellflag1)
            }
        }
    }
    
    func CommentBtn(sender:UIButton) {
        if self.commentchange != nil {
            self.commentchange!()
        }
        menuview.menuHide()
    }

    func LikeBtn(sender:UIButton) {
        
        if !likeflag {
            //服务器接口上传数据
            goodComm[sender.tag]["good"]!.remove(at: goodComm[sender.tag]["good"]!.index(of: "江左梅郎丶")!)
            if self.likechange != nil{
                self.likechange!(self.likeflag)
            }
            menuview.menuHide()
        }else {
            goodComm[sender.tag]["good"]!.append("江左梅郎丶")
            if self.likechange != nil {
                self.likechange!(self.likeflag)
            }
            menuview.menuHide()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
