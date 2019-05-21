//
//  APIManager.swift
//  TheOneDoctor
//
//  Created by MyMac on 06/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class APIManager
{
    //MARK:- Base Url & Suffixes 
    let baseURL = "http://159.89.162.140:3112/api/doctor/"
    let fileUploadBaseURL = "http://159.89.162.140/Mongo/HMSNew/API/Doctor/"
    let Authorization = "Basic YWRtaW46MTIzNA=="
    
    let createApiKeyURLSuffix = ""
    let sendOTPSuffix = "SendOTP"
    let loginSuffix = "Login"
    let profileSuffix = "Details"
    let updateKeyURLSuffix = ""
    let addSpecialitySuffix = "Speciality"
    let deletePicSuffix = "fileremove"
    let updateProfileSuffix = "update"
    
    func consolePrintValues(url:String,parameters:Dictionary<String, Any>)
    {
        print("URL \(url)")
        print("parameters \(parameters)")
    }
    
    //MARK:- Create API key
    
    func createAPIKey(completion: @escaping( _ status:Bool, _ showError:Bool, _ response:CreateAPIKeyModel?, _ error:Error?)-> Void)
    {
        var parameters = Dictionary<String, Any>()
        
        parameters["customer_id"] = ""
        parameters["device_id"] = ""
        parameters["firebase_token"] = ""
        parameters["app_version"] = ""
        parameters["platform"] = ""
        
        let createAPIURL = baseURL + createApiKeyURLSuffix
        let headers: HTTPHeaders = [ "Authorization": Authorization]
        Alamofire.request(createAPIURL, method: .post, parameters: parameters, headers: headers)
            .validate(contentType: ["application/json"])
            .responseObject { (response: DataResponse<CreateAPIKeyModel>) in
                switch response.result {
                    
                case .success:
                    let responseData = response.result.value
                    completion(true, false, responseData, nil)
                    
                case .failure(let error):
                    completion(false, true, nil, error)
                }
        }
    }
    
    func updateAPIKey(completion: @escaping(_ status: Bool, _ showError: Bool, _ response: UpdateKeyAPIModel?, _ error: Error?) -> Void) {
        
        var parameters = Dictionary<String, Any>()
        parameters["country"] = "7"
        
        let updateKeyURL = baseURL + updateKeyURLSuffix
        let headers: HTTPHeaders = [ "Authorization": Authorization , "session": (UserDefaults.standard.value(forKey: "sessionApiKey") as? String)!]
        Alamofire.request(updateKeyURL, method: .post, parameters: parameters, headers: headers)
            .validate(contentType: ["application/json"])
            .responseObject { (response: DataResponse<UpdateKeyAPIModel>) in
                
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            
                            
                        }
                        else {
                            print("Failed")
                        }
                    }
                }
                else{
                    switch response.result {
                        
                    case .success:
                        let responseData = response.result.value
                        completion(true, false, responseData, nil)
                        
                    case .failure(let error):
                        completion(false, true, nil, error)
                    }
                }
        }
    }
    
    //MARK:- Login API Methods
    func sendOTPAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:SendOTPModel?, _ error:Error?)-> Void)
    {
        let sendOTPAPIURL = baseURL + sendOTPSuffix
//        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: sendOTPAPIURL, parameters: parameters)
        Alamofire.request(sendOTPAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"]).responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<SendOTPModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.sendOTPAPI(parameters: parameters, completion: completion)
                            
                            
                        }
                        else {
                            print("Failed")
                            
                        }
                    }
                }
                else
                {
                    switch response.result {
                        
                    case .success:
                        let responseData = response.result.value
                        completion(true, false, responseData, nil)
                        
                    case .failure(let error):
                        completion(false, true, nil, error)
                    }
                }
                
        }
    }
    
    func loginAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:LoginModel?, _ error:Error?)-> Void)
    {
        let loginAPIURL = baseURL + loginSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: loginAPIURL, parameters: parameters)
        Alamofire.request(loginAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"]).responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<LoginModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.loginAPI(parameters: parameters, completion: completion)
                            
                            
                        }
                        else {
                            print("Failed")
                            
                        }
                    }
                }
                else
                {
                    switch response.result {
                        
                    case .success:
                        let responseData = response.result.value
                        completion(true, false, responseData, nil)
                        
                    case .failure(let error):
                        completion(false, true, nil, error)
                    }
                }
                
        }
        
    }
    func profileDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:ProfileModel?, _ error:Error?)-> Void)
    {
        let profileAPIURL = baseURL + profileSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: profileAPIURL, parameters: parameters)
        Alamofire.request(profileAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"]).responseJSON(completionHandler: { (response) in
                print(response as Any)
                print(response.request as Any)
            })
            .responseObject { (response: DataResponse<ProfileModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.profileDetailsAPI(parameters: parameters, completion: completion)
                            
                            
                        }
                        else {
                            print("Failed")
                            
                        }
                    }
                }
                else
                {
                    switch response.result {
                        
                    case .success:
                        let responseData = response.result.value
                        completion(true, false, responseData, nil)
                        
                    case .failure(let error):
                        completion(false, true, nil, error)
                    }
                }
                
        }
    }
    
    func addSpecialityDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:AddSpecialityModel?, _ error:Error?)-> Void)
    {
        let addSpecialityAPIURL = baseURL + addSpecialitySuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: addSpecialityAPIURL, parameters: parameters)
        Alamofire.request(addSpecialityAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"]).responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<AddSpecialityModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.addSpecialityDetailsAPI(parameters: parameters, completion: completion)
                            
                            
                        }
                        else {
                            print("Failed")
                            
                        }
                    }
                }
                else
                {
                    switch response.result {
                        
                    case .success:
                        let responseData = response.result.value
                        completion(true, false, responseData, nil)
                        
                    case .failure(let error):
                        completion(false, true, nil, error)
                    }
                }
                
        }
    }
    
    func deletePicDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:DeletePicModel?, _ error:Error?)-> Void)
    {
        let deletePicAPIURL = baseURL + deletePicSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: deletePicAPIURL, parameters: parameters)
        
        Alamofire.request(deletePicAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"]).responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<DeletePicModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.deletePicDetailsAPI(parameters: parameters, completion: completion)
                            
                            
                        }
                        else {
                            print("Failed")
                            
                        }
                    }
                }
                else
                {
                    switch response.result {
                        
                    case .success:
                        let responseData = response.result.value
                        completion(true, false, responseData, nil)
                        
                    case .failure(let error):
                        completion(false, true, nil, error)
                    }
                }
                
        }
    }
    func updateProfileDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:ProfileUpdateModel?, _ error:Error?)-> Void)
    {
        let updateProfileAPIURL = baseURL + updateProfileSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: updateProfileAPIURL, parameters: parameters)
        
        Alamofire.request(updateProfileAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"]).responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<ProfileUpdateModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.updateProfileDetailsAPI(parameters: parameters, completion: completion)
                            
                            
                        }
                        else {
                            print("Failed")
                            
                        }
                    }
                }
                else
                {
                    switch response.result {
                        
                    case .success:
                        let responseData = response.result.value
                        completion(true, false, responseData, nil)
                        
                    case .failure(let error):
                        completion(false, true, nil, error)
                    }
                }
                
        }
    }
    
}

