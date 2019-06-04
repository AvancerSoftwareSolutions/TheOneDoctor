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
    
    @IBOutlet weak var monthChangeView: UIView!
    @IBOutlet weak var monthDayView: UIView!
    @IBOutlet weak var monthDayLbl: UILabel!
    @IBOutlet weak var nextMonthBtnInst: UIButton!
    @IBOutlet weak var previousMonthBtnInst: UIButton!
    @IBOutlet weak var rescheduleCollectionView: UICollectionView!
    @IBOutlet weak var stackViewHgtConst: NSLayoutConstraint! //40
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var rescheduleBtnInst: UIButton!
    @IBOutlet weak var unavailableTodayBtnInst: UIButton!
    @IBOutlet weak var makeAvailableBtnInst: UIButton!
    @IBOutlet weak var editButtonInst: UIButton!
    
    @IBOutlet weak var cancelScheduleBtnInst: UIButton!
    @IBOutlet weak var cancelBtnHgtConst: NSLayoutConstraint! // 40
    @IBOutlet weak var collectionViewHgtConst: NSLayoutConstraint! // 100
    
    
    //MARK:- Variables
    var rescheduleCell:RescheduleTableViewCell? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Schedule"
        
        roundBtn(btn: cancelScheduleBtnInst)
        roundBtn(btn: rescheduleBtnInst)
        roundBtn(btn: unavailableTodayBtnInst)
        roundBtn(btn: makeAvailableBtnInst)

        cancelBtnHgtConst.constant = 0
        makeAvailableBtnInst.isHidden = true
        rescheduleCollectionView.isUserInteractionEnabled = false

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        let height = rescheduleCollectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHgtConst.constant = height;
    }
    func roundBtn(btn:UIButton)
    {
        btn.layer.cornerRadius = 5.0
        btn.layer.masksToBounds = true
    }
    
    //MARK:- IBActions
    @IBAction func editBtnClick(_ sender: Any) {
        rescheduleCollectionView.isUserInteractionEnabled = true
        makeAvailableBtnInst.isHidden = true
        stackView.isHidden = true
        stackViewHgtConst.constant = 0
    }
    @IBAction func cancelScheduleBtnClick(_ sender: Any) {
        
        rescheduleCollectionView.isUserInteractionEnabled = false
        
    }
    @IBAction func rescheduleBtnClick(_ sender: Any) {
    }
    @IBAction func unavailableTodayBtnClick(_ sender: Any) {
    }
    @IBAction func makeAvailableBtnClick(_ sender: Any) {
    }
    
    

}
