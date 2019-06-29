//
//  DashboardViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 06/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import Alamofire

class DashboardViewController: UIViewController,UIGestureRecognizerDelegate,sendViewNavigationMethod {
    
    
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var notificationImgView: UIImageView!
    
    @IBOutlet weak var settingsImgView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var profileContainerView: UIView!
    //MARK:- Variables
    
    var dashboardCell:DashboardCollectionViewCell? = nil
    var dashBoardListData:DashboardModel?
    let apiManager = APIManager()
    var panGesture = UIPanGestureRecognizer()
    var refreshControl = UIRefreshControl()
    var isRefreshEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roundImgView(imgView: settingsImgView)

        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(menuPageNavigationMethod))
        profileTapGesture.numberOfTapsRequired = 1
        self.profileContainerView.addGestureRecognizer(profileTapGesture)
        self.profileContainerView.isUserInteractionEnabled = true
        
        let settingsTapGesture = UITapGestureRecognizer(target: self, action: #selector(settingsNavigateMethod))
        settingsTapGesture.numberOfTapsRequired = 1
        self.settingsImgView.addGestureRecognizer(settingsTapGesture)
        self.settingsImgView.isUserInteractionEnabled = true
        
        GenericMethods.setLeftViewWithSVG(svgView: profileContainerView, with: "hamburger", color: AppConstants.appdarkGrayColor)
        

        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(menuPageNavigationMethod))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
//        let swipeBottom = UISwipeGestureRecognizer(target: self, action: #selector(refreshFunction))
//        swipeBottom.direction = UISwipeGestureRecognizer.Direction.down
//        self.view.addGestureRecognizer(swipeBottom)
        
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshFunction), for: .valueChanged)
        refreshControl.tintColor = UIColor.black
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing", attributes: attributes)
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshFunction()
    {
//        collectionView.refreshControl = refreshControl
//        refreshControl.addTarget(self, action: #selector(refreshFunction), for: .valueChanged)
//        refreshControl.tintColor = UIColor.black
//        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
//        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing", attributes: attributes)
        isRefreshEnabled = true
        loadingdashBoardDetailsAPI()
    }
    

    @objc func settingsNavigateMethod()
    {
        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "settingsVC") as! SettingsViewController
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    @objc func leftMenuPan(recognizer:UIPanGestureRecognizer)
    {
        if recognizer.state == UIGestureRecognizer.State.ended {
            if panGesture.isLeft(theViewYouArePassing: self.view)
            {
                menuBtnClick()
            }
        }
    }
    @objc func menuPageNavigationMethod()
    {
        menuBtnClick()
    }
    func menuBtnClick()
    {
        let leftMenuVC = self.storyboard?.instantiateViewController(withIdentifier: "leftMenuVC") as! LeftMenuViewController
        leftMenuVC.delegate = self
        self.navigationController!.definesPresentationContext = true
        leftMenuVC.modalTransitionStyle = .crossDissolve
        leftMenuVC.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(leftMenuVC, animated: true, completion: nil)
    }
    func roundImgView(imgView:UIImageView)
    {
        imgView.layer.cornerRadius = imgView.frame.size.height / 2
//        imgView.layer.borderWidth = 0.2
        imgView.clipsToBounds = true
        imgView.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        navigationController?.navigationBar.isHidden = true
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        loadingdashBoardDetailsAPI()
    }
    
    // MARK: - Dashboard API
    @objc func loadingdashBoardDetailsAPI()
    {
        var parameters = Dictionary<String, Any>()
        parameters["user_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        if !self.isRefreshEnabled
        {
           GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        }
        
        apiManager.dashboardListDetailsAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.dashBoardListData = response
                if self.dashBoardListData?.status?.code == "0" {
                    //MARK: Dashboard Success Details
                    if self.isRefreshEnabled
                    {
                        DispatchQueue.main.async(execute: {
                            
                            // when done, update the model and the UI here
                            
                            self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh") // reset the message
                            self.refreshControl.endRefreshing()
                            self.isRefreshEnabled = false
                            self.collectionView.reloadData()
                        })
                    }
                    else
                    {
                        self.collectionView.reloadData()
                    }
                    
                    
                }
                else
                {
                    
                    GenericMethods.showAlertwithPopNavigation(alertMessage: self.dashBoardListData?.status?.message ?? "Unable to fetch data. Please try again after sometime.", vc: self)
                    if self.isRefreshEnabled
                    {
                        DispatchQueue.main.async(execute: {
                            
                            // when done, update the model and the UI here
                            
                            self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh") // reset the message
                            self.refreshControl.endRefreshing()
                            self.isRefreshEnabled = false
                            
                        })
                    }
                    //                    GenericMethods.showAlert(alertMessage: self.profileData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                }
                
                
            }
            else {
                GenericMethods.showAlertwithPopNavigation(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.", vc: self)
                if self.isRefreshEnabled
                {
                    DispatchQueue.main.async(execute: {
                        
                        // when done, update the model and the UI here
                        
                        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh") // reset the message
                        self.refreshControl.isHidden = true
                        self.refreshControl.endRefreshing()
                        
                        self.isRefreshEnabled = false
                        
                    })
                }
                
                
            }
        }
    }
    
    func sendViewsToNavigate(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
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
extension DashboardViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout

{
    //dashboardCell
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.dashBoardListData != nil {
            return (self.dashBoardListData?.dashboardData?.count) ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        dashboardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardCell", for: indexPath) as? DashboardCollectionViewCell
        dashboardCell?.bgView.layer.cornerRadius = 5.0
        dashboardCell?.bgView.layer.masksToBounds = true
        dashboardCell?.bgView.layer.borderColor = UIColor.white.cgColor
        dashboardCell?.bgView.layer.borderWidth = 1.0
        
        dashboardCell?.descriptionLbl.text = dashBoardListData?.dashboardData?[indexPath.item].name
        
        GenericMethods.createThumbnailOfVideoFromRemoteUrl(url: dashBoardListData?.dashboardData?[indexPath.item].icon ?? "",imgView: dashboardCell!.imgView,playImgView: UIImageView())
        
        return dashboardCell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth:CGFloat = collectionView.frame.size.width - 20
        let cellHeight:CGFloat = collectionView.frame.size.height - 30
        return CGSize(width: cellWidth / 2, height: cellHeight / 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            
            let appointVC = self.storyboard?.instantiateViewController(withIdentifier: "appointVC") as! AppointmentsViewController
            self.navigationController?.pushViewController(appointVC, animated: true)
            
        case 1:
            
            let scheduleVC = self.storyboard?.instantiateViewController(withIdentifier: "scheduleVC") as! ScheduleViewController
            self.navigationController?.pushViewController(scheduleVC, animated: true)
        case 2:
            
            let queueVC = self.storyboard?.instantiateViewController(withIdentifier: "queueVC") as! QueueViewController
            self.navigationController?.pushViewController(queueVC, animated: true)
            
        case 3:
            
            
            
            let earningsVC = self.storyboard?.instantiateViewController(withIdentifier: "earningsVC") as! RevenuesViewController
            self.navigationController?.pushViewController(earningsVC, animated: true)
            
        default:
            break
        }
        
    }
    
    
}
