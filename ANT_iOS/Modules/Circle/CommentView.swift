//
//  CommentView.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/20.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class CommentView: UIView {
    
    var nameLabel = UILabel()
    var commentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        self.nameLabel.frame = CGRect(x: 5, y: 2, width: 60, height: 20)
        self.nameLabel.textAlignment = .left
        self.nameLabel.font = UIFont.systemFont(ofSize: 13)
        self.nameLabel.textColor = UIColor(red: 74/255, green: 83/255, blue: 130/255, alpha: 1)
        
        self.commentLabel.frame = CGRect(x: self.nameLabel.width+5, y: 2, width: 200, height: 20)
        self.commentLabel.font = UIFont.systemFont(ofSize: 13)
        self.commentLabel.textAlignment = .left
        
        self.addSubview(nameLabel)
        self.addSubview(commentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
