//
//  AppointmentsTableViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 16/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class AppointmentsTableViewCell: UITableViewCell {

    @IBOutlet weak var userTypeLbl: UILabel!
    @IBOutlet weak var patientNameLbl: UILabel!
    @IBOutlet weak var clinicNameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dayMonthLbl: UILabel!
    @IBOutlet weak var userTypeWdtConst: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
