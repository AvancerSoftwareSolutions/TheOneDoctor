//
//  DoctorPicturesCollectionViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 08/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class DoctorPicturesCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var DocPicImgView: UIImageView!
    
    @IBOutlet weak var playImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playImgView.isHidden = true
        playImgView.setImageColor(color: UIColor.white)
        
        
        // Initialization code
    }

}
