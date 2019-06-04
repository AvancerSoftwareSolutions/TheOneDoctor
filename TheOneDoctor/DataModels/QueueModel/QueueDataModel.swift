//
//  QueueDataModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 04/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class QueueDataModel:Mappable
{
    
    var otpStatus:Int?
    var sex:String?
    var patientId:String?
    var patientName:String?
    var appointmentId:String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        otpStatus <- map["OTPStatus"]
        sex <- map["sex"]
        patientId <- map["patient_id"]
        patientName <- map["patient_name"]
        appointmentId <- map["appointment_id"]
    }
    
    init() {
        
    }
    
}
