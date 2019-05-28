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

class CalendarViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var delegate : sendDateDelegate?
    let date = Date()
    var dateFormatter = DateFormatter()
    var monthYearFormatter = DateFormatter()
    var selectedDate = Date()
    var monthYearStr:String = ""
    var dateStr:String = ""
    var fromView:String = ""
    var minimumDate = Date()
    var maximumDate = Date()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        monthYearFormatter = DateFormatter()
        monthYearFormatter.dateFormat = AppConstants.monthDayFormat
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppConstants.postDateFormat
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 10.0
        popupView.layer.masksToBounds = true
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        datePicker.addTarget(self, action: #selector(pickerChanged(_:)), for: .valueChanged)
        selectedDate = date
        monthYearStr = "\(monthYearFormatter.string(from: date))"
        
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
        
        if let date = (sender as? UIDatePicker)?.date {
            print(" date description: \(dateFormatter.string(from: date))")
        }
        if let date = (sender as? UIDatePicker)?.date {
            monthYearStr = "\(monthYearFormatter.string(from: date))"
            selectedDate = date
        }
        
        print(" date description: \(selectedDate) & \(monthYearStr)")
    }
    @IBAction func cancelBtnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneBtnClick(_ sender: Any) {
        dateFormatter.dateFormat = AppConstants.postDateFormat
        
        dismiss(animated: true, completion: {
            self.delegate?.sendDate(selectedDateStr: "\(self.dateFormatter.string(from: self.selectedDate))", selectedDate: self.selectedDate)
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
