//
//  TraceStep3ViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/19.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

let margin = (SCREEN_WIDTH - 70 * 3) / (SCREEN_WIDTH > 320 ? 4 : 3)

class TraceStep3ViewController: BaseViewController {

    var dataArray = Array<Any>()
    var selectArray = Array<Any>()
    var selectedIndexPath: IndexPath?
    fileprivate static let classCollectionViewCellIdentifier = "ClassCollectionViewCell"
    
    override func loadSubViews() {
        super.loadSubViews()
        titleLabel.text = "第三步"
        contentView.backgroundColor = UIColor.white
        
        rightBtn.isHidden = false
        rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e611}", size: 25, color: UIColor.black)), for: .normal)
        rightBtn.setImage(UIImage.icon(with: TBCityIconInfo.init(text: "\u{e611}", size: 25, color: UIColor.gray)), for: .highlighted)
        
        let traceStepView = TraceStepView(style: .default, reuseIdentifier: "")
        traceStepView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 220)
        traceStepView.centerX = view.centerX
        
        let stepData = StepGuideModel()
        stepData.server_name = "小陌"
        stepData.server_image = ""
        stepData.step_title = "选出农产品的特点，最多只能选3个哦"
        traceStepView.stepData = stepData
        contentView.addSubview(traceStepView)

        contentView.addSubview(collectionView)
    }
    
    override func layoutConstraints() {
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(290, 0, 49, 0))
        }
        
        contentView.addSubview(nextStepkBtn)
        nextStepkBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.bottom.equalTo(view).offset(-40)
            make.height.equalTo(44)
        }
    }

    override func loadData() {
        let model = CharacteristicModel()
        model.feature_title = "无污染"
        dataArray = [model,model,model,model,model,model,model,model,model,model]
//        dataArray = ["无污染","绿色","有机","无公害","生态","口感好","香甜"]
        collectionView.reloadData()
    }
    
    override func rightBtnAction() {
        let alertView = YYAlertView()
        alertView.initWithTitle(titles: "退出后已经填写的信息将不会被保存，确定要退出吗？", message: "", sureTitle: "确定", cancleTitle: "取消")
        alertView.alertSelectIndex = { (index) -> Void in
            if index == 2 {
                self.dismiss(animated: true, completion: nil)
            }
        }
        alertView.showAlertView()
    }
    
    func nextStepkBtnAction() {
       let step4 = TraceStep4ViewController()
       self.navigationController?.pushViewController(step4, animated: true)
    }
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsetsMake(0, margin/2, margin/2, margin/2)
        layout.itemSize = CGSize(width: 70, height: 40)
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 190, width: SCREEN_WIDTH, height: SCREEN_WIDTH > 320 ? 300 : 220), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(CharacteristicCell.self, forCellWithReuseIdentifier: classCollectionViewCellIdentifier)
        return collectionView
    }()
    
    lazy var nextStepkBtn: UIButton = {
        let nextStepkBtn = UIButton(type: UIButtonType.custom)
        nextStepkBtn.setTitle("下一步", for: .normal)
        nextStepkBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextStepkBtn.setTitleColor(UIColor.white, for: .normal)
        nextStepkBtn.setTitleColor(BaseColor.GrayColor, for: .highlighted)
        nextStepkBtn.backgroundColor = BaseColor.ThemeColor
        nextStepkBtn.layer.cornerRadius = 5
        nextStepkBtn.clipsToBounds = true
        nextStepkBtn.addTarget(self, action: #selector(nextStepkBtnAction), for: .touchUpInside)
        return nextStepkBtn
    }()
}

extension TraceStep3ViewController: UICollectionViewDelegate, UICollectionViewDataSource, CharacteristicCellDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TraceStep3ViewController.classCollectionViewCellIdentifier, for: indexPath) as! CharacteristicCell
        cell.delegate = self as CharacteristicCellDelegate
        cell.indexPath = indexPath
        if indexPath.row < dataArray.count {
            let model = dataArray[indexPath.row]
            cell.model = model as? CharacteristicModel
            
            cell.addBtn.isHidden = true
        }
        
        if indexPath.row == dataArray.count {
            cell.addBtn.isHidden = false
            cell.nameLabel.text = ""
            cell.deleteBtn.isHidden = true
            cell.nameLabel.backgroundColor = UIColor.white
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let model = dataArray[indexPath.row] as! CharacteristicModel
        
    }
    
    func addNewCharacteristicLabel() {
        
    }
    
    func deleteLabelWithCell(cell: CharacteristicCell) {
        selectedIndexPath = cell.indexPath
    }
    
    
}
