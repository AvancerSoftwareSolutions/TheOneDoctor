//
//  AddVIPScheduleModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 23/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class AddVIPScheduleModel:Mappable
{
    
    var status:StatusDataModel?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        
    }
    
    init() {
        
    }
    
}
