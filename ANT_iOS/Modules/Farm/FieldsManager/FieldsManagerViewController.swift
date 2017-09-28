//
//  FieldsManagerViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/13.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class FieldsManagerViewController: BaseViewController {

    var selectedSegmentIndex: NSInteger?
    var popMenu: PopupMenu!
    
    override func loadSubViews() {
        super.loadSubViews()
        rightBtn.isHidden = false
        rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e61e}", size: 20, color: UIColor.black)), for: .normal)
        rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e61e}", size: 20, color: UIColor.gray)), for: .highlighted)
        navBar.addSubview(segmentControl)
        
        addChildViewController(fieldsTableVC)
        fieldsTableVC.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height-NavBarHeight)
        addChildViewController(fieldsMapVC)
        fieldsMapVC.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height-NavBarHeight)
    }
    
    override func layoutConstraints() {
        segmentControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(navBar);
            make.centerY.equalTo(navBar).offset(IS_IPHONE_iPX ? 15 : 5);
        }
    }
    
    override func loadData() {
        segmentControl.selectedSegmentIndex = 0
        view.layoutIfNeeded()
        contentView.addSubview(segmentControl.selectedSegmentIndex == 0 ? fieldsTableVC.view : fieldsMapVC.view)
        
        let fieldGroupData = FieldGroupModel()
        fieldGroupData.group_name = "1号田"
        fieldGroupData.total_area_size = 15284.03
        
        let fieldData = FieldModel()
        fieldData.thumbnail_url = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505366553726&di=69a2f77bed20228a48c260ceaa972cf7&imgtype=0&src=http%3A%2F%2Ftva1.sinaimg.cn%2Fcrop.0.0.1080.1080.1024%2F006BffOMjw8f8uctxaldlj30u00u0n2a.jpg"
        fieldData.field_name = "天宫一号"
        fieldData.area_size = 500
        
        let plantData = PlantModel()
        plantData.plant_crop_nam = "辽宁号"
        fieldData.crop_list.adding(plantData)
    
        fieldGroupData.field_list = [fieldData,fieldData,fieldData]
        
        fieldsTableVC.dataArray = [fieldGroupData,fieldGroupData,fieldGroupData]
    }
    
    func segmentSwitch(sender: UISegmentedControl) {
        let newController = sender.selectedSegmentIndex == 0 ? fieldsTableVC : fieldsMapVC
        let oldController = sender.selectedSegmentIndex == 0 ? fieldsMapVC : fieldsTableVC
        
        self.transition(from: oldController, to: newController, duration: 0.1, options: .transitionCrossDissolve, animations: nil) { (finished) in
            
            if finished {
                newController.didMove(toParentViewController: self)
            }
        }
    }
    
    override func rightBtnAction() {
      
        popMenu = PopupMenu(frame: CGRect(x: SCREEN_WIDTH - 160, y: NavBarHeight, width: 150, height: 150), arrowMargin: 12)
        
        popMenu.popData = [(icon: "ic_add_field", title: "添加田块"),
                           (icon: "ic_add_fieldgroup", title: "添加分组"),
                           (icon: "ic_fieldgroup_management", title: "分组管理")]
        //点击菜单
        popMenu.didSelectMenuBlock = { [weak self](index: Int)->Void in
            self?.popMenu.dismiss()
            switch index {
                case 0:
                    AppCommon.push(PlantManagerViewController(), animated: true)
                case 1:
                    AppCommon.push(PlantManagerViewController(), animated: true)
                case 2:
                    AppCommon.push(PlantManagerViewController(), animated: true)
                default:
                    break
            }
        }
        popMenu.show()
    }
    
    lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["列表","地图"])
        segmentControl.setWidth(80, forSegmentAt: 0)
        segmentControl.setWidth(80, forSegmentAt: 1)
        segmentControl.tintColor = BaseColor.ThemeColor
        segmentControl.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName:BaseColor.ThemeColor], for: .normal)
        segmentControl.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName:UIColor.white], for: .selected)
        segmentControl.addTarget(self, action: #selector(segmentSwitch), for: .valueChanged)
        return segmentControl
    }()

    lazy var fieldsTableVC: FieldsTableViewController = {
        let fieldsTableVC = FieldsTableViewController(style: .plain)
        fieldsTableVC.tableView.tableFooterView = UIView.init(frame: .zero)
        fieldsTableVC.view.backgroundColor = BaseColor.BackGroundColor
        return fieldsTableVC
    }()
    
    lazy var fieldsMapVC: FieldsMapViewController = {
        let fieldsMapVC = FieldsMapViewController()
        return fieldsMapVC
    }()
    
}
