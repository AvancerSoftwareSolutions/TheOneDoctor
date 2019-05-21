//
//  SpecialityListViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 09/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
protocol sendSpecialityListValuesDelegate {
    func sendSpecialityListValues(selectedListArray:NSMutableArray,type:Int)
}

class SpecialityListViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeBtnInst: UIButton!
    @IBOutlet weak var specialityLbl: UILabel!
    
    @IBOutlet weak var popUpHgtConst: NSLayoutConstraint!
    @IBOutlet weak var doneBtnInst: UIButton!
    //MARK:- Variables
    var specialityCell:SpecialityTableViewCell? = nil
    var addSpecialityData:AddSpecialityModel?
    var type:Int = 0
    var selectedSpecialityListArray:NSMutableArray = []
    
    var delegate:sendSpecialityListValuesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneBtnInst.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        tableView.tableFooterView = UIView()
        popupView.layer.cornerRadius = 10.0
        popupView.layer.masksToBounds = true
        tableView.layer.addBorder(edge: UIRectEdge.top, color: UIColor.darkGray, thickness: 1.0)
        doneBtnInst.layer.cornerRadius = 5.0
        doneBtnInst.layer.masksToBounds = true
        if type == 0
        {
            specialityLbl.text = "Select Speciality"
        }
        else
        {
            specialityLbl.text = "Select SubSpeciality"
        }
        
//        popUpHgtConst.constant = self.view.bounds.height - 100

        // Do any additional setup after loading the view.
    }
    

    @objc func addSpecialityBtnCLick(sender:UIButton)
    {
        
    }
    func showDoneBtn()
    {
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.closeBtnInst.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        },
                       completion: { _ in
                        
                        
                        UIView.animate(withDuration: 0.4) {
                            self.closeBtnInst.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                            self.doneBtnInst.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                            self.doneBtnInst.transform = CGAffineTransform.identity
                        }
        })
    }
    func showCloseBtn()
    {
        UIView.animate(withDuration: 0.4,
                       animations: {
                        self.doneBtnInst.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        },
                       completion: { _ in
                        
                        
                        UIView.animate(withDuration: 0.4) {
                            self.doneBtnInst.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                            self.closeBtnInst.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                            self.closeBtnInst.transform = CGAffineTransform.identity
                        }
        })

    }
    
    func removeDictFromArray(searchString:String)
    {
        
        let predicate = NSPredicate(format: "id contains[cd] %@", searchString)
        // change it to "coupon_code == @" for checking equality.
        
        let indexes = selectedSpecialityListArray.indexesOfObjects(options: []) { (dictionary, index, stop) -> Bool in
            return predicate.evaluate(with: dictionary)
        }
        selectedSpecialityListArray.removeObjects(at: indexes)
    }
    // MARK: - IBActions
    
    @IBAction func closeBtnClick(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func doneBtnClick(_ sender: Any) {
        self.delegate?.sendSpecialityListValues(selectedListArray: selectedSpecialityListArray, type: type)
        self.dismiss(animated: true, completion: nil)
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
extension SpecialityListViewController:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.addSpecialityData != nil {
            if type == 0
            {
               return (self.addSpecialityData?.specialityData?.count) ?? 0
            }
            else
            {
                return (self.addSpecialityData?.subSpecialityData?.count) ?? 0
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        specialityCell = tableView.dequeueReusableCell(withIdentifier: "specialityCell") as? SpecialityTableViewCell
        if specialityCell == nil
        {
            specialityCell = SpecialityTableViewCell(style: .default, reuseIdentifier: "specialityCell")
        }
        specialityCell?.addBtnInstance.tag = indexPath.row
        specialityCell?.addBtnInstance.addTarget(self, action: #selector(addSpecialityBtnCLick(sender:)), for: .touchUpInside)
        if type == 0
        {
            specialityCell?.specialityNameLbl.text = self.addSpecialityData?.specialityData?[indexPath.row].name
        }
        else
        {
            specialityCell?.specialityNameLbl.text = self.addSpecialityData?.subSpecialityData?[indexPath.row].subSpecialityname
        }
        
        return specialityCell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) as? SpecialityTableViewCell {
            
            if cell.addBtnInstance.isSelected
            {
                cell.addBtnInstance.isSelected = false
                cell.addBtnInstance.setImage(UIImage(named: "AddSpeciality"), for: .normal)
                
                if type == 0
                {
                    self.removeDictFromArray(searchString: addSpecialityData?.specialityData?[indexPath.row].id ?? "")
//                    let searchString = addSpecialityData?.specialityData?[indexPath.row].id!
//                    let predicate = NSPredicate(format: "id contains[cd] %@", searchString!)
//                    // change it to "coupon_code == @" for checking equality.
//
//                    let indexes = selectedSpecialityListArray.indexesOfObjects(options: []) { (dictionary, index, stop) -> Bool in
//                        return predicate.evaluate(with: dictionary)
//                    }
//                    selectedSpecialityListArray.removeObjects(at: indexes)
                    
                }
                else
                {
                    self.removeDictFromArray(searchString: addSpecialityData?.subSpecialityData?[indexPath.row].subSpecialityId ?? "")
//                    let searchString = addSpecialityData?.subSpecialityData?[indexPath.row].id!
//                    let predicate = NSPredicate(format: "id contains[cd] %@", searchString!)
//                    // change it to "coupon_code == @" for checking equality.
//                    
//                    let indexes = selectedSpecialityListArray.indexesOfObjects(options: []) { (dictionary, index, stop) -> Bool in
//                        return predicate.evaluate(with: dictionary)
//                    }
//                    selectedSpecialityListArray.removeObjects(at: indexes)
                    
                }
                if selectedSpecialityListArray.count == 0
                {
                    showCloseBtn()
                }
            }
            else
            {
                cell.addBtnInstance.setImage(UIImage(named: "RemoveSpeciality"), for: .normal)
                cell.addBtnInstance.isSelected = true
                if selectedSpecialityListArray.count == 0
                {
                    showDoneBtn()
                }
                if type == 0
                {
                    var mutableDictionary:[String:Any] = [:]
                    mutableDictionary.add(["id" : addSpecialityData?.specialityData?[indexPath.row].id ?? ""])
                    mutableDictionary.add(["name" : addSpecialityData?.specialityData?[indexPath.row].name ?? ""])
                    self.selectedSpecialityListArray.add(mutableDictionary)
                    
                }
                else
                {
                    var mutableDictionary:[String:Any] = [:]
                    mutableDictionary.add(["subspeciality_id" : addSpecialityData?.subSpecialityData?[indexPath.row].subSpecialityId ?? ""])
                    mutableDictionary.add(["subspecialityname" : addSpecialityData?.subSpecialityData?[indexPath.row].subSpecialityname ?? ""])
                    mutableDictionary.add(["speciality_id" : addSpecialityData?.subSpecialityData?[indexPath.row].speciality_id ?? ""])
                    self.selectedSpecialityListArray.add(mutableDictionary)
                    
                }
            }
            print("\(selectedSpecialityListArray)")
//            if cell.addBtnInstance.currentImage == UIImage(named: "AddSpeciality")
//            {
//                cell.addBtnInstance.setImage(UIImage(named: "RemoveSpeciality"), for: .normal)
//            }
//            else
//            {
//                cell.addBtnInstance.setImage(UIImage(named: "AddSpeciality"), for: .normal)
//            }
        }
    }
}
