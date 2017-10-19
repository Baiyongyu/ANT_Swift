//
//  PopUpPickerView.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/12.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

protocol PopUpMenuDataSource {
    func popUpMenuNumberOfComponentsInPickerView(popUpMenu: PopUpPickerView) -> NSInteger
    func popUpMenuNumberOfRowsInComponent(popUpMenu: PopUpPickerView, component: NSInteger) -> NSInteger
}

protocol PopUpMenuDelegate {
    func popUpMenuTitleForRow(popUpMenu: PopUpPickerView, row: NSInteger, component: NSInteger) -> String
    func popUpMenuDidSelectRowArray(popUpMenu: PopUpPickerView, rowArray: NSArray)
}

class PopUpPickerView: UIView {
    // 声明代理
    var dataSource:PopUpMenuDataSource?
    var delegate:PopUpMenuDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.frame = CGRect(x: 0, y: self.bgView.height, width: self.bgView.width, height: 200)
        self.addSubview(self.finishBtn)
        self.addSubview(self.pickerView)
    }
    
    public func show() {
        if (!(self.bgView.superview != nil)) {
            mainWindow().addSubview(self.bgView)
            if (!(self.superview != nil)) {
                self.bgView.addSubview(self)
            }
        }
        self.bgView.backgroundColor = UIColor.init(white: 0, alpha: 0)
        UIView.animate(withDuration: 0.3) {
            self.bgView.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
            self.top = self.bgView.bottom - self.height
        }
    }
    
    public func reloadData() {
        self.selectedRowArray = []
        self.pickerView.reloadAllComponents()
        if ((self.dataSource?.popUpMenuNumberOfComponentsInPickerView(popUpMenu: self)) != nil) {
            if ((self.dataSource?.popUpMenuNumberOfRowsInComponent(popUpMenu: self, component: 0)) != nil) {
                self.pickerView.selectRow(0, inComponent: 0, animated: true)
            }
        }
    }
    
    func tapAction() {
        dismiss()
    }
    
    func finishAction() {
        self.delegate?.popUpMenuDidSelectRowArray(popUpMenu: self, rowArray: self.selectedRowArray)
        dismiss()
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.backgroundColor = UIColor.init(white: 0, alpha: 0);
            self.top = self.bgView.bottom;
        }) { (true) in
            self.bgView.removeFromSuperview()
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.frame = UIScreen.main.bounds
        bgView.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(tapAction))
        tapGesture.delegate = self
        bgView.addGestureRecognizer(tapGesture)
        return bgView
    }()
    
    lazy var finishBtn: UIButton = {
        let finishBtn = UIButton(type: UIButtonType.system)
        finishBtn.frame = CGRect(x: self.width - 60, y: 0, width: 60, height: 40)
        finishBtn.setTitle("完成", for: .normal)
        finishBtn.setTitleColor(BaseColor.ThemeColor, for: .normal)
        finishBtn.addTarget(self, action: #selector(finishAction), for: .touchUpInside)
        return finishBtn
    }()
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.frame = CGRect(x: 0, y: 40, width: self.width, height: self.height - 40)
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    lazy var selectedRowArray: NSMutableArray = {
        let selectedRowArray = NSMutableArray.init(capacity: self.pickerView.numberOfComponents)
                for i in 0 ..< selectedRowArray.count {
                    self.selectedRowArray[i] = 0;
                }
        return selectedRowArray
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PopUpPickerView: UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if ((self.dataSource?.popUpMenuNumberOfComponentsInPickerView(popUpMenu: self)) != nil) {
            return (self.dataSource?.popUpMenuNumberOfComponentsInPickerView(popUpMenu: self))!
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if ((self.dataSource?.popUpMenuNumberOfRowsInComponent(popUpMenu: self, component: component)) != nil) {
            return (self.dataSource?.popUpMenuNumberOfRowsInComponent(popUpMenu: self, component: component))!
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if ((self.delegate?.popUpMenuTitleForRow(popUpMenu: self, row: row, component: component)) != nil) {
            return self.delegate?.popUpMenuTitleForRow(popUpMenu: self, row: row, component: component)
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: NSInteger, inComponent component: NSInteger) {
        self.selectedRowArray[component] = row
        if pickerView.numberOfComponents - 1 > component {
            pickerView.reloadAllComponents()
            pickerView.selectRow(0, inComponent: component+1, animated: true)
            
            let i: NSInteger = component+1
            for i in i ..< self.selectedRowArray.count {
                self.selectedRowArray[i] = 0
            }
            
//            let component = 0
//            for i in component + 1 ..< self.selectedRowArray.count {
//                self.selectedRowArray[i] = 0
//            }
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self.bgView)
        if self.frame.contains(touchPoint) {
            return false
        } else {
            return true
        }
    }
}

