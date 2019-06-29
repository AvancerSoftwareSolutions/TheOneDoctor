//
//  WebAPIHelper.swift
//  SwiftDemo
//
//  Created by MyMac on 10/4/18.
//  Copyright © 2018 MyMac. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
class WebAPIHelper: NSObject {
    
    //Get Method
    class func navigationController() -> UINavigationController
        
    {
        
        let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        
        
        
        return navController!
        
    }
    
    class func getMethod(methodName: String,vc:UIViewController,  success: @escaping (AnyObject?)->Void, Failure: @escaping (NSError)->Void)
        
    {
        
        if ReachabilityManager.shared.isConnectedToNetwork() == false
            
        {
            GenericMethods.hideLoaderMethod(view: vc.view)
            
            GenericMethods.hideLoading()
            GenericMethods.hideLoaderMethod(view: vc.view)
            GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "The Internet connection appears to be offline.")

            
        }
            
        else {
            
            var urlPath : URL!
            
            urlPath = URL(string: "\(AppConstants.BaseUrl)" + "\(methodName)")
            let headers:HTTPHeaders = [
                "X-API-KEY": "AvancerRapidWallet",
                "Content-Type": "application/json"
            ]
            
            Alamofire.request(urlPath,method:.get,encoding: JSONEncoding.default, headers:headers).responseJSON { response in
                
//                print(response.request!)
//                print(response.response as Any)
//                print(response.data as Any)
//                print(response.result)
                switch response.result {
                    
                case .success(let json):
                    GenericMethods.hideLoaderMethod(view: vc.view)
                    
                    success(json as AnyObject?)
                    print(json)
                    
                case .failure(let error):
                    GenericMethods.hideLoaderMethod(view: vc.view)
                    Failure(error as NSError)
                    
                    print("error is \(error)")
                    GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "\(error.localizedDescription)")
                }
                // do whatever you want here
            }

            
        }
        
    }
    class func directURLgetMethod(methodName: String,vc:UIViewController,  success: @escaping (AnyObject?)->Void, Failure: @escaping (NSError)->Void)
        
    {
        
        if ReachabilityManager.shared.isConnectedToNetwork() == false
            
        {
            GenericMethods.hideLoaderMethod(view: vc.view)
            GenericMethods.hideLoading()
            GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "The Internet connection appears to be offline.")
            
            
        }
            
        else {
            
            var urlPath : URL!
            
            urlPath = URL(string:"\(methodName)")
//            let headers:HTTPHeaders = [
//                "Authorization": "63c70ce7d22d2842fbaf05c45f91ca44",
//                "Content-Type": "application/json"
//            ]
            
            Alamofire.request(urlPath,method:.get,encoding: JSONEncoding.default, headers:nil).responseJSON { response in
                
                //                print(response.request!)
                //                print(response.response as Any)
                //                print(response.data as Any)
                //                print(response.result)
                switch response.result {
                    
                case .success(let json):
                    GenericMethods.hideLoaderMethod(view: vc.view)
                    success(json as AnyObject?)
                    print(json)
                    
                case .failure(let error):
                    GenericMethods.hideLoaderMethod(view: vc.view)
                    Failure(error as NSError)
                    
                    print("error is \(error)")
                    GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "\(error.localizedDescription)")
                }
                // do whatever you want here
            }
            
            
        }
        
    }
    
    
    //post method
    
    
    
    class func postMethod(params : [String: Any],vc :UIViewController, methodName: String, success: @escaping (AnyObject?)->Void, Failure:@escaping (NSError)->Void)
        
    {
        
        
            if ReachabilityManager.shared.isConnectedToNetwork() == false
                
            {
                GenericMethods.hideLoaderMethod(view: vc.view)
//                UIApplication.shared.endIgnoringInteractionEvents()
                GenericMethods.hideLoading()
                GenericMethods.hideLoaderMethod(view: vc.view)
                GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "The Internet connection appears to be offline.")
            } else {
                print(params)
                let apiManager = APIManager()
                var urlPath : URL!
                urlPath = URL(string: "\(apiManager.fileUploadBaseURL)" + "\(methodName)")
                var request = URLRequest(url: urlPath! as URL)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("text/html", forHTTPHeaderField: "Content-Type")
                request.timeoutInterval = 120 // 120 secs
                request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
                Alamofire.request(request as URLRequestConvertible).responseJSON {
                    response in
                    print(response.request as Any)
                    print(response)
                    
                    switch response.result {
                        
                    case .success(let json):
                        GenericMethods.hideLoaderMethod(view: vc.view)
//                        UIApplication.shared.endIgnoringInteractionEvents()
                        success(json as AnyObject?)
                        
//                        let y: AnyObject = (json as AnyObject?)!
//                        if let str:Int = y.object(forKey: "error_code") as? Int
//                        {
//                           print(str)
//                            GenericMethods.showAlert(alertMessage: "Something Went Wrong! Please try again")
//                        }
//                        else{
//                            success(json as AnyObject?)
//
//                        }
                        
                        
                    
                    
                    case .failure(let error):
                        GenericMethods.hideLoaderMethod(view: vc.view)
                    Failure(error as NSError)
                        
                    print("error is \(error)")
                    GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "\(error.localizedDescription)")
                   }
                    // do whatever you want here
                    }
            }
            
        
        
        
        
    }
    class func directURLpostMethod(params : [String: Any],vc :UIViewController, methodName: String, success: @escaping (AnyObject?)->Void, Failure:@escaping (NSError)->Void)
        
    {
        
        do {
            if ReachabilityManager.shared.isConnectedToNetwork() == false
                
            {
                GenericMethods.hideLoaderMethod(view: vc.view)
                
                GenericMethods.hideLoading()
                GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "The Internet connection appears to be offline.")
            } else {
                print(params)
                var urlPath : URL!
                urlPath = URL(string: "\(methodName)")
                var request = URLRequest(url: urlPath! as URL)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("63c70ce7d22d2842fbaf05c45f91ca44", forHTTPHeaderField: "Authorization")
                request.timeoutInterval = 120 // 120 secs
                request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
                Alamofire.request(request as URLRequestConvertible).responseJSON {
                    response in
                    print(response.request as Any)
                    print(response)
                    
                    switch response.result {
                        
                    case .success(let json):
                        GenericMethods.hideLoaderMethod(view: vc.view)
                        let y: AnyObject = (json as AnyObject?)!
                        if let str:Int = y.object(forKey: "error_code") as? Int
                        {
                            print(str)
                            GenericMethods.showAlert(alertMessage: "Something Went Wrong! Please try again")
                        }
                        else{
                            success(json as AnyObject?)
                            
                        }
                        
                        
                        
                        
                    case .failure(let error):
                        GenericMethods.hideLoaderMethod(view: vc.view)
                        Failure(error as NSError)
                        
                        print("error is \(error)")
                        GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "\(error.localizedDescription)")
                    }
                    // do whatever you want here
                }
            }
            
        }
            
        catch  {
            
            print("Error in catch \(error.localizedDescription)")
            
        }
        
        
        
    }

    class func postMethodFileUpload(shownProgress:MBProgressHUD,fileData:Data,filename:String,mimeType:String,methodName:String,keyname:String,vc:UIViewController,success: @escaping (AnyObject?)->Void, Failure: @escaping (NSError) ->Void)
    {
        if ReachabilityManager.shared.isConnectedToNetwork() == false
            
        {
            GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "The Internet connection appears to be offline.")
            
        }
        else
        {
            let apiManager = APIManager()
//            let headers: HTTPHeaders = [
//                "Accept": "application/json"
//            ]
            let userId = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
            Alamofire.upload(multipartFormData: { multipartFormData in
                
                multipartFormData.append(fileData, withName: keyname, fileName: filename, mimeType: mimeType)
                
                multipartFormData.append("\(userId)".data(using: .utf8)!, withName: "doctor_id")
                
                
            }, to: "\(apiManager.fileUploadBaseURL)\(methodName)", method: .post, headers: nil,
               encodingCompletion: { encodingResult in
                GenericMethods.hideLoading()
                GenericMethods.hideLoaderMethod(view: vc.view)
                print(encodingResult)
                switch encodingResult {
                    
                case .success(let upload, _, _):
                    print(upload.response as Any)
                    print("response Data is \(upload.responseData as Any)")
                    upload.uploadProgress { progress in
                        
                        
                        shownProgress.progress = Float(progress.fractionCompleted)
                    }
                    upload.responseJSON { response in
                        
//                        print("response is \(response.response as Any)")
//                        print(response.request as Any)
//                        print(response.result)
                        
                        switch response.result {
                            
                        case .success(let json):
                            
                            let y: AnyObject = (json as AnyObject?)!
                            if let str:Int = y.object(forKey: "error_code") as? Int
                            {
                                print(str)
                                GenericMethods.showAlert(alertMessage: "Something Went Wrong! Please try again")
                            }
                            else
                            {
                                success(json as AnyObject?)
                            }
                            
                            
                        case .failure(let error):
                            
                            Failure(error as NSError)
                            
                            print("failure error is \(error)")
                            
                            GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "\(error.localizedDescription)")
                        }
                    }
                case .failure(let encodingError):
                    GenericMethods.hideLoaderMethod(view: vc.view)
                    Failure(encodingError as NSError)
                    print("encodingError:\(encodingError)")
                }
            })
            
        }
            
    }
    class func addDoctorPicFileUpload(shownProgress:MBProgressHUD,parameters:Dictionary<String,Any>,fileData:[Data],filename:[String],mimeType:[String],methodName:String,vc:UIViewController,success: @escaping (AnyObject?)->Void, Failure: @escaping (NSError) ->Void)
    {
        if ReachabilityManager.shared.isConnectedToNetwork() == false
            
        {
            GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "The Internet connection appears to be offline.")
            
        }
        else
        {

            
            Alamofire.upload(multipartFormData: { (multipartFormData: MultipartFormData) in
                for i in 0..<fileData.count
                {
                    multipartFormData.append(fileData[i], withName: "file[\(i)]", fileName: filename[i], mimeType: mimeType[i])
                }
                for (key, value) in parameters {
                    print("value is \(value)")
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to: methodName, encodingCompletion: { (encodingResult) in
                
                
                    GenericMethods.hideLoading()
                
                    print(encodingResult)
                    switch encodingResult {
                        
                    case .success(let upload, _, _):
                        print(upload.response as Any)
                        print("response Data is \(upload.responseData as Any)")
                        upload.uploadProgress { progress in
                            
                            
                            shownProgress.progress = Float(progress.fractionCompleted)
                        }
                        upload.responseJSON { response in
                            
                            //                        print("response is \(response.response as Any)")
                            //                        print(response.request as Any)
                            //                        print(response.result)
                            
                            switch response.result {
                                
                            case .success(let json):
                                GenericMethods.hideLoaderMethod(view: vc.view)
                                
                                let y: AnyObject = (json as AnyObject?)!
                                if let str:Int = y.object(forKey: "error_code") as? Int
                                {
                                    print(str)
                                    GenericMethods.showAlert(alertMessage: "Something Went Wrong! Please try again")
                                }
                                else
                                {
                                    success(json as AnyObject?)
                                }
                                
                                
                            case .failure(let error):
                                GenericMethods.hideLoaderMethod(view: vc.view)
                                Failure(error as NSError)
                                
                                print("failure error is \(error)")
                                
                                GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "\(error.localizedDescription)")
                            }
                        }
                    case .failure(let encodingError):
                        GenericMethods.hideLoaderMethod(view: vc.view)
                        Failure(encodingError as NSError)
                        print("encodingError:\(encodingError)")
                    }
                })
            
            
        }
        
    }
    class func prescriptionPicFileUpload(shownProgress:MBProgressHUD,parameters:Dictionary<String,Any>,fileData:[Data],filename:[String],mimeType:[String],methodName:String,vc:UIViewController,success: @escaping (AnyObject?)->Void, Failure: @escaping (NSError) ->Void)
    {
        if ReachabilityManager.shared.isConnectedToNetwork() == false
            
        {
            GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "The Internet connection appears to be offline.")
            
        }
        else
        {
            //            let headers: HTTPHeaders = [
            //                "Accept": "application/json"
            //            ]
            //            UserDefaults.standard.value(forKey: "user_id") ?? 0 as Int
            
            
            Alamofire.upload(multipartFormData: { (multipartFormData: MultipartFormData) in
                for i in 0..<fileData.count
                {
                    multipartFormData.append(fileData[i], withName: "prescription[\(i)]", fileName: filename[i], mimeType: mimeType[i])
                }
                for (key, value) in parameters {
                    print("value is \(value)")
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }, to: methodName, encodingCompletion: { (encodingResult) in
                
                
                GenericMethods.hideLoading()
                
                print(encodingResult)
                switch encodingResult {
                    
                case .success(let upload, _, _):
                    print(upload.response as Any)
                    print("response Data is \(upload.responseData as Any)")
                    upload.uploadProgress { progress in
                        
                        
                        shownProgress.progress = Float(progress.fractionCompleted)
                    }
                    upload.responseJSON { response in
                        
                        //                        print("response is \(response.response as Any)")
                        //                        print(response.request as Any)
                        //                        print(response.result)
                        
                        switch response.result {
                            
                        case .success(let json):
                            GenericMethods.hideLoaderMethod(view: vc.view)
                            
                            let y: AnyObject = (json as AnyObject?)!
                            if let str:Int = y.object(forKey: "error_code") as? Int
                            {
                                print(str)
                                GenericMethods.showAlert(alertMessage: "Something Went Wrong! Please try again")
                            }
                            else
                            {
                                success(json as AnyObject?)
                            }
                            
                            
                        case .failure(let error):
                            GenericMethods.hideLoaderMethod(view: vc.view)
                            Failure(error as NSError)
                            
                            print("failure error is \(error)")
                            
                            GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "\(error.localizedDescription)")
                        }
                    }
                case .failure(let encodingError):
                    GenericMethods.hideLoaderMethod(view: vc.view)
                    Failure(encodingError as NSError)
                    print("encodingError:\(encodingError)")
                }
            })
            
            
        }
        
    }
    class func startDownload(audioUrl:String,vc:UIViewController,success: @escaping (URL?)->Void, Failure: @escaping (NSError) ->Void) {
        
        func getSaveFileUrl(fileName: String) -> URL {
            let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let documentsURL =  filePath.appendingPathComponent(AppConstants.storageFolderName)
            let nameUrl = URL(string: fileName)
            let fileURL = documentsURL.appendingPathComponent((nameUrl?.lastPathComponent)!).appendingPathExtension("xls")
            NSLog(fileURL.absoluteString)
            return fileURL;
        }
        
        if ReachabilityManager.shared.isConnectedToNetwork() == false
            
        {
            GenericMethods.hideLoaderMethod(view: vc.view)
            GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "The Internet connection appears to be offline.")
            
            
        }
            
        else {
            
            let fileUrl = getSaveFileUrl(fileName: audioUrl)
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            Alamofire.download(audioUrl, to:destination)
                .downloadProgress { (progress) in
                    print(progress.fractionCompleted)
                    //                self.progressLabel.text = (String)(progress.fractionCompleted)
                }
                .response { (response) in
                    print(response)
                    GenericMethods.hideLoaderMethod(view: vc.view)
                    if response.destinationURL != nil {
                        print("destination URL \(response.destinationURL!)")
                    }
                    success(response.destinationURL)
            }

        }
        
    }
    class func startDownloadWithPost(audioUrl:String,params : [String: Any],vc :UIViewController,success: @escaping (URL?)->Void, Failure: @escaping (NSError) ->Void) {
        
        func getSaveFileUrl(fileName: String) -> URL {
            let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let documentsURL =  filePath.appendingPathComponent(AppConstants.storageFolderName)
            let nameUrl = URL(string: fileName)
            let fileURL = documentsURL.appendingPathComponent((nameUrl?.lastPathComponent)!).appendingPathExtension("xls")
            NSLog(fileURL.absoluteString)
            return fileURL;
        }
        
        if ReachabilityManager.shared.isConnectedToNetwork() == false
            
        {
            GenericMethods.hideLoaderMethod(view: vc.view)
            GenericMethods.showAlertWithTitle(alertTitle: AppConstants.AppName, alertMessage: "The Internet connection appears to be offline.")
            
            
        }
            
        else {
            
            let fileUrl = getSaveFileUrl(fileName: audioUrl)
            
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                return (fileUrl, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            let headers:HTTPHeaders = [
                "X-API-KEY": "AvancerRapidWallet",
                "Accept": "application/json"
            ]
            Alamofire.download(audioUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, to: destination).response { (response) in
                print(response)
                GenericMethods.hideLoaderMethod(view: vc.view)
                if response.destinationURL != nil {
                    print("destination URL \(response.destinationURL!)")
                }
                success(response.destinationURL)
            }
//            Alamofire.download(audioUrl, to:destination)
//                .downloadProgress { (progress) in
//                    print(progress.fractionCompleted)
//                    //                self.progressLabel.text = (String)(progress.fractionCompleted)
//                }
//                .response { (response) in
//                    print(response)
//                    GenericMethods.hideLoaderMethod(view: vc.view)
//                    if response.destinationURL != nil {
//                        print("destination URL \(response.destinationURL!)")
//                    }
//                    success(response.destinationURL)
//            }
            
        }
        
    }
    

}
