//
//  AppointmentsModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 24/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class AppointmentsModel:Mappable
{
    
    var status:StatusDataModel?
    var appointmentsData:AppointmentsDataModel?
    var filterData:AppointmentsFilterModel?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        appointmentsData <- map["result"]
        filterData <- map["Filter"]
        
    }
    
    init() {
        
    }
    
}
