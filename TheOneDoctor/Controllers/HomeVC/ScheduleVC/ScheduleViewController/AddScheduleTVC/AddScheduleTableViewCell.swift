//
//  AddScheduleTableViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 21/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import JTAppleCalendar

protocol addScheduleTableViewCellDelegate {
    func selectedDateMethod(scheduleDate:Date)
}

class AddScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var previousMothBtnInstance: UIButton!
    @IBOutlet weak var nextMonthBtnInstance: UIButton!
    
    @IBOutlet weak var currentDateLbl: UILabel!
    @IBOutlet weak var clinicBgView: UIView!
    @IBOutlet weak var clinicImgView: UIImageView!
    @IBOutlet weak var clinicName: UILabel!
    @IBOutlet weak var clinicAddressLbl: UILabel!
    @IBOutlet weak var calendarContainerView: UIView!
    
    
    
    let todayDate = Date()
    let dateformatter = DateFormatter()
    let comparisonDateFormatter = DateFormatter()
    var delegate:addScheduleTableViewCellDelegate?
    
    var isFilterStr = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("awakeFromNib")
        
        dateformatter.dateFormat = AppConstants.dayMonthYearFormat
        currentDateLbl.text = dateformatter.string(from: GenericMethods.currentDateTime())

        
        clinicBgView.layer.cornerRadius = 5.0
        clinicBgView.layer.masksToBounds = true
        
        calendarContainerView.layer.cornerRadius = 5.0
        calendarContainerView.layer.masksToBounds = true
        
        
        
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
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func previousMonthBtnClick(_ sender: Any) {
        calendarView.scrollToSegment(.previous)
        
    }
    @IBAction func nextMonthBtnClick(_ sender: Any) {
        calendarView.scrollToSegment(.next)
        
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
            currentDateLbl.text = dateformatter.string(from: GenericMethods.currentDateTime())
        }
        else
        {
        currentDateLbl.text = dateformatter.string(from: firstDate)
        calendarView.reloadData()
        }
        GenericMethods.monthYearSelectionMethod(date: firstDate, previousBtnInstance: previousMothBtnInstance, nextBtnInstance: nextMonthBtnInstance, lastDate: GenericMethods.dayLimitCalendar(), dateFormat: AppConstants.monthYearFormat)
        
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
    
}
extension AddScheduleTableViewCell:JTAppleCalendarViewDelegate,JTAppleCalendarViewDataSource
{
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        print("shouldSelectDate")
        
        if cellState.dateBelongsTo != .thisMonth {
            return false
        }
        else
        {
            if GenericMethods.checkDateisBetween(date: date, lastDate: GenericMethods.dayLimitCalendar())
            {
                    return true
            }
            return false
        }
    }
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: "scheduleCalendarCell", for: indexPath) as! CalendarDateCollectionViewCell
        
        cell.dateTextLabel.text = cellState.text

        cell.backgroundColor = UIColor.white
        cell.dateTextLabel.textColor = UIColor.darkText
        
            if cellState.dateBelongsTo != .thisMonth {
                cell.dateTextLabel.textColor = UIColor.lightGray
                cell.backgroundColor = UIColor.white
                cell.achievedCountLbl.isHidden = true
            }
            else
            {
                if GenericMethods.checkDateisBetween(date: date, lastDate: GenericMethods.dayLimitCalendar())
                {
                    dateformatter.dateFormat = AppConstants.postDateFormat
                    
                    let extractedDate = dateformatter.string(from: date)
                    
                    let resultArray = self.searchFromArray(searchKey: "date", searchString: extractedDate, array: AppConstants.resultDateArray)
                    if resultArray.count > 0
                    {
                        if  let valueDict1 = (resultArray[0] as? [AnyHashable: Any])
                        {
                            
                            cell.achievedCountLbl.isHidden = false
                            cell.achievedCountLbl.text = "\(valueDict1["achieved"] ?? 0)"
                            var status = 0
                            
                            if (AppConstants.schedulefilteredStatus == 0) || (AppConstants.schedulefilteredStatus == 5)
                            {
                                status = valueDict1["status"]  as? Int ?? 0
                                
                            }
                            else
                            {
                                if valueDict1["status"]  as? Int ?? 0 == AppConstants.schedulefilteredStatus
                                {
                                    status = AppConstants.schedulefilteredStatus
                                }
                                
                            }
                            cell.contentView.layer.borderColor = UIColor.white.cgColor
                            cell.contentView.layer.borderWidth = 0.2
                            
                            switch status
                            {
                            case 0:
                                cell.backgroundColor = UIColor.white
                            case 1://fully booked
                                
                                cell.backgroundColor = UIColor.red.withAlphaComponent(0.7)
                            case 2://Booking started
                                cell.backgroundColor = UIColor.yellow.withAlphaComponent(0.7)
                            case 3: //No Booking
                                cell.backgroundColor = UIColor(red: 0.0, green: 128.0, blue: 0.0, alpha: 0.7)
                            case 4://No Slot
                                cell.backgroundColor = UIColor.orange.withAlphaComponent(0.7)
                                
                            case 5://Slots Cancelled
                                cell.backgroundColor = UIColor.white
                                cell.contentView.layer.borderColor = UIColor.red.cgColor
                                cell.contentView.layer.borderWidth = 1.5
                            default:
                                cell.backgroundColor = UIColor.white
                            }
                            
                        }
                        
                    }
                    else
                    {
                        cell.achievedCountLbl.isHidden = true
                    }
                }
                else
                {
                    cell.dateTextLabel.textColor = UIColor.lightGray
                    cell.backgroundColor = UIColor.white
                    cell.achievedCountLbl.isHidden = true
                }
                
        }

        self.handleSelectedCell(cell: cell, cellState: cellState)
        return cell
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {

        let endDate = GenericMethods.dayLimitCalendar()
        let param = ConfigurationParameters(startDate: GenericMethods.currentDateTime(), endDate: endDate)
        return param
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        self.handleSelectedCell(cell: cell, cellState: cellState)
        
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if cellState.selectionType == SelectionType.userInitiated {
            print("userInitial")
            
            print("current selected date \(dateformatter.string(from: date))")
            
            
            let selectedDateFormatter = DateFormatter()
            selectedDateFormatter.dateFormat = AppConstants.defaultDateFormat
            selectedDateFormatter.timeZone = TimeZone.current
            let datestr = selectedDateFormatter.string(from: date as Date)
            selectedDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

            guard let currentDate = selectedDateFormatter.date(from: datestr)
                else
            {
                return
            }

            selectedDateFormatter.dateFormat =
                AppConstants.postDateFormat

            guard let startDate2 = selectedDateFormatter.date(from: selectedDateFormatter.string(from: GenericMethods.currentDateTime()))
                else
            {
                return
            }
            print("startDate2 \(startDate2)")
            let between = currentDate.isBetween(startDate2, and: GenericMethods.dayLimitCalendar())
            if between
            {
                self.delegate?.selectedDateMethod(scheduleDate: currentDate)
            }
        }
        else if cellState.selectionType == SelectionType.programatic {
            print("programmatic")
//            dateformatter.dateFormat = AppConstants.monthYearFormat
//            dateformatter.locale = Calendar.current.locale
//            dateformatter.timeZone = Calendar.current.timeZone
//
//            if dateformatter.string(from: date) != dateformatter.string(from: GenericMethods.currentDateTime())
//            {
//                previousMothBtnInstance.isHidden = false
//                nextMonthBtnInstance.isHidden = true
//            }
//            else
//            {
//                nextMonthBtnInstance.isHidden = false
//                previousMothBtnInstance.isHidden = true
//            }
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
