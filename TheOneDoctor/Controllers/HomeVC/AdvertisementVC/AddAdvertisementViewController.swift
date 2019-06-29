//
//  AddAdvertisementViewController.swift
//  TheOneDoctor
//
//  Created by MyMac on 20/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import Alamofire
import Photos
import MobileCoreServices

class AddAdvertisementViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollViewInstance: UIScrollView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageUploadBtnInstance: UIButton!
    
    @IBOutlet weak var advtTextView: UITextView!
    @IBOutlet weak var submitBtnInstance: UIButton!
    @IBOutlet weak var imgContainerViewHgtConst: NSLayoutConstraint! // 150
    
    @IBOutlet weak var advertisementImageView: UIImageView!
    
    
    // MARK: - Variables
    var sendDict:[AnyHashable:Any] = [:]
    let apiManager = APIManager()
    var fileNameStr = ""
    var mimeTypeStr = ""
    var uploadfileData = Data()
    var imgHeight = ""
    var imgWidth = ""
    var alamoFireManager : SessionManager?
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Advertisement"
        
        self.imgContainerViewHgtConst.constant = 0
        
        GenericMethods.roundedCornerTextView(textView: advtTextView)
        GenericMethods.setButtonAttributes(button: submitBtnInstance, with: "Submit")
        GenericMethods.setButtonAttributes(button: imageUploadBtnInstance, with: "Image Upload")
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneWithNumberPad))]
        numberToolbar.sizeToFit()
        advtTextView.inputAccessoryView = numberToolbar
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    @objc func doneWithNumberPad()
    {
        let _ = advtTextView.resignFirstResponder()
        
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
    override func viewDidLayoutSubviews() {
        scrollViewInstance.contentSize = CGSize(width: scrollViewInstance.frame.width, height: submitBtnInstance.frame.origin.y+submitBtnInstance.frame.height+10)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewInstance.contentOffset = CGPoint(x: 0, y: scrollViewInstance.contentOffset.y)
    }
    
    //MARK:- Image Picker Methods
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
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
                        
                            self.updateProfPicUpload(fileData: imageData!, filename: imageURL.lastPathComponent, mimeType: FileUpload.mimeTypeForPath(path: imagePath), keyname: "picture")
                        
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
                            
                                self.updateProfPicUpload(fileData: imageData!, filename: fileURL.lastPathComponent, mimeType: FileUpload.mimeTypeForPath(path: fileURL.path), keyname: "file")
                            
                                FileUpload.removeFileDataToLocal()
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
                            
                                self.updateProfPicUpload(fileData: imageData!, filename: fileURL.lastPathComponent, mimeType: FileUpload.mimeTypeForPath(path: fileURL.path), keyname: "file")
                            
                            
                        }
                        catch {
                            print("failed to write data")
                        }
                    }
                    return
                }
                do{
                    let photoData = try Data.init(contentsOf: photoUrl)
                    
                    
                        self.updateProfPicUpload(fileData: photoData, filename: photoUrl.lastPathComponent, mimeType: FileUpload.mimeTypeForPath(path: photoUrl.path), keyname: "file")
                    
                    
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

    // MARK: - IBActions
    @IBAction func imageUploadBtnClick(_ sender: Any)
    {
        
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
    func updateProfPicUpload(fileData:Data,filename:String,mimeType:String,keyname:String)
    {
        //MARK:- Profile picture upload
        
        self.uploadfileData = fileData
        self.fileNameStr = filename
        self.mimeTypeStr = mimeType
        
        //        print("uploadFile \(self.uploadfileData) \n filename \(self.fileNameStr) mimeTypeStr \(self.mimeTypeStr)")
        self.imgContainerViewHgtConst.constant = 150
        self.advertisementImageView.image = UIImage(data: self.uploadfileData)
        
        
        guard let imageWidth = Double(imgWidth),let imageHeight = Double(imgHeight) else
        {
            self.uploadfileData = Data()
            self.mimeTypeStr = ""
            return
        }
        guard let fileImg = UIImage(data: fileData) else
        {
            self.uploadfileData = Data()
            self.mimeTypeStr = ""
            return
        }
        print("fileImg \(fileImg.size.width),\(fileImg.size.height)")
        let img = GenericMethods.ResizeImage(image: fileImg, targetSize: CGSize(width: imageWidth, height: imageHeight))
        
        guard let pngData = img.pngData() else
        {
            self.uploadfileData = Data()
            self.mimeTypeStr = ""
            return
        }
        self.uploadfileData = pngData
        self.mimeTypeStr = ".png"
        print("resultant image is \(img.size.width),\(img.size.height)")
        
        
    }
    
    @IBAction func submitBtnClick(_ sender: Any)
    {

        if GenericMethods.isStringEmpty(fileNameStr)
        {
            GenericMethods.showAlert(alertMessage: "Please upload image")
        }
            else if GenericMethods.isStringEmpty(advtTextView.text)
        {
            GenericMethods.showAlert(alertMessage: "Please enter description")
        }
        else
        {
        
            if GenericMethods.isStringEmpty(fileNameStr)
            {
                GenericMethods.showAlert(alertMessage: "Please upload advertisement image")
            }
            else if GenericMethods.isStringEmpty(advtTextView.text)
            {
                GenericMethods.showAlert(alertMessage: "Please enter advertisement description.")
            }
            else if GenericMethods.isStringEmpty(mimeTypeStr)
            {
                GenericMethods.showAlert(alertMessage: "Error in retrieving image. Please try again.")
            }
            else
            {
                
                UIApplication.shared.beginIgnoringInteractionEvents()
                let loadingProfileNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                loadingProfileNotification.mode = MBProgressHUDMode.annularDeterminate
                loadingProfileNotification.label.text = "Uploading"
                
                var parameters = Dictionary<String, Any>()
                parameters["doctor_id"] = UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
                parameters["speciality"] = sendDict["speciality"]
                parameters["typeid"] = sendDict["typeid"]
                parameters["priceid"] = sendDict["priceid"]
                parameters["date"] = sendDict["date"]
                parameters["comments"] = advtTextView.text
                parameters["no_of_days"] = sendDict["no_of_days"]
                parameters["amount"] = sendDict["amount"]
                print(parameters)
                
                
                if ReachabilityManager.shared.isConnectedToNetwork() == false
                    
                {
                    GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "The Internet connection appears to be offline.")
                    
                }
                else
                {
                    let configuration = URLSessionConfiguration.default
                    configuration.timeoutIntervalForRequest = AppConstants.uploadFileTimeOutSeconds
                    configuration.timeoutIntervalForResource = AppConstants.uploadFileTimeOutSeconds
                    alamoFireManager = Alamofire.SessionManager(configuration: configuration)
                    
                    alamoFireManager?.upload(multipartFormData: { (multipartFormData: MultipartFormData) in
                        multipartFormData.append(self.uploadfileData, withName: "file", fileName: self.fileNameStr, mimeType: self.mimeTypeStr)
                        
                        for (key, value) in parameters {
                            print("value is \(value)")
                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                        }
                    }, to: "\(apiManager.fileUploadBaseURL)Adsupdate", encodingCompletion: { (encodingResult) in
                        
                        
                        GenericMethods.hideLoading()
                        
                        print(encodingResult)
                        switch encodingResult {
                            
                        case .success(let upload, _, _):
                            print(upload.response as Any)
                            print("response Data is \(upload.responseData as Any)")
                            upload.uploadProgress { progress in
                                
                                
                                loadingProfileNotification.progress = Float(progress.fractionCompleted)
                            }
                            upload.responseJSON { response in
                                
                                //                        print("response is \(response.response as Any)")
                                //                        print(response.request as Any)
                                //                        print(response.result)
                                
                                switch response.result {
                                    
                                case .success(let json):
                                    GenericMethods.hideLoaderMethod(view: self.view)
                                    
                                    let y: AnyObject = (json as AnyObject?)!
                                    if let str:Int = y.object(forKey: "error_code") as? Int
                                    {
                                        print(str)
                                        GenericMethods.showAlert(alertMessage: "Something Went Wrong! Please try again")
                                    }
                                    else
                                    {
                                        //                                    success(json as AnyObject?)
                                        print("response \(response as Any)")
                                        GenericMethods.hideLoaderMethod(view: self.view)
                                        
                                        let responseObject: AnyObject = (json as AnyObject?)!
                                        guard let status = responseObject.object(forKey: "status") else
                                        {
                                            GenericMethods.showAlert(alertMessage: "Something Went Wrong! Please try again")
                                            return
                                        }
                                        if (status as AnyObject).object(forKey: "code") as? String == "0"
                                        {
                                            
                                            
                                            GenericMethods.showAlertwithPopNavigation(alertMessage: (status as AnyObject).object(forKey: "message") as? String ?? "Success", vc: self)
                                            
                                            
                                            
                                        }
                                        else
                                        {
                                            GenericMethods.showAlert(alertMessage: "Something Went Wrong! Please try again")
                                        }
                                    }
                                    
                                    
                                case .failure(let error):
                                    GenericMethods.hideLoaderMethod(view: self.view)
                                    
                                    print("failure error is \(error)")
                                    
                                    GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "\(error.localizedDescription)")
                                }
                            }
                        case .failure(let encodingError):
                            GenericMethods.hideLoaderMethod(view: self.view)
                            GenericMethods.showAlert(alertMessage: encodingError.localizedDescription)
                            print("encodingError:\(encodingError)")
                        }
                    })
                    
                    
//                    Alamofire.upload(multipartFormData: { (multipartFormData: MultipartFormData) in
//                        multipartFormData.append(self.uploadfileData, withName: "file", fileName: self.fileNameStr, mimeType: self.mimeTypeStr)
//
//                        for (key, value) in parameters {
//                            print("value is \(value)")
//                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
//                        }
//                    }, to: "\(apiManager.fileUploadBaseURL)Adsupdate", encodingCompletion: { (encodingResult) in
//
//
//                        GenericMethods.hideLoading()
//
//                        print(encodingResult)
//                        switch encodingResult {
//
//                        case .success(let upload, _, _):
//                            print(upload.response as Any)
//                            print("response Data is \(upload.responseData as Any)")
//                            upload.uploadProgress { progress in
//
//
//                                loadingProfileNotification.progress = Float(progress.fractionCompleted)
//                            }
//                            upload.responseJSON { response in
//
//                                //                        print("response is \(response.response as Any)")
//                                //                        print(response.request as Any)
//                                //                        print(response.result)
//
//                                switch response.result {
//
//                                case .success(let json):
//                                    GenericMethods.hideLoaderMethod(view: self.view)
//
//                                    let y: AnyObject = (json as AnyObject?)!
//                                    if let str:Int = y.object(forKey: "error_code") as? Int
//                                    {
//                                        print(str)
//                                        GenericMethods.showAlert(alertMessage: "Something Went Wrong! Please try again")
//                                    }
//                                    else
//                                    {
//                                        //                                    success(json as AnyObject?)
//                                        print("response \(response as Any)")
//                                        GenericMethods.hideLoaderMethod(view: self.view)
//
//                                        let responseObject: AnyObject = (json as AnyObject?)!
//                                        guard let status = responseObject.object(forKey: "status") else
//                                        {
//                                            GenericMethods.showAlert(alertMessage: "Something Went Wrong! Please try again")
//                                            return
//                                        }
//                                        if (status as AnyObject).object(forKey: "code") as? String == "0"
//                                        {
//
//
//                                            GenericMethods.showAlertwithPopNavigation(alertMessage: (status as AnyObject).object(forKey: "message") as? String ?? "Success", vc: self)
//
//
//
//                                        }
//                                        else
//                                        {
//                                            GenericMethods.showAlert(alertMessage: "Something Went Wrong! Please try again")
//                                        }
//                                    }
//
//
//                                case .failure(let error):
//                                    GenericMethods.hideLoaderMethod(view: self.view)
//
//                                    print("failure error is \(error)")
//
//                                    GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "\(error.localizedDescription)")
//                                }
//                            }
//                        case .failure(let encodingError):
//                            GenericMethods.hideLoaderMethod(view: self.view)
//                            GenericMethods.showAlert(alertMessage: encodingError.localizedDescription)
//                            print("encodingError:\(encodingError)")
//                        }
//                    })
                    
                    
                }
            }
        
        }
        
       
    }
    
}
extension AddAdvertisementViewController:UITextViewDelegate
{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 250
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        let scrollPoint : CGPoint = CGPoint(x:0 , y: advtTextView.frame.origin.y)
        self.scrollViewInstance.setContentOffset(scrollPoint, animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let zero:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.scrollViewInstance.contentInset = zero;
    }
}
