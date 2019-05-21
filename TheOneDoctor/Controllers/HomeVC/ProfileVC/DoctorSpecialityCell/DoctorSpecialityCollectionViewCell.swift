//
//  DoctorSpecialityCollectionViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 08/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class DoctorSpecialityCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var deleteBtnInst: UIButton!
    @IBOutlet weak var specialityLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        specialityLbl.adjustsFontSizeToFitWidth = true
        // Initialization code
    }

}
