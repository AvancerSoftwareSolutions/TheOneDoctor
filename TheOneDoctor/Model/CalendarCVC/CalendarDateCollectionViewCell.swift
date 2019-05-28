//
//  CalendarDateCollectionViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 22/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarDateCollectionViewCell: JTAppleCell {

    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var achievedCountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        // Initialization code
    }

}
