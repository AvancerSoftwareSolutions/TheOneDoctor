//
//  RescheduleViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class RescheduleViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var rescheduleTableView: UITableView!
    
    
    //MARK:- Variables
    var rescheduleCell:RescheduleTableViewCell? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rescheduleTableView.tableFooterView = UIView()
        

        // Do any additional setup after loading the view.
    }
    

}
extension RescheduleViewController:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        rescheduleCell = tableView.dequeueReusableCell(withIdentifier: "rescheduleCell") as? RescheduleTableViewCell
        if rescheduleCell == nil
        {
            rescheduleCell = RescheduleTableViewCell(style: .default, reuseIdentifier: "rescheduleCell")
        }
        
        return rescheduleCell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
