//
//  SlotsTableViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class SlotsTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleBtnInstance: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 5.0
        bgView.layer.masksToBounds = true
        bgView.layer.borderColor = AppConstants.appGreenColor.cgColor
        bgView.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
