//
//  AppointmentsClinicFilterModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 25/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class AppointmentsClinicFilterModel:Mappable
{
    
    var clinicId:Int?
    var clinicName:String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        clinicId <- map["clinic_id"]
        clinicName <- map["clinic_name"]
        
    }
    
    init() {
        
    }
    
}
