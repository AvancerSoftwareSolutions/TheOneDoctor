//
//  ProfileViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 06/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ProfileViewController: UIViewController,AVPlayerViewControllerDelegate,sendSpecialityListValuesDelegate {
    
    
    
    

    //MARK:- IBOutlets
    @IBOutlet weak var scrollViewInstance: UIScrollView!
    @IBOutlet weak var headerViewHgtConst: NSLayoutConstraint! // 260
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var specialityCollectionView: UICollectionView!

    @IBOutlet weak var subSpecialityCollectionView: UICollectionView!

    @IBOutlet weak var profilePicBtnInstance: UIButton!
    @IBOutlet weak var addSpecBtnInst: UIButton!
    @IBOutlet weak var addSubSpecBtnInst: UIButton!
    @IBOutlet weak var mobileIconView: UIView!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var experienceTF: UITextField!
    
    @IBOutlet weak var doctorPicturesCollectionView: UICollectionView!
    @IBOutlet weak var docPicCVHgtConst: NSLayoutConstraint! // 120
    @IBOutlet weak var addPicUploadBtnInstance: UIButton!
    @IBOutlet weak var biographyTextView: UITextView!
    @IBOutlet weak var biographyTVHgtConst: NSLayoutConstraint!
    
    
    
    //MARK:- Variables
    var docSpecialityCell:DoctorSpecialityCollectionViewCell?
    var docPicturesCell:DoctorPicturesCollectionViewCell?
    let apiManager = APIManager()
    var profileData:ProfileModel?
    var addSpecialityData:AddSpecialityModel?
    var cancelSpecialityData:CancelSpecialityModel?
    
    
    var doctorMediaArray:NSMutableArray = []
    var doctorUploadFileArray:NSMutableArray = []
    
    var specialityArray:NSMutableArray = []
    var subSpecialityArray:NSMutableArray = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        label.text = "Update"
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .black
        label.layer.cornerRadius = 10.0
        label.layer.masksToBounds = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: label)
        userNameLbl.adjustsFontSizeToFitWidth = true
        
        specialityCollectionView.register(UINib(nibName: "DoctorSpecialityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "docSpecialityCell")
        subSpecialityCollectionView.register(UINib(nibName: "DoctorSpecialityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "docSpecialityCell")
        doctorPicturesCollectionView.register(UINib(nibName: "DoctorPicturesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "docPicturesCell")
        
        GenericMethods.setProfileImage(imageView: profileImgView)
        GenericMethods.setLeftViewWithSVG(svgView: mobileIconView, with: "phone", color: AppConstants.appGreenColor)
        
        roundButton(button: profilePicBtnInstance)
        profilePicBtnInstance.imageView?.contentMode = .center
        roundButton(button: addSpecBtnInst)
        roundButton(button: addSubSpecBtnInst)
        
        biographyTextView.layer.borderColor = AppConstants.appdarkGrayColor.cgColor
        biographyTextView.layer.borderWidth = 1.0
        biographyTextView.layer.cornerRadius = 5.0
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneWithNumberPad))]
        numberToolbar.sizeToFit()
        mobileTF.inputAccessoryView = numberToolbar
        

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        loadingProfileDetailsAPI()
        
        // Do any additional setup after loading the view.
    }
    func roundButton(button:UIButton)
    {
        button.layer.cornerRadius = button.frame.size.height / 2
        //        imgView.layer.borderWidth = 0.2
        button.clipsToBounds = true
        button.layer.masksToBounds = true
    }
    @objc func doneWithNumberPad()
    {
        let _ = mobileTF.resignFirstResponder()
    }
    override func viewDidLayoutSubviews() {
        scrollViewInstance.contentSize = CGSize(width: scrollViewInstance.frame.width, height: addPicUploadBtnInstance.frame.origin.y+addPicUploadBtnInstance.frame.height+10)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewInstance.contentOffset = CGPoint(x: 0, y: scrollViewInstance.contentOffset.y)
    }
    @objc func keyboardWasShown(notification: NSNotification) {
        print("keyboardWasShown")
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsets:UIEdgeInsets = UIEdgeInsets(top: view.frame.origin.x, left: view.frame.origin.y, bottom: targetFrame.height + 2, right: 0)
        scrollViewInstance.contentInset = contentInsets
        scrollViewInstance.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        print("keyboardWillHide")
        let zero:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.scrollViewInstance.contentInset = zero;
        self.scrollViewInstance.scrollIndicatorInsets = zero;
    }

    @objc func specialityDeleteMethod(button:UIButton)
    {
        
    }
    @objc func subSpecialityDeleteMethod(button:UIButton)
    {
        
    }
    // MARK: - Profile API
    func loadingProfileDetailsAPI()
    {
        var parameters = Dictionary<String, Any>()
        parameters["user_id"] = UserDefaults.standard.value(forKey: "user_id") as Any
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.profileDetailsAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.profileData = response
                if self.profileData?.status?.code == "0" {
                    //MARK: Login Success Details
                    self.mobileTF.text = self.profileData?.profileData?.mobile
                    self.emailTF.text = self.profileData?.profileData?.email
                    self.experienceTF.text = self.profileData?.profileData?.experience
                    self.userNameLbl.text = "\(self.profileData?.profileData?.firstname ?? "") \(self.profileData?.profileData?.lastname ?? "")"
                    UserDefaults.standard.set(self.profileData?.profileData?.profPicture, forKey: "user_image")
                    UserDefaults.standard.set(self.profileData?.profileData?.gender, forKey: "gender")
                    
//                    self.specialityArray = NSMutableArray(array: (self.profileData?.profileData?.specialityList)!)
//                    self.subSpecialityArray = NSMutableArray(array: (self.profileData?.profileData?.subspecialityList)!)
//                    print("\(self.specialityArray)\n \(self.subSpecialityArray)")
                    var mutableDictionary:[String:Any] = [:]
                    for i in 0..<(self.profileData?.profileData?.specialityList?.count ?? 0)
                    {
//                        mutableDictionary.add(["":])
                        mutableDictionary.add(["id" : self.profileData?.profileData?.specialityList?[i].id ?? ""])
                        mutableDictionary.add(["name" : self.profileData?.profileData?.specialityList?[i].name ?? ""])
                        self.specialityArray.add(mutableDictionary)
                    }
                    print("specialiARR \(self.specialityArray)")
                    var mutablesubDictionary:[String:Any] = [:]
                    for i in 0..<(self.profileData?.profileData?.subspecialityList?.count ?? 0)
                    {
                        mutablesubDictionary.add(["id" : self.profileData?.profileData?.subspecialityList?[i].id ?? ""])
                        mutablesubDictionary.add(["name" : self.profileData?.profileData?.subspecialityList?[i].name ?? ""])
                        self.subSpecialityArray.add(mutablesubDictionary)
                       
                    }
                    print("subspecialiARR \(self.subSpecialityArray)")

//                    self.reloadHeaderView()
                    
                    GenericMethods.setProfileImage(imageView: self.profileImgView)

                    
                    guard let arr1 = self.profileData?.profileData?.additionalPictureList,let arr2 = self.profileData?.profileData?.additionalVideoList
                    else {
                        self.doctorMediaArray = []
                        return
                        
                    }
                    
                    self.doctorMediaArray = NSMutableArray(array: arr1 + arr2)
                    
                    print("doctorMediaArray \(self.doctorMediaArray)")
                    
                    self.reloadViews()

                }
                else
                {
                    GenericMethods.showAlert(alertMessage: self.profileData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                }
                
                
            }
            else {
                GenericMethods.showAlert(alertMessage:error?.localizedDescription ?? "")
                
            }
        }
    }
//    func reloadHeaderView()
//    {
//        let value1 = specialityArray.count
//
//        let value2 = subSpecialityArray.count
//
//        print(value1 , value2)
//
//        self.specialtyCVHgtConst.constant = CGFloat(value1 * 45) + 20
//        self.subSpecialtyCVHgtConst.constant = CGFloat(value2 * 45) + 20
//
//        self.headerViewHgtConst.constant = 160 + self.specialtyCVHgtConst.constant + self.subSpecialtyCVHgtConst.constant
//
//        print("headerConst \(self.headerViewHgtConst.constant)")
//    }
    func reloadViews()
    {
        self.specialityCollectionView.reloadData()
        self.subSpecialityCollectionView.reloadData()
        self.doctorPicturesCollectionView.reloadData()
    }
    
    func getIdMethod(listArray:NSMutableArray)-> [String]
    {
        var idArray:[String] = []
        for i in 0..<(listArray.count)
        {
            idArray.append((listArray[i] as? [AnyHashable:Any])? ["id"] as? String ?? "")
        }
        return idArray
    }
    
    func addSpecialityDetailsAPI(type:Int)
    {
        var parameters = Dictionary<String, Any>()
        
        parameters["id"] = getIdMethod(listArray: specialityArray) as Any
        parameters["subid"] = getIdMethod(listArray: subSpecialityArray) as Any
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.addSpecialityDetailsAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.addSpecialityData = response
                if self.addSpecialityData?.status?.code == "0" {
                    //MARK: Speciality Success Details
                    if type == 0
                    {
                        if self.addSpecialityData?.specialityData?.count ?? 0 == 0
                        {
                            GenericMethods.showAlertMethod(alertMessage: "Empty List")
                            return
                        }
                    }
                    else
                    {
                        if self.addSpecialityData?.subSpecialityData?.count ?? 0 == 0
                        {
                            GenericMethods.showAlertMethod(alertMessage: "Empty List")
                            return
                        }
                    }
                    let specialityListVC = self.storyboard?.instantiateViewController(withIdentifier: "specialityListVC") as! SpecialityListViewController
                    specialityListVC.addSpecialityData = self.addSpecialityData
                    specialityListVC.type = type
                    specialityListVC.delegate = self
                    
                    self.definesPresentationContext = true
                    specialityListVC.modalTransitionStyle = .crossDissolve
                    specialityListVC.modalPresentationStyle = .overCurrentContext
                    self.present(specialityListVC, animated: true, completion: nil)
                }
                else
                {
                    GenericMethods.showAlert(alertMessage: self.addSpecialityData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                }
                
                
            }
            else {
                GenericMethods.showAlert(alertMessage:error?.localizedDescription ?? "")
                
            }
        }
    }
    func cancelSpecialityDetailsAPI(id:String,type:Int)
    {
        var parameters = Dictionary<String, Any>()
        
        parameters["id"] = getIdMethod(listArray: specialityArray) as Any
        parameters["subid"] = getIdMethod(listArray: subSpecialityArray) as Any
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.cancelSpecialityDetailsAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.cancelSpecialityData = response
                if self.cancelSpecialityData?.status?.code == "0" {
                    //MARK: Speciality Success Details
//                    if type == 0
//                    {
//                        if self.cancelSpecialityData?.specialityData?.count ?? 0 == 0
//                        {
//                            GenericMethods.showAlertMethod(alertMessage: "Empty List")
//                            return
//                        }
//                    }
//                    else
//                    {
//                        if self.cancelSpecialityData?.subSpecialityData?.count ?? 0 == 0
//                        {
//                            GenericMethods.showAlertMethod(alertMessage: "Empty List")
//                            return
//                        }
//                    }
//                    let specialityListVC = self.storyboard?.instantiateViewController(withIdentifier: "specialityListVC") as! SpecialityListViewController
//                    specialityListVC.addSpecialityData = self.addSpecialityData
//                    specialityListVC.type = type
//                    specialityListVC.delegate = self
//
//                    self.definesPresentationContext = true
//                    specialityListVC.modalTransitionStyle = .crossDissolve
//                    specialityListVC.modalPresentationStyle = .overCurrentContext
//                    self.present(specialityListVC, animated: true, completion: nil)
                }
                else
                {
                    GenericMethods.showAlert(alertMessage: self.addSpecialityData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                }
                
                
            }
            else {
                GenericMethods.showAlert(alertMessage:error?.localizedDescription ?? "")
                
            }
        }
    }
    func sendSpecialityListValues(selectedListArray: NSMutableArray,type:Int)
    {
        if type == 0
        {
            specialityArray = NSMutableArray(array: specialityArray.addingObjects(from: selectedListArray as [AnyObject]))
            specialityCollectionView.reloadData()
        }
        else
        {
            subSpecialityArray = NSMutableArray(array: subSpecialityArray.addingObjects(from: selectedListArray as [AnyObject]))
            subSpecialityCollectionView.reloadData()
        }
//        self.reloadHeaderView()
        print("specialityArray \(specialityArray) subSpecialityArray \(subSpecialityArray)")
        
    }
    // MARK: - IBActions
    
    @IBAction func profilePicbtnClick(_ sender: Any) {
        
    }
    
    @IBAction func addSpecBtnClick(_ sender: Any) {
        
        addSpecialityDetailsAPI(type: 0)
    }
    
    @IBAction func addSubSpecBtnClick(_ sender: Any) {
        addSpecialityDetailsAPI(type: 1)
        
    }
    @IBAction func docAddiPicUploadBtnClick(_ sender: Any) {
        
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
extension ProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
    
{
    //dashboardCell
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.profileData != nil {
            switch collectionView {
            case specialityCollectionView:
                return self.specialityArray.count
                
            case subSpecialityCollectionView:
                return self.subSpecialityArray.count
            case doctorPicturesCollectionView:
                return self.doctorMediaArray.count
            default:
                break
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        func designMethod()
        {
            docSpecialityCell?.bgView.layer.cornerRadius = 5.0
            docSpecialityCell?.bgView.layer.masksToBounds = true
            docSpecialityCell?.bgView.layer.borderColor = UIColor.white.cgColor
            docSpecialityCell?.bgView.layer.borderWidth = 1.0
            
//            docSpecialityCell?.specialityLbl.adjustsFontSizeToFitWidth = true
        }
        switch collectionView {
        case specialityCollectionView:
            docSpecialityCell = collectionView.dequeueReusableCell(withReuseIdentifier: "docSpecialityCell", for: indexPath) as? DoctorSpecialityCollectionViewCell
            docSpecialityCell?.deleteBtnInst.addTarget(self, action: #selector(specialityDeleteMethod(button:)), for: .touchUpInside)
            designMethod()
            
            docSpecialityCell?.specialityLbl.text = (self.specialityArray[indexPath.item] as? [AnyHashable:Any])? ["name"] as? String ?? ""
            
            docSpecialityCell?.specialityLbl.sizeToFit()

            return docSpecialityCell!
        case subSpecialityCollectionView:
            docSpecialityCell = collectionView.dequeueReusableCell(withReuseIdentifier: "docSpecialityCell", for: indexPath) as? DoctorSpecialityCollectionViewCell
            docSpecialityCell?.deleteBtnInst.addTarget(self, action: #selector(subSpecialityDeleteMethod(button:)), for: .touchUpInside)
            designMethod()
            docSpecialityCell?.specialityLbl.text = (self.subSpecialityArray[indexPath.item] as? [AnyHashable:Any])? ["name"] as? String ?? ""
            return docSpecialityCell!
        case doctorPicturesCollectionView:
            
            docPicturesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "docPicturesCell", for: indexPath) as? DoctorPicturesCollectionViewCell
            GenericMethods.createThumbnailOfVideoFromRemoteUrl(url: self.doctorMediaArray[indexPath.item] as? String ?? "",imgView: docPicturesCell!.DocPicImgView,playImgView: docPicturesCell!.playImgView)
            
            return docPicturesCell!
            
        default:
            break
        }
        return docSpecialityCell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth:CGFloat = collectionView.frame.size.width - 20
        let cellHeight:CGFloat = collectionView.frame.size.height - 10
        switch collectionView {
        case specialityCollectionView:
//
//            if let cell = collectionView.cellForItem(at: indexPath as IndexPath) as? DoctorSpecialityCollectionViewCell {
//                let lblWidth = cell.specialityLbl.intrinsicContentSize.width
//                print("lblWidth \(lblWidth)")
//                return CGSize(width: lblWidth + 44, height: 45)
//            }
            
            let size = ((self.specialityArray[indexPath.item] as? [AnyHashable:Any])? ["name"] as? NSString)!.size(withAttributes: nil)
            print("size \(size.width)")
            return CGSize(width: (size.width + 38) , height: cellHeight)
            
        case subSpecialityCollectionView:
            let size = ((self.subSpecialityArray[indexPath.item] as? [AnyHashable:Any])? ["name"] as? NSString)!.size(withAttributes: nil)
            print("size \(size.width)")
            return CGSize(width: (size.width + 44) , height: cellHeight)
//            return CGSize(width: cellWidth, height: cellHeight)
        case doctorPicturesCollectionView:
            return CGSize(width: 120, height: 120)
        default:
            break
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case specialityCollectionView:
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        case subSpecialityCollectionView:
            return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        case doctorPicturesCollectionView:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            break
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == doctorPicturesCollectionView
        {
            if let cell = collectionView.cellForItem(at: indexPath) as? DoctorPicturesCollectionViewCell {
                if cell.playImgView.isHidden == false
                {
                    let videoURL = URL(string: self.doctorMediaArray[indexPath.item] as? String ?? "")
                    let player = AVPlayer(url: videoURL!)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                }
                else
                {
                    let openFileVC = self.storyboard!.instantiateViewController(withIdentifier: "openFileVC") as? OpenFileViewController
                    openFileVC?.titleStr = ""
                    openFileVC?.openURLStr = self.doctorMediaArray[indexPath.item] as? String ?? ""
                    self.navigationController?.pushViewController(openFileVC!, animated: true)
                }
            }
            
        }
        //        let financeTVC = self.storyboard!.instantiateViewController(withIdentifier: "financeTVC") as? FinanceTableViewController
        //        self.navigationController?.pushViewController(financeTVC!, animated: true)
    }
    
    
}
