//
//  ReferralHistoryModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 22/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class ReferralHistoryModel:Mappable
{
    
    var status:StatusDataModel?
    var referralData:Array<ReferralHistoryDataModel>?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        referralData <- map["Data"]
        
    }
    
    init() {
        
    }
    
}
class ReferralHistoryDataModel:Mappable
{
    
    var patientName:String?
    var referredDoctorName:String?
    var clinicName:String?
    var date:String?
    var status:Int?
    var commission:Int?
    var pharmacyCommission:Int?
    var referralPharmacyCommission:Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        date <- map["created_date"]
        status <- map["BookStatus"]
        referredDoctorName <- map["ReferDoctorname"]
        clinicName <- map["ClinicName"]
        patientName <- map["PatientName"]
        commission <- map["Commission"]
        pharmacyCommission <- map["PharmacyCommission"]
        referralPharmacyCommission <- map["PharmacyReferalCommission"]
    }
    
    init() {
        
    }
    
}
