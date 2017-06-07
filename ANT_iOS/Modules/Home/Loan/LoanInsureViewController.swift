//
//  LoanInsureViewController.swift
//  ANT_iOS
//
//  Created by 宇玄丶 on 2017/6/6.
//  Copyright © 2017年 qianmo. All rights reserved.
//

import UIKit

enum LoanOrInsureType {
    case loan
    case insure
}

class LoanInsureViewController: BaseViewController {
    
    var types: LoanOrInsureType?
    let loanType = LoanOrInsureType.loan
    
    override func loadSubViews() {
        super.loadSubViews()
        
        switch loanType {
        case .loan:
            self.titleLabel.text = "办贷款"
            break
        case .insure:
            self.titleLabel.text = "买保险"
            break
        }
    }
}
