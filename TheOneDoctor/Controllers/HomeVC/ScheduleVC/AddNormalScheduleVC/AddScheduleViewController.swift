//
//  AddScheduleViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 21/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
// addScheduleVC

import UIKit
import Alamofire

class AddScheduleViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var addScheduleTableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerContainerView: UIView!
    
    
    //MARK:- Vairables
    var addNormalScheduleCell:AddNormalScheduleTVC? = nil
    var fromTime = ""
    var toTime = ""
    var patientHrs = ""
    var weekDays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    
    var updateDaysArray:NSMutableArray = []
    var timeFormatter = DateFormatter()
    var patientHrsFormatter = DateFormatter()
    var patientMinFormatter = DateFormatter()
    var cancelAppointScheduleArray:NSMutableArray = []
    var cancelAppointListArray:NSMutableArray = []
    
    
    var addScheduleData:AddScheduleModel?
    var updateScheduleData:UpdateScheduleModel?
    let apiManager = APIManager()
    
    var selectedIndexPath = IndexPath()
    var selectedBtn = ""
    
    var resetTime = "00:00 AM"
    var resetHrs = "0 mins"
    var userId = 0
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        timeFormatter.dateFormat = AppConstants.time12HoursInMeridianFormat
        patientHrsFormatter.dateFormat = AppConstants.timeHoursFormat
        patientMinFormatter.dateFormat = AppConstants.timeMinFormat
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
            
        
        updateDaysArray = [[
            "doctor_id" : userId,
            "available_days" : "Sunday",
            "start_time" : "00:00",
            "end_time" : "00:00",
            "per_patient_time" : "00:00",
            "deleted_status" : 0,
            "type" : "0",
            ],[
                "doctor_id" : userId,
                "available_days" : "Monday",
                "start_time" : "00:00",
                "end_time" : "00:00",
                "per_patient_time" : "00:00",
                "deleted_status" : 0,
                "type" : "0",
            ],[
                "doctor_id" : userId,
                "available_days" : "Tuesday",
                "start_time" : "00:00",
                "end_time" : "00:00",
                "per_patient_time" : "00:00",
                "deleted_status" : 0,
                "type" : "0",
            ],[
                "doctor_id" : userId,
                "available_days" : "Wednesday",
                "start_time" : "00:00",
                "end_time" : "00:00",
                "per_patient_time" : "00:00",
                "deleted_status" : 0,
                "type" : "0",
            ],[
                "doctor_id" : userId,
                "available_days" : "Thursday",
                "start_time" : "00:00",
                "end_time" : "00:00",
                "per_patient_time" : "00:00",
                "deleted_status" : 0,
                "type" :"0",
            ],[
                "doctor_id" : userId,
                "available_days" : "Friday",
                "start_time" : "00:00",
                "end_time" : "00:00",
                "per_patient_time" : "00:00",
                "deleted_status" : 0,
                "type" : "0",
            ],[
                "doctor_id" : userId,
                "available_days" : "Saturday",
                "start_time" : "00:00",
                "end_time" : "00:00",
                "per_patient_time" : "00:00",
                "deleted_status" : 0,
                "type" : "0",
            ]]
        datePicker.layer.addBorder(edge: .top, color: UIColor.lightGray, thickness: 1.0)
        datePickerContainerView.isHidden = true
        self.title = "Change Schedule"
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        label.text = "Done"
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .clear
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 0.5
        label.layer.cornerRadius = 10.0
        label.layer.masksToBounds = true
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doneBtnMethod))
        tapGesture.numberOfTapsRequired = 1
        label.addGestureRecognizer(tapGesture)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: label)
        
        loadingAddScheduleDetailsAPI(type: 0, array: [""])
        
//        loadingProfileDetailsAPI(type: 0)
        

        // Do any additional setup after loading the view.
    }
    
    @objc func doneBtnMethod()
    {
        print("updateDaysArraydone \(updateDaysArray)")
        
        for i in 0..<updateDaysArray.count
        {
            let startTime = (self.updateDaysArray[i]  as AnyObject).value(forKey: "start_time") as! String
            let endTime = (self.updateDaysArray[i]  as AnyObject).value(forKey: "end_time") as! String
            let hrsTime = (self.updateDaysArray[i]  as AnyObject).value(forKey: "per_patient_time") as! String
            let type = "\((self.updateDaysArray[i]  as AnyObject).value(forKey: "type") )"
            let deleted_status = (self.updateDaysArray[i]  as AnyObject).value(forKey: "deleted_status") as! Int
            
            if type == "1" && deleted_status == 0
            {
                if (startTime == "00:00" || endTime == "00:00" || hrsTime == "00:00")
                {
                    GenericMethods.showAlert(alertMessage: "fill all details of \((self.updateDaysArray[i]  as AnyObject).value(forKey: "available_days") as! String)")
                    return
                }
            }
            
            if ((self.updateDaysArray[i]  as AnyObject).value(forKey: "type") as? String != self.addScheduleData?.scheduleData?[i].type) && ((self.updateDaysArray[i]  as AnyObject).value(forKey: "deleted_status") as? Int == 1)
                {
                    if self.addScheduleData?.scheduleData?[i].deleteStatus == (self.updateDaysArray[i]  as AnyObject).value(forKey: "deleted_status") as? Int
                    {
                        (self.updateDaysArray[i]  as AnyObject).setValue("0", forKey: "type")
                    }
                    
                }
            
        }
        print("updateDaysArray \(updateDaysArray)")
//        print((self.updateDaysArray[0]  as AnyObject).value(forKey: "type") as! String)
        let sendingArr = NSMutableArray(array: updateDaysArray)
        AppConstants.updateDaysArray = NSMutableArray(array: self.updateDaysArray)
        
        loadingAddScheduleDetailsAPI(type: 1, array: sendingArr)
        
    }
    
    @objc func fromTimeBtnMethod(btn:UIButton)
    {
        selectedBtn = "from"
        datePickerContainerView.isHidden = false
        datePicker.datePickerMode = .time
        selectedIndexPath = IndexPath(row: btn.tag, section: 0)

    }
    @objc func toTimeBtnMethod(btn:UIButton)
    {
        selectedBtn = "to"
        datePickerContainerView.isHidden = false
        datePicker.datePickerMode = .time
        selectedIndexPath = IndexPath(row: btn.tag, section: 0)

    }
    @objc func patientHrsBtnMethod(btn:UIButton)
    {
        selectedBtn = "patientHrs"
        datePickerContainerView.isHidden = false
        datePicker.datePickerMode = .countDownTimer
        selectedIndexPath = IndexPath(row: btn.tag, section: 0)
        
    }
    
    @objc func refreshBtnMethod(btn:UIButton)
    {
        selectedIndexPath = IndexPath(row: btn.tag, section: 0)
        guard let cell = addScheduleTableView.cellForRow(at: selectedIndexPath) as? AddNormalScheduleTVC else
        {
            return
        }
        cell.labelView.backgroundColor = AppConstants.appGreenColor
        cell.fromTimeBtnInstance.setTitle(resetTime, for: .normal)
        cell.toTimeBtnInstance.setTitle(resetTime, for: .normal)
//        cell.patientHrsBtnInstance.setTitle(resetHrs, for: .normal)
        (self.updateDaysArray[selectedIndexPath.row]  as AnyObject).setValue(1, forKey: "deleted_status")
        (self.updateDaysArray[selectedIndexPath.row]  as AnyObject).setValue("1", forKey: "type")
        
        (self.updateDaysArray[selectedIndexPath.row]  as AnyObject).setValue(resetTime, forKey: "start_time")
        (self.updateDaysArray[selectedIndexPath.row]  as AnyObject).setValue(resetTime, forKey: "end_time")
        (self.updateDaysArray[selectedIndexPath.row]  as AnyObject).setValue(resetTime, forKey: "per_patient_time")

    }
    
    //MARK:- IBActions
    @IBAction func cancelBtnClick(_ sender: Any) {
        datePickerContainerView.isHidden = true
    }
    
    @IBAction func doneBtnClick(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppConstants.time24HoursFormat
        
        guard let cell = addScheduleTableView.cellForRow(at: selectedIndexPath) as? AddNormalScheduleTVC else
        {
            datePickerContainerView.isHidden = true
            return
        }
        
        cell.labelView.backgroundColor = UIColor.darkGray
        switch selectedBtn {
        case "from":
            (self.updateDaysArray[selectedIndexPath.row]  as AnyObject).setValue(dateFormatter.string(from: datePicker.date), forKey: "start_time")
            (self.updateDaysArray[selectedIndexPath.row]  as AnyObject).setValue("1", forKey: "type")
            (self.updateDaysArray[selectedIndexPath.row]  as AnyObject).setValue(0, forKey: "deleted_status")

            
        case "to":
            
            (self.updateDaysArray[selectedIndexPath.row]  as AnyObject).setValue(dateFormatter.string(from: datePicker.date), forKey: "end_time")
            (self.updateDaysArray[selectedIndexPath.row]  as AnyObject).setValue("1", forKey: "type")
            (self.updateDaysArray[selectedIndexPath.row]  as AnyObject).setValue(0, forKey: "deleted_status")
            
        case "patientHrs":
            
            
            (self.updateDaysArray[selectedIndexPath.row]  as AnyObject).setValue(dateFormatter.string(from: datePicker.date), forKey: "per_patient_time")
            (self.updateDaysArray[selectedIndexPath.row]  as AnyObject).setValue("1", forKey: "type")
            (self.updateDaysArray[selectedIndexPath.row]  as AnyObject).setValue(0, forKey: "deleted_status")
            
        default:
            break
        }
        datePickerContainerView.isHidden = true
        addScheduleTableView.reloadData()
    }
    func convertArraytoJsonString(arr:NSMutableArray) -> String
    {
        do {
            
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: arr, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //Convert back to string. Usually only do this for debugging
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print(jsonString)
                return jsonString
            }
            return ""
            
            //            //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [Any].
            //            var json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
            
            
        } catch {
            print("cannot ")
            return ""
        }
    }
    //MARK: - Loading AddSchedule
    func loadingAddScheduleDetailsAPI(type:Int,array:NSMutableArray)
    {

        var sendingArray:NSMutableArray = NSMutableArray(array: array)

        var sendingArrayStr = ""
        if type == 1
        {
            let uploadingArray:NSMutableArray = NSMutableArray(array: sendingArray)
            
            for i in 0..<uploadingArray.count
            {
                if (uploadingArray[i]  as AnyObject).value(forKey: "type") as? String == "1"
                {
                    (uploadingArray[i] as AnyObject).setValue(1, forKey: "type")
                }
                else
                {
                    (uploadingArray[i] as AnyObject).setValue(0, forKey: "type")
                }
                
            }
            sendingArray = uploadingArray
            sendingArrayStr = convertArraytoJsonString(arr: sendingArray)

            print("updateDaysArray2 \(updateDaysArray)")
            updateDaysArray = NSMutableArray(array: AppConstants.updateDaysArray)
        }
        
        
        
        
        var parameters = Dictionary<String, Any>()
        parameters["doctor_id"] = userId
        parameters["available_days"] = sendingArrayStr
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.addNormalScheduleDetailsAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.addScheduleData = response
                print(self.addScheduleData?.scheduleData?.toJSONString() as Any)
                
                if self.addScheduleData?.status?.code == "0" {
                    if type == 1
                    {
                        GenericMethods.showAlertwithPopNavigation(alertMessage: self.addScheduleData?.status?.message ?? "Success", vc: self)
                    }
                    else
                    {
                        self.updateDaysArray = []
                        var patientHrsFromServer = ""
                        for i in 0..<(self.addScheduleData?.scheduleData?.count ?? 0)
                        {
                            
                            let dict:NSMutableDictionary = [:]
                            
                            
                            dict.setValue(self.addScheduleData?.scheduleData?[i].doctorId, forKey: "doctor_id")
                            dict.setValue(self.addScheduleData?.scheduleData?[i].availableDays, forKey: "available_days")
                            dict.setValue(self.addScheduleData?.scheduleData?[i].startTime, forKey: "start_time")
                            dict.setValue(self.addScheduleData?.scheduleData?[i].endTime, forKey: "end_time")
                            
                            dict.setValue(self.addScheduleData?.scheduleData?[i].deleteStatus, forKey: "deleted_status")
                            dict.setValue("00:00", forKey: "per_patient_time")
                            dict.setValue(self.addScheduleData?.scheduleData?[i].type, forKey: "type")
                            dict.setValue(self.addScheduleData?.scheduleData?[i].scheduleId, forKey: "schedule_id")
                            dict.setValue(self.addScheduleData?.scheduleData?[i].id, forKey: "s_id")
                            
                            if self.addScheduleData?.scheduleData?[i].patientHrsTime != "00:00"
                            {
                                patientHrsFromServer = self.addScheduleData?.scheduleData?[i].patientHrsTime ?? "00:00"
                            }
                            //                        dict.setValue(0, forKey: "type")
                            self.updateDaysArray.add(dict)
                        }
                        for i in 0..<self.updateDaysArray.count
                        {
                            (self.updateDaysArray[i] as AnyObject).setValue(patientHrsFromServer, forKey: "per_patient_time")
                        }
                        
                        print("updateArr \(self.updateDaysArray)")
                        
                        self.addScheduleTableView.reloadData()
                    }
                    
                    
                }
                else if self.addScheduleData?.status?.code == "1" {
                    if type == 1
                    {

                        GenericMethods.showYesOrNoAlertWithCompletionHandler(alertTitle: "The One", alertMessage: self.addScheduleData?.status?.message ?? "You have some appointments in the schedule. Do you want to change it?", completionHandlerForOk: { (alert) in
                            
                            print("json \(self.addScheduleData?.scheduleData?.toJSONString() as Any) \n \(self.addScheduleData?.scheduleData?.toJSONString() ?? "empty")")
                            self.updateChangeSchedule()
                        })
                    }
                }
                else
                {
                    GenericMethods.showAlert(alertMessage: self.addScheduleData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                    
                    
                }
                
                
            }
            else {
                
                GenericMethods.showAlert(alertMessage: error?.localizedDescription ??  "Unable to fetch data. Please try again after sometime.")
                
                
            }
        }
    }
    
    func updateChangeSchedule()
    {
        
        var parameters = Dictionary<String, Any>()
        parameters["doctor_id"] = userId
        parameters["schedule"] = self.addScheduleData?.scheduleData?.toJSONString() ?? ""
        parameters["appointment"] = self.addScheduleData?.appointment?.toJSONString()  ?? ""
        parameters["VIPSchedule"] = self.addScheduleData?.vipSchedule?.toJSONString()  ?? ""
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.updateNormalScheduleDetailsAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.updateScheduleData = response
                
                if self.updateScheduleData?.status?.code == "0"
                {
                    GenericMethods.showAlertwithPopNavigation(alertMessage: self.updateScheduleData?.status?.message ?? "Success", vc: self)
                }
                else
                {
                    GenericMethods.showAlert(alertMessage: self.updateScheduleData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                    
                    
                }
                
                
            }
            else {
                
                GenericMethods.showAlert(alertMessage: error?.localizedDescription ??  "Unable to fetch data. Please try again after sometime.")
               
            }
        }
    }

}
extension AddScheduleViewController:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return updateDaysArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        addNormalScheduleCell = tableView.dequeueReusableCell(withIdentifier: "addNormalScheduleCell") as? AddNormalScheduleTVC
        if addNormalScheduleCell == nil
        {
            addNormalScheduleCell = AddNormalScheduleTVC(style: .default, reuseIdentifier: "addNormalScheduleCell")
        }
        
        addNormalScheduleCell?.weekDayLabel.text = weekDays[indexPath.row]
       
       addNormalScheduleCell?.fromTimeBtnInstance.tag = indexPath.row
        addNormalScheduleCell?.fromTimeBtnInstance.addTarget(self, action: #selector(fromTimeBtnMethod(btn:)), for: .touchUpInside)
        addNormalScheduleCell?.toTimeBtnInstance.tag = indexPath.row
        addNormalScheduleCell?.toTimeBtnInstance.addTarget(self, action: #selector(toTimeBtnMethod(btn:)), for: .touchUpInside)
       
        addNormalScheduleCell?.patientHrsBtnInstance.titleLabel?.adjustsFontSizeToFitWidth = true
        addNormalScheduleCell?.patientHrsBtnInstance.tag = indexPath.row
//        addNormalScheduleCell?.patientHrsBtnInstance.setTitle(self.addScheduleData?.scheduleData?[0].patientHrsTime ?? "", for: .normal)
        
        
        addNormalScheduleCell?.patientHrsBtnInstance.setTitle(GenericMethods.convertHrstoMinsFormat(dateStr: (self.updateDaysArray[indexPath.row] as? [AnyHashable:Any])? ["per_patient_time"] as? String ?? "00:00 AM"), for: .normal)
//        addNormalScheduleCell?.patientHrsBtnInstance.addTarget(self, action: #selector(patientHrsBtnMethod(btn:)), for: .touchUpInside)
//        addNormalScheduleCell?.refreshBtnInstance.tag = indexPath.row
//        addNormalScheduleCell?.refreshBtnInstance.addTarget(self, action: #selector(refreshBtnMethod(btn:)), for: .touchUpInside)
        addNormalScheduleCell?.weekDayLabel.text = (self.updateDaysArray[indexPath.row] as? [AnyHashable:Any])? ["available_days"] as? String ?? ""
        
        
        if (self.updateDaysArray[indexPath.row] as? [AnyHashable:Any])? ["deleted_status"] as? Int ?? 1 == 0
        {  // Schedule // active
            addNormalScheduleCell?.labelView.backgroundColor = AppConstants.appdarkGrayColor
        }
        else
        { //Unschedule
            addNormalScheduleCell?.labelView.backgroundColor = AppConstants.appGreenColor
            
        }
        addNormalScheduleCell?.fromTimeBtnInstance.setTitle(GenericMethods.convert24hrto12hrFormat(dateStr: (self.updateDaysArray[indexPath.row] as? [AnyHashable:Any])? ["start_time"] as? String ?? "00:00 AM"), for: .normal)
        addNormalScheduleCell?.toTimeBtnInstance.setTitle(GenericMethods.convert24hrto12hrFormat(dateStr: (self.updateDaysArray[indexPath.row] as? [AnyHashable:Any])? ["end_time"] as? String ?? "00:00 AM"), for: .normal)
        
        
        
        return addNormalScheduleCell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
