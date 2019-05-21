//
//  ScheduleViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 21/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
// scheduleVC

import UIKit

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var fullBookedLbl: UILabel!
    @IBOutlet weak var bookingInProgressLbl: UILabel!
    @IBOutlet weak var bookingYetStartLbl: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        roundLabel(lbl: fullBookedLbl, color: UIColor.red)
        roundLabel(lbl: bookingInProgressLbl, color: UIColor.yellow)
        roundLabel(lbl: bookingYetStartLbl, color: UIColor.white)

        // Do any additional setup after loading the view.
    }
    func roundLabel(lbl:UILabel,color:UIColor)
    {
        lbl.layer.cornerRadius = lbl.frame.height / 2
        lbl.layer.masksToBounds = true
        lbl.backgroundColor = color
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
