//
//  AddScheduleViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 21/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
// addScheduleVC

import UIKit

class AddScheduleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addScheduleBtnClick))
        let editBtn = UIBarButtonItem(image: UIImage(named: "EditProfPic.png"), style: .plain, target: self, action: #selector(editScheduleBtnClick))
        let svgHoldingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        GenericMethods.setLeftViewWithSVG(svgView: svgHoldingView, with: "filter", color: UIColor.white)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(filterBtnClick))
        tapGesture.numberOfTapsRequired = 1
        svgHoldingView.addGestureRecognizer(tapGesture)
        self.navigationItem.rightBarButtonItems = [addBtn,editBtn,UIBarButtonItem.init(customView: svgHoldingView)]
        

        // Do any additional setup after loading the view.
    }
    @objc func filterBtnClick()
    {
        
    }
    @objc func addScheduleBtnClick()
    {
        
    }
    @objc func editScheduleBtnClick()
    {
        
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
