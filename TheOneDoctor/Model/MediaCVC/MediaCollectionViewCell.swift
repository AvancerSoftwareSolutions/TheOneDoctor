//
//  MediaCollectionViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 11/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import Photos

class MediaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mediaImgView: UIImageView!
    @IBOutlet weak var selectCellView: UIView!
    @IBOutlet weak var playImg: UIImageView!
    
    var asset:PHAsset?
    
//    override var isSelected: Bool{
//        didSet{
//            if self.isSelected
//            {
//                print("Selected")
//                selectCellView.isHidden = false
//            }
//            else
//            {
//                print("Unselected")
//                selectCellView.isHidden = true
//            }
//        }
//    }
    
}
