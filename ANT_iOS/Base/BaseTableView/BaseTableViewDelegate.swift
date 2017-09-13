//
//  BaseTableViewDelegate.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/12.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

typealias CellSelectBlock = (_ tableView: UITableView, _ indexPath: IndexPath) -> Void
typealias CellHeightBlock = (_ tableView: UITableView, _ indexPath: IndexPath) -> CGFloat
typealias ScrollViewDidScrollBlock = (_ tableView: UITableView) -> Void
typealias EditActionsForRowAtIndexPath = (_ tableView: UITableView, _ indexPath: IndexPath) -> NSArray

class BaseTableViewDelegate: NSObject, UITableViewDelegate {

    var clearSeperatorInset: Bool?
    var cellSelectBlock: CellSelectBlock?
    var cellHeightBlock: CellHeightBlock?
    var scrollViewDidScrollBlock: ScrollViewDidScrollBlock?
    var editActionsForRowAtIndexPath: EditActionsForRowAtIndexPath?
    var cellIdentifier: String?
    
    init(cellIdentifier: String) {
        self.cellIdentifier = cellIdentifier
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if cellSelectBlock != nil {
            cellSelectBlock!(tableView, indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellHeightBlock != nil {
            return cellHeightBlock!(tableView, indexPath)
        }
        return CGFloat(TableViewCellDefaultHeight)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return editActionsForRowAtIndexPath!(tableView, indexPath) as? [UITableViewRowAction]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if !clearSeperatorInset! {
            return
        }
        if(cell.responds(to: #selector(setter: UITableViewCell.separatorInset))){
            cell.separatorInset = .zero
        }
        if(cell.responds(to: #selector(setter: UIView.layoutMargins))){
            cell.layoutMargins = .zero
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollViewDidScrollBlock != nil {
            scrollViewDidScrollBlock!(scrollView as! UITableView);
        }
    }
}

