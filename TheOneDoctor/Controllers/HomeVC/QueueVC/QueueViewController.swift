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
    var queueCell:QueueCollectionViewCell? = nil
    var queueListData:QueueModel?
    let apiManager = APIManager()
    var filterType = ""
    var filterView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Queue"
        
        let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshClick))
        
        filterView = UIView(frame: CGRect(x: 28, y: 0, width: 10, height: 10))
        filterView.backgroundColor = .red
        filterView.layer.cornerRadius = 5
        filterView.layer.masksToBounds = true
        filterView.isHidden = true
        
        
        let svgHoldingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        GenericMethods.setLeftViewWithSVG(svgView: svgHoldingView, with: "filter", color: UIColor.white)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(filterBtnClick(sender:)))
        tapGesture.numberOfTapsRequired = 1
        svgHoldingView.addGestureRecognizer(tapGesture)
        svgHoldingView.addSubview(filterView)
        svgHoldingView.bringSubviewToFront(filterView)
        filterView.layer.zPosition = .greatestFiniteMagnitude
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: svgHoldingView),refreshBtn]

        self.loadingQueueDetailsAPI(fromLoad: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshClick), name: Notification.Name(rawValue: "refreshQueue"), object: nil)
        
        
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
    @objc func filterBtnClick(sender:UITapGestureRecognizer)
    {
        let optionsController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        optionsController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

        optionsController.view.tintColor = AppConstants.khudColour

        let subView: UIView? = optionsController.view.subviews.first
        let alertContentView: UIView? = subView?.subviews.first
        alertContentView?.backgroundColor = UIColor.white
        alertContentView?.layer.cornerRadius = 5
        
        for i in 0..<(self.queueListData?.appointmentData?.filter?.count ?? 0)
        {
            optionsController.addAction(UIAlertAction(title: self.queueListData?.appointmentData?.filter?[i], style: .default, handler: { (alertAction) in
                self.filterView.isHidden = false
                if i == 0
                {
                    self.filterType = ""
                    self.filterView.isHidden = true
                }
                else
                {
                   self.filterType = self.queueListData?.appointmentData?.filter?[i] ?? ""
                }
                self.loadingQueueDetailsAPI(fromLoad: 1)

            }))
        }
       
        optionsController.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (alertAction) in
            self.filterType = ""
            self.filterView.isHidden = true
            self.loadingQueueDetailsAPI(fromLoad: 1)
        }))

        //        let senderView = sender
        optionsController.modalPresentationStyle = .popover

        let popPresenter: UIPopoverPresentationController? = optionsController.popoverPresentationController
        popPresenter?.sourceView = self.view
        popPresenter?.sourceRect = self.view.bounds
        DispatchQueue.main.async(execute: {
            //    self.hud.hide(animated: true)
            //[self.tableView reloadData];
            UIApplication.shared.topMostViewController()?.present(optionsController, animated: true)
        })
    }
    @objc func refreshClick()
    {
        self.loadingQueueDetailsAPI(fromLoad: 1)
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
    func loadingQueueDetailsAPI(fromLoad:Int)
    {
        var parameters = Dictionary<String, Any>()
        parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        parameters["Type"] = filterType
        
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
                   if fromLoad == 0
                   {
                    GenericMethods.showAlertwithPopNavigation(alertMessage: self.queueListData?.status?.message ?? "Unable to fetch data. Please try again after sometime.", vc: self)
                    
                    }
                    else
                   {
                    GenericMethods.showAlert(alertMessage: self.queueListData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                    
                    }
                    
                    
                }
                
                
            }
            else {
                if fromLoad == 0
                {
                    GenericMethods.showAlertwithPopNavigation(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.", vc: self)
                    
                }
                else
                {
                    GenericMethods.showAlert(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.")
                    
                }
                
                
                
                
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
        queueCell = collectionView.dequeueReusableCell(withReuseIdentifier: "queueCell", for: indexPath) as? QueueCollectionViewCell
        
        let referral = queueListData?.appointmentData?.queueData?[indexPath.row].referral
        if referral == 1
        {
            queueCell?.userTypeLbl.text = "Referral"
        }
        else
        {
            queueCell?.userTypeLbl.text = queueListData?.appointmentData?.queueData?[indexPath.row].type
        }
        
        let sex = queueListData?.appointmentData?.queueData?[indexPath.row].sex?.lowercased()
        print("sex \(sex ?? "empty")")
        
        if queueListData?.appointmentData?.queueData?[indexPath.row].otpStatus ?? 0 == 0
        {
            // Not yet register otp
            if sex == "male"
            {
                //
                self.queueCell?.queueImgView.image = UIImage(named: "man_NOT.png")
               
            }
            else
            {
                self.queueCell?.queueImgView.image = UIImage(named: "Wom_NOT.png")
               
            }
        }
        else
        {
            // otp registered
            if sex == "male"
            {
                self.queueCell?.queueImgView.image = UIImage(named: "man_OTP.png")
               
            }
            else
            {
                self.queueCell?.queueImgView.image = UIImage(named: "Wom_OTP.png")
               
            }
        }
        
        
        
        
//        let queueListData?.appointmentData?.queueData?[indexPath.row].otpStatus
        
        
       
        return queueCell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 60, height: queueCollectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    
}
