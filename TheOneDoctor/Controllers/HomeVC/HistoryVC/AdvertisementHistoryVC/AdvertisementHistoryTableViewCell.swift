//
//  AdvertisementHistoryTableViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 27/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class AdvertisementHistoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var specialityName: UILabel!
    @IBOutlet weak var adTypeLbl: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var viewAdsLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        GenericMethods.shadowCellView(view: bgView)
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
