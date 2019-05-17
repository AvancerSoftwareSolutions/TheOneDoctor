//
//  AppointmentsViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 16/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class AppointmentsViewController: UIViewController,sendAppointmentsFilterValuesDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var appointmentsTableView: UITableView!
    @IBOutlet weak var monthDayView: UIView!
    @IBOutlet weak var monthDayLbl: UILabel!
    @IBOutlet weak var previousMonthBtnInst: UIButton!
    @IBOutlet weak var nextMonthBtnInst: UIButton!
    @IBOutlet weak var montchangeView: UIView!
    
    
    
    
    var appointmentsArray:NSMutableArray = []
    var appointmentsCell:AppointmentsTableViewCell? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        
        // Do any additional setup after loading the view.
    }
    @objc func filterBtnClick()
    {
        print("filterBtnClick")
        // appointFilterVC
        let appointFilterVC = self.storyboard?.instantiateViewController(withIdentifier: "appointFilterVC") as! AppointmentsFilterViewController
        self.navigationController?.present(appointFilterVC, animated: true, completion: nil)
        
    }
    func sendAppointmentsFilterValues(age: String, appointments: String, clinic: String) {
        print("\(age) \(appointments) \(clinic)")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func semiRound(label:UILabel)
    {
//        let circlePath = UIBezierPath.init(arcCenter: CGPoint(x: label.bounds.size.width / 2, y: 0), radius: label.bounds.size.height, startAngle: 0.0, endAngle: .pi, clockwise: true)
//        let circleShape = CAShapeLayer()
//        circleShape.path = circlePath.cgPath
//        label.layer.mask = circleShape
        
        let circlePath = UIBezierPath.init(arcCenter: CGPoint(x: label.bounds.size.width / 2, y: label.bounds.size.height / 2), radius: label.bounds.size.width / 2, startAngle: CGFloat(270.0).toRadians, endAngle: CGFloat(90.0).toRadians, clockwise: false)
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        label.layer.mask = circleShape
    }
    
    //MARK:- IBActions
    
    @IBAction func previousMonthBtnClick(_ sender: Any) {
        
    }
    @IBAction func nextMonthBtnClick(_ sender: Any) {
        
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
//        return appointmentsArray.count
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        appointmentsCell = (tableView.dequeueReusableCell(withIdentifier: "appointmentsCell", for: indexPath) as! AppointmentsTableViewCell)
        
        if appointmentsCell == nil
        {
            appointmentsCell = AppointmentsTableViewCell(style: .default, reuseIdentifier: "appointmentsCell")
        }
        appointmentsCell?.bgView.layer.cornerRadius = 5.0
        appointmentsCell?.bgView.layer.masksToBounds = true
        semiRound(label: appointmentsCell!.userTypeLbl)
        appointmentsCell?.userTypeWdtConst.constant = (appointmentsCell?.userTypeLbl.bounds.size.height)! / 2
        
        
        
        // Configure the cell...
        
        return appointmentsCell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}
