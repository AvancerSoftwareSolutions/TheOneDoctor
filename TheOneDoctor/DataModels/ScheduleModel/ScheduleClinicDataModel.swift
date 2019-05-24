//
//  ScheduleClinicDataModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 24/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class ScheduleClinicDataModel:Mappable
{
    
    var clinicId:Int?
    var clinicName:String?
    var clinicAddress:String?
    var clinicPicture:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        clinicId <- map["clinic_id"]
        clinicName <- map["clinicname"]
        clinicAddress <- map["clinicaddress"]
        clinicPicture <- map["clinicpicture"]
    }
    
    init() {
        
    }
    
}
