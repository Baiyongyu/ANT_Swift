//
//  InputDialog.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/13.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class TextView: UITextView {
    var placeHolder: String? {
        didSet {
            placeholderLabel.text = placeHolder
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: .zero, textContainer: textContainer)
        
        self.insertSubview(placeholderLabel, at: 0)
        placeholderLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(8)
            make.left.equalTo(5)
            make.width.equalTo(self)
            make.height.greaterThanOrEqualTo(20)
        })
        
        placeholderLabel.isHidden = super.text.lengthOfBytes(using: .utf8) > 0
        placeholderLabel.font = super.font
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: self)
    }
    
    func textDidChange() {
        placeholderLabel.isHidden = self.text.lengthOfBytes(using: .utf8) > 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.textColor = UIColor.lightGray
        return placeholderLabel
        
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class InputDialog: UIView, UITextViewDelegate {
    
    var text: String? {
        didSet {
            self.textView.text = text
            countChanged()
        }
    }
    var characterCount: NSInteger? {
        didSet {
            countChanged()
        }
    }
    typealias ValueBlock = (_ object: AnyObject) -> Void
    var valueBlock: ValueBlock?
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.addSubview(textView)
//    }
    init(initWithCountEnabled showCount: Bool) {
        super.init(frame: .zero)
        self.addSubview(textView)
        
        if !showCount {
            textView.snp.makeConstraints({ (make) in
                make.edges.equalTo(self)
            })
        }else {
            textView.snp.makeConstraints({ (make) in
                make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 0, 0))
            })
            self.addSubview(countLabel)
            countLabel.snp.makeConstraints({ (make) in
                make.left.bottom.equalTo(self)
                make.right.equalTo(self).offset(-10)
                make.bottom.equalTo(textView.snp.bottom)
            })
        }
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: self)
    }
 
    func countChanged() {
        countLabel.text = String(format: "%ld/%d", [textView.text.lengthOfBytes(using: .utf8), characterCount!])
    }
    
    
    func textDidChange(note: Notification) {
        var textView = UITextView()
        textView = note.object as! UITextView
        
        if textView == self.textView {
            let toBeString = self.textView.text
            let lang = self.textView.textInputMode?.primaryLanguage // 键盘输入模式
            if lang == "zh-Hans" { // 简体中文输入，包括简体拼音，健体五笔，简体手写
                let selectedRange = self.textView.markedTextRange
                // 获取高亮部分
                let position = self.textView.position(from: (selectedRange?.start)!, offset: 0)
                // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
                if !(position != nil) {
                    if (toBeString?.lengthOfBytes(using: .utf8))! > characterCount! {
                        self.textView.text = (toBeString! as NSString).substring(to: characterCount!)
                    }
                }else { // 有高亮选择的字符串，则暂不对文字进行统计和限制
                    
                }
            }else { // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
                if (toBeString?.lengthOfBytes(using: .utf8))! > characterCount! {
                    self.textView.text = (toBeString! as NSString).substring(to: characterCount!)
                }
            }
            countChanged()
            valueBlock!(self.textView.text as AnyObject)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.lengthOfBytes(using: .utf8)+text.lengthOfBytes(using: .utf8)-range.length > characterCount! {
            return false
        }
        return true
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    lazy var textView: TextView = {
        let textView = TextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.delegate = self as UITextViewDelegate
        return textView
    }()
    
    lazy var countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.font = UIFont.systemFont(ofSize: 12)
        countLabel.textColor = UIColor.lightGray
        countLabel.textAlignment = .right
        return countLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


