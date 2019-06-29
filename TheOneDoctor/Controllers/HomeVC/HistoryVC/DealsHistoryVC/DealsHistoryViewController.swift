//
//  DealsHistoryViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class DealsHistoryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var dealsTableView: UITableView!
    
    
    // MARK: - Variables
    let apiManager = APIManager()
    var dealsHistoryData:DealsHistoryModel?
    let postDateFormatter = DateFormatter()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Deals History"
        
        self.dealsTableView.tableFooterView = UIView()
        postDateFormatter.dateFormat = AppConstants.postDateFormat
        loadingDealsHistoryListDetailsAPI()

        // Do any additional setup after loading the view.
    }
    
    func loadingDealsHistoryListDetailsAPI()
    {
        var parameters = Dictionary<String, Any>()
        parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.dealsHistoryAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.dealsHistoryData = response
                
                if self.dealsHistoryData?.status?.code == "0" {
                    //MARK: Advertisement History Success Details
                    
                    self.dealsTableView.reloadData()
                    
                }
                else
                {
                    GenericMethods.showAlert(alertMessage: self.dealsHistoryData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                }
                
            }
            else {
                GenericMethods.showAlert(alertMessage:error?.localizedDescription ?? "")
                
            }
        }
    }

}
extension DealsHistoryViewController:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dealsHistoryData != nil {
            return (self.dealsHistoryData?.dealsListData?.count) ?? 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dealsHistCell = tableView.dequeueReusableCell(withIdentifier: "dealsHistCell", for: indexPath) as? DealsHistoryTableViewCell
        
        dealsHistCell?.adtitleLbl.text = self.dealsHistoryData?.dealsListData?[indexPath.row].title
        dealsHistCell?.dateLbl.text = self.dealsHistoryData?.dealsListData?[indexPath.row].title
        dealsHistCell?.specialityLbl.text = self.dealsHistoryData?.dealsListData?[indexPath.row].name
        dealsHistCell?.priceLbl.text = "\(self.dealsHistoryData?.dealsListData?[indexPath.row].amount ?? "") \(self.dealsHistoryData?.dealsListData?[indexPath.row].currencyCode ?? "")"
        dealsHistCell?.discountLbl.text = "\(self.dealsHistoryData?.dealsListData?[indexPath.row].percentage ?? "") %"
        
        return dealsHistCell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 125
    }
    
}
