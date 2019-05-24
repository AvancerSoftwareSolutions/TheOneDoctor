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

class ScheduleViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var fullBookedLbl: UILabel!
    @IBOutlet weak var bookingInProgressLbl: UILabel!
    @IBOutlet weak var bookingYetStartLbl: UILabel!
    
    @IBOutlet weak var scheduleTableView: UITableView!
    
    //MARK:- Variables
    
    let todayDate = Date()
    let dateformatter = DateFormatter()
    var addScheduleCell:AddScheduleTableViewCell? = nil
    let apiManager = APIManager()
    var scheduleData:ScheduleModel?
    
    var resultDateDict:NSMutableDictionary = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Schedule"
        
        scheduleTableView.register(UINib(nibName: "AddScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: "addScheduleCell")
        
        roundLabel(lbl: fullBookedLbl, color: UIColor.red)
        roundLabel(lbl: bookingInProgressLbl, color: UIColor.yellow)
        roundLabel(lbl: bookingYetStartLbl, color: UIColor.white)
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addScheduleBtnClick))
        let editBtn = UIBarButtonItem(image: UIImage(named: "EditProfPic.png"), style: .plain, target: self, action: #selector(editScheduleBtnClick))
        let svgHoldingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        GenericMethods.setLeftViewWithSVG(svgView: svgHoldingView, with: "filter", color: UIColor.white)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(filterBtnClick))
        tapGesture.numberOfTapsRequired = 1
        svgHoldingView.addGestureRecognizer(tapGesture)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: svgHoldingView),editBtn,addBtn]
    
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func roundLabel(lbl:UILabel,color:UIColor)
    {
        lbl.layer.cornerRadius = lbl.frame.height / 2
        lbl.layer.masksToBounds = true
        lbl.backgroundColor = color
    }
    @objc func filterBtnClick()
    {
        
    }
    @objc func addScheduleBtnClick()
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Add New Schedule", style: .default, handler: { _ in
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
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = self.view.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
            
        default:
            break
        }
        self.present(alert, animated: true, completion: nil)
    }
    @objc func editScheduleBtnClick()
    {
        
    }
    
    //MARK:- Loading Schedule
    func loadingScheduleDetailsAPI()
    {
        var parameters = Dictionary<String, Any>()
        parameters["user_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.scheduleDetailsAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.scheduleData = response
                if self.scheduleData?.status?.code == "0" {
                    
                    
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
        
        
        return addScheduleCell!
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 550.0
    }
}
