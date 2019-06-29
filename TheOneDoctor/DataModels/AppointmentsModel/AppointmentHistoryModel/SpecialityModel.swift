//
//  SpecialityModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class SpecialityModel:Mappable
{
    
    var status:StatusDataModel?
    var specialityData:Array<SpecialityListModel>?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        specialityData <- map["speciality"]
        
    }
    
    init() {
        
    }
    
}
class SpecialityListModel:Mappable
{
    
    var id:String?
    var name:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        
    }
    
    init() {
        
    }
    
}
