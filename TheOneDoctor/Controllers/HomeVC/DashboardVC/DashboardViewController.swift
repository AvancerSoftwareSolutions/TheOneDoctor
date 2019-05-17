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
    
    //MARK:- Variables
    
    var dashboardCell:DashboardCollectionViewCell? = nil
    var textArray:NSMutableArray = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        roundImgView(imgView: settingsImgView)
        GenericMethods.setProfileImage(imageView: profilePicImgView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profilePageNavigationMethod))
        tapGesture.numberOfTapsRequired = 1
        self.profilePicImgView.addGestureRecognizer(tapGesture)
        self.profilePicImgView.isUserInteractionEnabled = true
        
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
        
        // Do any additional setup after loading the view.
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
//        navigationController?.navigationBar.isHidden = true
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
        default:
            break
        }
        
    }
    
    
}
