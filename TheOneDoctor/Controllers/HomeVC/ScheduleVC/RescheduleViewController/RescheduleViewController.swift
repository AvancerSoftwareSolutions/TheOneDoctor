//
//  RescheduleViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import Alamofire

class RescheduleViewController: UIViewController,sendDateDelegate,refreshLoadingDelegate {
    

    //MARK:- IBOutlets
    
    @IBOutlet weak var availableLbl: UILabel!
    @IBOutlet weak var vipLbl: UILabel!
    @IBOutlet weak var cancelledLbl: UILabel!
    @IBOutlet weak var completedLbl: UILabel!
    
    @IBOutlet weak var scrollViewInstance: UIScrollView!
    @IBOutlet weak var slotsLbl: UILabel!
    @IBOutlet weak var monthChangeView: UIView!
    @IBOutlet weak var monthDayView: UIView!
    @IBOutlet weak var monthDayLbl: UILabel!
    @IBOutlet weak var nextMonthBtnInst: UIButton!
    @IBOutlet weak var previousMonthBtnInst: UIButton!
    @IBOutlet weak var rescheduleCollectionView: UICollectionView!

    @IBOutlet weak var unavailableTodayBtnInst: UIButton!
    @IBOutlet weak var makeAvailableBtnInst: UIButton!
    @IBOutlet weak var editButtonInst: UIButton!

    @IBOutlet weak var reasonTextView: UITextView!
    @IBOutlet weak var cancelBtnInst: UIButton!
    @IBOutlet weak var submitBtnInstance: UIButton!
    
    @IBOutlet weak var slotsUnavailableLbl: UILabel!
    
    @IBOutlet weak var collectionViewHgtConst: NSLayoutConstraint! // 100
    
    @IBOutlet weak var slotsMsgLblHgt: NSLayoutConstraint! // 21
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var cancelViewHgtConst: NSLayoutConstraint! //230
    @IBOutlet weak var makeAvailableHgtConst: NSLayoutConstraint!
    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var slotsUnavailableHgtConst: NSLayoutConstraint! //60
    
    //MARK:- Variables
    
    var slotsCell:SlotsCollectionViewCell? = nil
    var rescheduleListData:RescheduleModel?
    let apiManager = APIManager()
    
    let dayFormatter = DateFormatter()
    let postDataFormatter = DateFormatter()
    let dayMonthFormatter = DateFormatter()
    let createdDateFormatter = DateFormatter()
    var userSelectedDate = GenericMethods.currentDateTime()
    var cancelSlotsArray:NSMutableArray = []
    var reasonType = 0
    var selectedIndexPath = IndexPath()
    
//    let normalSlotColor:UIColor = UIColor.init(red: 0, green: 128, blue: 0, alpha: 1.0)
    let normalSlotColor:UIColor = AppConstants.normalSlotColor
    let vipSlotColor:UIColor = AppConstants.vipSlotColor
    let cancelSlotColor:UIColor = .red
    let disableSlotColor:UIColor = .lightGray
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        postDataFormatter.dateFormat = AppConstants.postDateFormat
        dayFormatter.dateFormat = AppConstants.dayFormat
        dayMonthFormatter.dateFormat = AppConstants.dayMonthYearFormat
        createdDateFormatter.dateFormat = AppConstants.defaultDateFormat
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Schedule"

        monthDayLbl.text = dayMonthFormatter.string(from: GenericMethods.currentDateTime())
        previousMonthBtnInst.isHidden = true
        
        monthChangeView.layer.borderColor = AppConstants.appdarkGrayColor.cgColor
        monthChangeView.layer.borderWidth = 1.0
        
        roundBtn(btn: cancelBtnInst)
        roundBtn(btn: submitBtnInstance)
        roundBtn(btn: unavailableTodayBtnInst)
        roundBtn(btn: makeAvailableBtnInst)
        
        GenericMethods.roundedCornerTextView(textView: reasonTextView)
        
        unavailableTodayBtnInst.layer.borderColor = #colorLiteral(red: 0.9879798293, green: 0.5034409761, blue: 0.09596314281, alpha: 1) //EC8739
        unavailableTodayBtnInst.layer.borderWidth = 1.0
        unavailableTodayBtnInst.layer.cornerRadius = 5.0
        unavailableTodayBtnInst.layer.masksToBounds = true

        reloadAllViews()
        
        self.rescheduleCollectionView.register(UINib(nibName: "SlotsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "slotsListCell")
        collectionViewHgtConst.constant = 0
        
        let calendarTapGesture = UITapGestureRecognizer(target: self, action: #selector(openCalendarView))
        calendarTapGesture.numberOfTapsRequired = 1
        monthDayView.addGestureRecognizer(calendarTapGesture)
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneWithNumberPad))]
        numberToolbar.sizeToFit()
        reasonTextView.inputAccessoryView = numberToolbar
        
        roundLbl(label: availableLbl,bgColor:normalSlotColor)
        roundLbl(label: vipLbl,bgColor:vipSlotColor)
        roundLbl(label: cancelledLbl,bgColor:cancelSlotColor)
        roundLbl(label: completedLbl,bgColor:disableSlotColor)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        print("viewdidloaduserSelectedDate \(userSelectedDate)")
        print("day is \(dayFormatter.string(from: userSelectedDate))")
        loadingRescheduleDetailsAPI(dayStr: dayFormatter.string(from: userSelectedDate), selectedDate: userSelectedDate)

        // Do any additional setup after loading the view.
    }
    func roundLbl(label:UILabel,bgColor:UIColor)
    {
        label.layer.cornerRadius = label.frame.height / 2
        label.layer.masksToBounds = true
        label.backgroundColor = bgColor
        
    }
    func reloadAllViews()
    {
        cancelView.isHidden = true
        cancelViewHgtConst.constant = 0
        makeAvailableHgtConst.constant = 0
        slotsUnavailableLbl.isHidden = true
        slotsMsgLblHgt.constant = 0
        unavailableTodayBtnInst.isHidden = true
        editButtonInst.isHidden = true
        slotsLbl.text = "Slots"
        rescheduleCollectionView.isUserInteractionEnabled = false
        slotsUnavailableHgtConst.constant = 0
    }
    @objc func openCalendarView()
    {
        let calendarVC = self.storyboard!.instantiateViewController(withIdentifier: "calendarVC") as! CalendarViewController
        
        self.navigationController?.definesPresentationContext = true
        calendarVC.modalTransitionStyle = .crossDissolve
        calendarVC.modalPresentationStyle = .overCurrentContext
        calendarVC.delegate = self
        calendarVC.minimumDate = GenericMethods.currentDateTime()
        calendarVC.maximumDate = Calendar.current.date(byAdding: .day, value: AppConstants.durationPeriod, to: Date())!
        calendarVC.setDate = self.userSelectedDate
        UIApplication.shared.topMostViewController()?.present(calendarVC, animated: true)
        
        
    }
    @objc func doneWithNumberPad()
    {
        let _ = reasonTextView.resignFirstResponder()
        
        
    }
    @objc func keyboardWasShown(notification: NSNotification) {
        print("keyboardWasShown")
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsets:UIEdgeInsets = UIEdgeInsets(top: view.frame.origin.x, left: view.frame.origin.y, bottom: targetFrame.height + 2, right: 0)
        scrollViewInstance.contentInset = contentInsets
        scrollViewInstance.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        print("keyboardWillHide")
        let zero:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.scrollViewInstance.contentInset = zero;
        self.scrollViewInstance.scrollIndicatorInsets = zero;
    }
    override func viewDidLayoutSubviews() {
        let height = rescheduleCollectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHgtConst.constant = height;
        scrollViewInstance.contentSize = CGSize(width: scrollViewInstance.frame.width, height: cancelView.frame.origin.y+cancelView.frame.height+10)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewInstance.contentOffset = CGPoint(x: 0, y: scrollViewInstance.contentOffset.y)
    }
    func roundBtn(btn:UIButton)
    {
        btn.layer.cornerRadius = 5.0
        btn.layer.masksToBounds = true
    }
    
    func setCalendarValuesMethod(date:Date)
    {
        self.userSelectedDate = date
        
        if postDataFormatter.string(from: self.userSelectedDate) == postDataFormatter.string(from: GenericMethods.currentDateTime())
        {
            self.previousMonthBtnInst.isHidden = true
        }
        else if postDataFormatter.string(from: self.userSelectedDate) == postDataFormatter.string(from: Calendar.current.date(byAdding: .day, value: AppConstants.durationPeriod, to: GenericMethods.currentDateTime())!)
        {
            self.nextMonthBtnInst.isHidden = true
        }
        else
        {
            self.previousMonthBtnInst.isHidden = false
            self.nextMonthBtnInst.isHidden = false
        }
        self.monthDayLbl.text = self.dayMonthFormatter.string(from: self.userSelectedDate)
        self.rescheduleCollectionView.reloadData()
    }
    
    func sendDate(selectedDateStr:String,selectedDate:Date)
    {
        loadingRescheduleDetailsAPI(dayStr: dayFormatter.string(from: selectedDate), selectedDate: selectedDate)
    }
    
    // MARK: - Reschedule List API
    func loadingRescheduleDetailsAPI(dayStr:String,selectedDate: Date)
    {
        var parameters = Dictionary<String, Any>()
        parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        parameters["day"] = dayStr
        parameters["date"] = postDataFormatter.string(from:selectedDate)
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.rescheduleListDetailsAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.rescheduleListData = response
                
                self.reloadAllViews()
                if self.rescheduleListData?.status?.code == "0" {
                    //MARK: Reschedule List Success Details
                    self.setCalendarValuesMethod(date: selectedDate)
                    
                    self.unavailableTodayBtnInst.isHidden = false
                    self.editButtonInst.isHidden = false
                    self.slotsLbl.text = "Slots"
//                    self.rescheduleCollectionView.isUserInteractionEnabled = true
                    
                    
                    
                }
                else if self.rescheduleListData?.status?.code == "1" {
                    //user Unavailable
                    self.setCalendarValuesMethod(date: selectedDate)
                    
                    self.collectionViewHgtConst.constant = 100
                    self.slotsUnavailableLbl.isHidden = false
                    self.makeAvailableHgtConst.constant = 40
                    self.slotsUnavailableHgtConst.constant = 60
                    self.slotsUnavailableLbl.text = "Slots Cancelled"
//                    GenericMethods.showAlert(alertMessage: self.rescheduleListData?.status?.message ?? "You are unavailable on this day")
                    
                }
                else if self.rescheduleListData?.status?.code == "2" {
                    //schedule not available
                    self.setCalendarValuesMethod(date: selectedDate)
                    self.slotsUnavailableLbl.isHidden = false
                    self.slotsUnavailableHgtConst.constant = 60
                    self.slotsUnavailableLbl.text = "Schedule not available"
//                    GenericMethods.showAlert(alertMessage: self.rescheduleListData?.status?.message ?? "Schedule not available")
                }
                    
                else
                {
                    GenericMethods.showAlertwithPopNavigation(alertMessage: self.rescheduleListData?.status?.message ?? "Unable to fetch data. Please try again after sometime.", vc: self)
                    
                }
                
                
            }
            else {
                GenericMethods.showAlertwithPopNavigation(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.", vc: self)
                
                
                
            }
        }
    }
    // MARK: - Reschedule API
    func rescheduleAPI(dayStr:String,selectedDate: Date,type:Int)
    {

        func sendArr() -> [String]
        {
            if type == 2
            {
                return [""]
            }
            else
            {
                var slotsArray:[String] = []
                for i in 0..<(cancelSlotsArray.count)
                {
                    slotsArray.append(cancelSlotsArray[i] as? String ?? "")
                }
                return slotsArray
            }
        }
        
        var parameters = Dictionary<String, Any>()
        parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        parameters["day"] = dayStr
        parameters["date"] = postDataFormatter.string(from:selectedDate)
        parameters["type"] = type
        parameters["cancelslot"] = sendArr()
        parameters["reason"] = reasonTextView.text!
//        print("parm \(parameters)")
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")

        apiManager.rescheduleSlotsDetailsAPI(parameters: parameters) { (status, showError, response, error) in

            GenericMethods.hideLoaderMethod(view: self.view)

            if status == true {
                self.rescheduleListData = response

                self.reloadAllViews()
                if self.rescheduleListData?.status?.code == "0" {
                    //MARK: Reschedule Success Details

                    GenericMethods.showAlertWithCompletionHandler(alertMessage: self.rescheduleListData?.status?.message ?? "Success", completionHandlerForOk: { (alertAction) in
                        self.reloadAllViews()
                        self.loadingRescheduleDetailsAPI(dayStr: dayStr, selectedDate: selectedDate)
                    })

                }
                else
                {

                    GenericMethods.showAlert(alertMessage: self.rescheduleListData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")


                }


            }
            else {

                GenericMethods.showAlert(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.")



            }
        }
    }
    
    func cancelSlotsMethod()
    {
        if cancelSlotsArray.count == 0
        {
            GenericMethods.showAlert(alertMessage: "Please select slots.")
        }
        else if GenericMethods.isStringEmpty(reasonTextView.text!)
        {
            GenericMethods.showAlert(alertMessage: "Please enter the reason")
        }
        else
        {
            
            GenericMethods.showYesOrNoAlertWithCompletionHandler(alertTitle: "Are you sure, you want to cancel the selected Slots?", alertMessage: "") { (alertAction) in
                self.rescheduleAPI(dayStr: self.dayFormatter.string(from: self.userSelectedDate), selectedDate: self.userSelectedDate, type: 0)
            }
            
            
        }
    }
    
    func unavailableSlotsMethod()
    {
        if GenericMethods.isStringEmpty(reasonTextView.text!)
        {
            GenericMethods.showAlert(alertMessage: "Please enter the reason")
        }
        else
        {
            
            GenericMethods.showYesOrNoAlertWithCompletionHandler(alertTitle: "Are you sure, you are unavailable?", alertMessage: "") { (alertAction) in
                self.rescheduleAPI(dayStr: self.dayFormatter.string(from: self.userSelectedDate), selectedDate: self.userSelectedDate, type: 2)
            }
            
            
        }
    }
    
    @objc func addCancelSlotsBtnClick(sender:UIButton)
    {
        print("addSlots")
        selectedIndexPath = IndexPath(row: sender.tag, section: 0)
        
        
        guard let slotsCell = rescheduleCollectionView.cellForItem(at: selectedIndexPath) as? SlotsCollectionViewCell else
        {
            return
        }
        let time = self.rescheduleListData?.rescheduleData?[sender.tag].time ?? ""
        if cancelSlotsArray.contains(time)
        {
           print("contains")
            slotsCell.slotBtnInstance.backgroundColor = UIColor.white
            let mySelectedAttributedTitle = NSAttributedString(string: self.rescheduleListData?.rescheduleData?[sender.tag].from ?? "",
                                                               attributes: [NSAttributedString.Key.foregroundColor : normalSlotColor])
            slotsCell.slotBtnInstance.setAttributedTitle(mySelectedAttributedTitle, for: .normal)
            
            slotsCell.bgView.layer.borderColor = normalSlotColor.cgColor
            self.cancelSlotsArray.remove(self.rescheduleListData?.rescheduleData?[sender.tag].time ?? "")
            
            return
        }
        slotsCell.slotBtnInstance.backgroundColor = normalSlotColor
        let mySelectedAttributedTitle = NSAttributedString(string: self.rescheduleListData?.rescheduleData?[sender.tag].from ?? "",
                                                           attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        slotsCell.slotBtnInstance.setAttributedTitle(mySelectedAttributedTitle, for: .normal)
        
        slotsCell.bgView.layer.borderColor = normalSlotColor.cgColor
        self.cancelSlotsArray.add(self.rescheduleListData?.rescheduleData?[sender.tag].time ?? "")
    }
    
    
    func refreshDelegateMethod(day: String, selectedDate: Date) {
        self.reloadAllViews()
        self.loadingRescheduleDetailsAPI(dayStr: day, selectedDate: self.userSelectedDate)
    }
    
    //MARK:- IBActions
    @IBAction func editBtnClick(_ sender: Any) {
        rescheduleCollectionView.isUserInteractionEnabled = true
        makeAvailableBtnInst.isHidden = true
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if self.rescheduleListData?.delayedSlotStatus ?? 0 == 0
        {
            alert.addAction(UIAlertAction(title: "Reschedule", style: .default, handler: { _ in
                let changeScheduleVC = self.storyboard?.instantiateViewController(withIdentifier: "changeScheduleVC") as! ChangeScheduleViewController
                changeScheduleVC.dayStr = self.dayFormatter.string(from: self.userSelectedDate)
                changeScheduleVC.selectedDate = self.userSelectedDate
                changeScheduleVC.delegate = self
                
                self.navigationController?.definesPresentationContext = true
                changeScheduleVC.modalTransitionStyle = .crossDissolve
                changeScheduleVC.modalPresentationStyle = .overCurrentContext
                UIApplication.shared.topMostViewController()?.present(changeScheduleVC, animated: true)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel Schedule", style: .default, handler: { _ in
            
            self.cancelSlotsArray = []
            self.cancelView.isHidden = false
            self.cancelViewHgtConst.constant = 230
            self.slotsMsgLblHgt.constant = 21
            self.unavailableTodayBtnInst.isHidden = true
            self.editButtonInst.isHidden = true
            self.rescheduleCollectionView.isUserInteractionEnabled = true
            self.reasonLbl.text = "Reason for Cancel"
            self.reasonTextView.text = ""
            self.unavailableTodayBtnInst.isHidden = true
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = self.editButtonInst
            alert.popoverPresentationController?.sourceRect = self.editButtonInst.bounds
            
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func cancelBtnClick(_ sender: Any) {
        /*
         cancelView.isHidden = true
         cancelViewHgtConst.constant = 0
         makeAvailableHgtConst.constant = 0
         slotsUnavailableLbl.isHidden = true
         slotsMsgLblHgt.constant = 0
         unavailableTodayBtnInst.isHidden = true
         editButtonInst.isHidden = true
         slotsLbl.text = "Slots"
         rescheduleCollectionView.isUserInteractionEnabled = false
         */
        
        self.cancelView.isHidden = true
        self.cancelViewHgtConst.constant = 0
        self.slotsMsgLblHgt.constant = 0
        self.editButtonInst.isHidden = false
        self.rescheduleCollectionView.isUserInteractionEnabled = false
        self.cancelSlotsArray = []
        self.reasonType = 0
        self.unavailableTodayBtnInst.isHidden = false
        
    }
    @IBAction func submitBtnClick(_ sender: Any) {
        
        if reasonType == 0
        { // cancel Slots
            cancelSlotsMethod()
        }
        else
        {
            // unavailable slots
            unavailableSlotsMethod()
        }
        
    }
    
    
    @IBAction func unavailableTodayBtnClick(_ sender: Any) {
        self.reasonType = 1
        self.cancelView.isHidden = false
        self.cancelViewHgtConst.constant = 230
        self.editButtonInst.isHidden = true
        self.reasonLbl.text = "Reason for unavailable"
        self.reasonTextView.text = ""
        self.unavailableTodayBtnInst.isHidden = true
    }
    @IBAction func makeAvailableBtnClick(_ sender: Any)
    {
        GenericMethods.showYesOrNoAlertWithCompletionHandler(alertTitle: "Are you sure, you are available?", alertMessage: "") { (alertAction) in
            
        }
    }
    @IBAction func nextMonthBtnClick(_ sender: Any) {
        let date = Calendar.current.date(byAdding: .day, value: 1, to: userSelectedDate)!
        loadingRescheduleDetailsAPI(dayStr: dayFormatter.string(from: date), selectedDate: date)
        
    }
    @IBAction func previousMonthBtnClick(_ sender: Any) {
        let date = Calendar.current.date(byAdding: .day, value: -1, to: userSelectedDate)!
        loadingRescheduleDetailsAPI(dayStr: dayFormatter.string(from: date), selectedDate: date)
        
    }
    
    
    
    

}
extension RescheduleViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.rescheduleListData != nil {
            return rescheduleListData?.rescheduleData?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        slotsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "slotsListCell", for: indexPath) as? SlotsCollectionViewCell
        
        slotsCell?.bgView.layer.cornerRadius = 10.0
        slotsCell?.bgView.layer.masksToBounds = true
        slotsCell?.bgView.layer.borderColor = UIColor.white.cgColor

        slotsCell?.slotBtnInstance.titleLabel?.adjustsFontSizeToFitWidth = true
        slotsCell?.slotBtnInstance.titleLabel?.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        slotsCell?.slotBtnInstance.setTitle(self.rescheduleListData?.rescheduleData?[indexPath.row].from ?? "", for: .normal)
        
        // status 0 - enable  status 1 - disable  status 2 - appoint fill  status 3 - cancelled slot
        func changeSlotBtnAppearance(titleColor:UIColor,borderColor:UIColor,bgColor:UIColor,enable:Bool)
        {
            
            slotsCell?.slotBtnInstance.backgroundColor = bgColor
            let mySelectedAttributedTitle = NSAttributedString(string: self.rescheduleListData?.rescheduleData?[indexPath.row].from ?? "",
                                                               attributes: [NSAttributedString.Key.foregroundColor : titleColor])
            slotsCell?.slotBtnInstance.setAttributedTitle(mySelectedAttributedTitle, for: .normal)

            slotsCell?.bgView.layer.borderColor = borderColor.cgColor
            slotsCell?.slotBtnInstance.isUserInteractionEnabled = enable
            
        }
        
        let status = self.rescheduleListData?.rescheduleData?[indexPath.item].status ?? 0
        let type = self.rescheduleListData?.rescheduleData?[indexPath.item].type ?? ""
       
        
        switch status
        {
        case 0: // Enable
            if type == "VIP"
            {
                changeSlotBtnAppearance(titleColor: vipSlotColor, borderColor: vipSlotColor, bgColor: UIColor.white, enable: true)
                
            }
            else
            {
                changeSlotBtnAppearance(titleColor: normalSlotColor, borderColor: normalSlotColor, bgColor: UIColor.white, enable: true)
            }
            
            
        case 1: // Disable Timeout
            
            changeSlotBtnAppearance(titleColor: disableSlotColor, borderColor: disableSlotColor, bgColor: UIColor.white, enable: false)
            
        case 2: // Booked slot
            
            if type == "VIP"
            {
                changeSlotBtnAppearance(titleColor: UIColor.white, borderColor: vipSlotColor, bgColor: vipSlotColor, enable: true)
            }
            else
            {
                changeSlotBtnAppearance(titleColor: UIColor.white, borderColor:normalSlotColor, bgColor: normalSlotColor, enable: true)
            }
        case 3: // Cancelled slot
            
            changeSlotBtnAppearance(titleColor: cancelSlotColor, borderColor: cancelSlotColor, bgColor: UIColor.white, enable: false)

        default:
            break
        }
        slotsCell?.slotBtnInstance.tag = indexPath.item
        slotsCell?.slotBtnInstance.addTarget(self, action: #selector(addCancelSlotsBtnClick(sender:)), for: .touchUpInside)
        
        return slotsCell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 60, height: 20)
    }
    
    
    
    
}
extension RescheduleViewController:UITextViewDelegate
{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 250
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textViewDidBeginEditing")
        let scrollPoint : CGPoint = CGPoint(x:0 , y: cancelView.frame.origin.y)
        self.scrollViewInstance.setContentOffset(scrollPoint, animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let zero:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.scrollViewInstance.contentInset = zero;
    }
}
