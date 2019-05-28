//
//  DashboardViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 06/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController,UIGestureRecognizerDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var profilePicImgView: UIImageView!
    @IBOutlet weak var notificationImgView: UIImageView!
    
    @IBOutlet weak var settingsImgView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var profileContainerView: UIView!
    //MARK:- Variables
    
    var dashboardCell:DashboardCollectionViewCell? = nil
    var textArray:NSMutableArray = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        roundImgView(imgView: settingsImgView)
        
        
        let cornerRadius = profilePicImgView.bounds.height / 2
        
        profileContainerView.clipsToBounds = false
        profileContainerView.layer.cornerRadius = cornerRadius
        profileContainerView.layer.shadowColor = UIColor.darkGray.cgColor
        profileContainerView.layer.shadowOpacity = 1
        profileContainerView.layer.shadowOffset = CGSize.zero
        profileContainerView.layer.shadowRadius = 2
        profileContainerView.layer.shadowPath = UIBezierPath(roundedRect: profileContainerView.bounds, cornerRadius: cornerRadius).cgPath
        
        
//
//
//
//
//
//        profilePicImgView.layer.shadowColor = UIColor.darkGray.cgColor
//        profilePicImgView.layer.shadowOpacity = 1.0
//        profilePicImgView.layer.shadowRadius = 5
//        profilePicImgView.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(profilePageNavigationMethod))
        profileTapGesture.numberOfTapsRequired = 1
        self.profilePicImgView.addGestureRecognizer(profileTapGesture)
        self.profilePicImgView.isUserInteractionEnabled = true
        
        let settingsTapGesture = UITapGestureRecognizer(target: self, action: #selector(logoutMethod))
        settingsTapGesture.numberOfTapsRequired = 1
        self.settingsImgView.addGestureRecognizer(settingsTapGesture)
        self.settingsImgView.isUserInteractionEnabled = true
        
        textArray = [
            ["image":"Appoint.png",
             "detail":"Appointments"],
            ["image":"Schedule.png",
             "detail":"Schedule"],
            ["image":"Queue.png",
             "detail":"Queue"],
            ["image":"Revenue.png",
             "detail":"Revenue"],
            ["image":"Upload.png",
             "detail":"Upload"],
            ["image":"Watch.png",
             "detail":"Link The ONE Watch"]
        ]
        let hours24 = GenericMethods.convert24hrto12hrFormat(dateStr: "20:00")
        print("hours24 \(hours24)")
        let mins24 = GenericMethods.convertHrstoMinsFormat(dateStr: "00:30")
        
        print("mins24 \(mins24)")
        jsonInput()
        // Do any additional setup after loading the view.
    }
    func jsonInput()
    {
        
        let location = "ScheduleJson"
        let fileType = "json"
        if let path = Bundle.main.path(forResource: location, ofType: fileType) {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: .mappedIfSafe)
                var alertacceptDict: [AnyHashable : Any]? = nil
                
                alertacceptDict = try! JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) as? [AnyHashable : Any]
                
                if let aDict = alertacceptDict {
                    print("responseDict \(aDict)")
                }
                if let body = alertacceptDict?["Date"] {
                    print("body is \("\(body)")")
                }
                
                AppConstants.resultDateDict = NSMutableDictionary(dictionary: alertacceptDict!["Date"] as! [AnyHashable : Any])
                print("datevalue is \(String(describing: AppConstants.resultDateDict.value(forKey: "2019-05-25")))")
            }
            catch let error {
                print(error.localizedDescription)
            }}
        else
        {
            print("cant found the file.")
        }
    }
    @objc func logoutMethod()
    {
        GenericMethods.showYesOrNoAlertWithCompletionHandler(alertTitle: "Are you sure want to Logout ?", alertMessage: "") { (UIAlertAction) in
            GenericMethods.resetDefaults()
            GenericMethods.navigateToLogin()
        }
    }
    @objc func profilePageNavigationMethod()
    {
    
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    func roundImgView(imgView:UIImageView)
    {
        imgView.layer.cornerRadius = imgView.frame.size.height / 2
//        imgView.layer.borderWidth = 0.2
        imgView.clipsToBounds = true
        imgView.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        GenericMethods.setProfileImage(imageView: profilePicImgView,borderColor:UIColor.lightGray)
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
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
        return textArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        dashboardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardCell", for: indexPath) as? DashboardCollectionViewCell
        dashboardCell?.bgView.layer.cornerRadius = 5.0
        dashboardCell?.bgView.layer.masksToBounds = true
        dashboardCell?.bgView.layer.borderColor = UIColor.white.cgColor
        dashboardCell?.bgView.layer.borderWidth = 1.0
        
        dashboardCell?.descriptionLbl.text = (textArray[indexPath.row] as? [AnyHashable:Any])? ["detail"] as? String
        dashboardCell?.imgView.image = UIImage(named: (textArray[indexPath.row] as? [AnyHashable:Any])? ["image"] as? String ?? "")
        
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
            
        default:
            break
        }
        
    }
    
    
}
