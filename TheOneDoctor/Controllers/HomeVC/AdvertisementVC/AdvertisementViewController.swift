//
//  AdvertisementViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 18/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Alamofire


class AdvertisementViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollViewInstance: UIScrollView!
    

    @IBOutlet weak var imageSizeLbl: UILabel!
    
    @IBOutlet weak var imgSizeHgtConst: NSLayoutConstraint!
    
    @IBOutlet weak var specialityTypeView: UIView!
    @IBOutlet weak var selectSpecialityBtnInstance: UIButton!
    @IBOutlet weak var calendarContainerView: UIView!
    
    @IBOutlet weak var advtTypeCollectionView: UICollectionView!
    @IBOutlet weak var monthYEarLbl: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var addContentBtnInstance: UIButton!
    
    @IBOutlet weak var priceDetailsCollectionView: UICollectionView!
    
    @IBOutlet weak var nextBtnInstance: UIButton!
    @IBOutlet weak var previousBtnInstance: UIButton!
    

    
    @IBOutlet weak var adTypeCVCHgtConst: NSLayoutConstraint!
    @IBOutlet weak var visibleAdsBtnInstance: UIButton!
    @IBOutlet weak var priorityBtnInstance: UIButton!
    
    
    // MARK: - Variables
    let dateformatter = DateFormatter()
    let comparisonDateFormatter = DateFormatter()
    var todayDate = Date()
    var advtPriceCell:AdvertisementPriceCollectionViewCell? = nil
    var advtTypeCell:AdvertisementTypeCollectionViewCell? = nil
    let apiManager = APIManager()
    var advertisementListData:AdvertisementModel?
    var checkAdvertisementData:AdvertisementCheckModel?
    var advtDetailsArray:NSMutableArray = []
    
    var specialityId = ""
    var adTypeId = 0
    var adPriceTypeId = 0
    var adPriceId = 0
    var noOfDays = 0
    var selectedDateArray:[String] = []
    var priceSelectedIndex = IndexPath(item: 0, section: 0)
    var adPrice = 0
    var selectedDate = ""
    var isAvailabilityVerified = 0
    var adHeight = ""
    var adWidth = ""
    var totalAdPrice = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Advertisement"
        
        dateformatter.dateFormat = AppConstants.monthYearTextFormat
        monthYEarLbl.text = dateformatter.string(from: GenericMethods.currentDateTime())
        
        
        
        GenericMethods.shadowCellView(view: calendarContainerView)
        
        addContentBtnInstance.layer.cornerRadius = 5.0
        addContentBtnInstance.layer.masksToBounds = true
        
        
        self.calendarView.calendarDelegate = self
        self.calendarView.calendarDataSource = self
        
        self.calendarView.register(UINib(nibName: "CalendarDateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "scheduleCalendarCell")
        
        DispatchQueue.main.async {
            self.calendarView.visibleDates { (visibleDates) in
                self.setupViewOfCalendar(from: visibleDates)
            }
        }
        
        
        self.calendarView.selectDates([todayDate])
        self.calendarView.scrollToDate(todayDate)
        
        adTypeCVCHgtConst.constant = 50
        imgSizeHgtConst.constant = 21
        imageSizeLbl.text = ""
        specialityTypeView.layer.cornerRadius = 5.0
        specialityTypeView.layer.masksToBounds = true
        specialityTypeView.layer.borderColor = AppConstants.appdarkGrayColor.cgColor
        specialityTypeView.layer.borderWidth = 1.0

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        loadingAdvertisementDetailsAPI(loadFrom: 0)
        self.visibleAdsBtnInstance.layer.addBorder(edge: .bottom, color: AppConstants.appGreenColor, thickness: 2.0)
        self.priorityBtnInstance.layer.addBorder(edge: .bottom, color: UIColor.white, thickness: 2.0)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Advertisement API
    func loadingAdvertisementDetailsAPI(loadFrom:Int)
    {
        
        self.selectedDateArray = []
        self.adPrice = 0
        self.adPriceId = 0
        self.priceLbl.text = ""
        self.addContentBtnInstance.isHidden = true
        var parameters = Dictionary<String, Any>()
        parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        if adTypeId == 0
        {
            parameters["Adtype"] = ""
        }
        else
        {
            parameters["Adtype"] = adTypeId
        }
        
        parameters["splid"] = specialityId
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.advertisementDetailsAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.advertisementListData = response
                
                if self.advertisementListData?.status?.code == "0" {
                    //MARK: Advertisement  Success Details

                    
                        self.advtDetailsArray = []
                    
                    
                        //                    print("advtDetailsArr \(self.advtDetailsArray)")
                        for i in 0..<(self.advertisementListData?.addDetails?.count ?? 0)
                        {
                            if let date = self.advertisementListData?.addDetails?[i].date
                            {
                                if date.contains(",")
                                {
                                    let fullNameArr = date.components(separatedBy: ",")
                                    
                                    for j in 0..<fullNameArr.count
                                    {
                                        self.advtDetailsArray.add(fullNameArr[j])
                                    }
                                    
                                }
                                else
                                {
                                    self.advtDetailsArray.add(self.advertisementListData?.addDetails?[i].date ?? "")
                                }
                            }
                        }
//                        print("self.advtDetailsArray \(self.advtDetailsArray)")
                        if self.adTypeId == 0
                        {
                            self.adTypeId = self.advertisementListData?.adType?[0].id ?? 0
                            self.adHeight = self.advertisementListData?.adType?[0].height ?? ""
                            self.adWidth = self.advertisementListData?.adType?[0].width ?? ""
                        
                            self.selectSpecialityBtnInstance.setTitle(self.advertisementListData?.speciality?[0].name ?? "", for: .normal)
                            
                            
                            
                            self.specialityId = self.advertisementListData?.speciality?[0].id ?? ""
                            print("self.specialityId  \(self.specialityId )")
                            print("adTypeId  \(self.adTypeId )")
                        }
                    print("adPrice \(self.adPrice)")
                    
                    self.imageSizeLbl.text = "Image height -\(self.adHeight)px width -\(self.adWidth)px"
                    self.priceDetailsCollectionView.reloadData()
                    self.advtTypeCollectionView.reloadData()
                        
                        DispatchQueue.main.async {
                            self.calendarView.reloadData()
                        }
                    
                }
                else
                {
                    GenericMethods.showAlertwithPopNavigation(alertMessage: self.advertisementListData?.status?.message ?? "Unable to fetch data. Please try again after sometime.", vc: self)
                    //                    GenericMethods.showAlert(alertMessage: self.profileData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                }
                
                
            }
            else {
                GenericMethods.showAlertwithPopNavigation(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.", vc: self)
                
                
                
            }
        }
    }
    
    func handleSelectedCell(cell:JTAppleCell?,cellState:CellState)
    {
        
        
    }
    func setupViewOfCalendar(from visibleDate:DateSegmentInfo)
    {
        guard let firstDate = visibleDate.monthDates.first?.date else {
            return
        }
        comparisonDateFormatter.dateFormat = AppConstants.monthYearFormat
        dateformatter.dateFormat = AppConstants.monthYearTextFormat
        
        if comparisonDateFormatter.string(from: firstDate) == comparisonDateFormatter.string(from: GenericMethods.currentDateTime())
        {
            monthYEarLbl.text = dateformatter.string(from: GenericMethods.currentDateTime())
            
        }
        
        else
        {
            monthYEarLbl.text = dateformatter.string(from: firstDate)
            calendarView.reloadData()
        }
        
        GenericMethods.monthYearSelectionMethod(date: firstDate, previousBtnInstance: previousBtnInstance, nextBtnInstance: nextBtnInstance, lastDate: GenericMethods.advtDayLimitCalendar(), dateFormat: AppConstants.monthYearFormat)
        
//        let dayFormatter = DateFormatter()
//        dayFormatter.dateFormat =
//            AppConstants.monthYearFormat
//        dayFormatter.timeZone = TimeZone.current
//        dayFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//        guard let firstDate = dayFormatter.date(from: dayFormatter.string(from: GenericMethods.currentDateTime()))
//            else
//        {
//            return
//        }
//        guard let lastDate = dayFormatter.date(from: dayFormatter.string(from: GenericMethods.advtDayLimitCalendar()))
//            else
//        {
//            return
//        }
//
//
//        guard let currentDate = dayFormatter.date(from: dayFormatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: date)!))
//            else
//        {
//            return
//        }
//
//        if firstDate == currentDate
//        {
//            print("this month")
//            nextBtnInstance.isHidden = false
//            previousBtnInstance.isHidden = true
//        }
//        else if lastDate == currentDate
//        {
//            nextBtnInstance.isHidden = true
//            previousBtnInstance.isHidden = false
//        }
//        else
//        {
//            nextBtnInstance.isHidden = false
//            previousBtnInstance.isHidden = false
//        }
        
    }
    func searchFromArray(searchKey:String,searchString:String,array:NSMutableArray) -> Array<Any>
    {
        let predicate = NSPredicate(format: "\(searchKey) CONTAINS[C] %@", "\(searchString)" )
        let orPredi: NSPredicate? = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate])
        
        let arr = array.filtered(using: orPredi!)
        //        print ("arr = \(arr) arrcount = \(arr.count)")
        return arr
        //        imageStr = (array[0]as? [AnyHashable:Any])? ["FlagPng"] as? String ?? ""
    }
    
    
    func updatePrice()
    {
        print("count \(selectedDateArray.count)")
        if selectedDateArray.count > 0
        {
            var price = 0
            if self.noOfDays == 1
            {
                price = self.adPrice * selectedDateArray.count
                self.totalAdPrice = "\(price)"
            }
            else
            {
                price = self.adPrice
                self.totalAdPrice = "\(price)"
            }
           
            
            let priceText = "\(price) \(self.advertisementListData?.adPrice?[0].currencyCode ?? "KWD")"
            let days = "\(selectedDateArray.count) days"
            let text = days + " " + priceText
            let attributedString = NSMutableAttributedString(string: text,
                                                             attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
            
            let boldrange = (text as NSString).range(of: priceText)
           
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),NSAttributedString.Key.foregroundColor:AppConstants.appGreenColor], range: boldrange)
           
            
            priceLbl.attributedText = attributedString
            
        }
        
        
    }
    func checkAvailabilityMethod()
    {

        print("adPrice \(adPrice)")
        if (selectedDateArray.count > 0) && adPrice != 0
        {
            var parameters = Dictionary<String, Any>()
            parameters["price_id"] = self.adPriceId
            parameters["date"] = self.selectedDate
            parameters["no_of_days"] = self.noOfDays
            parameters["speciality"] = self.specialityId
            if adTypeId == 0
            {
                parameters["Adtype"] = ""
            }
            else
            {
                parameters["Adtype"] = adTypeId
            }
            
            GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
            
            apiManager.advertisementCheckAPI(parameters: parameters) { (status, showError, response, error) in
                
                GenericMethods.hideLoaderMethod(view: self.view)
                
                if status == true {
                    self.checkAdvertisementData = response
                    print("nofodays\(self.noOfDays)")
                    if self.noOfDays != 1
                    {
                        self.selectedDateArray = []
                    }
                    if self.checkAdvertisementData?.status?.code == "0" {
                        //MARK: Check Validation Success Details
                        self.isAvailabilityVerified = 1
                        print("data \(self.checkAdvertisementData?.daysArray?[0] ?? "")")
                        
                        for i in 0..<(self.checkAdvertisementData?.daysArray?.count ?? 0)
                        {
                            print("check \(i)")
                            if !self.selectedDateArray.contains(self.checkAdvertisementData?.daysArray?[i] ?? "")
                            {
                                self.selectedDateArray.append(self.checkAdvertisementData?.daysArray?[i] ?? "")
                            }
                            
                        }
                        
                        print("selectedDateArray \(self.selectedDateArray)")
                        self.updatePrice()
                        if self.adTypeId == self.advertisementListData?.adPriorityType?[0].id ?? 0
                        {
                            self.addContentBtnInstance.setTitle("Submit", for: .normal)
                        }
                        else
                        {
                            self.addContentBtnInstance.setTitle("Add Contents", for: .normal)
                        }
                        self.addContentBtnInstance.isHidden = false
                        DispatchQueue.main.async {
                            self.calendarView.reloadData()
                        }
                    }
                    else if self.checkAdvertisementData?.status?.code == "1"
                    {
//                        self.selectedDateArray.remove(at: las)
                        self.isAvailabilityVerified = 0
                        GenericMethods.showAlert(alertMessage: self.checkAdvertisementData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                    }
                    else
                    {
                        
                        self.isAvailabilityVerified = 0
                        
                        GenericMethods.showAlert(alertMessage: self.checkAdvertisementData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                        
                    }
                    
                    
                }
                else {
                    self.isAvailabilityVerified = 0
                    GenericMethods.showAlert(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.")
                   
                    
                }
            }
            
        }
    }

    // MARK: - IBActions
    @IBAction func visibleAdsBtnClick(_ sender: Any) {
        
        self.visibleAdsBtnInstance.setTitleColor(AppConstants.appGreenColor, for: .normal)
        self.priorityBtnInstance.setTitleColor(UIColor.lightGray, for: .normal)
        self.visibleAdsBtnInstance.layer.addBorder(edge: .bottom, color: AppConstants.appGreenColor, thickness: 2.0)
        self.priorityBtnInstance.layer.addBorder(edge: .bottom, color: UIColor.white, thickness: 2.0)
        self.adTypeId = self.advertisementListData?.adType?[0].id ?? 0
        adTypeCVCHgtConst.constant = 50
        imgSizeHgtConst.constant = 21
        imageSizeLbl.text = ""
        loadingAdvertisementDetailsAPI(loadFrom: 1)
        
    }
    @IBAction func priorityBtnClick(_ sender: Any) {
        
        self.priorityBtnInstance.setTitleColor(AppConstants.appGreenColor, for: .normal)
        self.visibleAdsBtnInstance.setTitleColor(UIColor.lightGray, for: .normal)
        self.adTypeId = self.advertisementListData?.adPriorityType?[0].id ?? 0
        print("adTypeId \(adTypeId)")
        adTypeCVCHgtConst.constant = 0
        imgSizeHgtConst.constant = 0
        loadingAdvertisementDetailsAPI(loadFrom: 1)
        self.visibleAdsBtnInstance.layer.addBorder(edge: .bottom, color: UIColor.white, thickness: 2.0)
        self.priorityBtnInstance.layer.addBorder(edge: .bottom, color: AppConstants.appGreenColor, thickness: 2.0)
    }
    
    
    @IBAction func previousBtnClick(_ sender: Any) {
        calendarView.scrollToSegment(.previous)
        
    }
    @IBAction func nextBtnClick(_ sender: Any) {
        calendarView.scrollToSegment(.next)
        
        
        
    }
    
    @IBAction func selectSpecialityBtnClick(_ sender: Any)
    {
        let optionsController = UIAlertController(title: "Select Speciality", message: nil, preferredStyle: .actionSheet)
        optionsController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        optionsController.view.tintColor = AppConstants.khudColour
        
        let subView: UIView? = optionsController.view.subviews.first
        let alertContentView: UIView? = subView?.subviews.first
        alertContentView?.backgroundColor = UIColor.white
        alertContentView?.layer.cornerRadius = 5
        for i in 0..<(self.advertisementListData?.speciality?.count ?? 0) {
            var action = UIAlertAction()
            
            action = UIAlertAction(title: self.advertisementListData?.speciality?[i].name ?? "", style: .default, handler: { action in
                
                self.selectSpecialityBtnInstance.setTitle(self.advertisementListData?.speciality?[i].name ?? "", for: .normal)
                
                self.specialityId = "\(self.advertisementListData?.speciality?[i].id ?? "0")"
                print("specialityId \(self.specialityId) ")
                
                self.loadingAdvertisementDetailsAPI(loadFrom: 1)
                
            })
            optionsController.addAction(action)
        }
        optionsController.modalPresentationStyle = .popover
        
        let popPresenter: UIPopoverPresentationController? = optionsController.popoverPresentationController
        popPresenter?.sourceView = specialityTypeView
        popPresenter?.sourceRect = specialityTypeView?.bounds ?? CGRect.zero
        DispatchQueue.main.async(execute: {
            //    self.hud.hide(animated: true)
            //[self.tableView reloadData];
            UIApplication.shared.topMostViewController()?.present(optionsController, animated: true)
        })
    }
    
    @IBAction func addContentsViewController(_ sender: Any) {
        if selectedDateArray.count < 1 {
           GenericMethods.showAlert(alertMessage: "Please select Date")
        }
        else if adPrice == 0
        {
            GenericMethods.showAlert(alertMessage: "Please select Price Type")
        }
        else if self.isAvailabilityVerified == 0
        {
            GenericMethods.showAlert(alertMessage: "Please select Date")
        }
        else
        {
            
            if self.adTypeId == self.advertisementListData?.adPriorityType?[0].id ?? 0
            {
                submitBtnMethod()
            }
            else
            {
                let selectedDateArrString:String = selectedDateArray.joined(separator: ",")
                print("selectedDateArrString \(selectedDateArrString)")
                var sendDict:[AnyHashable:Any] = [:]
                sendDict = ["speciality":specialityId,"typeid":adTypeId,"priceid":adPriceId,"date":selectedDateArrString,"no_of_days":noOfDays,"amount":self.totalAdPrice]
                print("sendDict \(sendDict)")
                let addAddvtVC = self.storyboard?.instantiateViewController(withIdentifier: "addAddvtVC") as! AddAdvertisementViewController
                addAddvtVC.imgHeight = self.adHeight
                addAddvtVC.imgWidth = self.adWidth
                addAddvtVC.sendDict = sendDict
                
                self.navigationController?.pushViewController(addAddvtVC, animated: true)
            }
        }
    }
    func submitBtnMethod()
    {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        let loadingProfileNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingProfileNotification.mode = MBProgressHUDMode.annularDeterminate
        loadingProfileNotification.label.text = "Uploading"
        
        let selectedDateArrString:String = selectedDateArray.joined(separator: ",")
        print("selectedDateArrString \(selectedDateArrString)")
        
        var parameters = Dictionary<String, Any>()
        parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        parameters["speciality"] = specialityId
        parameters["typeid"] = adTypeId
        parameters["priceid"] = adPriceId
        parameters["date"] = selectedDateArrString
        parameters["comments"] = ""
        parameters["no_of_days"] = noOfDays
        parameters["amount"] = self.totalAdPrice
        print(parameters)
        
        
        if ReachabilityManager.shared.isConnectedToNetwork() == false
            
        {
            GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "The Internet connection appears to be offline.")
            
        }
        else
        {
            
            
            Alamofire.upload(multipartFormData: { (multipartFormData: MultipartFormData) in
                multipartFormData.append(Data(), withName: "file", fileName:
                    "", mimeType: "")
                
                for (key, value) in parameters {
                    print("value is \(value)")
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to: "\(apiManager.fileUploadBaseURL)Adsupdate", encodingCompletion: { (encodingResult) in
                
                
                GenericMethods.hideLoading()
                
                print(encodingResult)
                switch encodingResult {
                    
                case .success(let upload, _, _):
                    print(upload.response as Any)
                    print("response Data is \(upload.responseData as Any)")
                    upload.uploadProgress { progress in
                        
                        
                        loadingProfileNotification.progress = Float(progress.fractionCompleted)
                    }
                    upload.responseJSON { response in
                        
                        //                        print("response is \(response.response as Any)")
                        //                        print(response.request as Any)
                        //                        print(response.result)
                        
                        switch response.result {
                            
                        case .success(let json):
                            GenericMethods.hideLoaderMethod(view: self.view)
                            
                            let y: AnyObject = (json as AnyObject?)!
                            if let str:Int = y.object(forKey: "error_code") as? Int
                            {
                                print(str)
                                GenericMethods.showAlert(alertMessage: "Something Went Wrong! Please try again")
                            }
                            else
                            {
                                
                                //                                    success(json as AnyObject?)
                                
                                print("response \(response as Any)")
                                GenericMethods.hideLoaderMethod(view: self.view)
                                
                                let responseObject: AnyObject = (json as AnyObject?)!
                                guard let status = responseObject.object(forKey: "status") else
                                {
                                    GenericMethods.showAlert(alertMessage: "Something Went Wrong! Please try again")
                                    return
                                }
                                if (status as AnyObject).object(forKey: "code") as? String == "0"
                                {
                                    
                                    GenericMethods.showAlert(alertMessage: (status as AnyObject).object(forKey: "message") as? String ?? "Success")
                                    
                                    self.loadingAdvertisementDetailsAPI(loadFrom: 1)

                                }
                                else
                                {
                                    GenericMethods.showAlert(alertMessage:(status as AnyObject).object(forKey: "message") as? String ?? "Something Went Wrong! Please try again")
                                }
                            }
                        case .failure(let error):
                            GenericMethods.hideLoaderMethod(view: self.view)
                            
                            print("failure error is \(error)")
                            
                            GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "\(error.localizedDescription)")
                        }
                    }
                case .failure(let encodingError):
                    GenericMethods.hideLoaderMethod(view: self.view)
                    GenericMethods.showAlert(alertMessage: encodingError.localizedDescription)
                    print("encodingError:\(encodingError)")
                }
            })
            
            
        }
    }
    


}
extension AdvertisementViewController:JTAppleCalendarViewDelegate,JTAppleCalendarViewDataSource
{
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        
        if cellState.dateBelongsTo != .thisMonth {
            return false
        }
        else
        {
            if GenericMethods.checkDateisBetween(date: date, lastDate: GenericMethods.advtDayLimitCalendar())
            {
                dateformatter.dateFormat = AppConstants.postDateFormat
                let extractedDate = dateformatter.string(from: date)
                
                if advtDetailsArray.contains(extractedDate)
                {
                    return false
                }
                else
                {
                    return true
                }
            }
            return false
        }
        
    }
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: "scheduleCalendarCell", for: indexPath) as! CalendarDateCollectionViewCell
        
        cell.dateTextLabel.text = cellState.text
        cell.tag = indexPath.item
        cell.backgroundColor = UIColor.white
        cell.dateTextLabel.textColor = UIColor.darkText
        cell.achievedCountLbl.isHidden = true
        
        if cellState.dateBelongsTo != .thisMonth {
            cell.dateTextLabel.textColor = UIColor.lightGray
            cell.backgroundColor = UIColor.white
            cell.achievedCountLbl.isHidden = true
        }
        else
        {
            if GenericMethods.checkDateisBetween(date: date, lastDate: GenericMethods.advtDayLimitCalendar())
            {
                dateformatter.dateFormat = AppConstants.postDateFormat
                let extractedDate = dateformatter.string(from: date)
                
                if advtDetailsArray.contains(extractedDate)
                {
                    cell.backgroundColor = UIColor.red
                }
                else
                {
                    if dateformatter.string(from: GenericMethods.currentDateTime()) == extractedDate
                    {
                       cell.backgroundView?.layer.borderColor = AppConstants.appGreenColor.withAlphaComponent(0.5).cgColor
                        cell.backgroundView?.layer.borderWidth = 0.8
                    }
                    else
                    {
                        cell.backgroundView?.layer.borderColor = UIColor.white.cgColor
                        cell.backgroundView?.layer.borderWidth = 0.8
                    }
                    if selectedDateArray.count > 0 && selectedDateArray.contains(extractedDate)
                    {
                        cell.backgroundColor = UIColor.green
                    }
                    else
                    {
                        cell.backgroundColor = UIColor.white
                    }
                    
                }
            }
            else
            {
                cell.dateTextLabel.textColor = UIColor.lightGray
                cell.backgroundColor = UIColor.white
            }
            
        }
        
        self.handleSelectedCell(cell: cell, cellState: cellState)
        return cell
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let endDate = GenericMethods.advtDayLimitCalendar()
        let param = ConfigurationParameters(startDate: GenericMethods.currentDateTime(), endDate: endDate)
        return param
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        self.handleSelectedCell(cell: cell, cellState: cellState)
        
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if cellState.selectionType == SelectionType.userInitiated {
            print("userInitial")
            
            print("tag \(cell!.tag)")
            
            
            dateformatter.dateFormat = AppConstants.postDateFormat
            let extractedDate = dateformatter.string(from: date)
            
            func loadingDataInCalendar()
            {
                if self.selectedDateArray.contains(extractedDate)
                {
                    guard let row = self.selectedDateArray.firstIndex(of: extractedDate) else {return}
                    self.selectedDateArray.remove(at: row)
                    cell!.backgroundColor = UIColor.white
                    
                }
                else
                {
                    
                    self.selectedDateArray.append(extractedDate)
                    cell!.backgroundColor = UIColor.green
                    self.selectedDate = extractedDate
                    
                }
                if self.selectedDateArray.count > 0 {
                    self.addContentBtnInstance.isHidden = false
                    self.checkAvailabilityMethod()
                    
                }
                else
                {
                    self.priceLbl.text = ""
                    self.addContentBtnInstance.isHidden = true
                }
            }
            if self.noOfDays == 0
            {
                GenericMethods.showAlert(alertMessage: "Please select duration")
            }
            else
            {
                loadingDataInCalendar()
            }
//            if noOfDays != "1"
//            {
//                DispatchQueue.main.async {
//                    if self.noOfDays == ""
//                    {
//                        self.selectedDateArray = []
//                    }
//                    self.calendarView.reloadData()
//                    loadingDataInCalendar()
//                }
//            }
//            else
//            {
//                loadingDataInCalendar()
//            }
        }
        else if cellState.selectionType == SelectionType.programatic {
            print("programmatic")
            

        }
        
        
        
        self.handleSelectedCell(cell: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        print("didDeselectDate")
        self.handleSelectedCell(cell: cell, cellState: cellState)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewOfCalendar(from: visibleDates)
    }
    
}
extension AdvertisementViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case advtTypeCollectionView:
            if self.advertisementListData != nil {
                return (self.advertisementListData?.adType?.count) ?? 0
            }
        case priceDetailsCollectionView:
            if self.advertisementListData != nil {
                return (self.advertisementListData?.adPrice?.count) ?? 0
            }
        default:
            break
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case advtTypeCollectionView:
            advtTypeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "advtTypeCell", for: indexPath) as? AdvertisementTypeCollectionViewCell
            advtTypeCell?.advtTypeNameLbl.text = self.advertisementListData?.adType?[indexPath.row].name
            if self.adTypeId == self.advertisementListData?.adType?[indexPath.row].id
            {
                advtTypeCell?.advtTypeImgView.image = UIImage(named: "selected.png")
            }
            else
            {
                advtTypeCell?.advtTypeImgView.image = UIImage(named: "unselected.png")
            }
            
            return advtTypeCell!
        case priceDetailsCollectionView:
            advtPriceCell = collectionView.dequeueReusableCell(withReuseIdentifier: "advtPriceCell", for: indexPath) as? AdvertisementPriceCollectionViewCell
            
            advtPriceCell?.priceLbl.text = "\(self.advertisementListData?.adPrice?[indexPath.row].price ?? "") \(self.advertisementListData?.adPrice?[indexPath.row].currencyCode ?? "")"
            advtPriceCell?.dayLbl.text = self.advertisementListData?.adPrice?[indexPath.row].availability ?? ""
            
            if adPriceId == self.advertisementListData?.adPrice?[indexPath.row].priceId ?? 0
            {
                advtPriceCell?.priceLbl.textColor = AppConstants.appGreenColor
                advtPriceCell?.dayLbl.textColor = AppConstants.appGreenColor
            }
            else
            {
                advtPriceCell?.priceLbl.textColor = AppConstants.appdarkGrayColor
                advtPriceCell?.dayLbl.textColor = AppConstants.appdarkGrayColor
            }
            
            
            return advtPriceCell!
        default:
            break
        }
        
        return advtTypeCell!
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = priceDetailsCollectionView.frame.width
        switch collectionView {
            
        case priceDetailsCollectionView:
            return CGSize(width: (width - 50 )/2 , height: 60)
        case advtTypeCollectionView:
            return CGSize(width: width/2 , height: 50)
        default:
            break
        }
        
        return CGSize(width: 100 , height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
            
        case advtTypeCollectionView:
            
            self.adTypeId = self.advertisementListData?.adType?[indexPath.row].id ?? 0
            self.adHeight = self.advertisementListData?.adType?[indexPath.row].height ?? ""
            self.adWidth = self.advertisementListData?.adType?[indexPath.row].width ?? ""
            self.imageSizeLbl.text = "Image height -\(self.adHeight)px width -\(self.adWidth)px"
            loadingAdvertisementDetailsAPI(loadFrom: 1)
            
            
        case priceDetailsCollectionView:
//            if selectedDateArray.count > 0
//            {
                self.adPrice = Int(self.advertisementListData?.adPrice?[indexPath.row].price ?? "0") ?? 0
                self.adPriceTypeId = self.advertisementListData?.adPrice?[indexPath.row].id ?? 0
                self.adPriceId = self.advertisementListData?.adPrice?[indexPath.row].priceId ?? 0
                self.noOfDays = self.advertisementListData?.adPrice?[indexPath.row].noOfDays ?? 0
                print("adPrice \(adPrice) adPriceTypeId \(adPriceTypeId) adPriceId \(adPriceId) noOfDays \(noOfDays)")
                checkAvailabilityMethod()
                //TODO: put function if 1 day
                
                priceDetailsCollectionView.reloadData()
                
                DispatchQueue.main.async {
                    self.calendarView.reloadData()
                }
                
//            }
//            else
//            {
//                GenericMethods.showAlert(alertMessage: "Please select dates")
//            }
        default:
            break
        }
        
        
    }
    
    
}
