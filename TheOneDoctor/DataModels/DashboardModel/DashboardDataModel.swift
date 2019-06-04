//
//  DashboardDataModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 30/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class DashboardDataModel:Mappable
{
    
    var name:String?
    var icon:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        icon <- map["icon"]
        
    }
    
    init() {
        
    }
    
}
