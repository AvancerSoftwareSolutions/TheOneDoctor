//
//  DoctorListViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 19/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class DoctorListViewController: UIViewController {
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var doctorListTableView: UITableView!
    // MARK: - Variables
    var doctorListCell:DoctorListTableViewCell? = nil
    var doctorListData:DoctorListModel?
    var referSuccessData:SendOTPModel?
    var filterListArray:NSMutableArray = []
    let apiManager = APIManager()
    var appointmentId:String?
    var searching = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Doctors"
        
        loadingDoctorListDetailsAPI()

        // Do any additional setup after loading the view.
    }
    @objc func referBtnClick(sender:UIButton)
    {
        /* {"doctor_id":"4","appointment_id":"HMSC1A189","Refer_doctor_id":"6"}*/
        var parameters = Dictionary<String, Any>()
        parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        parameters["appointment_id"] = appointmentId
        if searching
        {
            parameters["Refer_doctor_id"] = (self.filterListArray[sender.tag] as? [AnyHashable:Any])? ["user_id"] ?? ""
        }
        else
        {
           parameters["Refer_doctor_id"] = self.doctorListData?.doctorList?[sender.tag].userId ?? 0
        }
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.referDoctorAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.referSuccessData = response
                
                if self.referSuccessData?.status?.code == "0" {
                    //MARK: Refer Success Details
                    
                    GenericMethods.showAlertwithPopNavigation(alertMessage: self.referSuccessData?.status?.message ?? "Success", vc: self)
                    
                }
                else
                {
                    GenericMethods.showAlert(alertMessage: self.referSuccessData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                }
                
            }
            else {
                GenericMethods.showAlert(alertMessage:error?.localizedDescription ?? "")
                
            }
        }
    }
    
    func loadingDoctorListDetailsAPI()
    {
        var parameters = Dictionary<String, Any>()
        parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.doctorListAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.doctorListData = response
                
                if self.doctorListData?.status?.code == "0" {
                    //MARK: Dashboard Success Details
                    
                    self.doctorListTableView.reloadData()
                    
                }
                else
                {
                    GenericMethods.showAlert(alertMessage: self.doctorListData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                }
                
            }
            else {
                GenericMethods.showAlert(alertMessage:error?.localizedDescription ?? "")
                
            }
        }
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
extension DoctorListViewController:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching
        {
            return filterListArray.count
        }
        else
        {
            if self.doctorListData != nil {
                return (self.doctorListData?.doctorList?.count) ?? 0
            }
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        doctorListCell = (tableView.dequeueReusableCell(withIdentifier: "doctorListCell", for: indexPath) as! DoctorListTableViewCell)
        
        if doctorListCell == nil
        {
            doctorListCell = DoctorListTableViewCell(style: .default, reuseIdentifier: "doctorListCell")
        }
        if searching
        {
            
            
            doctorListCell?.doctorNameLbl.text = "Dr. \((self.filterListArray[indexPath.row] as? [AnyHashable:Any])? ["firstname"] ?? "") \((self.filterListArray[indexPath.row] as? [AnyHashable:Any])? ["lastname"] ?? "")"
            doctorListCell?.doctorSpecialityLbl.text = (self.filterListArray[indexPath.row] as? [AnyHashable:Any])?  ["specialityname"] as? String ?? ""
            doctorListCell?.feesLbl.text = "\((self.filterListArray[indexPath.row] as? [AnyHashable:Any])? ["AppointmentFees"] ?? "") KWD"
            doctorListCell?.clinicNameLbl.text = "\((self.filterListArray[indexPath.row] as? [AnyHashable:Any])? ["clinicname"] ?? "") (30.0 KM)"
            doctorListCell?.clinicAddressLbl.text = (self.filterListArray[indexPath.row] as? [AnyHashable:Any])?  ["clinicaddress"] as? String ?? ""
            doctorListCell?.nextAvailableLbl.text = (self.filterListArray[indexPath.row] as? [AnyHashable:Any])?  ["ScheduleMsg"] as? String ?? ""
            doctorListCell?.referBtnInstance.tag = indexPath.row
            doctorListCell?.referBtnInstance.addTarget(self, action: #selector(referBtnClick(sender:)), for: .touchUpInside)
            //        doctorListCell?.referBtn
            doctorListCell?.doctorImgView.contentMode = .scaleAspectFit
            doctorListCell?.doctorImgView.sd_setShowActivityIndicatorView(true)
            doctorListCell?.doctorImgView.sd_setIndicatorStyle(.gray)
            doctorListCell?.doctorImgView.image = nil
            doctorListCell?.doctorImgView.sd_setImage(with: URL(string: (self.filterListArray[indexPath.row] as? [AnyHashable:Any])?  ["profile"] as? String ?? ""), placeholderImage: AppConstants.docImgListplaceHolderImg,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                
                if error == nil
                {
                    self.doctorListCell?.doctorImgView.image = image
                    
                }
                else{
                    print("error is \(error?.localizedDescription as Any)")
                    self.doctorListCell?.doctorImgView.image = nil
                }
                
                
            })
        }
        else
        {
            doctorListCell?.doctorNameLbl.text = "Dr. \(self.doctorListData?.doctorList?[indexPath.row].firstname ?? "") \(self.doctorListData?.doctorList?[indexPath.row].lastname ?? "")"
            doctorListCell?.doctorSpecialityLbl.text = self.doctorListData?.doctorList?[indexPath.row].specialityName
            doctorListCell?.feesLbl.text = "\(self.doctorListData?.doctorList?[indexPath.row].appointmentFees ?? "") KWD"
            doctorListCell?.clinicNameLbl.text = "\(self.doctorListData?.doctorList?[indexPath.row].clinicName ?? "") (30.0 KM)"
            doctorListCell?.clinicAddressLbl.text = self.doctorListData?.doctorList?[indexPath.row].clinicAddress
            doctorListCell?.nextAvailableLbl.text = self.doctorListData?.doctorList?[indexPath.row].scheduleMsg
            doctorListCell?.referBtnInstance.tag = indexPath.row
            doctorListCell?.referBtnInstance.addTarget(self, action: #selector(referBtnClick(sender:)), for: .touchUpInside)
            //        doctorListCell?.referBtn
            doctorListCell?.doctorImgView.contentMode = .scaleAspectFit
            doctorListCell?.doctorImgView.sd_setShowActivityIndicatorView(true)
            doctorListCell?.doctorImgView.sd_setIndicatorStyle(.gray)
            doctorListCell?.doctorImgView.image = nil
            doctorListCell?.doctorImgView.sd_setImage(with: URL(string: self.doctorListData?.doctorList?[indexPath.row].picture ?? ""), placeholderImage: AppConstants.docImgListplaceHolderImg,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                
                if error == nil
                {
                    self.doctorListCell?.doctorImgView.image = image
                    
                }
                else{
                    print("error is \(error?.localizedDescription as Any)")
                    self.doctorListCell?.doctorImgView.image = nil
                }
                
                
            })
        }
        
        return doctorListCell!
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153.5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //103.5 + 21 +21
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
extension DoctorListViewController:UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
        

        
        let arr:NSMutableArray = NSMutableArray(array: self.doctorListData?.doctorList?.toJSON() ?? [])
        
        filterListArray = NSMutableArray(array: self.searchFromArray(searchKey: "firstname", searchString: searchText, array: arr))
        print("resultArr \(filterListArray)")
        doctorListTableView.reloadData()
        
        
        

//        doctorListTableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.text = ""
        searching = false
        doctorListTableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.text = ""
        searching = false
//        doctorListTableView.reloadData()
    }
}
