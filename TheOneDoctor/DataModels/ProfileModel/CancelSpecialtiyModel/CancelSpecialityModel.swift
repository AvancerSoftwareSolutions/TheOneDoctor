//
//  CancelSpecialityModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 17/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class CancelSpecialityModel:Mappable
{
    var status:StatusDataModel?
    var subSpecialityData:Array<Any>?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        subSpecialityData <- map["subspeciality"]
    }
    
    
}
