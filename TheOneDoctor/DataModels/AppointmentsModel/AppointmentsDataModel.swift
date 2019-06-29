//
//  AppointmentsDataModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 24/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class AppointmentsDataModel:Mappable
{
    
    var clinicId:Int?
    var clinicName:String?
    var patientName:String?
    var date:String?
    var type:String?
    var fromTime:String?
    var status:Int?
    var appointmentId:String?
    var picture:String?
    var imageArray:Array<String>?
    var id:Int?
    var referredDoctorName:String?
    var referral:Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        clinicId <- map["clinic_id"]
        clinicName <- map["clinic"]
        patientName <- map["patient_name"]
        date <- map["date"]
        type <- map["type"]
        fromTime <- map["From"]
        status <- map["status"]
        appointmentId <- map["appointment_id"]
        id <- map["id"]
        picture <- map["profile"]
        imageArray <- map["prescription"]
        referredDoctorName <- map["referby"]
        referral <- map["Referral"]
    }
    
    init() {
        
    }
    
}
