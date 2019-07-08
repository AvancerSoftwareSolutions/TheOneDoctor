//
//  CalendarViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 12/14/18.
//  Copyright © 2018 MyMac. All rights reserved.
//

import UIKit
protocol sendDateDelegate {
    func sendDate(selectedDateStr:String,selectedDate:Date)
}

class CalendarViewController: UIViewController
{

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var delegate : sendDateDelegate?
//    let date = Date()
    var dateFormatter = DateFormatter()
    var monthYearFormatter = DateFormatter()
    var selectedDate = Date()
//    var monthYearStr:String = ""
    var dateStr:String = ""
    var fromView:String = ""
    var minimumDate = Date()
    var maximumDate = Date()
    var setDate = Date()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        monthYearFormatter.dateFormat = AppConstants.monthYearTextFormat
        monthYearFormatter.timeZone = TimeZone.current
        monthYearFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        dateFormatter.dateFormat = AppConstants.postDateFormat
        monthYearFormatter.timeZone = TimeZone.current
        monthYearFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10.0
        popupView.layer.masksToBounds = true
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        datePicker.locale = Locale.current
        datePicker.timeZone = TimeZone.current
        datePicker.timeZone = TimeZone(secondsFromGMT: 0)
        datePicker.addTarget(self, action: #selector(pickerChanged(_:)), for: .valueChanged)
        
//        monthYearStr = "\(monthYearFormatter.string(from: date))"
        datePicker.setDate(setDate, animated: true)
        selectedDate = datePicker.date
        
        
        
//        if fromView == "register"
//        {
//            self.titleLbl.text = "Select Date of Birth"
//        }
//        else
//        {
            self.titleLbl.text = "Select Date"
//        }

        // Do any additional setup after loading the view.
    }
    @objc func pickerChanged(_ sender: Any?) {

        print("datePicker \(datePicker.date)")
        dateFormatter.dateFormat = AppConstants.datePickerFormat
        print(Date().localizedDescription)
        if let date = (sender as? UIDatePicker)?.date {
//            monthYearStr = "\(monthYearFormatter.string(from: date))"
            
            let datestr = dateFormatter.string(from: date as Date)
            
            let finaldate = dateFormatter.date(from:datestr)!
            print("finaldate \(finaldate)")
            dateFormatter.dateFormat = AppConstants.postDateFormat
            
            let selectDate = (dateFormatter.string(from: finaldate) == dateFormatter.string(from: GenericMethods.currentDateTime())) ? GenericMethods.currentDateTime() : finaldate
            
            selectedDate = selectDate
            print("selectDate \(selectDate)")
            
           

        }
        
        print(" date description: \(selectedDate)")
    }
    @IBAction func cancelBtnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneBtnClick(_ sender: Any) {
        dateFormatter.dateFormat = AppConstants.postDateFormat
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        func sendDelegateMethod()
        {
            if dateFormatter.string(from: selectedDate) == dateFormatter.string(from: GenericMethods.currentDateTime())
            {
                self.selectedDate = GenericMethods.currentDateTime()
            }
            
            self.delegate?.sendDate(selectedDateStr: "\(self.dateFormatter.string(from: self.selectedDate))", selectedDate: self.selectedDate)
        }
        dismiss(animated: true, completion: {
            
            sendDelegateMethod()
            print("selectedDate \(self.selectedDate)")
        })
        
//        dismiss(animated: true, completion: nil)
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
