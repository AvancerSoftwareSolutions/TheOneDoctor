//
//  QueueModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 04/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class QueueModel:Mappable
{
    
    var status:StatusDataModel?
    var appointmentData:QueueAppointmentModel?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        appointmentData <- map["Appointmentdata"]
        
    }
    
    init() {
        
    }
    
}
