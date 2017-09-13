//
//  BaseTableViewDataSource.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/29.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

typealias CellConfigureBlock = (_ cell: UITableViewCell, _ data: AnyObject, _ indexPath: IndexPath) -> Void

class BaseTableViewDataSource: NSObject, UITableViewDataSource {
    var items: NSArray? {
        didSet {
            print("调用didSet方法：items")
        }
    }
    
    var cellIdentifier: String?
    var cellConfigureBlock: CellConfigureBlock?
    
    override init() {
        super.init()
    }
    
    init(items: NSArray) {
        self.items = items
    }
    
    init(items: NSArray, cellIdentifier: String, cellConfigureBlock: CellConfigureBlock?) {
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.cellConfigureBlock = cellConfigureBlock
    }
    
    init(cellIdentifier: String, cellConfigureBlock: CellConfigureBlock?) {
        self.cellIdentifier = cellIdentifier
        self.cellConfigureBlock = cellConfigureBlock
    }

    func itemAtIndexPath(indexPath: IndexPath) -> AnyObject {
        return items![indexPath.row] as AnyObject
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier!, for: indexPath)
        if (cellConfigureBlock != nil) {
            let item = self.itemAtIndexPath(indexPath: indexPath)
            cellConfigureBlock!(cell, item, indexPath)
        }
        return cell
    }
}
