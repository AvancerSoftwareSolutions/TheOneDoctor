//
//  AddNormalScheduleTVC.swift
//  TheOneDoctor
//
//  Created by MyMac on 22/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class AddNormalScheduleTVC: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var fromTimeBtnInstance: UIButton!
    @IBOutlet weak var toTimeBtnInstance: UIButton!
    @IBOutlet weak var patientHrsBtnInstance: UIButton!
    
    @IBOutlet weak var weekDayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GenericMethods.shadowCellView(view:bgView)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
