//
//  LeftMenuViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 19/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
protocol sendViewNavigationMethod {
    func sendViewsToNavigate(vc:UIViewController)
}
class LeftMenuViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var appVersionLbl: UILabel!
    @IBOutlet weak var profilePictureImgView: UIImageView!
    @IBOutlet weak var profileNavigateImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    
    //MARK:- Variables
    var delegate:sendViewNavigationMethod?
    var menuListArray:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePictureImgView.layer.cornerRadius = profilePictureImgView.frame.size.height / 2
        profilePictureImgView.clipsToBounds = true
        profilePictureImgView.layer.masksToBounds = true
        profilePictureImgView.layer.borderColor = UIColor.white.cgColor
        profilePictureImgView.layer.borderWidth = 0.3
        
       
        userNameLbl.text = "\(UserDefaults.standard.value(forKey: "firstName") as? String ?? "") \(UserDefaults.standard.value(forKey: "lastName") as? String ?? "")"
        profileNavigateImgView.setImageColor(color: UIColor.white)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToProfileView))
        tapGesture.numberOfTapsRequired = 1
        profileNavigateImgView.isUserInteractionEnabled = true
        profileNavigateImgView.addGestureRecognizer(tapGesture)
        
        let closetapGesture = UITapGestureRecognizer(target: self, action: #selector(closeVC))
        closetapGesture.numberOfTapsRequired = 1
        bgView.isUserInteractionEnabled = true
        bgView.addGestureRecognizer(closetapGesture)
        
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            else {
                appVersionLbl.text = "The ONE Doctor app version : 0.0.1"
                return
        }
        appVersionLbl.text = "The ONE Doctor app version : \(version)"
        
        menuListArray = [
            ["image":"Profile",
             "detail":"Profile"],
            ["image":"Add Advertisement",
             "detail":"Add Advertisement"],
            ["image":"Refer",
             "detail":"Add Deals"],
            ["image":"Refer",
             "detail":"History"]
        ]
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(closeVC))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        GenericMethods.setProfileImage(imageView: profilePictureImgView, borderColor: UIColor.white.withAlphaComponent(0.3), imageString: UserDefaults.standard.value(forKey: "user_image") as? String ?? "")
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    @objc func closeVC()
    {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func navigateToProfileView()
    {
        self.dismiss(animated: true, completion: {
            let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
            self.delegate?.sendViewsToNavigate(vc: profileVC)
        })
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
extension LeftMenuViewController:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        menuCell.textLabel?.textColor = UIColor.white
        menuCell.textLabel?.text = (menuListArray[indexPath.row] as? [AnyHashable:Any])? ["detail"] as? String ?? ""
        menuCell.imageView?.image = UIImage(named: (menuListArray[indexPath.row] as? [AnyHashable:Any])? ["image"] as? String ?? "")
        menuCell.imageView?.setImageColor(color: AppConstants.appGreenColor)
        menuCell.selectionStyle = .none
        
        return menuCell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.row {
            
        case 0:
            let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
            self.delegate?.sendViewsToNavigate(vc: profileVC)
        case 1:
            
            let advertiseVC = self.storyboard?.instantiateViewController(withIdentifier: "advertiseVC") as! AdvertisementViewController
            self.delegate?.sendViewsToNavigate(vc: advertiseVC)
            
        case 2:
            
            let dealsVC = self.storyboard?.instantiateViewController(withIdentifier: "dealsVC") as! DealsViewController
            self.delegate?.sendViewsToNavigate(vc: dealsVC)
            
        case 3:
            
            let historyListVC = self.storyboard?.instantiateViewController(withIdentifier: "historyListVC") as! HistoryListTableViewController
            self.delegate?.sendViewsToNavigate(vc: historyListVC)
            
        default:
            break
        }
        
        self.dismiss(animated: true, completion:nil)
        
    }
}
