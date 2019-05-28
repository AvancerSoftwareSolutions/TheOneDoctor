//
//  AppointmentFilterCollectionViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 25/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class AppointmentFilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var textBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textBtn.setTitleColor(AppConstants.appGreenColor, for: .normal)
        bgView.layer.cornerRadius = 5.0
        bgView.layer.masksToBounds = true
        bgView.layer.borderColor = AppConstants.appGreenColor.cgColor
        bgView.layer.borderWidth = 1.0
        // Initialization code
    }

}
