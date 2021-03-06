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
    
    
    //MARK:- live URL
    let baseURL = "http://159.89.162.140:3112/api/Doctor/"
    let fileUploadBaseURL = "http://159.89.162.140/HMSNew/API/Doctor/"
    let prescriptionBaseURL = "http://159.89.162.140/HMSNew/API/"
    
    //MARK:- Demo url
//    let baseURL = "http://159.89.162.140:3113/api/Doctor/"
//    let fileUploadBaseURL = "http://159.89.162.140/Mongo/HMSNew/API/Doctor/"
//    let prescriptionBaseURL = "http://159.89.162.140/Mongo/HMSNew/API/"
//
    
    
    let Authorization = "Basic YWRtaW46MTIzNA=="
    let createApiKeyURLSuffix = ""
    let sendOTPSuffix = "SendOTP"
    let loginSuffix = "Login"
    let dashboardListSuffix = "IconList"
    let profileSuffix = "Details"
    let updateKeyURLSuffix = ""
    let addSpecialitySuffix = "Speciality"
    let deletePicSuffix = "Removefile"
    let updateProfileSuffix = "Update"
    let scheduleSuffix = "DashboardData"
    let scheduleHistorySuffix = "History"
    let addNormalScheduleSuffix = "Schedule"
    let updateNormalScheduleSuffix = "ScheduleUpdate"
    let appointmentsListSuffix = "Appointment"
    let scheduleDateSuffix = "ScheduleDataByDate"
    let slotSessionSuffix = "SlotCreate"
    let addVIPScheduleSuffix = "VIPScheduleRequest"
    let queueListSuffix = "QueueList"
    let rescheduleListSuffix = "RescheduleList"
    let rescheduleSuffix = "Reschedule"
    let delayScheduleSuffix = "delayslot"
    let makeAvailableSuffix = "Makeavailable"
    let advertisementSuffix = "Advertisement"
    let doctorListSuffix = "ReferDoctorList"
    let referDoctorSuffix = "ReferInsert"
    let advertisementCheckSuffix = "AlreadyAdvExists"
    let referralHistorySuffix = "ReferralHistory"
    let appointmentHistorySuffix = ""
    let revenueListSuffix = "Revenue"
    let addDealsSuffix = "DoctorBestDealsInsert"
    let dealsHistorySuffix = "DoctorBestDealsList"
    let advertisementHistorySuffix = "AdvertisementList"
    let specialityListSuffix = "DoctorSpecialityList"
    
    
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
    func dashboardListDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:DashboardModel?, _ error:Error?)-> Void)
    {
        let dashboardListAPIURL = baseURL + dashboardListSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: dashboardListAPIURL, parameters: parameters)
        
        Alamofire.request(dashboardListAPIURL, method: .post, parameters: parameters, headers: nil)
            .responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<DashboardModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.dashboardListDetailsAPI(parameters: parameters, completion: completion)
                            
                            
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
        let deletePicAPIURL = fileUploadBaseURL + deletePicSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: deletePicAPIURL, parameters: parameters)
        
        Alamofire.request(deletePicAPIURL, method: .post, parameters: parameters, headers: nil)
           .responseJSON(completionHandler: { (response) in
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
            .validate(contentType: ["application/json","text/html"]).responseJSON(completionHandler: { (response) in
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
    
    func scheduleDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:ScheduleModel?, _ error:Error?)-> Void)
    {
        let scheduleAPIURL = baseURL + scheduleSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: scheduleAPIURL, parameters: parameters)
        
        Alamofire.request(scheduleAPIURL, method: .post, parameters: parameters, headers: nil)
           .responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<ScheduleModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.scheduleDetailsAPI(parameters: parameters, completion: completion)
                            
                            
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
    
    func scheduleHistoryAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:ScheduleHistoryModel?, _ error:Error?)-> Void)
    {
        let sscheduleHistoryAPIURL = baseURL + scheduleHistorySuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: sscheduleHistoryAPIURL, parameters: parameters)
        
        Alamofire.request(sscheduleHistoryAPIURL, method: .post, parameters: parameters, headers: nil)
            .responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<ScheduleHistoryModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.scheduleHistoryAPI(parameters: parameters, completion: completion)
                            
                            
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
    
    func addNormalScheduleDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:AddScheduleModel?, _ error:Error?)-> Void)
    {
        let addNormalScheduleAPIURL = baseURL + addNormalScheduleSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: addNormalScheduleAPIURL, parameters: parameters)
        
        Alamofire.request(addNormalScheduleAPIURL, method: .post, parameters: parameters, headers: nil)
            .responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<AddScheduleModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.addNormalScheduleDetailsAPI(parameters: parameters, completion: completion)
                            
                            
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
    
    func updateNormalScheduleDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:UpdateScheduleModel?, _ error:Error?)-> Void)
    {
        let updateNormalScheduleAPIURL = baseURL + updateNormalScheduleSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: updateNormalScheduleAPIURL, parameters: parameters)
        
        Alamofire.request(updateNormalScheduleAPIURL, method: .post, parameters: parameters, headers: nil)
            .responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<UpdateScheduleModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.updateNormalScheduleDetailsAPI(parameters: parameters, completion: completion)
                            
                            
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
    
    func appointmentsListDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:AppointmentsModel?, _ error:Error?)-> Void)
    {
        let appointmentsListAPIURL = baseURL + appointmentsListSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: appointmentsListAPIURL, parameters: parameters)
        
        Alamofire.request(appointmentsListAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<AppointmentsModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.appointmentsListDetailsAPI(parameters: parameters, completion: completion)
                            
                            
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
    func scheduleDateDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:ScheduleDateModel?, _ error:Error?)-> Void)
    {
        let scheduleDateAPIURL = baseURL + scheduleDateSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: scheduleDateAPIURL, parameters: parameters)
        
        Alamofire.request(scheduleDateAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<ScheduleDateModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.scheduleDateDetailsAPI(parameters: parameters, completion: completion)
                            
                            
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
    func slotSessionDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:SessionScheduleModel?, _ error:Error?)-> Void)
    {
        let slotSessionAPIURL = baseURL + slotSessionSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: slotSessionAPIURL, parameters: parameters)
        
        Alamofire.request(slotSessionAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<SessionScheduleModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.slotSessionDetailsAPI(parameters: parameters, completion: completion)
                            
                            
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
    func addVIPScheduleDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:AddVIPScheduleModel?, _ error:Error?)-> Void)
    {
        let addVIPScheduleAPIURL = baseURL + addVIPScheduleSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: addVIPScheduleAPIURL, parameters: parameters)
        
        Alamofire.request(addVIPScheduleAPIURL, method: .post, parameters: parameters, headers: nil)
            .responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<AddVIPScheduleModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.addVIPScheduleDetailsAPI(parameters: parameters, completion: completion)
                            
                            
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
    func queueListDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:QueueModel?, _ error:Error?)-> Void)
    {
        let queueListAPIURL = baseURL + queueListSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: queueListAPIURL, parameters: parameters)
        
        Alamofire.request(queueListAPIURL, method: .post, parameters: parameters, headers: nil)
            .responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<QueueModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.queueListDetailsAPI(parameters: parameters, completion: completion)
                            
                            
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
    func rescheduleListDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:RescheduleModel?, _ error:Error?)-> Void)
    {
        let rescheduleListAPIURL = baseURL + rescheduleListSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: rescheduleListAPIURL, parameters: parameters)
        
        Alamofire.request(rescheduleListAPIURL, method: .post, parameters: parameters, headers: nil)
            .responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<RescheduleModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.rescheduleListDetailsAPI(parameters: parameters, completion: completion)
                            
                            
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
    func rescheduleSlotsDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:RescheduleModel?, _ error:Error?)-> Void)
    {
        let rescheduleSlotsAPIURL = baseURL + rescheduleSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: rescheduleSlotsAPIURL, parameters: parameters)
        
        Alamofire.request(rescheduleSlotsAPIURL, method: .post, parameters: parameters, headers: nil)
            .responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<RescheduleModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.rescheduleSlotsDetailsAPI(parameters: parameters, completion: completion)
                            
                            
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
    func delaySlotsDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:RescheduleModel?, _ error:Error?)-> Void)
    {
        let delaySlotsAPIURL = baseURL + delayScheduleSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: delaySlotsAPIURL, parameters: parameters)
        
        Alamofire.request(delaySlotsAPIURL, method: .post, parameters: parameters, headers: nil)
            .responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<RescheduleModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.delaySlotsDetailsAPI(parameters: parameters, completion: completion)
                            
                            
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
    func makeAvailableDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:RescheduleModel?, _ error:Error?)-> Void)
    {
        let makeAvailableAPIURL = baseURL + makeAvailableSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: makeAvailableAPIURL, parameters: parameters)
        
        Alamofire.request(makeAvailableAPIURL, method: .post, parameters: parameters, headers: nil)
            .responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<RescheduleModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.makeAvailableDetailsAPI(parameters: parameters, completion: completion)
                            
                            
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
    
    func appointmentsDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:AppointmentsDetailsModel?, _ error:Error?)-> Void)
    {
        let appointmentsDetailsAPIURL = baseURL + appointmentsListSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: appointmentsDetailsAPIURL, parameters: parameters)
        
        Alamofire.request(appointmentsDetailsAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<AppointmentsDetailsModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.appointmentsDetailsAPI(parameters: parameters, completion: completion)
                            
                            
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
    func appointmentsHistoryAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:AppointmentHistoryModel?, _ error:Error?)-> Void)
    {
        let appointmentsDetailsAPIURL = baseURL + appointmentHistorySuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: appointmentsDetailsAPIURL, parameters: parameters)
        
        Alamofire.request(appointmentsDetailsAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<AppointmentHistoryModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.appointmentsHistoryAPI(parameters: parameters, completion: completion)
                            
                            
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
    func advertisementDetailsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:AdvertisementModel?, _ error:Error?)-> Void)
    {
        let advertisementAPIURL = baseURL + advertisementSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: advertisementAPIURL, parameters: parameters)
        
        Alamofire.request(advertisementAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"])
            .responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<AdvertisementModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.advertisementDetailsAPI(parameters: parameters, completion: completion)
                            
                            
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
    func doctorListAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:DoctorListModel?, _ error:Error?)-> Void)
    {
        let doctorListAPIURL = baseURL + doctorListSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: doctorListAPIURL, parameters: parameters)
        Alamofire.request(doctorListAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"]).responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<DoctorListModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.doctorListAPI(parameters: parameters, completion: completion)
                            
                            
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
    func referDoctorAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:SendOTPModel?, _ error:Error?)-> Void)
    {
        let referDoctorAPIURL = baseURL + referDoctorSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: referDoctorAPIURL, parameters: parameters)
        Alamofire.request(referDoctorAPIURL, method: .post, parameters: parameters, headers: nil)
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
                            self.referDoctorAPI(parameters: parameters, completion: completion)
                            
                            
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
    
    func advertisementCheckAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:AdvertisementCheckModel?, _ error:Error?)-> Void)
    {
        let advertisementCheckAPIURL = baseURL + advertisementCheckSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: advertisementCheckAPIURL, parameters: parameters)
        Alamofire.request(advertisementCheckAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"]).responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<AdvertisementCheckModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.advertisementCheckAPI(parameters: parameters, completion: completion)
                            
                            
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
    func referralHistoryAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:ReferralHistoryModel?, _ error:Error?)-> Void)
    {
        let referralHistoryAPIURL = baseURL + referralHistorySuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: referralHistoryAPIURL, parameters: parameters)
        Alamofire.request(referralHistoryAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"]).responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<ReferralHistoryModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.referralHistoryAPI(parameters: parameters, completion: completion)
                            
                            
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
    func revenueListAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:RevenueListModel?, _ error:Error?)-> Void)
    {
        let referralHistoryAPIURL = baseURL + revenueListSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: referralHistoryAPIURL, parameters: parameters)
        Alamofire.request(referralHistoryAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"]).responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<RevenueListModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.revenueListAPI(parameters: parameters, completion: completion)
                            
                            
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
    func specialityListAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:SpecialityModel?, _ error:Error?)-> Void)
    {
        let specialityAPIURL = baseURL + specialityListSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: specialityAPIURL, parameters: parameters)
        Alamofire.request(specialityAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"]).responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<SpecialityModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.specialityListAPI(parameters: parameters, completion: completion)
                            
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
    func addDealsAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:DealsListModel?, _ error:Error?)-> Void)
    {
        let referralHistoryAPIURL = baseURL + addDealsSuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: referralHistoryAPIURL, parameters: parameters)
        Alamofire.request(referralHistoryAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"]).responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<DealsListModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.addDealsAPI(parameters: parameters, completion: completion)
                            
                            
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
    func dealsHistoryAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:DealsHistoryModel?, _ error:Error?)-> Void)
    {
        let referralHistoryAPIURL = baseURL + dealsHistorySuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: referralHistoryAPIURL, parameters: parameters)
        Alamofire.request(referralHistoryAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"]).responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<DealsHistoryModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.dealsHistoryAPI(parameters: parameters, completion: completion)
                            
                            
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
    func advertisementHistoryAPI(parameters:Dictionary<String, Any>,completion: @escaping( _ status:Bool, _ showError:Bool, _ response:AdvertisementHistoryModel?, _ error:Error?)-> Void)
    {
        let referralHistoryAPIURL = baseURL + advertisementHistorySuffix
        //        let headers: HTTPHeaders = [ "Authorization": Authorization]
        consolePrintValues(url: referralHistoryAPIURL, parameters: parameters)
        Alamofire.request(referralHistoryAPIURL, method: .post, parameters: parameters, headers: nil)
            .validate(contentType: ["application/json"]).responseJSON(completionHandler: { (response) in
                print(response as Any)
            })
            .responseObject { (response: DataResponse<AdvertisementHistoryModel>) in
                let i =  response.response?.statusCode
                
                if i==402{
                    let apiManager = APIManager()
                    apiManager.createAPIKey{ (status, showError, response, error) in
                        var createApiKey: CreateAPIKeyModel?
                        if status == true {
                            print("Sucess")
                            
                            createApiKey = response
                            
                            UserDefaults.standard.set(createApiKey?.key, forKey: "sessionApiKey")
                            self.advertisementHistoryAPI(parameters: parameters, completion: completion)
                          
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
