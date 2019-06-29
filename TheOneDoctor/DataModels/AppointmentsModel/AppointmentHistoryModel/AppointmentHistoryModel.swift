//
//  AppointmentHistoryModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class AppointmentHistoryModel:Mappable
{
    
    var status:StatusDataModel?
    var referralData:Array<DealsHistoryDataModel>?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        referralData <- map["Data"]
        
    }
    
    init() {
        
    }
    
}
class AppointmentHistoryDataModel:Mappable
{
    
    var patientName:String?
    var referredDoctorName:String?
    var clinicName:String?
    var date:String?
    var status:Int?
    var commission:Int?
    var pharmacyCommission:Int?
    
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
        
    }
    
    init() {
        
    }
    
}
