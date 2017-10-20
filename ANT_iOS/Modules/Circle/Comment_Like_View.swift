//
//  CommentView.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/10/20.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class Comment_Like_View: UIView {

    let likeViewBackImage = UIImageView()
    var likeImage = UIImageView()
    var likeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        self.likeImage.image = UIImage(named: "likewhite")
        self.likeViewBackImage.image = UIImage(named:"comment")
        
        self.likeImage.frame = CGRect(x: 5, y: 5, width: 15, height: 15)
        self.likeViewBackImage.frame = CGRect(x: 0, y: -6, width: 60, height: 20)
        
        self.likeLabel.frame = CGRect(x: 25, y: 2, width: UIScreen.main.bounds.size.width-10-15-55-27, height: 20)
        self.likeLabel.font = UIFont.systemFont(ofSize: 12)
        
        self.addSubview(likeViewBackImage)
        self.addSubview(likeImage)
        self.addSubview(likeLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
