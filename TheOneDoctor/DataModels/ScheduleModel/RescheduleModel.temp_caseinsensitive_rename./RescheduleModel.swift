//
//  RescheduleModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class RescheduleModel:Mappable
{
    
    var status:StatusDataModel?
    var rescheduleListData:Array<RescheduleDataModel>?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        
    }
    
    init() {
        
    }
    
}
