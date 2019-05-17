//
//  AddSpecialityModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 17/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class AddSpecialityModel:Mappable
{
    var status:StatusDataModel?
    var specialityData:Array<ProfileSpecialityDataModel>?
    var subSpecialityData:Array<SubSpecialityDataModel>?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        specialityData <- map["speciality"]
        subSpecialityData <- map["subspeciality"]
    }
    
    
}
