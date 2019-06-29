//
//  AddVIPScheduleViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 21/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//  addVIPScheduleVC

import UIKit
import Alamofire

class AddVIPScheduleViewController: UIViewController,sendDateDelegate {
    
    

    //MARK:- IBOutlets
    @IBOutlet weak var scrollViewInstance: UIScrollView!
    @IBOutlet weak var selectDateBtnInstance: UIButton!
    @IBOutlet weak var slotsSelectView: UIView!
    @IBOutlet weak var slotsButtonInstance: UIButton!
    @IBOutlet weak var beforeSeesionView: UIView!
    @IBOutlet weak var afterSessionView: UIView!
    @IBOutlet weak var beforeTimeLbl: UILabel!
    @IBOutlet weak var afterTimeLbl: UILabel!
    
    
    @IBOutlet weak var slotsCollectionView: UICollectionView!
    @IBOutlet weak var submitBtnInstance: UIButton!
    @IBOutlet weak var slotsCVCHgtConst: NSLayoutConstraint! // 100
    
    
    var slotsCell:SlotsCollectionViewCell? = nil
    var scheduleDateData:ScheduleDateModel?
    var addVIPScheduleData:AddVIPScheduleModel?
    var sessionScheduleData:SessionScheduleModel?
    let dateFormatter = DateFormatter()
    let apiManager = APIManager()
    var numberOfSlots = ""
    var selectedStr = ""
    var timeSlotTime = ""
    var selectedDate = GenericMethods.currentDateTime()
    var selectedType = ""
    let postDataFormatter = DateFormatter()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        postDataFormatter.dateFormat = AppConstants.postDateFormat
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add VIP Schedule"
        GenericMethods.setButtonAttributes(button: submitBtnInstance, with: "Submit")
        selectDateBtnInstance.layer.borderColor = AppConstants.appdarkGrayColor.cgColor
        selectDateBtnInstance.layer.borderWidth = 1.0
        
        
        
        selectDateBtnInstance.setTitle("Select Date", for: .normal)
        
        let beforeTimeTap = UITapGestureRecognizer(target: self, action:  #selector(beforeTimeClick))
        beforeTimeTap.numberOfTapsRequired = 1
        beforeSeesionView.addGestureRecognizer(beforeTimeTap)
        
        let afterTimeTap = UITapGestureRecognizer(target: self, action:  #selector(afterTimeClick))
        afterTimeTap.numberOfTapsRequired = 1
        afterSessionView.addGestureRecognizer(afterTimeTap)
        
        self.slotsCollectionView.register(UINib(nibName: "SlotsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "slotsListCell")
        slotsCVCHgtConst.constant = 0
        
//        let hgt = ((self.appointmentsListData?.filterData?[0].clinicList?.count ?? 0) * 45) + ((self.appointmentsListData?.filterData?[0].clinicList?.count ?? 0) * 10)
//        clinicTVHgtConst.constant = CGFloat(hgt)
        

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        slotsSelectView.layer.addBorder(edge: .bottom, color: AppConstants.appdarkGrayColor, thickness: 1.0)
    }
    @objc func beforeTimeClick()
    {
//        beforeSeesionView.backgroundColor = AppConstants.appGreenColor
//        afterSessionView.backgroundColor = AppConstants.appdarkGrayColor
        sessionLoadingDetails(timeStr: beforeTimeLbl.text!, type: "before")
        
    }
    @objc func afterTimeClick()
    {
//        beforeSeesionView.backgroundColor = AppConstants.appdarkGrayColor
//        afterSessionView.backgroundColor = AppConstants.appGreenColor
        sessionLoadingDetails(timeStr: afterTimeLbl.text!, type: "after")
        
    }
    override func viewDidLayoutSubviews() {
        let height = slotsCollectionView.collectionViewLayout.collectionViewContentSize.height
        slotsCVCHgtConst.constant = height;
        scrollViewInstance.contentSize = CGSize(width: scrollViewInstance.frame.width, height: submitBtnInstance.frame.origin.y+submitBtnInstance.frame.height+10)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewInstance.contentOffset = CGPoint(x: 0, y: scrollViewInstance.contentOffset.y)
    }
    func sessionLoadingDetails(timeStr:String,type:String)
    {
//        {"time":"3:00 PM","count":"10","type":"before","interval":"00:30"}
        if GenericMethods.isStringEmpty(self.selectedStr)
        {
            GenericMethods.showAlert(alertMessage: "Please select Date")
        }
        else if GenericMethods.isStringEmpty(self.numberOfSlots)
        {
            GenericMethods.showAlert(alertMessage: "Please select number of Slots")
        }
        else
        {
            self.sessionScheduleData?.sessionData = []
            var parameters = Dictionary<String, Any>()
            parameters["time"] = timeStr
            parameters["count"] = self.numberOfSlots
            parameters["type"] = type
            parameters["interval"] = self.scheduleDateData?.interval
            parameters["date"] = postDataFormatter.string(from:selectedDate)
            
            GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
            
            apiManager.slotSessionDetailsAPI(parameters: parameters) { (status, showError, response, error) in
                
                GenericMethods.hideLoaderMethod(view: self.view)
                
                if status == true {
                    self.sessionScheduleData = response
                    
                    if self.sessionScheduleData?.status?.code == "0" {
                        //MARK: session data Success Details
                        
                        if type == "before"
                        {
                            self.selectedType = "before"
                            self.timeSlotTime = self.scheduleDateData?.startTime ?? ""
                            self.beforeSeesionView.backgroundColor = AppConstants.appGreenColor
                            self.afterSessionView.backgroundColor = AppConstants.appdarkGrayColor
                        }
                        else
                        {
                            self.selectedType = "after"
                            self.timeSlotTime = self.scheduleDateData?.endTime ?? ""
                            self.beforeSeesionView.backgroundColor = AppConstants.appdarkGrayColor
                            self.afterSessionView.backgroundColor = AppConstants.appGreenColor
                        }
                        print("timeSlotTime \(self.timeSlotTime)")
                        let count = self.sessionScheduleData?.sessionData?.count ?? 0
                        if count != 0
                        {
                            
                        }
                        else
                        {
                            self.slotsCVCHgtConst.constant = 0
                        }
                        self.slotsCollectionView.reloadData()
                        //                    let hgt = ((self.sessionScheduleData?.sessionData?.count ?? 0) * 45) + ((self.sessionScheduleData?.sessionData?.count ?? 0) * 10)
                        //                    self.slotsCVCHgtConst.constant = CGFloat(hgt)
                        
                    }
                        
                    else
                    {
                        GenericMethods.showAlert(alertMessage: self.sessionScheduleData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                        
                        
                    }
                    
                    
                }
                else {
                    GenericMethods.showAlert(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.")
                    
                }
            }
        }
        
        
        
    }

    @IBAction func selectDateBtnClick(_ sender: Any) {
        let calendarVC = self.storyboard!.instantiateViewController(withIdentifier: "calendarVC") as! CalendarViewController
        
        self.navigationController?.definesPresentationContext = true
        calendarVC.modalTransitionStyle = .crossDissolve
        calendarVC.modalPresentationStyle = .overCurrentContext
        calendarVC.delegate = self
        calendarVC.minimumDate = GenericMethods.currentDateTime()
        calendarVC.setDate = selectedDate
        calendarVC.maximumDate = GenericMethods.dayLimitCalendar()
        
        
        UIApplication.shared.topMostViewController()?.present(calendarVC, animated: true)
    }
    @IBAction func slotsBtnClick(_ sender: Any) {
        let optionsController = UIAlertController(title: "Select No. of slots", message: nil, preferredStyle: .actionSheet)
        optionsController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        optionsController.view.tintColor = AppConstants.khudColour
        
        let subView: UIView? = optionsController.view.subviews.first
        let alertContentView: UIView? = subView?.subviews.first
        alertContentView?.backgroundColor = UIColor.white
        alertContentView?.layer.cornerRadius = 5
        for i in 1..<11 {
            var action = UIAlertAction()
            
                action = UIAlertAction(title: "\(i)", style: .default, handler: { action in
                    
                    self.slotsButtonInstance.setTitle("\(i)", for: .normal)

                    self.numberOfSlots = "\(i)"
                    self.beforeSeesionView.backgroundColor = AppConstants.appdarkGrayColor
                    self.afterSessionView.backgroundColor = AppConstants.appdarkGrayColor
                    self.slotsCVCHgtConst.constant = 0
                
                })
            optionsController.addAction(action)
        }
        optionsController.modalPresentationStyle = .popover
        
        let popPresenter: UIPopoverPresentationController? = optionsController.popoverPresentationController
        popPresenter?.sourceView = slotsSelectView
        popPresenter?.sourceRect = slotsSelectView?.bounds ?? CGRect.zero
        DispatchQueue.main.async(execute: {
            //    self.hud.hide(animated: true)
            //[self.tableView reloadData];
            UIApplication.shared.topMostViewController()?.present(optionsController, animated: true)
        })
    }
    @IBAction func submitBntClick(_ sender: Any) {
        if GenericMethods.isStringEmpty(self.selectedStr)
        {
            GenericMethods.showAlert(alertMessage: "Please Select date")
        }
        else if GenericMethods.isStringEmpty(numberOfSlots)
        {
            GenericMethods.showAlert(alertMessage: "Please Select number of slot")
        }
        else if GenericMethods.isStringEmpty(timeSlotTime)
        {
            GenericMethods.showAlert(alertMessage: "Please select session")
        }
        else
        {
            
//            let timeFormatter = DateFormatter()
//            timeFormatter.dateFormat = "HH:mm"
            print(postDataFormatter.string(from: self.selectedDate))
            var startTime = ""
            var endTime = ""
            if self.selectedType == "before"
            {
                
                startTime = self.sessionScheduleData?.sessionData?.last?.railwayformat ?? ""
                endTime = GenericMethods.convert12hrto24hrFormat(dateStr:timeSlotTime)
            }
            else
            {
                
                endTime = self.sessionScheduleData?.sessionData?.last?.railwayformat ?? ""
                startTime = GenericMethods.convert12hrto24hrFormat(dateStr:timeSlotTime)
            }

            print(scheduleDateData?.fees ?? 0.0)
            var parameters = Dictionary<String, Any>()
            parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
            parameters["AppointmentFees"] = scheduleDateData?.fees
            parameters["per_patient_time"] = scheduleDateData?.interval
            parameters["date"] = postDataFormatter.string(from: self.selectedDate)
            parameters["scheduletype"] = self.selectedType
            parameters["start_time"] = startTime
            parameters["end_time"] = endTime
            
            print("param \(parameters)")
            
            
            
            GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
            
            apiManager.addVIPScheduleDetailsAPI(parameters: parameters) { (status, showError, response, error) in
                
                GenericMethods.hideLoaderMethod(view: self.view)
                
                if status == true {
                    self.addVIPScheduleData = response
                    if self.addVIPScheduleData?.status?.code == "0" {
                        //MARK: add VIP Schedule Success Details
                        
                        GenericMethods.showAlertwithPopNavigation(alertMessage: self.addVIPScheduleData?.status?.message ?? "Success", vc: self)
             
             
                    }
                        
                    else
                    {
             
                        GenericMethods.showAlertwithPopNavigation(alertMessage: self.addVIPScheduleData?.status?.message ?? "Unable to fetch data. Please try again after sometime.", vc: self)
                        
                    }
                    
                    
                }
                else {
                    GenericMethods.showAlert(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.")
                    
                }
            }
            
            
        }
    }
    
    func getScheduleSlotFromDate(dayStr:String,selectedDate: Date)
    {
        
        
        var parameters = Dictionary<String, Any>()
        parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        parameters["day"] = dayStr
        parameters["date"] = postDataFormatter.string(from:selectedDate)
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.scheduleDateDetailsAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.scheduleDateData = response
                if self.scheduleDateData?.status?.code == "0" {
                    //MARK: Schedule date Success Details
                    
                    self.beforeTimeLbl.text = self.scheduleDateData?.startTime
                    self.afterTimeLbl.text = self.scheduleDateData?.endTime
                    self.selectedStr = "\(self.dateFormatter.string(from: selectedDate))"
                    let btnDateFormatter = DateFormatter()
                    btnDateFormatter.dateFormat = AppConstants.titleDateFormat
                   print("date title \(btnDateFormatter.string(from: selectedDate))")
                    self.selectedDate = selectedDate
                    self.selectDateBtnInstance.setTitle(btnDateFormatter.string(from: selectedDate), for: .normal)
                    btnDateFormatter.dateFormat = AppConstants.postDateFormat
                    
                    self.beforeSeesionView.backgroundColor = AppConstants.appdarkGrayColor
                    self.afterSessionView.backgroundColor = AppConstants.appdarkGrayColor
                    self.slotsCVCHgtConst.constant = 0
                    
                    
                    if btnDateFormatter.string(from: selectedDate) == btnDateFormatter.string(from: GenericMethods.currentDateTime())
                    {
                        
                        
                        let startDate = GenericMethods.convert12hrStringToDate(dateString: self.scheduleDateData?.startTime ?? "00:00 AM")
                        let currentDate = GenericMethods.stringToDate(dateString: GenericMethods.currentDateTimeString())
                        
                        if startDate > currentDate
                        {
                            print("start time is greater")
                            self.beforeSeesionView.isUserInteractionEnabled = true
                            self.afterSessionView.isUserInteractionEnabled = true
                        }
                        else
                        {
                            print("current time is greater")
                            self.afterSessionView.isUserInteractionEnabled = true
                        }
                    }
                    else
                    {
                        self.beforeSeesionView.isUserInteractionEnabled = true
                        self.afterSessionView.isUserInteractionEnabled = true
                    }
                    
                }
                
                else
                {
                    GenericMethods.showAlert(alertMessage: self.scheduleDateData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                    
                    
                }
                
                
            }
            else {
                GenericMethods.showAlert(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.")
                
            }
        }
        
    }
    func sendDate(selectedDateStr: String, selectedDate: Date) {
        print(selectedDate)
        
        dateFormatter.dateFormat = AppConstants.dayFormat
        getScheduleSlotFromDate(dayStr: dateFormatter.string(from: selectedDate),selectedDate: selectedDate)
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddVIPScheduleViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.sessionScheduleData != nil {
            return self.sessionScheduleData?.sessionData?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        slotsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "slotsListCell", for: indexPath) as? SlotsCollectionViewCell
        
        slotsCell?.bgView.layer.cornerRadius = 10.0
        slotsCell?.bgView.layer.masksToBounds = true
        slotsCell?.slotBtnInstance.isEnabled = false
        
        slotsCell?.slotBtnInstance.titleLabel?.adjustsFontSizeToFitWidth = true
        slotsCell?.slotBtnInstance.titleLabel?.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        slotsCell?.slotBtnInstance.setTitle(self.sessionScheduleData?.sessionData?[indexPath.row].ordinaryformat ?? "", for: .normal)
        
        return slotsCell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 60, height: 20)
    }

    
}
