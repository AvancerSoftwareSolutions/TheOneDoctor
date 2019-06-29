//
//  AppointmentsTableViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 16/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class AppointmentsTableViewCell: UITableViewCell {

    @IBOutlet weak var appointmentIdLbl: UILabel!
    @IBOutlet weak var userTypeLbl: UILabel!
    @IBOutlet weak var patientNameLbl: UILabel!
    @IBOutlet weak var clinicNameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dayMonthLbl: UILabel!
    @IBOutlet weak var userTypeWdtConst: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        semiRound(label: self.userTypeLbl)
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func semiRound(label:UILabel)
    {
        
        
        let circlePath = UIBezierPath.init(arcCenter: CGPoint(x: label.bounds.size.width / 2, y: label.bounds.size.height / 2), radius: label.bounds.size.width / 2, startAngle: CGFloat(270.0).toRadians, endAngle: CGFloat(90.0).toRadians, clockwise: false)
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        label.layer.mask = circleShape
    }

}
