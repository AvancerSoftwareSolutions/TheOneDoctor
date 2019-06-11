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
    var queueListData:QueueModel?
    let apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Queue"
        
        let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshClick))
        
        self.navigationItem.rightBarButtonItem = refreshBtn
        
        self.queueCollectionView.register(UINib(nibName: "SlotsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "slotsListCell")
        self.loadingQueueDetailsAPI()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        stackViewHgtConst.constant = totalPatientView.bounds.width
        totalPatientView.layer.cornerRadius = totalPatientView.bounds.height / 2
        totalPatientView.layer.masksToBounds = true
        pendingPatientView.layer.cornerRadius = pendingPatientView.bounds.height / 2
        pendingPatientView.layer.masksToBounds = true
        self.shadowView(view: self.totalPatientView)
        self.shadowView(view:self.pendingPatientView)
    }
    @objc func refreshClick()
    {
        self.loadingQueueDetailsAPI()
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
    
    // MARK: - Queue API
    func loadingQueueDetailsAPI()
    {
        var parameters = Dictionary<String, Any>()
        parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.queueListDetailsAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.queueListData = response
                if self.queueListData?.status?.code == "0" {
                    //MARK: Queue Success Details
                    
                    self.totalPatientLbl.text = "\(self.queueListData?.appointmentData?.totalPatientCount ?? 0)"
                    self.pendingPatientLbl.text = "\(self.queueListData?.appointmentData?.attendedCount ?? 0)"
                    
                    self.queueCollectionView.reloadData()
                    
                }
                else
                {
                    GenericMethods.showAlertwithPopNavigation(alertMessage: self.queueListData?.status?.message ?? "Unable to fetch data. Please try again after sometime.", vc: self)
                    
                }
                
                
            }
            else {
                GenericMethods.showAlertwithPopNavigation(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.", vc: self)
                
                
                
            }
        }
    }


}
extension QueueViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    //dashboardCell
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.queueListData != nil {
            return (self.queueListData?.appointmentData?.queueData?.count) ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        slotsListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "slotsListCell", for: indexPath) as? SlotsCollectionViewCell
        
        slotsListCell?.bgView.layer.cornerRadius = 0.0
        slotsListCell?.bgView.layer.masksToBounds = true
        slotsListCell?.slotBtnInstance.isEnabled = true
        slotsListCell?.bgView.layer.borderColor = UIColor.white.cgColor
        slotsListCell?.slotBtnInstance.setTitleColor(UIColor.clear, for: .normal)
        slotsListCell?.slotBtnInstance.setTitle("", for: .normal)
//        slotsListCell?.slotBtnInstance.setImage(UIImage(named: "green-man.png"), for: .normal)
        
        if queueListData?.appointmentData?.queueData?[indexPath.row].otpStatus ?? 0 == 0
        {
            // Not yet register otp
            if queueListData?.appointmentData?.queueData?[indexPath.row].sex == "male"
            {
                //
                slotsListCell?.slotBtnInstance.setImage(UIImage(named: "man_NOT.png"), for: .normal)
            }
            else
            {
                slotsListCell?.slotBtnInstance.setImage(UIImage(named: "Wom_NOT.png"), for: .normal)
            }
        }
        else
        {
            // otp registered
            if queueListData?.appointmentData?.queueData?[indexPath.row].sex == "male"
            {
                //
                slotsListCell?.slotBtnInstance.setImage(UIImage(named: "man_OTP.png"), for: .normal)
            }
            else
            {
                slotsListCell?.slotBtnInstance.setImage(UIImage(named: "Wom_OTP.png"), for: .normal)
            }
        }
        
        
        
        
//        let queueListData?.appointmentData?.queueData?[indexPath.row].otpStatus
        
        
       
        return slotsListCell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 60, height: queueCollectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    
}
