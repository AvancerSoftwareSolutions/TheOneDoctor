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
    var comp = DateComponents()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        timeFormatter.dateFormat = AppConstants.time12HoursInMeridianFormat
        patientHrsFormatter.dateFormat = AppConstants.timeHoursFormat
        patientMinFormatter.dateFormat = AppConstants.timeMinFormat
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
            
        
        
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
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        datePicker.layer.addBorder(edge: .top, color: UIColor.lightGray, thickness: 1.0)
    }
    @objc func doneBtnMethod()
    {
        print(self.addScheduleData?.scheduleData?.toJSONString(prettyPrint: true) ?? "")
        loadingAddScheduleDetailsAPI(type: 1, array: [""])

    }
    
    @objc func fromTimeBtnMethod(btn:UIButton)
    {
        selectedBtn = "from"
        datePickerContainerView.isHidden = false
        datePicker.datePickerMode = .time
        datePicker.setDate(GenericMethods.currentDateTime(), animated: false)
        datePicker.minimumDate = nil
        datePicker.maximumDate = nil
        let setDate = GenericMethods.convert12hrStringToDate(dateString: GenericMethods.convert24hrto12hrFormat(dateStr: self.addScheduleData?.scheduleData?[btn.tag].startTime ?? "00:00"))
        datePicker.setDate(setDate, animated: true)
        
        selectedIndexPath = IndexPath(row: btn.tag, section: 0)
    }
    @objc func toTimeBtnMethod(btn:UIButton)
    {
        selectedBtn = "to"
        datePickerContainerView.isHidden = false
        datePicker.datePickerMode = .time
        datePicker.setDate(GenericMethods.currentDateTime(), animated: false)
        datePicker.minimumDate = nil
        datePicker.maximumDate = nil
        
        
        let minDate = GenericMethods.convert12hrStringToDate(dateString: GenericMethods.convert24hrto12hrFormat(dateStr: self.addScheduleData?.scheduleData?[btn.tag].startTime ?? "00:00"))

        
        print("calendar \(String(describing: Calendar.current.date(byAdding: comp, to: minDate, wrappingComponents: false)))")
        datePicker.minimumDate = Calendar.current.date(byAdding: comp, to: minDate, wrappingComponents: false)
        
        let setDate = GenericMethods.convert12hrStringToDate(dateString: GenericMethods.convert24hrto12hrFormat(dateStr: self.addScheduleData?.scheduleData?[btn.tag].endTime ?? "00:00"))
        datePicker.setDate(setDate, animated: true)
        selectedIndexPath = IndexPath(row: btn.tag, section: 0)
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
            
            if dateFormatter.string(from: datePicker.date) == "00:00"
            {
                cell.labelView.backgroundColor = AppConstants.appGreenColor
                GenericMethods.showAlert(alertMessage: "Please select time greater than 12 AM")
            }
            else
            {
                self.addScheduleData?.scheduleData?[selectedIndexPath.row].startTime = dateFormatter.string(from: datePicker.date)
                self.addScheduleData?.scheduleData?[selectedIndexPath.row].type = "1"
                
                datePickerContainerView.isHidden = true
                addScheduleTableView.reloadData()
            }

        case "to":
            
            self.addScheduleData?.scheduleData?[selectedIndexPath.row].endTime = dateFormatter.string(from: datePicker.date)
            self.addScheduleData?.scheduleData?[selectedIndexPath.row].type = "1"
            
            datePickerContainerView.isHidden = true
            addScheduleTableView.reloadData()
            
        default:
            break
        }
        
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
        var sendingArrayStr = ""
        if type == 1
        {
            sendingArrayStr = self.addScheduleData?.scheduleData?.toJSONString() ?? ""
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
                        if self.addScheduleData?.scheduleData?.count ?? 0 > 0
                        {
                            let min = GenericMethods.getHrsFromDate(dateStr: self.addScheduleData?.scheduleData?[0].patientHrsTime ?? "00:00", type: "min")
                            let hr = GenericMethods.getHrsFromDate(dateStr: self.addScheduleData?.scheduleData?[0].patientHrsTime ?? "00:00", type: "hour")
                            self.comp.setValue(min, for: .minute)
                            self.comp.setValue(hr, for: .hour)
                        }
                        self.addScheduleTableView.reloadData()
                    }
                    
                    
                }
                else if self.addScheduleData?.status?.code == "1"
                {
                    if type == 1
                    {

                        GenericMethods.showYesOrNoAlertWithCompletionHandler(alertTitle: "The One", alertMessage: self.addScheduleData?.status?.message ?? "You have some appointments in the schedule. Do you want to change it?", completionHandlerForOk: { (alert) in
                            
                            print("json \(self.addScheduleData?.scheduleData?.toJSONString() as Any) \n \(self.addScheduleData?.scheduleData?.toJSONString() ?? "empty")")
                            self.updateChangeSchedule()
                        })
                    }
                    
                }
                else if self.addScheduleData?.status?.code == "2"
                {
                    GenericMethods.showAlertwithPopNavigation(alertMessage: self.addScheduleData?.status?.message ?? "Schedule Not changed", vc: self)
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
        
        if self.addScheduleData != nil {
            return self.addScheduleData?.scheduleData?.count ?? 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        addNormalScheduleCell = tableView.dequeueReusableCell(withIdentifier: "addNormalScheduleCell") as? AddNormalScheduleTVC
        if addNormalScheduleCell == nil
        {
            addNormalScheduleCell = AddNormalScheduleTVC(style: .default, reuseIdentifier: "addNormalScheduleCell")
        }
        
        
       
       addNormalScheduleCell?.fromTimeBtnInstance.tag = indexPath.row
        addNormalScheduleCell?.fromTimeBtnInstance.addTarget(self, action: #selector(fromTimeBtnMethod(btn:)), for: .touchUpInside)
        addNormalScheduleCell?.toTimeBtnInstance.tag = indexPath.row
        addNormalScheduleCell?.toTimeBtnInstance.addTarget(self, action: #selector(toTimeBtnMethod(btn:)), for: .touchUpInside)
       
        addNormalScheduleCell?.patientHrsBtnInstance.titleLabel?.adjustsFontSizeToFitWidth = true
        addNormalScheduleCell?.patientHrsBtnInstance.tag = indexPath.row
//        addNormalScheduleCell?.patientHrsBtnInstance.setTitle(self.addScheduleData?.scheduleData?[0].patientHrsTime ?? "", for: .normal)
        
        
        addNormalScheduleCell?.patientHrsBtnInstance.setTitle(GenericMethods.convertHrstoMinsFormat(dateStr: self.addScheduleData?.scheduleData?[indexPath.row].patientHrsTime ?? "00:00"), for: .normal)

        
        
        addNormalScheduleCell?.weekDayLabel.text = self.addScheduleData?.scheduleData?[indexPath.row].availableDays ?? ""
        addNormalScheduleCell?.fromTimeBtnInstance.setTitle(GenericMethods.convert24hrto12hrFormat(dateStr: self.addScheduleData?.scheduleData?[indexPath.row].startTime ?? "00:00"), for: .normal)
        addNormalScheduleCell?.toTimeBtnInstance.setTitle(GenericMethods.convert24hrto12hrFormat(dateStr: self.addScheduleData?.scheduleData?[indexPath.row].endTime ?? "00:00"), for: .normal)
        
        
        
        return addNormalScheduleCell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
