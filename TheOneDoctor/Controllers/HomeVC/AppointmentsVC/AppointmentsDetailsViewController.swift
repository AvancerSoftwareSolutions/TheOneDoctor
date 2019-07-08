//
//  AppointmentsDetailsViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 14/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
// appointmentsDetailsVC

import UIKit
import Alamofire
import Photos
import MobileCoreServices

class AppointmentsDetailsViewController: UIViewController,sendMediaAssetsDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var userTypeLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var clinicNameLbl: UILabel!
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var referADoctorBtnInst: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var prescriptionUploadBtnInst: UIButton!
    @IBOutlet weak var referralLbl: UILabel!
    
    @IBOutlet weak var prescriptionCVCHgtConst: NSLayoutConstraint!
    
    //MARK:- Variables
    var docPicturesCell:DoctorPicturesCollectionViewCell? = nil
    var appointDetailsData:AppointmentsDataModel?
    var selectedAssets = [PHAsset]()
    var fileDataArr = [Data]()
    var fileNameArr = [String]()
    var mimeTypeArr = [String]()
    var imagePicker = UIImagePickerController()
    let apiManager = APIManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        referralLbl.isHidden = true
    
        collectionView.register(UINib(nibName: "DoctorPicturesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "docPicturesCell")
        referADoctorBtnInst.layer.cornerRadius = 5.0
        referADoctorBtnInst.layer.masksToBounds = true
        
        userTypeLbl.layer.cornerRadius = 5.0
        userTypeLbl.layer.masksToBounds = true
        userTypeLbl.layer.borderColor = AppConstants.appyellowColor.cgColor
        userTypeLbl.layer.borderWidth = 1.0
        
        userImgView.layer.cornerRadius = userImgView.frame.height / 2
        userImgView.layer.masksToBounds = true
        userImgView.layer.borderColor = UIColor.black.cgColor
        userImgView.layer.borderWidth = 1.0
        prescriptionCVCHgtConst.constant = 0
        
        loadingAppointmentDetailsAPI()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Appointment Details
    func loadingAppointmentDetailsAPI()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppConstants.dayMonthYearFormat
        self.title = self.appointDetailsData?.appointmentId
        self.userNameLbl.text = self.appointDetailsData?.patientName
        self.clinicNameLbl.text = self.appointDetailsData?.clinicName
        
        if  !GenericMethods.isStringEmpty(self.appointDetailsData?.referredDoctorName ?? "")
        {
            referralLbl.text = "Referred by: Dr. \(self.appointDetailsData?.referredDoctorName ?? "")"
        }
        else
        {
            referralLbl.text = ""
        }
        
        if self.appointDetailsData?.imageArray?.count ?? 0 > 0
        {
            prescriptionCVCHgtConst.constant = 120
            prescriptionUploadBtnInst.isHidden = true
        }
        else
        {
            prescriptionCVCHgtConst.constant = 0
        }
        
        self.dateTimeLbl.text = "\(self.appointDetailsData?.fromTime ?? "") \(GenericMethods.changeDateFormatting(createdDateStr: self.appointDetailsData?.date ?? "", inputDateFormat: "yyyy-MM-dd", resultDateFormat: "E, MMM d"))"
        
        let userType = self.appointDetailsData?.type
        switch userType {
        case "Normal":
            self.userTypeLbl.text = "Normal"
        case "VIP":
            self.userTypeLbl.text = "VIP"
        case "Referral":
            self.referralLbl.isHidden = false
            self.referralLbl.text = "Referred By: Dr. \(self.appointDetailsData?.referredDoctorName ?? "")"
        case "WalkIn":
            self.userTypeLbl.text = "Walk In"
        default:
            break
        }
        self.userImgView.sd_setShowActivityIndicatorView(true)
        self.userImgView.sd_setIndicatorStyle(.gray)
        self.userImgView.contentMode = .scaleAspectFit
        self.userImgView.image = nil
        self.userImgView.sd_setImage(with: URL(string: self.appointDetailsData?.picture ?? ""), placeholderImage: AppConstants.docImgListplaceHolderImg,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
            if error == nil
            {
                self.userImgView.image = image
                
            }
            else{
                print("error is \(error?.localizedDescription as Any)")
                self.userImgView.image = nil
            }
        })
        
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
                    
//                    DispatchQueue.main.async {
                    
                    PHImageManager.default().requestImage(for: assetsArr[i], targetSize: self.view.frame.size, contentMode: PHImageContentMode.aspectFill, options: options, resultHandler: {
                        (image, info) in
                        guard let getImage = image,let dictInfo = info else
                        {
                            GenericMethods.showAlert(alertMessage: "Error in retrieving image. Please try again")
                            return
                        }
//                            print("dict: \(String(describing: dictInfo))")
//                            print("image size: \(String(describing: getImage.size))")
                        print("picurl \(String(describing: dictInfo["PHImageFileURLKey"]))")
                        guard let imgUrl = dictInfo["PHImageFileURLKey"] as? URL else
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
                                
                                let fileURL = filePath.appendingPathComponent("Imageon\(GenericMethods.removeSpaceFromStr(str: "\(GenericMethods.currentDateTime()).png"))")
                                print(fileURL)
                                guard let imgData = getImage.pngData()
                                    else
                                {
                                    GenericMethods.showAlert(alertMessage: "Error in retrieving image. Please try again")
                                    return
                                }
                                //writing
                                do {
                                    try imgData.write(to: fileURL, options:[])
                                    
                                    print(fileURL.path)
                                    print("mimieType \(FileUpload.mimeTypeForPath(path: fileURL.path))")
                                    sendAssetDataToServer(mediaURL: fileURL)
                                    self.fileDataArr.append(imgData)
                                    self.fileNameArr.append(fileURL.lastPathComponent)
                                    self.mimeTypeArr.append(FileUpload.mimeTypeForPath(path: fileURL.path))
                                    if self.fileDataArr.count == (assetsArr.count)
                                    {
                                        DispatchQueue.main.async {
                                            self.addDocFilesUpload()
                                        }
                                        
                                    }
                                    
                                }
                                catch {
                                    print("failed to write data")
                                    GenericMethods.showAlert(alertMessage: "Error in retrieving image. Please try again")
                                }
                            }
                            return
                        }
                        sendAssetDataToServer(mediaURL: imgUrl)
                        
                        
                    })
//                    }
                    return
                }
                sendAssetDataToServer(mediaURL: mediaURL)
                
            }
        }
    }
    func addDocFilesUpload()
    {
        //MARK:- Prescription File upload
        
        //        GenericMethods.showLoaderMethod(shownView: self.view, message: "Uploading")
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.annularDeterminate
        loadingNotification.label.text = "Uploading"
        
        for i in 0..<fileDataArr.count
        {
            let data = fileDataArr[i]
            let image = UIImage(data: data)
            let pngData = image!.pngData()
            print("pngData\(i) : \(String(describing: pngData))")
//            fileDataArr[i] = pngData!
        }
        
        print("fileDataArr \(fileDataArr)\n fileNameArr \(fileNameArr)\n mimeTypeArr \(mimeTypeArr)\n")
        
        let parameters:Parameters = ["id":self.appointDetailsData?.id ?? 0,"appointment_id":self.appointDetailsData?.appointmentId ?? "","doctor_id":UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int]
        print("parameters\(parameters)")
        
        WebAPIHelper.prescriptionPicFileUpload(shownProgress:loadingNotification, parameters: parameters,fileData: fileDataArr, filename: fileNameArr, mimeType: mimeTypeArr, methodName: "\(apiManager.prescriptionBaseURL)Appointment/PrescriptionApprove", vc: self, success: { (response) in
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
               
                GenericMethods.showAlertwithPopNavigation(alertMessage: (status as AnyObject).object(forKey: "message") as? String ?? "Uploaded sucessfully", vc: self)

            }
            else
            {
                GenericMethods.showAlert(alertMessage: "Something Went Wrong! Please try again")
            }

        }, Failure: { (error) in
            print(error.localizedDescription)
        })
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
                        
                            self.fileDataArr.append(imageData!)
                            self.fileNameArr.append(imageURL.lastPathComponent)
                            self.mimeTypeArr.append(FileUpload.mimeTypeForPath(path: imagePath))
                            
                            self.addDocFilesUpload()
                      
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
                            self.fileDataArr.append(imageData!)
                            self.fileNameArr.append(fileURL.lastPathComponent)
                            self.mimeTypeArr.append(FileUpload.mimeTypeForPath(path: fileURL.path))
                            
                            self.addDocFilesUpload()
                            
                        }
                        catch {
                            print("failed to write data")
                        }
                    }
                    
                }
                
                
            }
        }
        else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            //MARK: Photo Library
            var asset = PHAsset()
            asset = info[.phAsset] as! PHAsset
            
            
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
                           
                            self.fileDataArr.append(imageData!)
                            self.fileNameArr.append(fileURL.lastPathComponent)
                            self.mimeTypeArr.append(FileUpload.mimeTypeForPath(path: fileURL.path))
                            
                            self.addDocFilesUpload()
                            
                        }
                        catch {
                            print("failed to write data")
                        }
                    }
                    return
                }
                do{
                    let photoData = try Data.init(contentsOf: photoUrl)
                    
                    
                        self.fileDataArr.append(photoData)
                        self.fileNameArr.append(photoUrl.lastPathComponent)
                        self.mimeTypeArr.append(FileUpload.mimeTypeForPath(path: photoUrl.path))
                        
                        self.addDocFilesUpload()
                    
                }
                catch
                {
                    print("Cannot convert photo data")
                }
                
            }
            
            
            
        }

        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- IBActions
    
    @IBAction func referDoctorBtnClick(_ sender: Any) {
        let doctorListVC = self.storyboard?.instantiateViewController(withIdentifier: "doctorListVC") as! DoctorListViewController
        doctorListVC.appointmentId = self.appointDetailsData?.appointmentId
        self.navigationController?.pushViewController(doctorListVC, animated: true)
    }
    @IBAction func prescriptionUploadBtnClick(_ sender: Any)
    {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.imagePicker.delegate = self
            FileUpload.showcamera(type:"media",imagePicker: self.imagePicker, vc: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            //            self.imagePicker.delegate = self
            //            FileUpload.openGallary(imagePicker: self.imagePicker, vc: self, assets: self.selectedAssets)
            
            let mediaCVC = self.storyboard?.instantiateViewController(withIdentifier: "mediaCVC") as! MediaCollectionViewController
            mediaCVC.maxNumberOfSelections = 4
            mediaCVC.delegate = self
            let navigateVC = UINavigationController(rootViewController: mediaCVC)
            navigateVC.navigationBar.barTintColor = AppConstants.appGreenColor
            navigateVC.navigationBar.tintColor = UIColor.white
            self.present(navigateVC, animated: true, completion: nil)
            
            
            
        }))
        
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = []
            
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendMediaAssests(assets: [PHAsset]) {
        self.selectedAssets = []
        for i in 0..<assets.count
        {
            self.selectedAssets.append(assets[i])
        }
        print("selectedAssets \(self.selectedAssets)")
        self.gettingValuesFromPHAsset(assetsArr: self.selectedAssets)
    }
    

}
extension AppointmentsDetailsViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.appointDetailsData != nil {
            return (self.appointDetailsData?.imageArray?.count) ?? 0
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        docPicturesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "docPicturesCell", for: indexPath) as? DoctorPicturesCollectionViewCell
        
        GenericMethods.createThumbnailOfVideoFromRemoteUrl(url: self.appointDetailsData?.imageArray?[indexPath.item] ?? "",imgView: docPicturesCell!.DocPicImgView,playImgView: docPicturesCell!.playImgView)
        
        return docPicturesCell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imgArr = NSMutableArray(array: self.appointDetailsData?.imageArray ?? [])
            let previewMediaVC = self.storyboard?.instantiateViewController(withIdentifier: "previewMediaVC") as! PreviewMediaViewController
            previewMediaVC.mediaArray = imgArr
            self.navigationController?.present(previewMediaVC, animated: true, completion: nil)
    }
}
