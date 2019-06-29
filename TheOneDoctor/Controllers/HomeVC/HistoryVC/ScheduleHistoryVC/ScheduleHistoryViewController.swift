//
//  ScheduleHistoryViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 14/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import Alamofire

class ScheduleHistoryViewController: UIViewController {
    
    
    @IBOutlet weak var scheduleHistoryTableView: UITableView!
    @IBOutlet weak var monthDayView: UIView!
    @IBOutlet weak var monthDayLbl: UILabel!
    @IBOutlet weak var previousMonthBtnInst: UIButton!
    @IBOutlet weak var nextMonthBtnInst: UIButton!
    @IBOutlet weak var montchangeView: UIView!
    @IBOutlet weak var schedulePickerview: UIPickerView!
    @IBOutlet weak var pickerContainerView: UIView!
    
    
    let apiManager = APIManager()
    var scheduleHistoryData:ScheduleHistoryModel?
    let createdDateFormatter = DateFormatter()
    var scheduleHistCell:ScheduleHistoryTableViewCell? = nil
    var scheduleSectionCell:ScheduleSectionTableViewCell? = nil
    var yearArray = [""]
    var selectedYear = ""
    var selectedRow = 0

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
        createdDateFormatter.dateFormat = "yyyy"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Schedule History"
        
        montchangeView.layer.cornerRadius = 5.0
        montchangeView.layer.masksToBounds = true
        montchangeView.layer.borderColor = AppConstants.appdarkGrayColor.cgColor
        montchangeView.layer.borderWidth = 1.0
        
        
        self.scheduleHistoryTableView.tableFooterView = UIView()
        self.scheduleHistoryTableView.sectionHeaderHeight = 80
        
        let calendarTapGesture = UITapGestureRecognizer(target: self, action: #selector(openpickerView))
        calendarTapGesture.numberOfTapsRequired = 1
        monthDayView.addGestureRecognizer(calendarTapGesture)
        loadingScheduleHistoryAPI(year: createdDateFormatter.string(from: GenericMethods.currentDateTime()))
        monthDayLbl.text = createdDateFormatter.string(from: GenericMethods.currentDateTime())
        nextMonthBtnInst.isHidden = true
        self.scheduleHistoryTableView.register(UINib(nibName: "ScheduleSectionTableViewCell", bundle: nil), forCellReuseIdentifier: "scheduleSectionCell")
        
        let currentYear = Int(createdDateFormatter.string(from: GenericMethods.currentDateTime()))!
        yearArray = []
        for i in 2019...currentYear
        {
            yearArray.append("\(i)")
        }
        
        pickerContainerView.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @objc func openpickerView()
    {
        pickerContainerView.isHidden = false
        if !GenericMethods.isStringEmpty(selectedYear)
        {
            var defaultRowIndex = yearArray.firstIndex(of: selectedYear)
            print("defaultRowIndex \(String(describing: defaultRowIndex))")
            if(defaultRowIndex == nil) { defaultRowIndex = 0 }
            schedulePickerview.selectRow(defaultRowIndex!, inComponent: 0, animated: false)
        }
        else
        {
            schedulePickerview.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    @IBAction func doneBtnClick(_ sender: Any) {
        pickerContainerView.isHidden = true
        
        loadingScheduleHistoryAPI(year: pickerView(schedulePickerview, titleForRow: selectedRow, forComponent: 0) ?? "")
//        print("selectedYear \(selectedYear)")
//        if selectedYear != ""
//        {
//            loadingScheduleHistoryAPI(year: selectedYear)
//            monthDayLbl.text = selectedYear
//
//            if selectedYear == createdDateFormatter.string(from: GenericMethods.currentDateTime())
//            {
//                if yearArray.count > 0
//                {
//                    nextMonthBtnInst.isHidden = true
//                    previousMonthBtnInst.isHidden = false
//                }
//                else
//                {
//                    nextMonthBtnInst.isHidden = true
//                    previousMonthBtnInst.isHidden = true
//                }
//
//            }
//            else if yearArray.contains(selectedYear)
//            {
//                nextMonthBtnInst.isHidden = false
//                previousMonthBtnInst.isHidden = false
//            }
//            else
//            {
//                nextMonthBtnInst.isHidden = false
//                previousMonthBtnInst.isHidden = true
//            }
//        }
    }
    @IBAction func cancelBtnClick(_ sender: Any) {
        pickerContainerView.isHidden = true
    }
    func dateSelectionMethod()
    {
        if yearArray.count == 1
        {
            nextMonthBtnInst.isHidden = true
            previousMonthBtnInst.isHidden = true
        }
        else
        {
            if selectedYear == yearArray[0]
            {
                nextMonthBtnInst.isHidden = false
                previousMonthBtnInst.isHidden = true
            }
            else if selectedYear == yearArray.last ?? ""
            {
                nextMonthBtnInst.isHidden = true
                previousMonthBtnInst.isHidden = false
            }
            else
            {
                nextMonthBtnInst.isHidden = false
                previousMonthBtnInst.isHidden = false
            }
            
        }
        
    }
    
    func loadingScheduleHistoryAPI(year:String)
    {
        pickerContainerView.isHidden = true

        // "type":"ALL","clinic_id":1,"age":"0-10"
        var parameters = Dictionary<String, Any>()
        parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        parameters["year"] = year
        
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.scheduleHistoryAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.scheduleHistoryData = response
                
                
                
                if self.scheduleHistoryData?.status?.code == "0"{
                    //MARK: Schedule History Success
                    self.selectedYear = year
                    self.monthDayLbl.text = year
                    
                    self.dateSelectionMethod()
                    
                    self.scheduleHistoryTableView.reloadData()
                }
                
                else
                {
                    GenericMethods.showAlertwithPopNavigation(alertMessage: self.scheduleHistoryData?.status?.message ?? "Unable to fetch data. Please try again after sometime.", vc: self)
                    
                }
                
                
            }
            else {
                GenericMethods.showAlertwithPopNavigation(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.", vc: self)
                
            }
        }
        
    }
    
    @IBAction func previousBtnClick(_ sender: Any) {
        guard let index = yearArray.firstIndex(of: selectedYear)
            else{return}
        
            loadingScheduleHistoryAPI(year: yearArray[index-1])
        
        
        
    }
    @IBAction func nextBtnClick(_ sender: Any) {
        guard let index = yearArray.firstIndex(of: selectedYear)
            else{return}
        
        loadingScheduleHistoryAPI(year: yearArray[index+1])
    }
    


}
extension ScheduleHistoryViewController:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scheduleHistoryData != nil{
            return self.scheduleHistoryData?.appointment?.count ?? 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        scheduleHistCell = (tableView.dequeueReusableCell(withIdentifier: "scheduleHistCell", for: indexPath) as! ScheduleHistoryTableViewCell)
        
        if scheduleHistCell == nil
        {
            scheduleHistCell = ScheduleHistoryTableViewCell(style: .default, reuseIdentifier: "searchListCell")
        }
        
        scheduleHistCell?.bgView.layer.cornerRadius = 5.0
        scheduleHistCell?.bgView.layer.masksToBounds = true
        
        scheduleHistCell?.monthLbl.text = self.scheduleHistoryData?.appointment?[indexPath.row].month ?? ""
        scheduleHistCell?.monthAttendantsLbl.text = "\(self.scheduleHistoryData?.appointment?[indexPath.row].value ?? 0)"
        
        scheduleHistCell?.monthAttendantsLbl?.layer.cornerRadius =  (scheduleHistCell?.monthAttendantsLbl?.bounds.height)! / 2
        scheduleHistCell?.monthAttendantsLbl?.layer.masksToBounds = true
        scheduleHistCell?.monthAttendantsLbl?.clipsToBounds = true
        
        return scheduleHistCell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        scheduleSectionCell = (tableView.dequeueReusableCell(withIdentifier: "scheduleSectionCell") as! ScheduleSectionTableViewCell)
        
        if scheduleSectionCell == nil
        {
            scheduleSectionCell = ScheduleSectionTableViewCell(style: .default, reuseIdentifier: "scheduleSectionCell")
        }
        scheduleSectionCell?.contentView.backgroundColor = UIColor.white
        scheduleSectionCell?.totalAppointmentsLbl.text = "\(self.scheduleHistoryData?.totalAppointment ?? 0)"
        
        return scheduleSectionCell!
    }
}
extension ScheduleHistoryViewController:UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return yearArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(yearArray[row])
        selectedRow = row
        
    }
}
