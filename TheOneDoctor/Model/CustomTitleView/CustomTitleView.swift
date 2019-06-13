//
//  CustomTitleView.swift
//  TheOneDoctor
//
//  Created by MyMac on 11/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class CustomTitleView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dropDownBtnInst: UIButton!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        customInit()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customInit()
        
    }
    
    func customInit() {
        Bundle.main.loadNibNamed("CustomTitleView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
    }
//    override var intrinsicContentSize: CGSize {
//        return UIView.layoutFittingExpandedSize
//    }

}
