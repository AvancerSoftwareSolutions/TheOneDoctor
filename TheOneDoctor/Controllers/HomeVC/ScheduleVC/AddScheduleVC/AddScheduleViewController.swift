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

    
    //MARK:- Vairables
    var addNormalScheduleCell:AddNormalScheduleTVC? = nil
    var fromTime = ""
    var toTime = ""
    var patientHrs = ""
    var weekDays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Schedule"
        
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addScheduleBtnMethod))
        tapGesture.numberOfTapsRequired = 1
        label.addGestureRecognizer(tapGesture)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: label)
        
        
        

        // Do any additional setup after loading the view.
    }
    
    @objc func addScheduleBtnMethod()
    {
        
    }
    @objc func fromTimeBtnMethod(btn:UIButton)
    {
        
    }
    @objc func toTimeBtnMethod(btn:UIButton)
    {
        
    }
    @objc func patientHrsBtnMethod(btn:UIButton)
    {
        
    }
    


}
extension AddScheduleViewController:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weekDays.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        addNormalScheduleCell = tableView.dequeueReusableCell(withIdentifier: "addNormalScheduleCell") as? AddNormalScheduleTVC
        if addNormalScheduleCell == nil
        {
            addNormalScheduleCell = AddNormalScheduleTVC(style: .default, reuseIdentifier: "addNormalScheduleCell")
        }
        
        addNormalScheduleCell?.weekDayLabel.text = weekDays[indexPath.row]
       
       addNormalScheduleCell?.fromTimeBtnInstance.tag = indexPath.row
        addNormalScheduleCell?.fromTimeBtnInstance.addTarget(self, action: #selector(fromTimeBtnMethod(btn:)), for: .touchUpInside)
        addNormalScheduleCell?.toTimeBtnInstance.tag = indexPath.row
        addNormalScheduleCell?.toTimeBtnInstance.addTarget(self, action: #selector(toTimeBtnMethod(btn:)), for: .touchUpInside)
        addNormalScheduleCell?.patientHrsBtnInstance.tag = indexPath.row
        addNormalScheduleCell?.patientHrsBtnInstance.addTarget(self, action: #selector(patientHrsBtnMethod(btn:)), for: .touchUpInside)
        
        return addNormalScheduleCell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
