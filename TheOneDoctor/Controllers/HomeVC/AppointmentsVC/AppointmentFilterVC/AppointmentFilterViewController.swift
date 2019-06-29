//
//  AppointmentFilterViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 25/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
protocol sendAppointmentsFilterValuesDelegate {
    func sendAppointmentsFilterValues(age: String, appointments: String, clinic: String)
}
class AppointmentFilterViewController: UIViewController {

    @IBOutlet weak var scrollViewInstance: UIScrollView!
    @IBOutlet weak var ageCollectionView: UICollectionView!
    @IBOutlet weak var appointmentCollectionView: UICollectionView!
    @IBOutlet weak var clinicListTableView: UITableView!
    @IBOutlet weak var clinicTVHgtConst: NSLayoutConstraint! //100
    
    @IBOutlet weak var submitBntInstance: UIButton!
    
    var appointmentsListData:AppointmentsModel?
    var appointFilterDelegate:sendAppointmentsFilterValuesDelegate?
    var appointfilterCell:AppointmentFilterCollectionViewCell? = nil
//    var clinicListCell:AppointmentTableViewCell? = nil
    var clinicListCell:SlotsTableViewCell? = nil
    var ageArray:NSMutableArray = []
    var appointmentArray:NSMutableArray = []
    var clinicArray:NSMutableArray = []
    var age = ""
    var appointment = ""
    var clinic = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        resetArray(type: "age")
        resetArray(type: "appoint")
        resetArray(type: "clinic")
        
        self.title = "Filter"
        
        GenericMethods.setButtonAttributes(button: submitBntInstance, with: "Submit")
        
        let closeBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        
        self.ageCollectionView.register(UINib(nibName: "AppointmentFilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "appointfilterCell")
        
        self.appointmentCollectionView.register(UINib(nibName: "AppointmentFilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "appointfilterCell")
        
        self.clinicListTableView.register(UINib(nibName: "SlotsTableViewCell", bundle: nil), forCellReuseIdentifier: "slotsCell")
        
        let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetFilterMethod))
        self.navigationItem.rightBarButtonItems = [closeBtn,refreshBtn]
        
        clinicListTableView.tableFooterView = UIView()
        let hgt = ((self.appointmentsListData?.filterData?[0].clinicList?.count ?? 0) * 45) + ((self.appointmentsListData?.filterData?[0].clinicList?.count ?? 0) * 10)
        clinicTVHgtConst.constant = CGFloat(hgt)
        print("clinicTVHgtConst \(hgt)")
        
        
        viewload()
        
//        let count = (self.appointmentsListData?.filterData?[0].clinicList?.count)!
//        let hgt = count * 45

        // Do any additional setup after loading the view.
    }
    func viewload()
    {
        if GenericMethods.isStringEmpty("age")
        {
            resetArray(type: "age")
        }
        else
        {
            resetArray(type: "age")
            let index = appointmentsListData?.filterData?[0].age?.firstIndex(of: age)
            print(index as Any)
//            ageArray.replaceObject(at: index!, with: 1)
            
        }
        if GenericMethods.isStringEmpty("appoint")
        {
            
        }
        if GenericMethods.isStringEmpty("clinic")
        {
            
        }
        
        
    }
    func searchFromArray(searchKey:String,searchString:String,array:NSMutableArray)
    {
        let predicate = NSPredicate(format: "\(searchKey) CONTAINS[C] %@", "\(searchString)" )
        let orPredi: NSPredicate? = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate])
        
        let arr = array.filtered(using: orPredi!)
        print ("arr = \(arr)")
        //        imageStr = (array[0]as? [AnyHashable:Any])? ["FlagPng"] as? String ?? ""
    }
    func resetArray(type:String)
    {
        switch type {
        case "age":
            ageArray = []
            for _ in 0..<(self.appointmentsListData?.filterData?[0].age?.count)!
            {
                self.ageArray.add(0)
            }
            print("arr is \(ageArray)")
        case "appoint":
            appointmentArray = []
            for _ in 0..<(self.appointmentsListData?.filterData?[0].appointments?.count)!
            {
                self.appointmentArray.add(0)
            }
            print("arr is \(appointmentArray)")
        case "clinic":
            clinicArray = []
            for _ in 0..<(self.appointmentsListData?.filterData?[0].clinicList?.count)!
            {
                self.clinicArray.add(0)
            }
            print("arr is \(clinicArray)")
        default:
            break
        }
        
    }
    @objc func dismissVC()
    {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func resetFilterMethod()
    {
        resetArray(type: "age")
        resetArray(type: "appoint")
        resetArray(type: "clinic")
        age = ""
        appointment = ""
        clinic = ""
        
    }
    
    override func viewDidLayoutSubviews() {
        scrollViewInstance.contentSize = CGSize(width: scrollViewInstance.frame.width, height: clinicListTableView.frame.origin.y+clinicListTableView.frame.height+10)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewInstance.contentOffset = CGPoint(x: 0, y: scrollViewInstance.contentOffset.y)
    }
    @objc func agebtnClick(sender:UIButton)
    {
        if ageArray.object(at: sender.tag) as! Int  == 1
        {
            resetArray(type: "age")
            age = ""
        }
        else
        {
            resetArray(type: "age")
            
            ageArray.replaceObject(at: sender.tag, with: 1)
            age = self.appointmentsListData?.filterData?[0].age?[sender.tag] ?? ""
            print("age \(age)")
        }

        print("arr is \(ageArray)")
        self.ageCollectionView.reloadData()
    }
    @objc func appointmentbtnClick(sender:UIButton)
    {
        if appointmentArray.object(at: sender.tag) as! Int  == 1
        {
            resetArray(type: "appoint")
            appointment = ""
        }
        else
        {
            appointmentArray.replaceObject(at: sender.tag, with: 1)
            appointment = self.appointmentsListData?.filterData?[0].appointments?[sender.tag] ?? ""
            print("appointment \(appointment)")
        }

        print("arr is \(appointmentArray)")
        self.appointmentCollectionView.reloadData()
    }
    @objc func clinicbtnClick(sender:UIButton)
    {
        
        if clinicArray.object(at: sender.tag) as! Int  == 1
        {
            resetArray(type: "clinic")
            clinic = ""
        }
        else
        {
            clinicArray.replaceObject(at: sender.tag, with: 1)
            clinic = "\(self.appointmentsListData?.filterData?[0].clinicList?[sender.tag].clinicId ?? 0)"
            print("clinic \(clinic)")
        }

        print("arr is \(clinicArray)")
        self.clinicListTableView.reloadData()
    }

    @IBAction func submitBtnClick(_ sender: Any) {
        
        self.dismiss(animated: true, completion: {
            self.appointFilterDelegate?.sendAppointmentsFilterValues(age: self.age, appointments: self.appointment, clinic: self.clinic)
        })
        
    }
    
}
extension AppointmentFilterViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case self.ageCollectionView:
            if self.appointmentsListData != nil {
                return self.appointmentsListData?.filterData?[0].age?.count ?? 0
            }
            return 0
        case self.appointmentCollectionView:
            if self.appointmentsListData != nil {
                return self.appointmentsListData?.filterData?[0].appointments?.count ?? 0
            }
            return 0
        
        default:
            break
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        appointfilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "appointfilterCell", for: indexPath) as? AppointmentFilterCollectionViewCell
        switch collectionView {
        case self.ageCollectionView:
            
            appointfilterCell?.textBtn.setTitle("\(self.appointmentsListData?.filterData?[0].age?[indexPath.row] ?? "") yrs", for: .normal)
            appointfilterCell?.textBtn.layer.borderColor = AppConstants.appGreenColor.cgColor
            appointfilterCell?.textBtn.tag = indexPath.item
            appointfilterCell?.textBtn.addTarget(self, action: #selector(agebtnClick(sender:)), for: .touchUpInside)
            
            if ageArray[indexPath.row] as! Int == 0
            {
                appointfilterCell?.textBtn.setTitleColor(AppConstants.appGreenColor, for: .normal)
                appointfilterCell?.textBtn.backgroundColor = UIColor.white
            }
            else
            {
                appointfilterCell?.textBtn.setTitleColor(UIColor.white, for: .normal)
                appointfilterCell?.textBtn.backgroundColor = AppConstants.appGreenColor
            }

            
        case self.appointmentCollectionView:
            
            appointfilterCell?.textBtn.setTitle("\(self.appointmentsListData?.filterData?[0].appointments?[indexPath.row] ?? "")", for: .normal)
            appointfilterCell?.textBtn.layer.borderColor = AppConstants.appGreenColor.cgColor
            appointfilterCell?.textBtn.tag = indexPath.item
            appointfilterCell?.textBtn.addTarget(self, action: #selector(appointmentbtnClick(sender:)), for: .touchUpInside)
            
            if appointmentArray[indexPath.row] as! Int == 0
            {
                appointfilterCell?.textBtn.setTitleColor(AppConstants.appGreenColor, for: .normal)
                appointfilterCell?.textBtn.backgroundColor = UIColor.white
            }
            else
            {
                appointfilterCell?.textBtn.setTitleColor(UIColor.white, for: .normal)
                appointfilterCell?.textBtn.backgroundColor = AppConstants.appGreenColor
            }
            
        default:
            break
        }
        return appointfilterCell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let cellSize:CGFloat = collectionView.frame.size.width - 20
        return CGSize(width: cellSize / 2, height: 45)
    }
}
extension AppointmentFilterViewController:UITableViewDelegate,UITableViewDataSource
{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.appointmentsListData != nil {
            return self.appointmentsListData?.filterData?[0].clinicList?.count ?? 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        clinicListCell = tableView.dequeueReusableCell(withIdentifier: "slotsCell") as? SlotsTableViewCell
        if clinicListCell == nil
        {
            clinicListCell = SlotsTableViewCell(style: .default, reuseIdentifier: "slotsCell")
        }
        clinicListCell?.titleBtnInstance.layer.borderColor = AppConstants.appGreenColor.cgColor
        clinicListCell?.titleBtnInstance.tag = indexPath.item
        clinicListCell?.titleBtnInstance.addTarget(self, action: #selector(clinicbtnClick(sender:)), for: .touchUpInside)
        
        clinicListCell?.titleBtnInstance.setTitle("\(self.appointmentsListData?.filterData?[0].clinicList?[indexPath.row].clinicName ?? "")", for: .normal)
        
        if clinicArray[indexPath.row] as! Int == 0
        {
            clinicListCell?.titleBtnInstance.setTitleColor(AppConstants.appGreenColor, for: .normal)
            clinicListCell?.titleBtnInstance.backgroundColor = UIColor.white
        }
        else
        {
            clinicListCell?.titleBtnInstance.setTitleColor(UIColor.white, for: .normal)
            clinicListCell?.titleBtnInstance.backgroundColor = AppConstants.appGreenColor
        }
        return clinicListCell!
        
//        clinicListCell = tableView.dequeueReusableCell(withIdentifier: "clinicListCell") as? AppointmentTableViewCell
//        if clinicListCell == nil
//        {
//            clinicListCell = AppointmentTableViewCell(style: .default, reuseIdentifier: "clinicListCell")
//        }
//        clinicListCell?.clinicNameBtn.layer.borderColor = AppConstants.appGreenColor.cgColor
//        clinicListCell?.clinicNameBtn.tag = indexPath.item
//        clinicListCell?.clinicNameBtn.addTarget(self, action: #selector(clinicbtnClick(sender:)), for: .touchUpInside)
//
//        clinicListCell?.clinicNameBtn.setTitle("\(self.appointmentsListData?.filterData?[0].clinicList?[indexPath.row].clinicName ?? "")", for: .normal)
//
//        if clinicArray[indexPath.row] as! Int == 0
//        {
//            clinicListCell?.clinicNameBtn.setTitleColor(AppConstants.appGreenColor, for: .normal)
//            clinicListCell?.clinicNameBtn.backgroundColor = UIColor.white
//        }
//        else
//        {
//            clinicListCell?.clinicNameBtn.setTitleColor(UIColor.white, for: .normal)
//            clinicListCell?.clinicNameBtn.backgroundColor = AppConstants.appGreenColor
//        }
//        return clinicListCell!
        
    }
    
}
