//
//  AdvertisementHistoryViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 27/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class AdvertisementHistoryViewController: UIViewController {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    let apiManager = APIManager()
    var advertisementHistoryData:AdvertisementHistoryModel?
    let postDateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Advertisement History"
        
        self.tableView.tableFooterView = UIView()
        postDateFormatter.dateFormat = AppConstants.postDateFormat
        loadingAdvertisementHistoryListDetailsAPI()

        // Do any additional setup after loading the view.
    }
    @objc func viewAdsClick(sender:UITapGestureRecognizer)
    {
        
        let touch = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: touch) {
            // Access the image or the cell at this index path
            let advtPreviewVC = self.storyboard?.instantiateViewController(withIdentifier: "advtPreviewVC") as! AdvertismentPreviewViewController
            self.navigationController?.definesPresentationContext = true
            advtPreviewVC.modalTransitionStyle = .crossDissolve
            advtPreviewVC.modalPresentationStyle = .overCurrentContext
            advtPreviewVC.adTypeId = self.advertisementHistoryData?.advtHistoryData?[indexPath.row].adTypeID ?? 0
            advtPreviewVC.advtContent = self.advertisementHistoryData?.advtHistoryData?[indexPath.row].comments ?? ""
            advtPreviewVC.imageStr = self.advertisementHistoryData?.advtHistoryData?[indexPath.row].picture ?? ""
            
            UIApplication.shared.topMostViewController()?.present(advtPreviewVC, animated: true)
        }
        
    }
    func loadingAdvertisementHistoryListDetailsAPI()
    {
        var parameters = Dictionary<String, Any>()
        parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.advertisementHistoryAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.advertisementHistoryData = response
                
                if self.advertisementHistoryData?.status?.code == "0" {
                    //MARK: Advertisement History Success Details
                    
                    self.tableView.reloadData()
                    
                }
                else
                {
                    GenericMethods.showAlert(alertMessage: self.advertisementHistoryData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                }
                
            }
            else {
                GenericMethods.showAlert(alertMessage:error?.localizedDescription ?? "")
                
            }
        }
    }

}
extension AdvertisementHistoryViewController:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.advertisementHistoryData != nil {
            return (self.advertisementHistoryData?.advtHistoryData?.count) ?? 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let advtHistCell = tableView.dequeueReusableCell(withIdentifier: "advtHistCell", for: indexPath) as? AdvertisementHistoryTableViewCell
        
        advtHistCell?.specialityName.text = self.advertisementHistoryData?.advtHistoryData?[indexPath.row].specialityName
        advtHistCell?.dateLbl.text = postDateFormatter.string(from: GenericMethods.convertStringToDate(dateString: self.advertisementHistoryData?.advtHistoryData?[indexPath.row].created_date ?? "",dateformat:AppConstants.defaultDateFormat))
        
        advtHistCell?.adTypeLbl.text = "Ads Type: \(self.advertisementHistoryData?.advtHistoryData?[indexPath.row].typename ?? "")"
        
        let from = self.advertisementHistoryData?.advtHistoryData?[indexPath.row].fromdate ?? ""
        let to = self.advertisementHistoryData?.advtHistoryData?[indexPath.row].todate ?? ""
        advtHistCell?.fromLbl.text = ""
        advtHistCell?.toLbl.text = ""
        if from == to
        {
            advtHistCell?.fromLbl.text = "Date: \(from)"
        }
        else
        {
            advtHistCell?.fromLbl.text = "From \n\(from)"
            advtHistCell?.toLbl.text = "To \n\(to)"
        }
        let status = self.advertisementHistoryData?.advtHistoryData?[indexPath.row].status ?? ""
        advtHistCell?.statusLbl.text = self.advertisementHistoryData?.advtHistoryData?[indexPath.row].status
        if status == "Active"
        {
            advtHistCell?.statusLbl.textColor = AppConstants.appGreenColor
        }
        else if status == "Inactive"
        {
            advtHistCell?.statusLbl.textColor = UIColor.red
        }
        if !GenericMethods.isStringEmpty(self.advertisementHistoryData?.advtHistoryData?[indexPath.row].price ?? "")
        {
            advtHistCell?.priceLbl.text = "\(self.advertisementHistoryData?.advtHistoryData?[indexPath.row].price ?? "") \(self.advertisementHistoryData?.advtHistoryData?[indexPath.row].currency_code ?? "")"
        }
        else
        {
            advtHistCell?.priceLbl.text = ""
        }
        advtHistCell?.viewAdsLbl.tag = indexPath.row
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewAdsClick(sender:)))
        advtHistCell?.viewAdsLbl.addGestureRecognizer(tapGesture)
        advtHistCell?.viewAdsLbl.text = "View Ads"
        advtHistCell?.viewAdsLbl.addImage(imageName: "viewads.png", afterLabel: true)
        
        return advtHistCell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 155
    }
    
}
