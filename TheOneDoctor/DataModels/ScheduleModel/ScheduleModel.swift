//
//  ScheduleModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 23/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class ScheduleModel:Mappable
{
    
    var status:StatusDataModel?
    var dateDict:Array<ScheduleDataModel>?
    var clinicData:ScheduleClinicDataModel?
    var startDate:String?
    var endDate:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        dateDict <- map["Data"]
        startDate <- map["StartDate"]
        endDate <- map["EndDate"]
    }
    
    init() {
        
    }
    
}
