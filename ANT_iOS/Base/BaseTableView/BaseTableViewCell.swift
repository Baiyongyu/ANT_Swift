//
//  BaseTableViewCell.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/12.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    
    var isAutoHeight: Bool?
    var item: AnyObject?
    var indexPath: IndexPath?
    var cellConfigureBlock: CellConfigureBlock?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        buildCellView()
    }
    
    func buildCellView() {
        
    }
    
    func setCellData(item: AnyObject, atIndexPath indexPath: IndexPath) {
        
    }
    
    func cellAutoHeight(item: AnyObject, atIndexPath indexPath: IndexPath) -> CGFloat {
        
        if cellConfigureBlock != nil {
            cellConfigureBlock!(self, item, indexPath)
        }
        self.setCellData(item: item, atIndexPath: indexPath)
        
        self.layoutIfNeeded()
        self.updateConstraintsIfNeeded()
        
        let height = contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        return height
    }
    
    func cellHeight(item: AnyObject, atIndexPath indexPath: IndexPath) -> CGFloat {

        if isAutoHeight! {
            return self.cellAutoHeight(item:item, atIndexPath: indexPath)
            
        }else {
            return CGFloat(TableViewCellDefaultHeight)
        }
    }
    
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
