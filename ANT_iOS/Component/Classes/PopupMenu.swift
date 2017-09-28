//
//  PopView.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/27.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

public protocol SwiftPopMenuDelegate {
    func swiftPopMenuDidSelectIndex(index:Int)
}

public class PopupMenu: UIView {
    
    public var delegate: SwiftPopMenuDelegate?
    private var myFrame: CGRect!
    private var arrowView: UIView! = nil
    private var arrowViewWidth: CGFloat = 15
    private var arrowViewHeight: CGFloat = 8
    
    //*  -----------------------  可变参数 ------------------------------------------ *／
    
    //小箭头距离右边距离
    public var arrowViewMargin : CGFloat = 15
    //圆角弧度
    public var cornorRadius:CGFloat = 5
    //pop文字颜色
    public var popTextColor:UIColor = UIColor.black
    //pop背景色
    public var popMenuBgColor:UIColor = UIColor.white
    
    var tableView: UITableView! = nil
    public var popData:[(icon:String,title:String)]! = [(icon:String,title:String)](){
        didSet{
            //计算行高
            rowHeightValue = (self.myFrame.height - arrowViewHeight)/CGFloat(popData.count)
            initViews()
        }
    }
    
    public var didSelectMenuBlock:((_ index:Int)->Void)?

    static let cellID:String = "SwiftPopMenuCellID"
    var rowHeightValue:CGFloat = 50

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        myFrame = frame
    }
    
    init(frame: CGRect,arrowMargin:CGFloat) {
        super.init(frame: frame)
        arrowViewMargin = arrowMargin
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        myFrame = frame
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
    
    public func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    public func dismiss() {
         self.removeFromSuperview()
    }

    func initViews() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        //箭头
        arrowView = UIView(frame: CGRect(x: myFrame.origin.x, y: myFrame.origin.y, width: myFrame.width, height: arrowViewHeight))
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x:myFrame.width - arrowViewMargin - arrowViewWidth/2, y: 0))
        path.addLine(to: CGPoint(x: myFrame.width - arrowViewMargin - arrowViewWidth, y: arrowViewHeight))
        path.addLine(to: CGPoint(x: myFrame.width - arrowViewMargin, y: arrowViewHeight))
        layer.path = path.cgPath
        layer.fillColor = popMenuBgColor.cgColor
        arrowView.layer.addSublayer(layer)
        self.addSubview(arrowView)
        
        tableView = UITableView(frame: CGRect(x: myFrame.origin.x,y: myFrame.origin.y + arrowViewHeight,width: myFrame.width,height: myFrame.height - arrowViewHeight), style: .plain)
        tableView.register(PopMenuCell.classForCoder(), forCellReuseIdentifier: PopupMenu.cellID)
        tableView.backgroundColor = popMenuBgColor
        tableView.layer.cornerRadius = cornorRadius
        tableView.layer.masksToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        UIView.animate(withDuration: 0.3) { 
            self.addSubview(self.tableView)
        }
    }
}

class PopMenuCell: UITableViewCell {
    var iconImage: UIImageView!
    var lblTitle: UILabel!
    var line: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        
        iconImage = UIImageView()
        self.contentView.addSubview(iconImage)
        
        lblTitle = UILabel()
        lblTitle.font = UIFont.systemFont(ofSize: 16)
        self.contentView.addSubview(lblTitle)
        
        line = UIView()
        line.backgroundColor = UIColor(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 0.5)
        self.contentView.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(iconImage:String,title:String,textColor:UIColor,islast:Bool = false) {
        self.iconImage.image = UIImage(named: iconImage)
        self.lblTitle.text = title
        self.line.isHidden = islast
        lblTitle.textColor = textColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.iconImage.frame = CGRect(x: 10, y: (self.bounds.size.height - 20)/2, width: 20, height: 20)
        self.lblTitle.frame = CGRect(x: 40, y: 0, width: self.bounds.size.width - 40, height: self.bounds.size.height)
        self.line.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
    }
}

extension PopupMenu : UITableViewDataSource,UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if popData.count > indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: PopupMenu.cellID) as! PopMenuCell
            let model = popData[indexPath.row]
            if indexPath.row == popData.count - 1 {
                cell.fill(iconImage: model.icon, title: model.title,textColor: popTextColor, islast: true)
            }else {
                cell.fill(iconImage: model.icon, title: model.title,textColor: popTextColor)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeightValue
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.delegate != nil{
            self.delegate?.swiftPopMenuDidSelectIndex(index: indexPath.row)
        }
        if didSelectMenuBlock != nil {
            didSelectMenuBlock!(indexPath.row)
        }
    }
}

