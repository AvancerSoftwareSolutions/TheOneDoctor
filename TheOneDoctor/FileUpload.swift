//
//  FileUpload.swift
//  RapidWallet
//
//  Created by MyMac on 2/5/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import Foundation
import Photos
import Alamofire
import MobileCoreServices

class FileUpload: NSObject {
    

    class func exportOptionMethod(sender:UIBarButtonItem,vc:UIViewController,excelCompletionHandler:@escaping () -> Void,pdfCompletionHandler:@escaping () -> Void)
    {
        let optionsController = UIAlertController(title: "Export as", message: nil, preferredStyle: .actionSheet)
        optionsController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        optionsController.view.tintColor = AppConstants.khudColour
        
        let subView: UIView? = optionsController.view.subviews.first
        let alertContentView: UIView? = subView?.subviews.first
        alertContentView?.backgroundColor = UIColor.white
        alertContentView?.layer.cornerRadius = 5
//        let array = ["Excel","PDF"]
            let  excelAction = UIAlertAction(title: "Excel", style: .default, handler: { action in
                
                excelCompletionHandler()
            })
            optionsController.addAction(excelAction)
        
        let  pdfAction = UIAlertAction(title: "PDF", style: .default, handler: { action in
            
            pdfCompletionHandler()
            
        })
        optionsController.addAction(pdfAction)
            
        optionsController.modalPresentationStyle = .popover
        
        let popPresenter: UIPopoverPresentationController? = optionsController.popoverPresentationController
        popPresenter?.barButtonItem = sender
        popPresenter?.sourceView = vc.view
        popPresenter?.sourceRect = vc.view?.bounds ?? CGRect.zero
        DispatchQueue.main.async(execute: {
            //    self.hud.hide(animated: true)
            //[self.tableView reloadData];
            UIApplication.shared.topMostViewController()?.present(optionsController, animated: true)
        })
    }
    class func exportFileMethod(vc:UIViewController,url:String,params:Parameters)
    { //"http://192.168.1.9/Avancer_rapidwallet_testing/Apidownload/GetFinanceReportExcel"
        print("url exportFile is \(AppConstants.downloadURL)")
        WebAPIHelper.startDownloadWithPost(audioUrl: url, params: params, vc: vc, success:
            { (destinationURL) in
            print(destinationURL as Any)
            if let url = destinationURL
            {
                let dc = UIDocumentInteractionController(url: url)
                dc.delegate = vc as? UIDocumentInteractionControllerDelegate
                dc.presentPreview(animated: true)
            }
            else
            {
                GenericMethods.showAlert(alertMessage: "Error in Downloading File. Please Try again.")
            }
            
            
        }, Failure:
            { (error) in
            print(error.localizedDescription)
            //                GenericMethods.showAlert(alertMessage: error.localizedDescription)
        })
        /*
        WebAPIHelper.startDownload(audioUrl: url, vc: vc, success: { (destinationURL) in
            print(destinationURL as Any)
            if let url = destinationURL
            {
                let dc = UIDocumentInteractionController(url: url)
                dc.delegate = vc as? UIDocumentInteractionControllerDelegate
                dc.presentPreview(animated: true)
            }
            else
            {
                GenericMethods.showAlert(alertMessage: "Error in Downloading File. Please Try again.")
            }
            
            
        }, Failure: { (error) in
            print(error.localizedDescription)
            //                GenericMethods.showAlert(alertMessage: error.localizedDescription)
        })
        */
    }
    class func mimeTypeForPath(path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
    
    
    class func saveFileDataToLocal(fileData:Data , fileStr:String)
    {
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath =  tDocumentDirectory.appendingPathComponent("RapidWallet")
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
            print("fileStr is \(fileStr)")
            let fileURL = filePath.appendingPathComponent(fileStr)
            //writing
            do {
                try fileData.write(to: fileURL, options:[])
            }
            catch {
                print("failed to write data")
            }
        }
        
    }
    class func removeFileDataToLocal()
    {
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath =  tDocumentDirectory.appendingPathComponent("RapidWallet")
            if fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.removeItem(at: filePath)
                }
                catch {
                    print("failed to remove data")
                }
            }
            }
    }
    class func localFilesArray()-> NSArray
    {
        var localFilesArray:NSArray = []
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath =  tDocumentDirectory.appendingPathComponent("RapidWallet")
            print(filePath)
            print(filePath.path)
            print(filePath.pathComponents)
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
            do {
                localFilesArray = try fileManager.contentsOfDirectory(atPath: filePath.path) as NSArray
                print("localArray is \(localFilesArray)")
                return localFilesArray
                
            } catch {
                // failed to read directory – bad permissions, perhaps?
            }
            
        }
        return []
    }
    
    
    class func getURL(of asset: PHAsset, completionHandler : @escaping ((_ responseURL : URL?) -> Void)) {
        
        if asset.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            asset.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput, info) in
                completionHandler(contentEditingInput!.fullSizeImageURL)
            })
        } else if asset.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options, resultHandler: { (asset, audioMix, info) in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl = urlAsset.url
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
    class func showcamera(imagePicker:UIImagePickerController,vc:UIViewController) {
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authStatus == .authorized {
            FileUpload.openCamera(imagePicker: imagePicker, vc: vc)
        } else if authStatus == .notDetermined {
            //NSLog(@"%@", @"Camera access not determined. Ask for permission.");
            
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if granted {
                    //NSLog(@"Granted access to %@", AVMediaTypeVideo);
                    FileUpload.openCamera(imagePicker: imagePicker, vc: vc)
                } else {
                    //NSLog(@"Not granted access to %@", AVMediaTypeVideo);
                    FileUpload.camDenied(vc:vc)
                }
                return
            })
            FileUpload.camDenied(vc:vc)
        }
        else if authStatus == .denied
        {
            FileUpload.camDenied(vc:vc)
        }
        else if authStatus == .restricted {
            
        }
        else{
            
        }
    }
    class func openCamera(imagePicker:UIImagePickerController,vc:UIViewController)
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            imagePicker.videoQuality = UIImagePickerController.QualityType.typeHigh
            vc.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
        }
    }
    class func galleryDenied(vc:UIViewController) {
        //NSLog(@"%@", @"Denied camera access");
        
        let alert = UIAlertController(title: "Error", message: "It looks like your privacy settings are preventing us from accessing your gallery to pick Photos. You can fix this by doing the following:\n\n1. Touch the Settings button below to open the Settings of this app.\n\n2. Click Photos and Allow to Read and Write .\n\n3. Open this app and try again.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { action in
            defer {
            }
            do {
                //NSLog(@"tapped Settings");
                //                let canOpenSettings: Bool = UIApplication.openSettingsURLString != nil
                //                if canOpenSettings {
                let url =  URL(string: UIApplication.openSettingsURLString)
                
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                //                }
                
                
            }
            catch let exception {
                print(exception)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        vc.present(alert, animated: true)
    }
    class func camDenied(vc:UIViewController) {
        //NSLog(@"%@", @"Denied camera access");
        
        let alert = UIAlertController(title: "Error", message: "It looks like your privacy settings are preventing us from accessing your camera to take Photos. You can fix this by doing the following:\n\n1. Touch the Settings button below to open the Settings of this app.\n\n2. Turn the Camera on.\n\n3. Open this app and try again.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { action in
            defer {
            }
            do {
                //NSLog(@"tapped Settings");
                //                let canOpenSettings: Bool = UIApplication.openSettingsURLString != nil
                //                if canOpenSettings {
                let url =  URL(string: UIApplication.openSettingsURLString)
                
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                //                }
            }
            catch let exception {
                print(exception)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        vc.present(alert, animated: true)
    }
    class func openGallary(imagePicker:UIImagePickerController,vc:UIViewController)
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        //        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        imagePicker.allowsEditing = false
        imagePicker.videoQuality = UIImagePickerController.QualityType.typeHigh
        vc.present(imagePicker, animated: true, completion: nil)
    }

}
