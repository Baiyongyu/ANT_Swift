//
//  BaseTableViewDataSource.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/29.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

typealias CellConfigureBlock = (_ cell: UITableViewCell, _ data: AnyObject, _ indexPath: NSIndexPath) -> Void

class BaseTableViewDataSource: NSObject, UITableViewDataSource {
    var items = NSArray()
    var cellIdentifier: String?
    var cellConfigureBlock: CellConfigureBlock?
    
    override init() {
        super.init()
    }
    
    func initWithItems(items: NSArray, cellIdentifier: String, cellConfigureBlock: CellConfigureBlock?) {
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.cellConfigureBlock = cellConfigureBlock
    }
    
    func initWithCellIdentifier(cellIdentifier: String, cellConfigureBlock: CellConfigureBlock?) {
        self.cellIdentifier = cellIdentifier
        self.cellConfigureBlock = cellConfigureBlock
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> AnyObject {
        return items[indexPath.row] as AnyObject
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier!, for: indexPath)
        if (cellConfigureBlock != nil) {
            let item = self.itemAtIndexPath(indexPath: indexPath as NSIndexPath)
            cellConfigureBlock!(cell, item, indexPath as NSIndexPath)
        }
        return cell
    }
    
    
    
    func setItems(items: NSArray) {
        self.items = items
    }
}
