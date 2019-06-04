//
//  QueueViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 30/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class QueueViewController: UIViewController {

    @IBOutlet weak var queueCollectionView: UICollectionView!
    @IBOutlet weak var totalPatientView: UIView!
    @IBOutlet weak var totalPatientLbl: UILabel!
    @IBOutlet weak var pendingPatientView: UIView!
    @IBOutlet weak var pendingPatientLbl: UILabel!
    
    @IBOutlet weak var stackViewHgtConst: NSLayoutConstraint!
    
    //MARK: Variables
    var queueArray:NSMutableArray = []
    var slotsListCell:SlotsCollectionViewCell? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Queue"
        
        self.queueCollectionView.register(UINib(nibName: "SlotsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "slotsListCell")

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        stackViewHgtConst.constant = totalPatientView.bounds.height
        totalPatientView.layer.cornerRadius = totalPatientView.bounds.height / 2
        totalPatientView.layer.masksToBounds = true
        pendingPatientView.layer.cornerRadius = pendingPatientView.bounds.height / 2
        pendingPatientView.layer.masksToBounds = true
        self.shadowView(view: self.totalPatientView)
        self.shadowView(view:self.pendingPatientView)
    }
    func shadowView(view:UIView)
    {
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.2
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 2.5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
    }


}
extension QueueViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    //dashboardCell
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        slotsListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "slotsListCell", for: indexPath) as? SlotsCollectionViewCell
        
        slotsListCell?.bgView.layer.cornerRadius = 0.0
        slotsListCell?.bgView.layer.masksToBounds = true
        slotsListCell?.slotBtnInstance.isEnabled = true
        slotsListCell?.bgView.layer.borderColor = UIColor.white.cgColor
        slotsListCell?.slotBtnInstance.setTitleColor(UIColor.clear, for: .normal)
        slotsListCell?.slotBtnInstance.setTitle("", for: .normal)
        slotsListCell?.slotBtnInstance.setImage(UIImage(named: "green-man.png"), for: .normal)
        
        
       
        return slotsListCell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 60, height: queueCollectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    
}
