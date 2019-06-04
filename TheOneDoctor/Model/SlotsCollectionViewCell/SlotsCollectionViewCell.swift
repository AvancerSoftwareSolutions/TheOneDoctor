//
//  SlotsCollectionViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 29/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class SlotsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var slotBtnInstance: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 5.0
        bgView.layer.masksToBounds = true
        bgView.layer.borderColor = AppConstants.appGreenColor.cgColor
        bgView.layer.borderWidth = 1.0
    }

}
