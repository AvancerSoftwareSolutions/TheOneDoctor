//
//  ScheduleViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 21/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
// scheduleVC scheduleCalendarCell

import UIKit
import JTAppleCalendar
import Alamofire

class ScheduleViewController: UIViewController,addScheduleTableViewCellDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var fullBookedLbl: UILabel!
    @IBOutlet weak var bookingInProgressLbl: UILabel!
    @IBOutlet weak var bookingYetStartLbl: UILabel!
    @IBOutlet weak var noSlotLbl: UILabel!
    
    @IBOutlet weak var scheduleTableView: UITableView!
    
    //MARK:- Variables
    var filterView = UIView()
    let todayDate = Date()
    let dateformatter = DateFormatter()
    var addScheduleCell:AddScheduleTableViewCell? = nil
    let apiManager = APIManager()
    var scheduleData:ScheduleModel?
    var addBtn = UIBarButtonItem()
    var editBtn = UIBarButtonItem()
    
    
    var resultDateDict:NSMutableDictionary = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Schedule"
        AppConstants.schedulefilteredStatus = 0
        
        scheduleTableView.register(UINib(nibName: "AddScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "addScheduleCell")
        
        roundLabel(lbl: fullBookedLbl, color: UIColor.red)
        roundLabel(lbl: bookingInProgressLbl, color: UIColor.yellow)
        roundLabel(lbl: bookingYetStartLbl, color: UIColor.green)
        roundLabel(lbl: noSlotLbl, color: UIColor.orange)
        
        bookingYetStartLbl.layer.borderColor = UIColor.lightGray.cgColor
        bookingYetStartLbl.layer.borderWidth = 0.2

        addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addScheduleBtnClick))
        editBtn = UIBarButtonItem(image: UIImage(named: "EditProfPic.png"), style: .plain, target: self, action: #selector(editScheduleBtnClick))
        
        filterView = UIView(frame: CGRect(x: 28, y: 0, width: 10, height: 10))
        filterView.backgroundColor = .red
        filterView.layer.cornerRadius = 5
        filterView.layer.masksToBounds = true
        filterView.isHidden = true
        
        
        let svgHoldingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        GenericMethods.setLeftViewWithSVG(svgView: svgHoldingView, with: "filter", color: UIColor.white)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(filterBtnClick(sender:)))
        tapGesture.numberOfTapsRequired = 1
        svgHoldingView.addGestureRecognizer(tapGesture)
        svgHoldingView.addSubview(filterView)
        svgHoldingView.bringSubviewToFront(filterView)
        filterView.layer.zPosition = .greatestFiniteMagnitude
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: svgHoldingView),editBtn,addBtn]
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadingScheduleDetailsAPI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    func roundLabel(lbl:UILabel,color:UIColor)
    {
        lbl.layer.cornerRadius = lbl.frame.height / 2
        lbl.layer.masksToBounds = true
        lbl.backgroundColor = color
    }
    @objc func filterBtnClick(sender:UITapGestureRecognizer)
    {
//        filterView.isHidden = true
        let optionsController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        optionsController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        optionsController.view.tintColor = AppConstants.khudColour
        
        let subView: UIView? = optionsController.view.subviews.first
        let alertContentView: UIView? = subView?.subviews.first
        alertContentView?.backgroundColor = UIColor.white
        alertContentView?.layer.cornerRadius = 5
        optionsController.addAction(UIAlertAction(title: "Fully Booked", style: .default, handler: { (alertAction) in
            self.filterView.isHidden = false
            AppConstants.schedulefilteredStatus = 1
        }))
        optionsController.addAction(UIAlertAction(title: "Booking Inprogress", style: .default, handler: { (alertAction) in
            self.filterView.isHidden = false
            AppConstants.schedulefilteredStatus = 2
        }))
        optionsController.addAction(UIAlertAction(title: "No booking", style: .default, handler: { (alertAction) in
            self.filterView.isHidden = false
            AppConstants.schedulefilteredStatus = 3
        }))
        optionsController.addAction(UIAlertAction(title: "Slot not allocated", style: .default, handler: { (alertAction) in
            self.filterView.isHidden = false
            AppConstants.schedulefilteredStatus = 4
        }))
        optionsController.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (alertAction) in
            self.filterView.isHidden = true
            AppConstants.schedulefilteredStatus = 5
        }))
        
//        let senderView = sender
        optionsController.modalPresentationStyle = .popover
        
        let popPresenter: UIPopoverPresentationController? = optionsController.popoverPresentationController
        popPresenter?.sourceView = self.view
        popPresenter?.sourceRect = self.view.bounds
        DispatchQueue.main.async(execute: {
            //    self.hud.hide(animated: true)
            //[self.tableView reloadData];
            UIApplication.shared.topMostViewController()?.present(optionsController, animated: true)
        })
    }
    @objc func addScheduleBtnClick()
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Change Schedule", style: .default, handler: { _ in
           let addScheduleVC = self.storyboard?.instantiateViewController(withIdentifier: "addScheduleVC") as! AddScheduleViewController
            self.navigationController?.pushViewController(addScheduleVC, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Add VIP Schedule", style: .default, handler: { _ in
            let addVIPScheduleVC = self.storyboard?.instantiateViewController(withIdentifier: "addVIPScheduleVC") as! AddVIPScheduleViewController
            self.navigationController?.pushViewController(addVIPScheduleVC, animated: true)
        }))
        
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.barButtonItem = self.addBtn
            
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }
    @objc func editScheduleBtnClick()
    {
        
        let rescheduleVC = self.storyboard?.instantiateViewController(withIdentifier: "rescheduleVC") as! RescheduleViewController
        self.navigationController?.pushViewController(rescheduleVC, animated: true)
    }
    func searchFromArray(searchKey:String,searchString:String,array:NSMutableArray)
    {
        let predicate = NSPredicate(format: "\(searchKey) CONTAINS[C] %@", "\(searchString)" )
        let orPredi: NSPredicate? = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate])
        
        let arr = array.filtered(using: orPredi!)
//        print ("arr = \(arr)")
        //        imageStr = (array[0]as? [AnyHashable:Any])? ["FlagPng"] as? String ?? ""
    }
    //MARK:- Loading Schedule
    func loadingScheduleDetailsAPI()
    {
        var parameters = Dictionary<String, Any>()
        parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.scheduleDetailsAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.scheduleData = response
                if self.scheduleData?.status?.code == "0" {
                    AppConstants.resultDateArray = []
                    AppConstants.resultDateArray = NSMutableArray(array: self.scheduleData?.dateDict ?? [""])
                    print("first array \(AppConstants.resultDateArray[0])")
                    
                    self.searchFromArray(searchKey: "date", searchString: "2019-05-25", array: AppConstants.resultDateArray)
                    
                    self.scheduleTableView.reloadData()
                    self.addScheduleCell?.calendarView.reloadData()
                }
                else
                {
                    GenericMethods.showAlertwithPopNavigation(alertMessage: self.scheduleData?.status?.message ?? "Unable to fetch data. Please try again after sometime.", vc: self)
                }
            }
            else
            {
                GenericMethods.showAlertwithPopNavigation(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.", vc: self)
            }
        }
    }
    func selectedDateMethod(scheduleDate:Date)
    {
        print("selectedDateMethod\(scheduleDate)")
        let rescheduleVC = self.storyboard?.instantiateViewController(withIdentifier: "rescheduleVC") as! RescheduleViewController
        rescheduleVC.userSelectedDate = scheduleDate
        self.navigationController?.pushViewController(rescheduleVC, animated: true)
    }

    

}
extension ScheduleViewController:UITableViewDelegate,UITableViewDataSource
{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        addScheduleCell = tableView.dequeueReusableCell(withIdentifier: "addScheduleCell") as? AddScheduleTableViewCell
        if addScheduleCell == nil
        {
            addScheduleCell = AddScheduleTableViewCell(style: .default, reuseIdentifier: "addScheduleCell")
        }
        
        addScheduleCell?.delegate = self
        addScheduleCell?.clinicName.text = scheduleData?.clinicData?.clinicName ?? ""
        addScheduleCell?.clinicAddressLbl.text = scheduleData?.clinicData?.clinicAddress ?? ""
        addScheduleCell?.clinicAddressLbl.addImage(imageName: "location.png", afterLabel: false)
        
        addScheduleCell?.clinicImgView.layer.cornerRadius = (addScheduleCell!.clinicImgView.frame.size.height / 2)
        addScheduleCell?.clinicImgView.layer.borderWidth = 0.2
        
        addScheduleCell?.clinicImgView.clipsToBounds = true
        addScheduleCell?.clinicImgView.layer.masksToBounds = true
        addScheduleCell?.clinicImgView.layer.borderColor = UIColor.white.cgColor
        
        addScheduleCell?.clinicImgView.contentMode = .scaleAspectFit
        addScheduleCell?.clinicImgView.image = nil
        addScheduleCell?.clinicImgView.sd_setImage(with: URL(string: scheduleData?.clinicData?.clinicPicture ?? ""), placeholderImage: AppConstants.imgPlaceholder,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
            if error == nil
            {
                self.addScheduleCell?.clinicImgView.image = image
                
            }
            else{
                print("error is \(error?.localizedDescription as Any)")
                self.addScheduleCell?.clinicImgView.contentMode = .center
                self.addScheduleCell?.clinicImgView.image = AppConstants.imgPlaceholder
                
            }
            
            // Perform operation.
        })
        
        return addScheduleCell!
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 550.0
    }
}
