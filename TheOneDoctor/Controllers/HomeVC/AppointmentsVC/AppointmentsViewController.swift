//
//  AppointmentsViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 16/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class AppointmentsViewController: UIViewController,sendAppointmentsFilterValuesDelegate,sendDateDelegate {
    
    

    //MARK:- IBOutlets
    @IBOutlet weak var appointmentsTableView: UITableView!
    @IBOutlet weak var monthDayView: UIView!
    @IBOutlet weak var monthDayLbl: UILabel!
    @IBOutlet weak var previousMonthBtnInst: UIButton!
    @IBOutlet weak var nextMonthBtnInst: UIButton!
    @IBOutlet weak var montchangeView: UIView!
    
    
    
    
    var appointmentsArray:NSMutableArray = []
    var appointmentsCell:AppointmentsTableViewCell? = nil
    var appointmentsListData:AppointmentsModel?
    let apiManager = APIManager()
    var date = ""
    let dateFormatter = DateFormatter()
    let createdDateFormatter = DateFormatter()
    
    var maximumDate = Date()
    var selectedDate = Date()
    
    var ageStr = ""
    var appointmentStr = ""
    var clinicStr = ""
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        dateFormatter.dateFormat = AppConstants.dayMonthYearFormat
        createdDateFormatter.dateFormat = AppConstants.defaultDateFormat
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthDayLbl.text = dateFormatter.string(from: GenericMethods.currentDateTime())
        previousMonthBtnInst.isHidden = true
        selectedDate = GenericMethods.currentDateTime()
        
        self.title = "Appointments"
        montchangeView.layer.borderColor = AppConstants.appdarkGrayColor.cgColor
        montchangeView.layer.borderWidth = 1.0
        
        appointmentsTableView.tableFooterView = UIView()
        
        let svgHoldingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        GenericMethods.setLeftViewWithSVG(svgView: svgHoldingView, with: "filter", color: UIColor.white)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(filterBtnClick))
        tapGesture.numberOfTapsRequired = 1
        svgHoldingView.addGestureRecognizer(tapGesture)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: svgHoldingView)
        
        loadingAppointmentsDetailsAPI(date: createdDateFormatter.string(from: GenericMethods.currentDateTime()), postDate: GenericMethods.currentDateTime())
        
        let calendarTapGesture = UITapGestureRecognizer(target: self, action: #selector(openCalendarView))
        calendarTapGesture.numberOfTapsRequired = 1
        monthDayView.addGestureRecognizer(calendarTapGesture)
        
        // Do any additional setup after loading the view.
    }
    @objc func openCalendarView()
    {
        let calendarVC = self.storyboard!.instantiateViewController(withIdentifier: "calendarVC") as! CalendarViewController

        self.navigationController?.definesPresentationContext = true
        calendarVC.modalTransitionStyle = .crossDissolve
        calendarVC.modalPresentationStyle = .overCurrentContext
        calendarVC.delegate = self
        calendarVC.minimumDate = Date()
        calendarVC.maximumDate = Calendar.current.date(byAdding: .day, value: 28, to: Date())!
        UIApplication.shared.topMostViewController()?.present(calendarVC, animated: true)

        
    }
    @objc func filterBtnClick()
    {
        if appointmentsListData?.filterData?.count ?? 0 > 0
        {
            
            
            let appFilterVC = self.storyboard?.instantiateViewController(withIdentifier: "appFilterVC") as! AppointmentFilterViewController
            appFilterVC.appointFilterDelegate = self
            appFilterVC.appointmentsListData = self.appointmentsListData
            appFilterVC.age = self.ageStr
            appFilterVC.appointment = self.appointmentStr
            appFilterVC.clinic = self.clinicStr
            let navigateVC = UINavigationController(rootViewController: appFilterVC)
            navigateVC.navigationBar.barTintColor = AppConstants.appGreenColor
            navigateVC.navigationBar.tintColor = UIColor.white
            navigateVC.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            self.present(navigateVC, animated: true, completion: nil)
//            let appointFilterVC = self.storyboard?.instantiateViewController(withIdentifier: "appointFilterVC") as! AppointmentsFilterViewController
//            appointFilterVC.appointmentsListData = self.appointmentsListData
//            let navigateVC = UINavigationController(rootViewController: appointFilterVC)
//            navigateVC.navigationBar.barTintColor = AppConstants.appGreenColor
//            navigateVC.navigationBar.tintColor = UIColor.white
//            navigateVC.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
//            self.present(navigateVC, animated: true, completion: nil)
        }
        
        // appointFilterVC
        
        
    }
    func sendAppointmentsFilterValues(age: String, appointments: String, clinic: String) {
        print("\(age) \(appointments) \(clinic)")
        self.ageStr = age
        self.appointmentStr = appointments
        self.clinicStr = clinic
        
        loadingAppointmentsDetailsAPI(date: createdDateFormatter.string(from: self.selectedDate), postDate: self.selectedDate)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    func loadingAppointmentsDetailsAPI(date:String,postDate:Date)
    {
        let postDataFormatter = DateFormatter()
        postDataFormatter.dateFormat = AppConstants.postDateFormat
        print(GenericMethods.dateFormatting(createdDateStr: date, dateFormat: AppConstants.postDateFormat))
        
        // "type":"ALL","clinic_id":1,"age":"0-10"
        var parameters = Dictionary<String, Any>()
        parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        parameters["date"] = GenericMethods.dateFormatting(createdDateStr: date, dateFormat: AppConstants.postDateFormat)
        parameters["type"] = appointmentStr
        parameters["clinic_id"] = Int(clinicStr)
        parameters["age"] = ageStr
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.appointmentsListDetailsAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.appointmentsListData = response
                if self.appointmentsListData?.status?.code == "0" {
                    //MARK: Appointments Success Details
                    self.selectedDate = postDate
                    if self.selectedDate == Date()
                    {
                        self.previousMonthBtnInst.isHidden = true
                    }
                    else if self.selectedDate == self.maximumDate
                    {
                        self.nextMonthBtnInst.isHidden = true
                    }
                    else
                    {
                        self.previousMonthBtnInst.isHidden = true
                    }
                    self.monthDayLbl.text = self.dateFormatter.string(from: self.selectedDate)
                    self.appointmentsTableView.reloadData()
                    
                }
                else if self.appointmentsListData?.status?.code == "1"
                {
                    GenericMethods.showAlert(alertMessage: self.appointmentsListData?.status?.message ?? "No schedule.")
                }
                else
                {
                GenericMethods.showAlertwithPopNavigation(alertMessage: self.appointmentsListData?.status?.message ?? "Unable to fetch data. Please try again after sometime.", vc: self)

                    //                    GenericMethods.showAlert(alertMessage: self.profileData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                }
                
                
            }
            else {
                GenericMethods.showAlertwithPopNavigation(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.", vc: self)

            }
        }
        
    }
    
    func sendDate(selectedDateStr:String,selectedDate:Date)
    {
        loadingAppointmentsDetailsAPI(date: createdDateFormatter.string(from: selectedDate), postDate: selectedDate)
        
//        self.loadingAppointmentsDetailsAPI(date: selectedDateStr)
//        monthDayLbl.text = dateFormatter.string(from: selectedDate)
    }
    //MARK:- IBActions
    
    @IBAction func previousMonthBtnClick(_ sender: Any) {
        
        let date = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
        loadingAppointmentsDetailsAPI(date: createdDateFormatter.string(from: date), postDate: date)
    }
    @IBAction func nextMonthBtnClick(_ sender: Any) {
//        previousMonthBtnInst.isHidden = false
        let date = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
        loadingAppointmentsDetailsAPI(date: createdDateFormatter.string(from: date), postDate: date)
    }
    
    
}
extension AppointmentsViewController:UITableViewDelegate,UITableViewDataSource
{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.appointmentsListData != nil {
                return (self.appointmentsListData?.appointmentsData?.count) ?? 0
            }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        appointmentsCell = (tableView.dequeueReusableCell(withIdentifier: "appointmentsCell", for: indexPath) as! AppointmentsTableViewCell)
        
        if appointmentsCell == nil
        {
            appointmentsCell = AppointmentsTableViewCell(style: .default, reuseIdentifier: "appointmentsCell")
        }
        appointmentsCell?.bgView.layer.cornerRadius = 5.0
        appointmentsCell?.bgView.layer.masksToBounds = true
        appointmentsCell?.userTypeLbl.adjustsFontSizeToFitWidth = true
        
        appointmentsCell?.userTypeWdtConst.constant = (appointmentsCell?.userTypeLbl.bounds.size.height)! / 2
        appointmentsCell?.appointmentIdLbl.text = self.appointmentsListData?.appointmentsData?[indexPath.row].appointmentId ?? ""
        appointmentsCell?.clinicNameLbl.text = self.appointmentsListData?.appointmentsData?[indexPath.row].clinicName ?? ""
        appointmentsCell?.clinicNameLbl.addImage(imageName: "location.png", afterLabel: false)
        appointmentsCell?.patientNameLbl.text = self.appointmentsListData?.appointmentsData?[indexPath.row].patientName
        
        appointmentsCell?.timeLbl.text = appointmentsListData?.appointmentsData?[indexPath.row].fromTime
        
        appointmentsCell?.dayMonthLbl.text = GenericMethods.changeDateFormatting(createdDateStr: appointmentsListData?.appointmentsData?[indexPath.row].date ?? "", inputDateFormat: "yyyy-MM-dd", resultDateFormat: "E, MMM d")
        
        let userType = appointmentsListData?.appointmentsData?[indexPath.row].type
        switch userType {
        case "Normal":
            appointmentsCell?.userTypeLbl.text = "  N"
        case "VIP":
            appointmentsCell?.userTypeLbl.text = "  V"
        case "Referral":
            appointmentsCell?.userTypeLbl.text = "  R"
        default:
            break
        }
        
        
        // Configure the cell...
        
        return appointmentsCell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
}
