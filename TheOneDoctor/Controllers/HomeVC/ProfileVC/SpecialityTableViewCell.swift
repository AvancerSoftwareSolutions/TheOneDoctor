//
//  SpecialityTableViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 14/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class SpecialityTableViewCell: UITableViewCell {

    @IBOutlet weak var specialityNameLbl: UILabel!
    @IBOutlet weak var addBtnInstance: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        specialityNameLbl.adjustsFontSizeToFitWidth = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
