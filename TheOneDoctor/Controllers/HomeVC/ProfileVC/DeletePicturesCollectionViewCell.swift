//
//  DeletePicturesCollectionViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 21/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class DeletePicturesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var deleteBtnInstance: UIButton!
    @IBOutlet weak var playImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playImg.isHidden = true
        playImg.image = playImg.image?.withRenderingMode(.alwaysTemplate)
        playImg.tintColor = UIColor.white

        
        // Initialization code
    }
    
    
}
