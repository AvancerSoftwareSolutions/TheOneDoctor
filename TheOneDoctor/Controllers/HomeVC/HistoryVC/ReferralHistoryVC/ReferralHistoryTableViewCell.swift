//
//  ReferralHistoryTableViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 22/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class ReferralHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var patientNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var referredDoctorNameLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var clinicNameLbl: UILabel!
    @IBOutlet weak var bookingCommisionLbl: UILabel!
    @IBOutlet weak var pharmacyLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        GenericMethods.shadowCellView(view: bgView)
        self.selectionStyle = .none
        self.bookingCommisionLbl.text = ""
        self.pharmacyLbl.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
