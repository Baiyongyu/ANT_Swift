//
//  CircleViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/2.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class CircleViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate {

    var tableView: UITableView?
    var refreshControl = UIRefreshControl()
    let imagePicView = UIView()
    let imagePic = UIImageView()
    let nameLable = UILabel()
    let avatorImage = UIImageView()
    var biaozhi = true
    var selectItems: [Bool] = []
    var likeItems: [Bool] = []
    var replyViewDraw:CGFloat!
    var test = UITextField()
    var commentView = pingLunFun()
    
    override func loadSubViews() {
        super.loadSubViews()
        self.titleLabel.text = "圈子"
        rightBtn.isHidden = false
        rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e61e}", size: 20, color: UIColor.black)), for: .normal)
        rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e61e}", size: 20, color: UIColor.gray)), for: .highlighted)
        
        
        for _ in 0...dataItem.count {
            selectItems.append(false)
            likeItems.append(false)
        }
        test.delegate = self
        self.commentView.commentTextField.delegate = self
        refreshControl.addTarget(self, action: #selector(CircleViewController.refreshData),
                                 for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        
        self.tableView = UITableView(frame: self.view.frame, style:UITableViewStyle.grouped)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView?.tableHeaderView = headerView()
        self.tableView?.contentInset = UIEdgeInsets(top: 50,left: 0,bottom: 0,right: 0)
        self.view.addSubview(self.tableView!)
        self.tableView?.addSubview(refreshControl)
        self.tableView!.allowsMultipleSelection = true
        
        commentView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40)
        commentView.isHidden = true
        self.view.addSubview(self.commentView)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        
        //圈子tabbar，点击回到顶部
        NotificationCenter.default.addObserver(self, selector: #selector(CircleViewController.tabbarButtonClick), name: NSNotification.Name(rawValue: NotificationTabbarButtonClickDidRepeat), object: nil)
        //键盘收起，下落
        NotificationCenter.default.addObserver(self, selector:#selector(CircleViewController.keyBoardWillShow(note:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(CircleViewController.keyBoardWillHide(note:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func rightBtnAction() {
        YYSheetView.actionSheet().showActionSheetWithTitles(["农友圈","提问题"], { (index) in
            switch index {
                case 0:
                    AppCommon.push(PublishViewController(), animated: true)
                case 1:
                    AppCommon.push(PublishViewController(), animated: true)
                default:
                    break
            }
        })
    }
    
    func refreshData() {
        biaozhi = true
        refreshControl.endRefreshing()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataItem.count
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView?.separatorInset = UIEdgeInsets.zero
        self.tableView?.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutMargins = UIEdgeInsets.zero
        cell.separatorInset = UIEdgeInsets.zero
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify:String = "SwiftCell\(indexPath.row)"
        //禁止重用机制
        var cell:CircleTableViewCell? = tableView.cellForRow(at: indexPath as IndexPath) as? CircleTableViewCell
        if cell == nil{
            cell = CircleTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: identify)
        }
        cell!.setData(name: dataItem[indexPath.row]["name"]! as! String, imagePic: dataItem[indexPath.row]["avator"]! as! String,content: dataItem[indexPath.row]["content"]! as! String,imgData: dataItem[indexPath.row]["imageUrls"]! as! [String],indexRow:indexPath as NSIndexPath as NSIndexPath,selectItem: selectItems[indexPath.row],like:goodComm[indexPath.row]["good"]!,likeItem:likeItems[indexPath.row],CommentNameArray:goodComm[indexPath.row]["commentName"]! ,CommentArray:goodComm[indexPath.row]["comment"]! )
        cell!.displayView.tapedImageV = {[unowned self] index in
            cell!.pbVC.show(inVC: self,index: index)
        }
        cell!.selectionStyle = .none
        
        cell!.heightZhi = { cellflag in
            self.selectItems[indexPath.row] = cellflag
            self.tableView?.reloadData()
        }
        cell!.likechange = { cellflag in
            self.likeItems[indexPath.row] = cellflag
            self.tableView?.reloadData()
        }
        cell!.commentchange = { _ in
            self.replyViewDraw = cell!.convert(cell!.bounds,to:self.view.window).origin.y + cell!.frame.size.height
            self.commentView.commentTextField.becomeFirstResponder()
            self.commentView.sendBtn.addTarget(self, action: #selector(CircleViewController.sendComment(sender:)), for:.touchUpInside)
            self.commentView.sendBtn.tag = indexPath.row
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var h_content = cellHeightByData(data: dataItem[indexPath.row]["content"]! as! String)
        let h_image = cellHeightByData1(imageNum: (dataItem[indexPath.row]["imageUrls"]! as AnyObject).count)
        var h_like:CGFloat = 0.0
        let h_comment = cellHeightByCommentNum(Comment: goodComm[indexPath.row]["commentName"]!.count)
        if h_content > 13*5 {
            if !self.selectItems[indexPath.row] {
                h_content = 13*5
            }
        }
        if goodComm[indexPath.row]["good"]!.count > 0 {
            h_like = 40
        }
        return h_content + h_image + 50 + 20 + h_like + h_comment
    }
    
    func headerView() -> UIView {
        imagePicView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 225)
        imagePic.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 200)
        imagePic.image = UIImage(named: "ic_shop_test_image")
        imagePicView.addSubview(imagePic)
        imagePic.clipsToBounds = true
        
        avatorImage.frame = CGRect(x: SCREEN_WIDTH - 80, y: 150, width: 70, height: 70)
        avatorImage.image = UIImage(named: "placeholder")
        avatorImage.layer.borderWidth = 2
        avatorImage.layer.borderColor = UIColor.white.cgColor
        
        nameLable.frame = CGRect(x: SCREEN_WIDTH - 100 - 80, y: 170, width: 100, height: 18)
        nameLable.text = "江左梅郎丶"
        nameLable.textAlignment = .right
        nameLable.font = UIFont.systemFont(ofSize: 16)
        nameLable.textColor = UIColor.white
        
        let view: UIView = UIView(frame: CGRect(x: 0, y: 200, width: SCREEN_WIDTH, height: 26))
        view.backgroundColor = UIColor.white
        imagePicView.addSubview(nameLable)
        imagePicView.addSubview(view)
        imagePicView.addSubview(avatorImage)
        return imagePicView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset:CGPoint = scrollView.contentOffset
        if (offset.y < 0) {
            var rect:CGRect = imagePic.frame
            rect.origin.y = offset.y
            rect.size.height = 200 - offset.y
            imagePic.frame = rect
        }
    }
    
    // 圈子按钮点击回到顶部
    func tabbarButtonClick() {
        if self.view.window == nil {
            return
        }
        tableView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 20), animated: true)
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.commentView.commentTextField.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    
    func keyBoardWillShow(note:NSNotification) {
        
        let userInfo  = note.userInfo! as NSDictionary
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyBoardBounds.size.height
        let commentY = SCREEN_HEIGHT - deltaY + NavBarHeight + TabBarHeight
        var frame = self.commentView.frame
        
        let animations:(() -> Void) = {
            self.commentView.isHidden = false
            self.commentView.frame.origin.y = commentY - 40
            frame.origin.y = commentY
            var point:CGPoint = self.tableView!.contentOffset
            point.y -= (frame.origin.y - self.replyViewDraw)
            self.tableView!.contentOffset = point
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else {
            animations()
        }
    }
    
    func keyBoardWillHide(note:NSNotification) {
        
        let userInfo = note.userInfo! as NSDictionary
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations:(() -> Void) = {
            self.commentView.isHidden = true
            self.commentView.transform = .identity
            self.tableView!.frame.origin.y = 0
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
        }else {
            animations()
        }
    }
    
    func sendComment(sender:UIButton) {
        goodComm[sender.tag]["commentName"]!.append("江左梅郎丶")
        goodComm[sender.tag]["comment"]!.append(commentView.commentTextField.text!)
        self.commentView.commentTextField.resignFirstResponder()
        self.tableView?.reloadData()
    }
}
