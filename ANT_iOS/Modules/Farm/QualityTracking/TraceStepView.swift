//
//  TraceStepView.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/9/19.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

class TraceStepView: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildCellView()
    }
    
    func buildCellView() {
        contentView.backgroundColor = UIColor.white
        
        contentView.addSubview(serviceImage)
        serviceImage.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.centerX.equalTo(contentView)
            make.height.width.equalTo(80)
        }
        
        contentView.addSubview(serviceName)
        serviceName.snp.makeConstraints { (make) in
            make.top.equalTo(serviceImage.snp.bottom).offset(5);
            make.centerX.equalTo(contentView);
            make.height.equalTo(20);
        }
        
        contentView.addSubview(stepLabel)
        stepLabel.snp.makeConstraints { (make) in
            make.top.equalTo(serviceName.snp.bottom).offset(10);
            make.left.equalTo(20);
            make.right.equalTo(contentView).offset(-20);
        }
        
        let seperator = UIView()
        seperator.backgroundColor = BaseColor.LineColor
        contentView.addSubview(seperator)
        seperator.snp.makeConstraints { (make) in
            make.left.equalTo(30);
            make.right.equalTo(contentView).offset(-30);
            make.top.equalTo(stepLabel.snp.bottom).offset(10);
            make.height.equalTo(1);
            make.bottom.equalTo(-10);
        }
    }
    
    var stepData: StepGuideModel? {
        didSet {
            serviceName.text = stepData?.server_name
            serviceImage.kf.setImage(with: NSURL.init(string: (stepData?.server_image)!)! as URL, placeholder: IMAGE_AVATAR_PLACEHOLDER, options: nil, progressBlock: nil, completionHandler: nil)
            stepLabel.text = stepData?.step_title
        }
    }
    
    lazy var serviceImage: UIImageView = {
        let serviceImage = UIImageView()
        serviceImage.contentMode = .scaleAspectFill
        serviceImage.layer.cornerRadius = 40
        serviceImage.layer.borderColor = UIColor.init(white: 0, alpha: 0.4).cgColor
        serviceImage.layer.borderWidth = 0.5
        serviceImage.layer.masksToBounds = true
        return serviceImage
    }()
    
    lazy var serviceName: UILabel = {
        let serviceName = UILabel()
        serviceName.font = UIFont.systemFont(ofSize: 14)
        return serviceName
    }()
    
    lazy var stepLabel: UILabel = {
        let stepLabel = UILabel()
        stepLabel.font = UIFont.systemFont(ofSize: 14)
        stepLabel.numberOfLines = 0;
        stepLabel.textAlignment = .center
        stepLabel.isUserInteractionEnabled = true
        return stepLabel
    }()
    
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
