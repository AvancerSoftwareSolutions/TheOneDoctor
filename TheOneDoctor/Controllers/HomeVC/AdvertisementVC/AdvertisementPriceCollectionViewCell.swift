//
//  AdvertisementPriceCollectionViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 18/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class AdvertisementPriceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GenericMethods.shadowCellView(view: self.bgView)
    }
    
}
