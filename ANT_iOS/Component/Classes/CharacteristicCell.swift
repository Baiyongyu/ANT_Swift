//
//  CharacteristicCell.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/19.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

protocol CharacteristicCellDelegate {
    func addNewCharacteristicLabel()
    func deleteLabelWithCell(cell: CharacteristicCell)
}

class CharacteristicCell: UICollectionViewCell {
    var delegate: CharacteristicCellDelegate?
    
    var nameLabel = UILabel()
    var deleteBtn = UIButton()
    var addBtn = UIButton()
    var indexPath: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubViews()
    }
    
    func loadSubViews() {
        let nameLabel = UILabel(frame: contentView.bounds)
        self.nameLabel = nameLabel
        nameLabel.backgroundColor = UIColor.white
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.layer.cornerRadius = 4
        nameLabel.layer.borderColor = BaseColor.LineColor.cgColor
        nameLabel.layer.borderWidth = 0.5
        nameLabel.layer.masksToBounds = true
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
        
        let deleteBtn = UIButton(frame: CGRect(x: 70-15-2, y: 2, width: 15, height: 15))
        deleteBtn.setImage(UIImage.init(named: "ic_photo_delete"), for: .normal)
        self.deleteBtn = deleteBtn
        deleteBtn.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
        contentView.addSubview(deleteBtn)
        
        let addBtn = UIButton(type: UIButtonType.custom)
        addBtn.frame = contentView.bounds
        addBtn.setTitle("添加", for: .normal)
        addBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e647}", size: 15, color: BaseColor.ThemeColor)), for: .normal)
        addBtn.setTitleColor(BaseColor.ThemeColor, for: .normal)
        addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        addBtn.isHidden = true
        self.addBtn = addBtn
        addBtn.addTarget(self, action: #selector(addLabelAction), for: .touchUpInside)
        contentView.addSubview(addBtn)
    }
    
    var model: CharacteristicModel? {
        didSet {
            nameLabel.text = model?.feature_title
            if model?.is_mine == "0" {
                self.deleteBtn.isHidden = true
            }else {
                self.deleteBtn.isHidden = false
            }
        }
    }
    
    func deleteBtnAction() {
        self.delegate?.addNewCharacteristicLabel()
    }
    
    func addLabelAction() {
        self.delegate?.deleteLabelWithCell(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class CharacteristicModel: NSObject {
    //特点id
    var feature_id: String?
    //特点名称
    var feature_title: String?
    //0为原有  1为新加
    var is_mine: String?
}
