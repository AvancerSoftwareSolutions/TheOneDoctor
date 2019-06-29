//
//  HistoryListTableViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 22/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class HistoryListTableViewController: UITableViewController {
    
    // MARK: - Variables
    var historyListArray:NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "History"

        historyListArray = ["Schedule History","Referral History","Advertisement History","Deals History"]
        tableView.tableFooterView = UIView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historyListArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let historyListCell = tableView.dequeueReusableCell(withIdentifier: "historyListCell", for: indexPath)

        historyListCell.textLabel?.text = historyListArray[indexPath.row] as? String ?? ""

        return historyListCell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let scheduleHistVC = self.storyboard?.instantiateViewController(withIdentifier: "scheduleHistVC") as! ScheduleHistoryViewController
            self.navigationController?.pushViewController(scheduleHistVC, animated: true)
        case 1:
            let referralVC = self.storyboard?.instantiateViewController(withIdentifier: "referralVC") as! ReferralHistoryViewController
            self.navigationController?.pushViewController(referralVC, animated: true)
        case 2:
            let advtHistoryVC = self.storyboard?.instantiateViewController(withIdentifier: "advtHistoryVC") as! AdvertisementHistoryViewController
            self.navigationController?.pushViewController(advtHistoryVC, animated: true)
        case 3:
            let dealsHistoryVC = self.storyboard?.instantiateViewController(withIdentifier: "dealsHistoryVC") as! DealsHistoryViewController
            self.navigationController?.pushViewController(dealsHistoryVC, animated: true)
        default:
            break
        }
    }
    

}
