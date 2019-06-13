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
import ACFloatingTextfield_Swift
import Photos
import MobileCoreServices
import BSImagePicker
import SDWebImage

class ProfileViewController: UIViewController,AVPlayerViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIDocumentInteractionControllerDelegate,sendSpecialityListValuesDelegate,sendDeletePicDelegate,sendMediaAssetsDelegate {
    
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var scrollViewInstance: UIScrollView!
    @IBOutlet weak var headerViewHgtConst: NSLayoutConstraint! // 260
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
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
    
    @IBOutlet weak var editPicturesBtnInstance: UIButton!
    
    @IBOutlet weak var otpTF: ACFloatingTextfield!
    
    @IBOutlet weak var otpHgtConst: NSLayoutConstraint! //45
    @IBOutlet weak var otpTopConst: NSLayoutConstraint! // 15
    
    //MARK:- Variables
    var docSpecialityCell:DoctorSpecialityCollectionViewCell?
    var docPicturesCell:DoctorPicturesCollectionViewCell?
    let apiManager = APIManager()
    var profileData:ProfileModel?
    var addSpecialityData:AddSpecialityModel?
    var cancelSpecialityData:CancelSpecialityModel?
    var sendOTPData:SendOTPModel?
    var profileUpdateData:ProfileUpdateModel?
    
    var imagePicker = UIImagePickerController()
    var doctorMediaArray:NSMutableArray = []
    var doctorUploadFileArray:NSMutableArray = []
    
    var specialityArray:NSMutableArray = []
    var subSpecialityArray:NSMutableArray = []
    
    var selectedAssets = [PHAsset]()
    
    var fileDataArr = [Data]()
    var fileNameArr = [String]()
    var mimeTypeArr = [String]()
    var uploadType:Int = 0 // 0 - profile pic 1- add Pic
    
    var uploadingMediaArray:NSMutableArray = []
    var randomNumber = ""
    
    var otp = ""
    var isPictureUpload:Bool = false
    
    
    var mobileNumber = ""
    var email = ""
    var short_biography = ""
    var speciality = ""
    var subspeciality = ""
    var picture = ""
    var additionalpicture = [""]
    var additionalvideo = [""]
    
    /*
    parameters["mobile"] = mobileTF.text
    parameters["additionalpicture"] = ""
    parameters["additionalvideo"] = ""
    parameters["email"] = ""
    parameters["short_biography"] = ""
    parameters["speciality"] = ""
    parameters["subspeciality"] = ""
    parameters["picture"] = ""
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"
        
        otpHgtConst.constant = 0
        otpTopConst.constant = 0
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        label.text = "Update"
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .black
        label.layer.cornerRadius = 10.0
        label.layer.masksToBounds = true
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileUpdateMethod))
        tapGesture.numberOfTapsRequired = 1
        label.addGestureRecognizer(tapGesture)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: label)
        
        
        userNameLbl.adjustsFontSizeToFitWidth = true
        
        specialityCollectionView.register(UINib(nibName: "DoctorSpecialityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "docSpecialityCell")
        subSpecialityCollectionView.register(UINib(nibName: "DoctorSpecialityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "docSpecialityCell")
        doctorPicturesCollectionView.register(UINib(nibName: "DoctorPicturesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "docPicturesCell")
        
        GenericMethods.setProfileImage(imageView: profileImgView,borderColor:UIColor.white)
        GenericMethods.setLeftViewWithSVG(svgView: mobileIconView, with: "phone", color: AppConstants.appGreenColor)
        
        roundButton(button: profilePicBtnInstance)
        profilePicBtnInstance.imageView?.contentMode = .center
        roundButton(button: addSpecBtnInst)
        roundButton(button: addSubSpecBtnInst)
        
        biographyTextView.layer.borderColor = AppConstants.appdarkGrayColor.cgColor
        biographyTextView.layer.borderWidth = 1.0
        biographyTextView.layer.cornerRadius = 5.0
        
        let mobileNumberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        mobileNumberToolbar.barStyle = .default
        mobileNumberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneWithMobile))]
        mobileNumberToolbar.sizeToFit()
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneWithNumberPad))]
        numberToolbar.sizeToFit()
        mobileTF.inputAccessoryView = mobileNumberToolbar
        otpTF.inputAccessoryView = numberToolbar
        biographyTextView.inputAccessoryView = numberToolbar

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
        let _ = biographyTextView.resignFirstResponder()
        
        let _ = otpTF.resignFirstResponder()
    }
    @objc func doneWithMobile()
    {
        let _ = mobileTF.resignFirstResponder()
        if mobileTF.text!.count == 8 && mobileTF.text! != self.mobileNumber
        {
            sendOTPMethod()
        }
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
        if specialityArray.count == 1
        {
           GenericMethods.showAlert(alertMessage: "Atleast one speciality should be added.")
            return
        }
        let selectedId = (self.specialityArray[button.tag] as? [AnyHashable:Any])? ["id"] as? String ?? ""
        self.removeDictFromArray(searchKey: "id", searchString: selectedId, array: self.specialityArray)
        self.removeDictFromArray(searchKey: "speciality_id", searchString: selectedId, array: self.subSpecialityArray)
        specialityCollectionView.reloadData()
        subSpecialityCollectionView.reloadData()
        print("specialityArray \(specialityArray) subSpecialityArray \(subSpecialityArray)")
    }
    @objc func subSpecialityDeleteMethod(button:UIButton)
    {
        let selectedId = (self.subSpecialityArray[button.tag] as? [AnyHashable:Any])? ["subspeciality_id"] as? String ?? ""
        self.removeDictFromArray(searchKey: "subspeciality_id", searchString: selectedId, array: self.subSpecialityArray)
        subSpecialityCollectionView.reloadData()
        print("subSpecialityArray \(subSpecialityArray)")
    }
    // MARK: - Profile API
    func loadingProfileDetailsAPI()
    {
        var parameters = Dictionary<String, Any>()
        parameters["user_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        
        apiManager.profileDetailsAPI(parameters: parameters) { (status, showError, response, error) in
            
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.profileData = response
                if self.profileData?.status?.code == "0" {
                    //MARK: Profile Success Details
                    self.mobileNumber = self.profileData?.profileData?.mobile ?? ""
                    self.email = self.profileData?.profileData?.email ?? ""
                    self.short_biography = self.profileData?.profileData?.short_biography ?? ""
                    self.picture = self.profileData?.profileData?.picture ?? ""
                    
                    
                    self.biographyTextView.text = self.profileData?.profileData?.short_biography ?? ""
                    self.mobileTF.text = self.profileData?.profileData?.mobile
                    self.emailTF.text = self.profileData?.profileData?.email
                    self.experienceTF.text = self.profileData?.profileData?.experience
                    self.userNameLbl.text = "\(self.profileData?.profileData?.firstname ?? "") \(self.profileData?.profileData?.lastname ?? "")"
                    self.designationLbl.text = self.profileData?.profileData?.designation
                    UserDefaults.standard.set(self.profileData?.profileData?.profPicture, forKey: "user_image")
                    UserDefaults.standard.set(self.profileData?.profileData?.gender, forKey: "gender")
                    
                    var mutableDictionary:[String:Any] = [:]
                    for i in 0..<(self.profileData?.profileData?.specialityList?.count ?? 0)
                    {
                        mutableDictionary.add(["id" : self.profileData?.profileData?.specialityList?[i].id ?? ""])
                        mutableDictionary.add(["name" : self.profileData?.profileData?.specialityList?[i].name ?? ""])
                        self.specialityArray.add(mutableDictionary)
                    }
                    print("specialiARR \(self.specialityArray)")
                    var mutablesubDictionary:[String:Any] = [:]
                    for i in 0..<(self.profileData?.profileData?.subspecialityList?.count ?? 0)
                    {
                        mutablesubDictionary.add(["subspeciality_id" : self.profileData?.profileData?.subspecialityList?[i].subSpecialityId ?? ""])
                        mutablesubDictionary.add(["subspecialityname" : self.profileData?.profileData?.subspecialityList?[i].subSpecialityname ?? ""])
                        mutablesubDictionary.add(["speciality_id" : self.profileData?.profileData?.subspecialityList?[i].speciality_id ?? ""])
                        self.subSpecialityArray.add(mutablesubDictionary)
                       
                    }
                    print("subspecialiARR \(self.subSpecialityArray)")

//                    self.reloadHeaderView()
                    
                    GenericMethods.setProfileImage(imageView: self.profileImgView,borderColor:UIColor.white)

                    
                    guard let arr1 = self.profileData?.profileData?.additionalPictureList,let arr2 = self.profileData?.profileData?.additionalVideoList
                    else {
                        self.doctorMediaArray = []
                        return
                        
                    }
                    
                    self.doctorMediaArray = NSMutableArray(array: arr1 + arr2)
                    if self.doctorMediaArray.count > 0
                    {
                        self.editPicturesBtnInstance.isHidden = false
                    }
                    guard let arr3 = self.profileData?.profileData?.uploadingPictureList,let arr4 = self.profileData?.profileData?.uploadingVideoList
                        else {
                            self.uploadingMediaArray = []
                            return
                            
                    }
                    
                    self.uploadingMediaArray = NSMutableArray(array: arr3 + arr4)
                    
                    print("uploadingMediaArray \(self.uploadingMediaArray)")
                    
                    self.reloadViews()
                }
                else
                {
                    GenericMethods.showAlertwithPopNavigation(alertMessage: self.profileData?.status?.message ?? "Unable to fetch data. Please try again after sometime.", vc: self)
//                    GenericMethods.showAlert(alertMessage: self.profileData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                }
                
                
            }
            else {
                GenericMethods.showAlertwithPopNavigation(alertMessage: error?.localizedDescription ?? "Something Went Wrong. Please try again.", vc: self)
               
               
                
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
    
    func getIdMethod(listArray:NSMutableArray,type:Int)-> [String]
    {
        var idArray:[String] = []
        if listArray.count == 0
        {
            return [""]
        }
        for i in 0..<(listArray.count)
        {
            if type == 0
            {
               idArray.append((listArray[i] as? [AnyHashable:Any])? ["id"] as? String ?? "")
            }
            else
            {
                idArray.append((listArray[i] as? [AnyHashable:Any])? ["subspeciality_id"] as? String ?? "")
            }
            
        }
        return idArray
    }
    
    func addSpecialityDetailsAPI(type:Int)
    {
        var parameters = Dictionary<String, Any>()
        
        parameters["id"] = getIdMethod(listArray: specialityArray, type: 0) as [String]
        parameters["subid"] = getIdMethod(listArray: subSpecialityArray, type: 1) as [String]
//        parameters["id"] = [""]
//        parameters["subid"] = [""]
        
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
    func removeDictFromArray(searchKey:String,searchString:String,array:NSMutableArray)
    {
        
        let predicate = NSPredicate(format: "\(searchKey) contains[cd] %@", searchString)
        
        let indexes = array.indexesOfObjects(options: []) { (dictionary, index, stop) -> Bool in
            return predicate.evaluate(with: dictionary)
        }
        array.removeObjects(at: indexes)
    }
    //MARK:- Image Picker Methods
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        fileDataArr = []
        fileNameArr = []
        mimeTypeArr = []
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
         instead of `UIImagePickerControllerEditedImage`
         */
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            //MARK: Camera
            print("info \(info)")
            let mediaType = info[.mediaType] as! NSString
            
            if mediaType.isEqual(to: kUTTypeImage as String) {
                self.isPictureUpload = true
                guard let chosenImage = info[.originalImage] as? UIImage else
                {
                    fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
                }
                //                UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil)
                
                let imageData = chosenImage.jpegData(compressionQuality: 0.0)
                
                //                let dataString = imageData!.base64EncodedString(options: .lineLength64Characters)
                //Media is an image info[.imageURL]
                if let imageURL = info[.imageURL] as? URL
                {
                    let imagePath = imageURL.path
                    print("\(imageURL) \n \(imagePath)")
                    //                let fileExtension = imageURL.pathExtension
                    
                    print("mimieType \(FileUpload.mimeTypeForPath(path: imagePath))")
                    let duration: Int = 1 // duration in seconds
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Double(duration) * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                        if self.uploadType == 0
                        {
                            self.updateProfPicUpload(fileData: imageData!, filename: imageURL.lastPathComponent, mimeType: FileUpload.mimeTypeForPath(path: imagePath), keyname: "picture")
                        }
                        else
                        {
                            self.fileDataArr.append(imageData!)
                            self.fileNameArr.append(imageURL.lastPathComponent)
                            self.mimeTypeArr.append(FileUpload.mimeTypeForPath(path: imagePath))
                            
                            self.addDocFilesUpload()
                        }
                        
                        
//                        self.postMethodFileUpload(fileData: imageData!, filename: imageURL.lastPathComponent, mimeType: "\(FileUpload.mimeTypeForPath(path: imagePath))")
                    })
                }
                else
                {
                    let fileManager = FileManager.default
                    if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let filePath =  tDocumentDirectory.appendingPathComponent(AppConstants.storageFolderName)
                        if !fileManager.fileExists(atPath: filePath.path) {
                            do {
                                try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                            } catch {
                                NSLog("Couldn't create document directory")
                            }
                        }
                        else
                        {
                            print("Already exists")
                        }
                        NSLog("Document directory is \(filePath)")
                        
                        let fileURL = filePath.appendingPathComponent("Imageon\(GenericMethods.removeSpaceFromStr(str: "\(GenericMethods.currentDateTime()).jpeg"))")
                        print(fileURL)
                        //writing
                        do {
                            try imageData!.write(to: fileURL, options:[])
                            
                            print(fileURL.path)
                            print("mimieType \(FileUpload.mimeTypeForPath(path: fileURL.path))")
                            if self.uploadType == 0
                            {
                                self.updateProfPicUpload(fileData: imageData!, filename: fileURL.lastPathComponent, mimeType: FileUpload.mimeTypeForPath(path: fileURL.path), keyname: "file")
                            }
                            else
                            {
                                self.fileDataArr.append(imageData!)
                                self.fileNameArr.append(fileURL.lastPathComponent)
                                self.mimeTypeArr.append(FileUpload.mimeTypeForPath(path: fileURL.path))
                                
                                self.addDocFilesUpload()
                            }
//                            postMethodFileUpload(fileData: imageData!, filename: fileURL.lastPathComponent, mimeType: "\(FileUpload.mimeTypeForPath(path: fileURL.path))")
//                            FileUpload.removeFileDataToLocal()
                        }
                        catch {
                            print("failed to write data")
                        }
                    }
                    
                }

                
            } else if mediaType.isEqual(to: kUTTypeMovie as String) {
                self.isPictureUpload = false
                
                let videoURL = info[.mediaURL] as! URL
                //                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath)
                //                {
                //                    UISaveVideoAtPathToSavedPhotosAlbum(videoPath, nil, nil, nil)
                //                }
                do{
                    let videoData = try Data.init(contentsOf: videoURL)
                    if self.uploadType == 0
                    {
                        self.updateProfPicUpload(fileData: videoData, filename: videoURL.lastPathComponent, mimeType: FileUpload.mimeTypeForPath(path: videoURL.path), keyname: "picture")
                    }
                    else
                    {
                        self.fileDataArr.append(videoData)
                        self.fileNameArr.append(videoURL.lastPathComponent)
                        self.mimeTypeArr.append(FileUpload.mimeTypeForPath(path: videoURL.path))
                        
                        self.addDocFilesUpload()
                    }
                }
                catch
                {
                    print("Cannot convert video data")
                }
                // Media is a video
                
            }
        }
        else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            //MARK: Photo Library
            var asset = PHAsset()
            asset = info[.phAsset] as! PHAsset
            if asset.mediaType == .image {
                self.isPictureUpload = true
            }
            else if asset.mediaType == .video
            {
                self.isPictureUpload = false
            }
            
            FileUpload.getURL(of: asset) { (url) in
                print("url is \(url as Any)")
                guard let photoUrl = url else
                {
                    //MARK: Phasset failure
                    guard let chosenImage = info[.originalImage] as? UIImage else
                    {
                        fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
                    }
                    //                UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil)
                    
                    let imageData = chosenImage.jpegData(compressionQuality: 0.0)
                    
                    let fileManager = FileManager.default
                    if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let filePath =  tDocumentDirectory.appendingPathComponent(AppConstants.storageFolderName)
                        if !fileManager.fileExists(atPath: filePath.path) {
                            do {
                                try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                            } catch {
                                NSLog("Couldn't create document directory")
                            }
                        }
                        else
                        {
                            print("Already exists")
                        }
                        NSLog("Document directory is \(filePath)")
                        
                        let fileURL = filePath.appendingPathComponent("Imageon\(GenericMethods.removeSpaceFromStr(str: "\(GenericMethods.currentDateTime()).jpeg"))")
                        print(fileURL)
                        //writing
                        do {
                            try imageData!.write(to: fileURL, options:[])
                            
                            print(fileURL.path)
                            print("mimieType \(FileUpload.mimeTypeForPath(path: fileURL.path))")
                            if self.uploadType == 0
                            {
                                self.updateProfPicUpload(fileData: imageData!, filename: fileURL.lastPathComponent, mimeType: FileUpload.mimeTypeForPath(path: fileURL.path), keyname: "file")
                            }
                            else
                            {
                                self.fileDataArr.append(imageData!)
                                self.fileNameArr.append(fileURL.lastPathComponent)
                                self.mimeTypeArr.append(FileUpload.mimeTypeForPath(path: fileURL.path))
                                
                                self.addDocFilesUpload()
                            }
                            
                        }
                        catch {
                            print("failed to write data")
                        }
                    }
                    return
                }
                do{
                    let photoData = try Data.init(contentsOf: photoUrl)
                    
                    if self.uploadType == 0
                    {
                        self.updateProfPicUpload(fileData: photoData, filename: photoUrl.lastPathComponent, mimeType: FileUpload.mimeTypeForPath(path: photoUrl.path), keyname: "picture")
                    }
                    else
                    {
                        self.fileDataArr.append(photoData)
                        self.fileNameArr.append(photoUrl.lastPathComponent)
                        self.mimeTypeArr.append(FileUpload.mimeTypeForPath(path: photoUrl.path))
                        
                        self.addDocFilesUpload()
                    }
                    
                    
                    
//                    self.postMethodFileUpload(fileData: photoData, filename: photoUrl!.lastPathComponent, mimeType: "\(FileUpload.mimeTypeForPath(path: photoUrl!.path))")
                    
                    //                    let dataString = videoData.base64EncodedString(options: .lineLength64Characters)
                    //                    print(dataString)
                    
                    //                    [self postMethodwithPath:videoUrl withImageData:videoData withPictureName:[videoUrl lastPathComponent]];
                }
                catch
                {
                    print("Cannot convert photo data")
                }
                
            }
            /* UIImage *chosenImage = [info valueForKey:UIImagePickerControllerOriginalImage];
             UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil);
             NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.0);
             NSLog(@"imageData %@",imageData);
             */
            
            
        }
        
        
        
        //        guard let selectedImage = info[.originalImage] as? UIImage else {
        //            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        //        }
        //                let imageData = selectedImage.jpegData(compressionQuality: 0.2)
        //                let imgString = imageData?.base64EncodedString(options: .lineLength64Characters)
        //                print(imgString as Any)
        
        
        //        profileImgView.image = selectedImage
        
        
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    func navigateToEditPictureVC()
    {
        let deletePicVC = self.storyboard?.instantiateViewController(withIdentifier: "deletePicVC") as! DeletePicturesViewController
        deletePicVC.picturesArray = self.doctorMediaArray
        deletePicVC.uploadPicturesArray = self.uploadingMediaArray
        deletePicVC.delegate = self
        let navigateVC = UINavigationController(rootViewController: deletePicVC)
        navigateVC.navigationBar.barTintColor = AppConstants.appGreenColor
        navigateVC.navigationBar.tintColor = UIColor.white
        navigateVC.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.present(navigateVC, animated: true, completion: nil)
    }
    // MARK: - IBActions
    
    @IBAction func profilePicbtnClick(_ sender: Any) {
        self.uploadType = 0
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.imagePicker.delegate = self
            FileUpload.showcamera(type: "picture", imagePicker: self.imagePicker, vc: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.imagePicker.delegate = self
            FileUpload.openGallary(type:"picture",imagePicker: self.imagePicker, vc: self)
            
            
            
        }))
        
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
//            alert.popoverPresentationController?.sourceView = self.profilePicBtnInstance
//            alert.popoverPresentationController?.sourceRect = self.profilePicBtnInstance.bounds
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = []
            
        default:
            break
        }
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addSpecBtnClick(_ sender: Any) {
        
        addSpecialityDetailsAPI(type: 0)
    }
    
    @IBAction func addSubSpecBtnClick(_ sender: Any) {
        addSpecialityDetailsAPI(type: 1)
        
    }
    @IBAction func docAddiPicUploadBtnClick(_ sender: Any) {
        let maxCount = Int(self.profileData?.profileData?.maxcount ?? "") ?? 0
        print(uploadingMediaArray.count)
        if uploadingMediaArray.count == maxCount
        {
            GenericMethods.showYesOrNoAlertWithCompletionHandler(alertTitle: "The ONE", alertMessage: "You already have maximum additional pictures. Do you want to delete existing to add more pictures?") { (alertAction) in
                self.navigateToEditPictureVC()
            }
        }
        else
        {
            self.uploadType = 1
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.imagePicker.delegate = self
                FileUpload.showcamera(type:"media",imagePicker: self.imagePicker, vc: self)
            }))
            
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                //            self.imagePicker.delegate = self
                //            FileUpload.openGallary(imagePicker: self.imagePicker, vc: self, assets: self.selectedAssets)
                
                let mediaCVC = self.storyboard?.instantiateViewController(withIdentifier: "mediaCVC") as! MediaCollectionViewController
                mediaCVC.maxNumberOfSelections =  maxCount - self.uploadingMediaArray.count
                mediaCVC.delegate = self
                let navigateVC = UINavigationController(rootViewController: mediaCVC)
                navigateVC.navigationBar.barTintColor = AppConstants.appGreenColor
                navigateVC.navigationBar.tintColor = UIColor.white
                self.present(navigateVC, animated: true, completion: nil)
                
//                let vc = BSImagePickerViewController()
//                vc.maxNumberOfSelections = maxCount - self.uploadingMediaArray.count
//                self.bs_presentImagePickerController(vc, animated: true, select: { (asset:PHAsset) in
//
//                }, deselect: { (asset:PHAsset) in
//
//                }, cancel: { (assets:[PHAsset]) in
//
//                }, finish: { (outputassets:[PHAsset]) in
//                    self.selectedAssets = []
//                    for i in 0..<outputassets.count
//                    {
//                        self.selectedAssets.append(outputassets[i])
//                    }
//                    print("selectedAssets \(self.selectedAssets)")
//                    self.gettingValuesFromPHAsset(assetsArr: self.selectedAssets)
//
//                }, completion: nil)
                
            }))
            
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            /*If you want work actionsheet on ipad
             then you have to use popoverPresentationController to present the actionsheet,
             otherwise app will crash on iPad */
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
//                alert.popoverPresentationController?.sourceView = self.addPicUploadBtnInstance
//                alert.popoverPresentationController?.sourceRect = self.addPicUploadBtnInstance.bounds
//                alert.popoverPresentationController?.permittedArrowDirections = .up
                alert.popoverPresentationController?.sourceView = self.view
                alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                alert.popoverPresentationController?.permittedArrowDirections = []
                
            default:
                break
            }
            
            self.present(alert, animated: true, completion: nil)
        }

    }
    @IBAction func editPicturesBtnClick(_ sender: Any) {
        navigateToEditPictureVC()
    }
    //MARK : Textfield Editing Methods
    @IBAction func otpTFEditingChange(_ sender: UITextField) {
//        if sender.text!.count == 4
//        {
//            if sender.text == randomNumber
//            {
//                otpHgtConst.constant = 0
//                otpTopConst.constant = 0
//            }
//            else
//            {
//                GenericMethods.showAlert(alertMessage: "Invalid OTP")
//            }
//        }
    }
    @IBAction func mobileEditingChange(_ sender: UITextField) {
        if sender.text!.count == 8
        {
            if sender.text != self.mobileNumber
            {
                sendOTPMethod()
            }

        }
    }
    
    //MARK:- Delegate Method
    func sendDeletePicValues(picArray: NSMutableArray,uploadArray:NSMutableArray) {
        self.doctorMediaArray = NSMutableArray(array: picArray)
        self.uploadingMediaArray = NSMutableArray(array: uploadArray)
        self.doctorPicturesCollectionView.reloadData()
    }
    func sendMediaAssests(assets:[PHAsset])
    {
        self.selectedAssets = []
        for i in 0..<assets.count
        {
            self.selectedAssets.append(assets[i])
        }
        print("selectedAssets \(self.selectedAssets)")
        self.gettingValuesFromPHAsset(assetsArr: self.selectedAssets)
    }
    func gettingValuesFromPHAsset(assetsArr:[PHAsset])
    {
        fileDataArr = []
        fileNameArr = []
        mimeTypeArr = []
        
        for i in 0..<assetsArr.count {
            print("assets index \(assetsArr[i])")
            FileUpload.getURL(of: assetsArr[i]) { (url) in
                print("mediaURL \(String(describing: url))")
                
                func sendAssetDataToServer(mediaURL:URL)
                {
                    do
                    {
                        let mediaData = try Data.init(contentsOf: mediaURL)
                        self.fileDataArr.append(mediaData)
                        self.fileNameArr.append(mediaURL.lastPathComponent)
                        self.mimeTypeArr.append(FileUpload.mimeTypeForPath(path: mediaURL.path))
                        if self.fileDataArr.count == (assetsArr.count)
                        {
                            DispatchQueue.main.async {
                                self.addDocFilesUpload()
                            }
                            
                        }
                    }
                    catch
                    {
                        print("Cannot convert photo data")
                    }
                }
                guard let mediaURL = url else
                {
                    let options = PHImageRequestOptions()
                    options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
                    options.isSynchronous = false
                    options.isNetworkAccessAllowed = true
                    
                    options.progressHandler = {  (progress, error, stop, info) in
                        print("progress: \(progress)")
                    }
                    
                    DispatchQueue.main.async {
                        
                        PHImageManager.default().requestImage(for: assetsArr[i], targetSize: self.view.frame.size, contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: {
                            (image, info) in
                            guard let getImage = image,let dictInfo = info else
                            {
                                GenericMethods.showAlert(alertMessage: "Something went wrong. Try again.")
                                return
                            }
                            print("dict: \(String(describing: dictInfo))")
                            print("image size: \(String(describing: getImage.size))")
                            print("picurl \(String(describing: dictInfo["PHImageFileURLKey"]))")
                            guard let imgUrl = dictInfo["PHImageFileURLKey"] as? URL else
                            {
                                return
                            }
                            sendAssetDataToServer(mediaURL: imgUrl)
                            
                            
                        })
                    }
                    return
                }
                sendAssetDataToServer(mediaURL: mediaURL)
                
            }
        }
    }
    //TODO: File upload
    
    func updateProfPicUpload(fileData:Data,filename:String,mimeType:String,keyname:String)
    {
        //MARK:- Profile picture upload
//        GenericMethods.showLoaderMethod(shownView: self.view, message: "Uploading")
        UIApplication.shared.beginIgnoringInteractionEvents()
        let loadingProfileNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingProfileNotification.mode = MBProgressHUDMode.annularDeterminate
        loadingProfileNotification.label.text = "Uploading"
        
        WebAPIHelper.postMethodFileUpload(shownProgress:loadingProfileNotification,fileData: fileData, filename: filename, mimeType: mimeType, methodName: "upload", keyname: "file", vc: self, success: { (response) in
             print("response \(response as Any)")
            GenericMethods.hideLoaderMethod(view: self.view)
            let responseObject: AnyObject = (response as AnyObject?)!
            guard let status = responseObject.object(forKey: "status") else
            {
                GenericMethods.showAlert(alertMessage: "Something Went Wrong! Please try again")
                return
            }
            if (status as AnyObject).object(forKey: "code") as? String == "0"
            {
                UserDefaults.standard.set(responseObject.object(forKey: "picturepath") as? String ?? "", forKey: "user_image")
                GenericMethods.setProfileImage(imageView: self.profileImgView,borderColor:UIColor.white)
                self.picture = responseObject.object(forKey: "profile") as? String ?? ""
                
                GenericMethods.showAlertMethod(alertMessage: "\((status as AnyObject).object(forKey: "message") as? String ?? "Success")")
            }
            else
            {
                GenericMethods.showAlert(alertMessage: "Something Went Wrong! Please try again")
            }
            
            
        }, Failure: { (error) in
            print(error.localizedDescription)
            })
        

    }
    func addDocFilesUpload()
    {
        //MARK:- Additional Pictures upload
        self.isPictureUpload = true
        
//        GenericMethods.showLoaderMethod(shownView: self.view, message: "Uploading")
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.annularDeterminate
        loadingNotification.label.text = "Uploading"
        
        
        print("fileDataArr \(fileDataArr)\n fileNameArr \(fileNameArr)\n mimeTypeArr \(mimeTypeArr)\n")
        
        WebAPIHelper.addDoctorPicFileUpload(shownProgress:loadingNotification,fileData: fileDataArr, filename: fileNameArr, mimeType: mimeTypeArr, methodName: "multipleupload", vc: self, success: { (response) in
            print("response \(response as Any)")
            GenericMethods.hideLoaderMethod(view: self.view)
            
            let responseObject: AnyObject = (response as AnyObject?)!
            guard let status = responseObject.object(forKey: "status") else
            {
                GenericMethods.showAlert(alertMessage: "Something Went Wrong! Please try again")
                return
            }
            if (status as AnyObject).object(forKey: "code") as? String == "0"
            {
                let picPathArray:[String] = response?.object(forKey: "picturepath") as! [String]
                
                for i in 0..<picPathArray.count
                {
                    self.doctorMediaArray.add(picPathArray[i])
                }
                
                let uploadingDataArray:[String] = response?.object(forKey: "data") as! [String]
                
                for i in 0..<uploadingDataArray.count
                {
                    self.uploadingMediaArray.add(uploadingDataArray[i])
                }
                FileUpload.removeFileDataToLocal()
                self.doctorPicturesCollectionView.reloadData()
                GenericMethods.showAlert(alertMessage: "Uploaded sucessfully")
            }
            else
            {
                GenericMethods.showAlert(alertMessage: "Something Went Wrong! Please try again")
            }
            
            
            
        }, Failure: { (error) in
            print(error.localizedDescription)
        })
    }
    func otpSuccessMethod()
    {
        self.otp = self.randomNumber
        self.otpTF.text = self.otp
        self.otpHgtConst.constant = 45
        self.otpTopConst.constant = 15
        let _ = self.otpTF.becomeFirstResponder()
    }
    
    func sendOTPMethod()
    {
        randomNumber = AppConstants.fourDigitNumber
        
        var parameters = Dictionary<String, Any>()
        parameters["mobile"] = mobileTF.text
        parameters["Type"] = "Register"
        parameters["OTP"] = randomNumber
        
        GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
        apiManager.sendOTPAPI(parameters: parameters) { (status, showError, response, error) in
            self.view.endEditing(true)
            GenericMethods.hideLoaderMethod(view: self.view)
            
            if status == true {
                self.sendOTPData = response
                
                if self.sendOTPData?.status?.code == "0" {
                    //MARK: sendOTP Success Details
                    
                    let alert = UIAlertController(title: nil, message: self.sendOTPData?.status?.message ?? "", preferredStyle: .alert)
                    
                    UIApplication.shared.topMostViewController()?.present(alert, animated: true)
                    let duration: Int = 1 // duration in seconds
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Double(duration) * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                        alert.dismiss(animated: true)
                        self.otpSuccessMethod()
                    })
                    
                }
                else
                {
                    GenericMethods.showAlert(alertMessage: self.sendOTPData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                }
                
            }
            else {
                GenericMethods.showAlert(alertMessage:error?.localizedDescription ?? "")
                
            }
        }
    }
    @objc func profileUpdateMethod()
    {
        self.view.endEditing(true)
        if GenericMethods.isStringEmpty(emailTF.text)
        {
            GenericMethods.showAlert(alertMessage: "Please enter mail id")
        }
        else if GenericMethods.isStringEmpty(mobileTF.text)
        {
            GenericMethods.showAlert(alertMessage: "Please enter mail id")
        }
        else if !GenericMethods.validate(YourEMailAddress: emailTF.text!)
        {
            GenericMethods.showAlertMethod(alertMessage: "Enter valid EmailId")
        }
        else if mobileTF.text!.count < 8
        {
            GenericMethods.showAlertMethod(alertMessage: "Invalid mobile number")
        }
        else if otpHgtConst.constant == 45 && otpTF.text!.count == 4 && self.otp != self.randomNumber
        {
            GenericMethods.showAlertMethod(alertMessage: "Invalid OTP")
        }
        else
        {
            var imgArr = Array<String>()
            var videoArr = Array<String>()
            print("update success")
            let specArr:NSMutableArray = NSMutableArray(array: getIdMethod(listArray: specialityArray, type: 0) as [String])
            let specArrString = specArr.componentsJoined(by: ",")
            print("specArrString\(specArrString)")
            
            let subspecArr:NSMutableArray = NSMutableArray(array: getIdMethod(listArray: subSpecialityArray, type: 1) as [String])
            let subspecArrString = subspecArr.componentsJoined(by: ",")
            print("subspecArrString\(subspecArrString)")
            
            
            
            for i in 0..<uploadingMediaArray.count
            {
                let str = FileUpload.checkImgOrVideofromURL(filePath: uploadingMediaArray[i] as! String)
                if str == "image"
                {
                    imgArr.append(uploadingMediaArray[i] as? String ?? "")
                }
                else if str == "video"
                {
                    videoArr.append(uploadingMediaArray[i] as? String ?? "")
                }
            }
            
            print("imgarr \(imgArr) \n videoArr \(videoArr)")
            
            var parameters = Dictionary<String, Any>()
            parameters["user_id"] = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
            parameters["mobile"] = mobileTF.text
            parameters["email"] = emailTF.text
            parameters["short_biography"] = biographyTextView.text
            parameters["picture"] = self.picture
            
            parameters["additionalpicture"] = imgArr
            parameters["additionalvideo"] = videoArr
            parameters["speciality"] = specArrString
            parameters["subspeciality"] = subspecArrString
            
            
            GenericMethods.showLoaderMethod(shownView: self.view, message: "Loading")
            
            apiManager.updateProfileDetailsAPI(parameters: parameters) { (status, showError, response, error) in
                
                GenericMethods.hideLoaderMethod(view: self.view)
                
                if status == true {
                    self.profileUpdateData = response
                    print(self.profileUpdateData?.status?.code ?? "empty")
                    if self.profileUpdateData?.status?.code == "0" {
                        //MARK: Update Success Details
                        
                        GenericMethods.showAlertwithPopNavigation(alertMessage: self.profileUpdateData?.status?.message ?? "", vc: self)
                        
                        
                        
                    }
                    else
                    {
                        GenericMethods.showAlert(alertMessage: self.profileUpdateData?.status?.message ?? "Unable to fetch data. Please try again after sometime.")
                    }
                    
                }
                else {
                    GenericMethods.showAlert(alertMessage:error?.localizedDescription ?? "")
                    
                }
            }
            
        }
        
        
        
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
            docSpecialityCell?.deleteBtnInst.tag = indexPath.row
            docSpecialityCell?.deleteBtnInst.addTarget(self, action: #selector(specialityDeleteMethod(button:)), for: .touchUpInside)
            designMethod()
            
            docSpecialityCell?.specialityLbl.text = (self.specialityArray[indexPath.item] as? [AnyHashable:Any])? ["name"] as? String ?? ""
            
            docSpecialityCell?.specialityLbl.sizeToFit()

            return docSpecialityCell!
        case subSpecialityCollectionView:
            docSpecialityCell = collectionView.dequeueReusableCell(withReuseIdentifier: "docSpecialityCell", for: indexPath) as? DoctorSpecialityCollectionViewCell
            docSpecialityCell?.deleteBtnInst.tag = indexPath.row
            docSpecialityCell?.deleteBtnInst.addTarget(self, action: #selector(subSpecialityDeleteMethod(button:)), for: .touchUpInside)
            designMethod()
            docSpecialityCell?.specialityLbl.text = (self.subSpecialityArray[indexPath.item] as? [AnyHashable:Any])? ["subspecialityname"] as? String ?? ""
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

            let size = ((self.specialityArray[indexPath.item] as? [AnyHashable:Any])? ["name"] as? NSString)!.size(withAttributes: nil)
            print("size \(size.width)")
            return CGSize(width: (size.width + 44) , height: cellHeight)
            
        case subSpecialityCollectionView:
            let size = ((self.subSpecialityArray[indexPath.item] as? [AnyHashable:Any])? ["subspecialityname"] as? NSString)!.size(withAttributes: nil)
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
extension ProfileViewController:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case otpTF:
            if textField.text!.count > 3 && range.length == 0
            {
                return false
            }
            else
            {
                otpTopConst.constant = 15
                otpHgtConst.constant = 45
                return true
            }
            
        case mobileTF:
            
            if textField.text!.count > 7 && range.length == 0
            {
                return false
            }
            else
            {
                otpTopConst.constant = 0
                otpHgtConst.constant = 0
                return true
            }
        default:
            break
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF
        {
            let _ = emailTF.resignFirstResponder()
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
//        case mobileTF:
            
//            if textField.text!.count == 8 && textField.text! != self.mobileNumber
//            {
//                sendOTPMethod()
//            }
        case otpTF:
            if textField.text!.count == 4
            {
                if textField.text == randomNumber
                {
                    otpHgtConst.constant = 0
                    otpTopConst.constant = 0
                }
                else
                {
                    GenericMethods.showAlert(alertMessage: "Invalid OTP")
                }
            }
        default:
            break
        }
    }
    
}
extension ProfileViewController:UITextViewDelegate
{
   
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 250
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        let scrollPoint : CGPoint = CGPoint(x:0 , y: biographyTextView.frame.origin.y)
        self.scrollViewInstance.setContentOffset(scrollPoint, animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let zero:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.scrollViewInstance.contentInset = zero;
    }
}
