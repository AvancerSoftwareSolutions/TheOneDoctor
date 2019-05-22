//
//  AddScheduleTableViewCell.swift
//  TheOneDoctor
//
//  Created by MyMac on 21/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import JTAppleCalendar

class AddScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var previousMothBtnInstance: UIButton!
    @IBOutlet weak var nextMonthBtnInstance: UIButton!
    
    @IBOutlet weak var currentDateLbl: UILabel!
    
    let todayDate = Date()
    let dateformatter = DateFormatter()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        guard let validcell = cell as? CalendarDateCollectionViewCell else {
            return
        }
//        if validcell.isHighlighted
//        {
//            validcell.backgroundColor = .red
//        }
//        else
//        {
//            validcell.backgroundColor = .white
//        }
    }
    func setupViewOfCalendar(from visibleDate:DateSegmentInfo)
    {
        guard let date = visibleDate.monthDates.first?.date else {
            return
        }
        
        dateformatter.dateFormat = "E, MMM d"
        currentDateLbl.text = dateformatter.string(from: date)
        
        print("current date \(dateformatter.string(from: date))")
        
        
    }
    
}
extension AddScheduleTableViewCell:JTAppleCalendarViewDelegate,JTAppleCalendarViewDataSource
{
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if cellState.dateBelongsTo != .thisMonth {
            return false
        }
        return true
    }
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: "scheduleCalendarCell", for: indexPath) as! CalendarDateCollectionViewCell
        
        cell.dateTextLabel.text = cellState.text
        
        if Calendar.current.isDateInToday(date) {
            cell.backgroundColor = UIColor.blue
            cell.dateTextLabel.textColor = UIColor.orange
            cell.achievedCountLbl.isHidden = false
        } else {
            cell.backgroundColor = UIColor.white
            if cellState.dateBelongsTo != .thisMonth {
                cell.dateTextLabel.textColor = UIColor.lightGray
            }
            else
            {
                cell.dateTextLabel.textColor = UIColor.darkText
            }
        }
        //        cell.layer.cornerRadius = 5.0
//        cell.layer.borderColor = UIColor.lightGray.cgColor
//        cell.layer.borderWidth = 0.8
        
        self.handleSelectedCell(cell: cell, cellState: cellState)
        return cell
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        dateformatter.dateFormat = "dd MM yyyy"
        dateformatter.locale = Calendar.current.locale
        dateformatter.timeZone = Calendar.current.timeZone
        
        
        let endDate = dateformatter.date(from: "11 11 2119")!
        print("current \(GenericMethods.currentDateTime())")
        let param = ConfigurationParameters(startDate: GenericMethods.currentDateTime(), endDate: endDate)
//        let param = ConfigurationParameters(startDate: GenericMethods.currentDateTime(), endDate: endDate, numberOfRows: 6, calendar: Calendar.current, generateInDates: .forFirstMonthOnly, generateOutDates: .off, firstDayOfWeek: .sunday, hasStrictBoundaries: true)
        
        
        return param
        
        
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        self.handleSelectedCell(cell: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        
        dateformatter.dateFormat = "MM yyyy"
        dateformatter.locale = Calendar.current.locale
        dateformatter.timeZone = Calendar.current.timeZone
        print("selected date \(dateformatter.string(from: date))")
        print("current selected date \(dateformatter.string(from: date))")
        if dateformatter.string(from: date) != dateformatter.string(from: GenericMethods.currentDateTime())
        {
            previousMothBtnInstance.isHidden = false
        }

        self.handleSelectedCell(cell: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        self.handleSelectedCell(cell: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewOfCalendar(from: visibleDates)
    }
}
