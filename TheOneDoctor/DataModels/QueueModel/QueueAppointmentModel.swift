//
//  QueueAppointmentModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 04/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class QueueAppointmentModel:Mappable
{
    
    var queueData:Array<DashboardDataModel>?
    var totalPatientCount:Int?
    var attendedCount:Int?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        queueData <- map["QueueData"]
        totalPatientCount <- map["TotalPatientCount"]
        attendedCount <- map["AttentedCount"]
    }
    
    init() {
        
    }
    
}
