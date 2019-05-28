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
    
    
    var rescheduleData:RescheduleModel?
    var appointfilterCell:AppointmentFilterCollectionViewCell? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        editBtnInstance.layer.borderColor = UIColor.white.cgColor
        editBtnInstance.layer.borderWidth = 1.0
        unavailableBtnInstance.layer.borderColor = AppConstants.appyellowColor.cgColor
        unavailableBtnInstance.layer.borderWidth = 1.0
        
        self.collectionView.register(UINib(nibName: "AppointmentFilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "appointfilterCell")
        
        
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
        
        if self.rescheduleData != nil {
            return self.rescheduleData?.rescheduleListData?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        appointfilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "appointfilterCell", for: indexPath) as? AppointmentFilterCollectionViewCell
        
        // appointfilterCell?.textBtn.setTitle("\(self.appointmentsListData?.filterData?[0].appointments?[indexPath.row] ?? "")", for: .normal)
        //appointfilterCell?.textBtn.layer.borderColor = AppConstants.appGreenColor.cgColor
//        appointfilterCell?.textBtn.setTitleColor(AppConstants.appGreenColor, for: .normal)
        
        return appointfilterCell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize:CGFloat = collectionView.frame.size.width - 20
        return CGSize(width: cellSize / 2, height: 45)
    }
}
