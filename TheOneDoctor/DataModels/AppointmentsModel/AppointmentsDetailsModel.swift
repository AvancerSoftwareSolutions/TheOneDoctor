//
//  AppointmentsDetailsModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 14/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class AppointmentsDetailsModel:Mappable
{
    
    var status:StatusDataModel?
    var imageArray:Array<String>?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        imageArray <- map["result"]
        
        
    }
    
    init() {
        
    }
    
}
