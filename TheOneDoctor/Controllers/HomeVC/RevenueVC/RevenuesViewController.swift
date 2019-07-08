//
//  EarningsViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 24/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import Charts

class RevenuesViewController: UIViewController {

    @IBOutlet weak var monthYearView: UIView!
    @IBOutlet weak var scrollViewInstance: UIScrollView!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var nextBtnInstance: UIButton!
    @IBOutlet weak var previousBtnInstance: UIButton!
    @IBOutlet weak var earningsBtnInstance: UIButton!
    @IBOutlet weak var creditPointsBtnInstance: UIButton!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var redeemBtnInstance: UIButton!
    @IBOutlet weak var yearClickView: UIView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var yearArray:[String] = []
    var selectedYear = ""
    var selectedMonth = 0
    var selectedYearRow = 0
    var selectedMonthRow = 0
    let createdDateFormatter = DateFormatter()
    let yearFormatter = DateFormatter()
    var monthsArray = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    var detailBarbuttonItem = UIBarButtonItem()
    let apiManager = APIManager()
    var revenueDetailsData:RevenueListModel?
    var selectedDate = GenericMethods.currentDateTime()
    var xValues: [String]!
    var yValues: [Double]!
    var selectedType = 0
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createdDateFormatter.dateFormat = AppConstants.defaultDateFormat
        yearFormatter.dateFormat = AppConstants.yearFormat
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Revenue"
        detailBarbuttonItem = UIBarButtonItem(image: UIImage(named: "Info"), style: .plain, target: self, action: #selector(openDetailsView))
        
        self.navigationItem.rightBarButtonItem = detailBarbuttonItem
        
        detailBarbuttonItem.tintColor = UIColor.clear
        detailBarbuttonItem.isEnabled = false
        
        monthYearView.layer.cornerRadius = 5.0
        monthYearView.layer.masksToBounds = true
        monthYearView.layer.borderColor = AppConstants.appdarkGrayColor.cgColor
        monthYearView.layer.borderWidth = 1.0
        
        earningsClickMethod()
        redeemBtnInstance.layer.cornerRadius = 15.0
        redeemBtnInstance.layer.masksToBounds = true
        redeemBtnInstance.layer.borderColor = AppConstants.appyellowColor.cgColor
        redeemBtnInstance.layer.borderWidth = 1.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openCalendarView))
        tapGesture.numberOfTapsRequired = 1
        yearClickView.addGestureRecognizer(tapGesture)
        
        
        let currentYear = Int(yearFormatter.string(from: GenericMethods.currentDateTime()))!
        
        
        for i in 2019...currentYear
        {
            yearArray.append("\(i)")
        }
        
        pickerContainerView.isHidden = true
        
        barChartView.gridBackgroundColor = UIColor.clear
        
        print("month number \(Calendar.current.component(.month, from: selectedDate))")
        let currentYearStr = GenericMethods.dateFormatting(createdDateStr: createdDateFormatter.string(from: selectedDate), dateFormat: AppConstants.yearFormat)
        let currentMonth = Calendar.current.component(.month, from: GenericMethods.currentDateTime())
        monthsArray = []
        for i in 0...currentMonth-1
        {
            monthsArray.append(DateFormatter().monthSymbols[i])
        }
        loadingRevenueDetailsAPI(fromLoad: 0, type: selectedType, month: currentMonth, year: currentYearStr)
        
//        loadingRevenueDetailsAPI(fromLoad:0)
//        barChartView.legend.enabled = false

        // Do any additional setup after loading the view.
    }
    @objc func openDetailsView()
    {
        
    }
    @objc func openCalendarView()
    {
        pickerContainerView.isHidden = false
        if !GenericMethods.isStringEmpty(selectedYear)
        {
            var defaultRowIndex = yearArray.firstIndex(of: selectedYear)
            print("defaultRowIndex \(String(describing: defaultRowIndex))")
            if(defaultRowIndex == nil) { defaultRowIndex = 1 }
            pickerView.selectRow(defaultRowIndex!, inComponent: 1, animated: false)
            let defaultMonthIndex = selectedMonth
            print("defaultMonthIndex \(String(describing: defaultMonthIndex))")
            pickerView.selectRow(defaultMonthIndex, inComponent: 0, animated: false)
        }
        else
        {
            pickerView.selectRow(0, inComponent: 0, animated: false)
        }
    }
    override func viewDidLayoutSubviews() {
        scrollViewInstance.contentSize = CGSize(width: scrollViewInstance.frame.width, height: barChartView.frame.origin.y+barChartView.frame.height+20)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewInstance.contentOffset = CGPoint(x: 0, y: scrollViewInstance.contentOffset.y)
    }
    func getDateFrom(day:Int,month:Int,year:Int)-> Date
    {
        var calendarComp = DateComponents()
        calendarComp.day = day
        calendarComp.month = month
        calendarComp.year = year
        calendarComp.hour = 0
        calendarComp.minute = 0
        calendarComp.second = 0
        let userSelectedDate = GenericMethods.currentCalender().date(from: calendarComp)!
        return userSelectedDate
    }
    func dateSelectionMethod(previousBtnInstance:UIButton,nextBtnInstance:UIButton,firstdate:Date,lastDate:Date,dateFormat:String,currentDate:Date)
    {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = dateFormat
        dayFormatter.timeZone = TimeZone.current
        dayFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let firstDate = dayFormatter.date(from: dayFormatter.string(from: firstdate))
            else
        {
            return
        }
        guard let lastDate = dayFormatter.date(from: dayFormatter.string(from: lastDate))
            else
        {
            return
        }
        
        guard let currentDate = dayFormatter.date(from: dayFormatter.string(from: currentDate))
            else
        {
            return
        }
        print("firstDate\(firstDate) currentDate\(currentDate) lastDate\(lastDate)")
        if firstDate == currentDate
        {
            print("this month")
            nextBtnInstance.isHidden = false
            previousBtnInstance.isHidden = true
        }
        else if lastDate == currentDate
        { print("last month")
            nextBtnInstance.isHidden = true
            previousBtnInstance.isHidden = false
        }
        else
        { print("between month")
            nextBtnInstance.isHidden = false
            previousBtnInstance.isHidden = false
        }
    }
    
    // MARK: - Revenue API
    func loadingRevenueDetailsAPI(fromLoad:Int,type:Int,month:Int,year:String)
    {
        pickerContainerView.isHidden = true
        var parameters = Dictionary<String, Any>()
        parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        parameters["month"] = month
        parameters["year"] = year
        parameters["type"] = type
        print("parma \(parameters)")
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")

        apiManager.revenueListAPI(parameters: parameters) { (status, showError, response, error) in

            GenericMethods.hideLoaderMethod(view: self.view)

            if status == true
            {
                self.revenueDetailsData = response
                if self.revenueDetailsData?.status?.code == "0" {
                    //MARK: Revenue Success Details
                    
                    self.selectedMonth = month
                    self.selectedYear = year
                    self.yearLbl.text = "\(DateFormatter().monthSymbols[self.selectedMonth - 1]) \(self.selectedYear)"
                    
                    
                    let selectDate =  self.getDateFrom(day: 1, month: self.selectedMonth, year: Int(self.selectedYear)!)
                    let firstDate =  self.getDateFrom(day: 1, month: 1, year: Int(self.yearArray[0])!)
                    let lastDate =  GenericMethods.currentDateTime()
                    self.dateSelectionMethod(previousBtnInstance: self.previousBtnInstance, nextBtnInstance: self.nextBtnInstance, firstdate: firstDate, lastDate: lastDate, dateFormat: AppConstants.monthYearFormat, currentDate: selectDate)
                    if self.redeemBtnInstance.isHidden == true
                    {
                        self.priceLbl.text = "\(self.revenueDetailsData?.totalValue ?? 0) KWD"
                    }
                    else
                    {
                        self.priceLbl.text = "\(self.revenueDetailsData?.totalValue ?? 0) points"
                    }
                    
                    print("name \(self.revenueDetailsData?.referralData?[0].name ?? "")")
                    self.barChartUpdate()
                    
                }
                else
                {
                    if fromLoad == 0
                    {
                        GenericMethods.showAlertwithPopNavigation(alertMessage: self.revenueDetailsData?.status?.message ?? "Unable to fetch data. Please try again after sometime.", vc: self)

                    }
                    else
                    {
                        GenericMethods.showAlert(alertMessage: self.revenueDetailsData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")

                    }


                }


            }
            else {
                if fromLoad == 0
                {
                    GenericMethods.showAlertwithPopNavigation(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.", vc: self)

                }
                else
                {
                    GenericMethods.showAlert(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.")

                }




            }
        }
    }
   
    func barChartUpdate()
    {
        
        barChartView.xAxis.labelPosition = .bottom
        var name = [""]
        var values = [0.0]
        name.remove(at: 0)
        values.remove(at: 0)
        for i in 0..<(self.revenueDetailsData?.referralData?.count ?? 0)
        {
            print(self.revenueDetailsData?.referralData?[i].name ?? "")
            
            name.append(self.revenueDetailsData?.referralData?[i].name ?? "")
            values.append(Double(self.revenueDetailsData?.referralData?[i].value ?? 0))
            
        }
        
        barChartView.setBarChartData(xValues: name, yValues: values, label: "")
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: name)
        barChartView.xAxis.labelCount = name.count
        barChartView.xAxis.labelPosition = .bottom
        barChartView.drawGridBackgroundEnabled = false
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawLabelsEnabled = false
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.legend.enabled = false
        
        
    }

    func earningsClickMethod()
    {
        self.earningsBtnInstance.setTitleColor(AppConstants.appGreenColor, for: .normal)
        self.creditPointsBtnInstance.setTitleColor(UIColor.lightGray, for: .normal)
        self.earningsBtnInstance.layer.addBorder(edge: .bottom, color: AppConstants.appGreenColor, thickness: 2.0)
        self.creditPointsBtnInstance.layer.addBorder(edge: .bottom, color: UIColor.white, thickness: 2.0)
        self.redeemBtnInstance.isHidden = true
        detailBarbuttonItem.tintColor = UIColor.clear
        detailBarbuttonItem.isEnabled = false
    }
    
    //MARK: IBActions
    
    @IBAction func previousBtnClick(_ sender: Any) {
        let selectYear = self.selectedYear
        let selectMonth = selectedMonth - 1
        print("selectedYear \(selectYear) selectedMonth \(selectMonth)")
        loadingRevenueDetailsAPI(fromLoad: 1, type: selectedType, month: selectMonth, year: selectYear)
    }
    @IBAction func nextBtnClick(_ sender: Any) {
        let selectYear = self.selectedYear
        let selectMonth = selectedMonth + 1
        print("selectedYear \(selectYear) selectedMonth \(selectMonth)")
        loadingRevenueDetailsAPI(fromLoad: 1, type: selectedType, month: selectMonth, year: selectYear)
    }
    @IBAction func earningsBtnClick(_ sender: Any)
    {
        earningsClickMethod()
        selectedType = 0
        loadingRevenueDetailsAPI(fromLoad: 1, type: selectedType, month: selectedMonth, year: selectedYear)
    }
    @IBAction func creditBtnClick(_ sender: Any)
    {
        self.creditPointsBtnInstance.setTitleColor(AppConstants.appGreenColor, for: .normal)
        self.earningsBtnInstance.setTitleColor(UIColor.lightGray, for: .normal)
        self.creditPointsBtnInstance.layer.addBorder(edge: .bottom, color: AppConstants.appGreenColor, thickness: 2.0)
        self.earningsBtnInstance.layer.addBorder(edge: .bottom, color: UIColor.white, thickness: 2.0)
        self.redeemBtnInstance.isHidden = false
        detailBarbuttonItem.tintColor = UIColor.white
        detailBarbuttonItem.isEnabled = true
        selectedType = 1
        loadingRevenueDetailsAPI(fromLoad: 1, type: selectedType, month: selectedMonth, year: selectedYear)
        
    }
    
    @IBAction func doneBtnClick(_ sender: Any) {
        pickerContainerView.isHidden = true

        let selectYear = yearArray[selectedYearRow]
        let selectMonth = selectedMonthRow + 1
        print("selectedYear \(selectYear) selectedMonth \(selectMonth)")
        loadingRevenueDetailsAPI(fromLoad: 1, type: selectedType, month: selectMonth, year: selectYear)
        
    }
    @IBAction func cancelBtnClick(_ sender: Any) {
        pickerContainerView.isHidden = true
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
extension BarChartView {
    
    private class BarChartFormatter: NSObject, IAxisValueFormatter {
        
        var labels: [String] = []
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
        
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
    }
    
    func setBarChartData(xValues: [String], yValues: [Double], label: String) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<yValues.count {

                let dataEntry = BarChartDataEntry(x: Double(i), y: yValues[i])
                dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: label)
        let chartData = BarChartData(dataSet: chartDataSet)
        
        
        let chartFormatter = BarChartFormatter(labels: xValues)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        
        self.data = chartData
    }
}
extension RevenuesViewController:UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0
        {
            return monthsArray.count
        }
        return yearArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0
        {
            return monthsArray[row]
        }
        return yearArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("year row \(pickerView.selectedRow(inComponent: 1))")
        print("month row \(pickerView.selectedRow(inComponent: 0))")
        selectedYearRow = pickerView.selectedRow(inComponent: 1)
        selectedMonthRow = pickerView.selectedRow(inComponent: 0)
    }
}
