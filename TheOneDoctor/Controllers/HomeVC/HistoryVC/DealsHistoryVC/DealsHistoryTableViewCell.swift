//
//  DealsHistoryTableViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 28/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class DealsHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var adtitleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var specialityLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        GenericMethods.shadowCellView(view: bgView)
        discountLbl.layer.cornerRadius = discountLbl.bounds.height / 2
        discountLbl.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
