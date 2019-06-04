//
//  RescheduleTableViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class RescheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var editBtnInstance: UIButton!
    @IBOutlet weak var unavailableBtnInstance: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var cvcHgtConst: NSLayoutConstraint! // 45
    
    
    var rescheduleData:RescheduleModel?
    var slotsListCell:SlotsCollectionViewCell? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.layer.cornerRadius = 5.0
        bgView.layer.masksToBounds = true
        GenericMethods.shadowCellView(view:bgView)

        editBtnInstance.layer.cornerRadius = 5.0
        editBtnInstance.layer.masksToBounds = true
        editBtnInstance.layer.borderColor = UIColor.white.cgColor
        editBtnInstance.layer.borderWidth = 1.0
        
        unavailableBtnInstance.layer.cornerRadius = 5.0
        unavailableBtnInstance.layer.masksToBounds = true
        unavailableBtnInstance.layer.borderColor = AppConstants.appyellowColor.cgColor
        unavailableBtnInstance.layer.borderWidth = 1.0
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(UINib(nibName: "SlotsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "slotsListCell")
        
        let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
        cvcHgtConst.constant = height;
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension RescheduleTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        if self.rescheduleData != nil {
//            return self.rescheduleData?.rescheduleListData?.count ?? 10
//        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        slotsListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "slotsListCell", for: indexPath) as? SlotsCollectionViewCell
        
        slotsListCell?.bgView.layer.cornerRadius = 10.0
        slotsListCell?.bgView.layer.masksToBounds = true
        slotsListCell?.slotBtnInstance.isEnabled = false
        
        slotsListCell?.slotBtnInstance.titleLabel?.adjustsFontSizeToFitWidth = true
        slotsListCell?.slotBtnInstance.titleLabel?.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        
        return slotsListCell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 20)
    }
}
