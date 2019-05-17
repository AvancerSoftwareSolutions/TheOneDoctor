//
//  AppointmentsFilterViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 16/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
protocol sendAppointmentsFilterValuesDelegate {
    func sendAppointmentsFilterValues(age:String,appointments:String,clinic:String)
}

class AppointmentsFilterViewController: UIViewController {
    
    var appointFilterDelegate:sendAppointmentsFilterValuesDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeBtn = UIBarButtonItem(image: UIImage(named: "Close"), style: .plain, target: self, action: #selector(dismissVC))
        
        let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetFilterMethod))
        self.navigationItem.rightBarButtonItems = [refreshBtn,closeBtn]

        // Do any additional setup after loading the view.
    }
    
    @objc func dismissVC()
    {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func resetFilterMethod()
    {
        appointFilterDelegate?.sendAppointmentsFilterValues(age: "", appointments: "", clinic: "")
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
