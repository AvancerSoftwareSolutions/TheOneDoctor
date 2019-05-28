//
//  AppointmentsFilterModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 24/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class AppointmentsFilterModel:Mappable
{
    
    var age:Array<String>?
    var appointments:Array<String>?
    var clinicList:Array<AppointmentsClinicFilterModel>?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        age <- map["Age"]
        appointments <- map["Appointments"]
        clinicList <- map["Clinics"]
    }
    
    init() {
        
    }
    
}
