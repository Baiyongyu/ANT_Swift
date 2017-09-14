//
//  BuyFormulaPopView.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/13.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class BuyFormulaPopView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white;
        self.layer.cornerRadius = 3.0;
        self.clipsToBounds = true;
        
        let titleLabel = UILabel()
        titleLabel.text = "购买配方肥"
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self);
            make.left.equalTo(10);
            make.height.equalTo(30);
        }
        
        let topLine = UIView()
        topLine.backgroundColor = BaseColor.BackGroundColor
        self.addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(self);
            make.top.equalTo(titleLabel.snp.bottom);
            make.height.equalTo(0.5);
        }
        
        var titleArray = NSArray()
        titleArray = ["建议施肥量：","商品单价：","配肥亩数：","购买数量："]
        for i in 0 ..< titleArray.count {
            let titleLabel = UILabel()
            titleLabel.tag = 100 + i
            titleLabel.textAlignment = .right
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            titleLabel.text = titleArray[i] as? String
            self.addSubview(titleLabel)
            titleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(self);
                make.top.equalTo(topLine.snp.bottom).offset(50 * CGFloat(i));
                make.width.equalTo(100);
                make.height.equalTo(50);
            })
        }
        self.addSubview(fertilizerAmountLabel)
        self.addSubview(unitPriceLabel)
        self.addSubview(acreageTextField)
        
        var titleLabel1 = UILabel()
        titleLabel1 = self.viewWithTag(100) as! UILabel
        fertilizerAmountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel1.snp.right).offset(5);
            make.top.bottom.equalTo(titleLabel1);
            make.right.equalTo(self).offset(-10);
        }
        
        var titleLabel2 = UILabel()
        titleLabel2 = self.viewWithTag(101) as! UILabel
        unitPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel2.snp.right).offset(5);
            make.top.bottom.equalTo(titleLabel2);
            make.right.equalTo(self).offset(-10);
        }
        
        var titleLabel3 = UILabel()
        titleLabel3 = self.viewWithTag(102) as! UILabel
        acreageTextField.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel3.snp.right).offset(5);
            make.centerY.equalTo(titleLabel3);
            make.right.equalTo(self).offset(-30);
            make.height.equalTo(30);
        }
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = BaseColor.BackGroundColor
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(self);
            make.top.equalTo(titleLabel3.snp.bottom);
            make.height.equalTo(0.5);
        }
        
        self.addSubview(totalPriceLabel)
        self.addSubview(addToCartBtn)
        addToCartBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.totalPriceLabel);
            make.height.equalTo(30);
            make.width.equalTo(80);
            make.right.equalTo(self).offset(-10);
        }
        
        totalPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10);
            make.right.equalTo(self.addToCartBtn.snp.left).offset(-5);
            make.top.equalTo(bottomLine.snp.bottom);
            make.height.equalTo(44);
            make.bottom.equalTo(self);
        }
        
        let closeBtn = UIButton(type: UIButtonType.custom)
        closeBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e611}", size: 20, color: UIColor.black)), for: .normal)
        closeBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e611}", size: 20, color: UIColor.gray)), for: .highlighted)
        closeBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        self.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(self).offset(5);
        }
    }
    
    public func showWithGoodsData(goodsData: FormulaModel) {
        if (!(self.bgView.superview != nil)) {
            mainWindow().addSubview(self.bgView)
            self.bgView.snp.makeConstraints({ (make) in
                make.edges.equalTo(mainWindow());
            })
            
            if (!(self.superview != nil)) {
                self.bgView.addSubview(self)
                self.snp.makeConstraints({ (make) in
                    make.center.equalTo(self.bgView);
                    make.width.equalTo(280);
                })
            }
        }
        CommonUtils().setCAKeyframeAnimation(view: self.bgView)
    }
    
    func tapAction() {
        dismiss()
    }
    
    func deliveryDateAction() {
        
    }
    
    func addToCartAction() {
        print("加入购物车")
    }
    
    func dismiss() {
        self.bgView.removeFromSuperview()
    }
    
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector((tapAction)))
        tapGesture.delegate = self as? UIGestureRecognizerDelegate
        bgView.addGestureRecognizer(tapGesture)
        return bgView
    }()
    
    lazy var totalPriceLabel: UILabel = {
        let totalPriceLabel = UILabel()
        return totalPriceLabel
    }()
    
    lazy var fertilizerAmountLabel: UILabel = {
        let fertilizerAmountLabel = UILabel()
        fertilizerAmountLabel.font = UIFont.systemFont(ofSize: 14)
        fertilizerAmountLabel.textColor = BaseColor.BlackColor
        return fertilizerAmountLabel
    }()
    
    lazy var unitPriceLabel: UILabel = {
        let unitPriceLabel = UILabel()
        unitPriceLabel.font = UIFont.systemFont(ofSize: 14)
        unitPriceLabel.textColor = BaseColor.BlackColor
        return unitPriceLabel
    }()
    
    lazy var acreageTextField: UITextField = {
        let acreageTextField = UITextField()
        acreageTextField.layer.cornerRadius = 5.0
        acreageTextField.layer.borderColor = BaseColor.BackGroundColor.cgColor
        acreageTextField.layer.borderWidth = 1.0
        acreageTextField.font = UIFont.systemFont(ofSize: 14)
        acreageTextField.placeholder = "请输入"
        acreageTextField.keyboardType = .numberPad
        
        let unitLabel = UILabel()
        unitLabel.font = UIFont.systemFont(ofSize: 14)
        unitLabel.textColor = UIColor.lightGray
        unitLabel.frame = CGRect(x: 0, y: 0, width: 30, height: 44)
        unitLabel.text = "亩"
        acreageTextField.rightView = unitLabel
        acreageTextField.rightViewMode = .always
        acreageTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
        acreageTextField.leftViewMode = .always
        return acreageTextField
    }()
    
    lazy var deliveryDateBtn: UIButton = {
        let deliveryDateBtn = UIButton(type: UIButtonType.custom)
        deliveryDateBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        deliveryDateBtn.titleLabel?.textAlignment = .left
        deliveryDateBtn.setTitleColor(BaseColor.BlackColor, for: .normal)
        deliveryDateBtn.contentHorizontalAlignment = .left
        deliveryDateBtn.addTarget(self, action: #selector(deliveryDateAction), for: .touchUpInside)
        return deliveryDateBtn
    }()
    
    lazy var addToCartBtn: UIButton = {
        let addToCartBtn = UIButton(type: UIButtonType.custom)
        addToCartBtn.layer.cornerRadius = 3.0
        addToCartBtn.clipsToBounds = true
        addToCartBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        addToCartBtn.setTitle("加入购物车", for: .normal)
        addToCartBtn.setTitleColor(UIColor.white, for: .normal)
        addToCartBtn.backgroundColor = UIColor.red
        addToCartBtn.addTarget(self, action: #selector(addToCartAction), for: .touchUpInside)
        return addToCartBtn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
