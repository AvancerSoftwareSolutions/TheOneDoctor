//
//  DoctorListTableViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 19/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class DoctorListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var doctorImgView: UIImageView!
    @IBOutlet weak var doctorNameLbl: UILabel!
    @IBOutlet weak var doctorSpecialityLbl: UILabel!
    @IBOutlet weak var feesLbl: UILabel!
    @IBOutlet weak var clinicNameLbl: UILabel!
    @IBOutlet weak var clinicAddressLbl: UILabel!
    @IBOutlet weak var nextAvailableLbl: UILabel!
    @IBOutlet weak var referBtnInstance: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nextAvailableLbl.isHidden = true
        GenericMethods.shadowCellView(view: bgView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
