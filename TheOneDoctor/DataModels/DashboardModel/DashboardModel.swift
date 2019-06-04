//
//  DashboardModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 30/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class DashboardModel:Mappable
{
    
    var status:StatusDataModel?
    var dashboardData:Array<DashboardDataModel>?
    var notificationCount:Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        dashboardData <- map["MainList"]
        notificationCount <- map["notification_count"]
    }
    
    init() {
        
    }
    
}
