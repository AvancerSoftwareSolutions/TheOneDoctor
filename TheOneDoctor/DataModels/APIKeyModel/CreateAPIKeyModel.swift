//
//  CreateAPIKeyModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 07/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class CreateAPIKeyModel:Mappable
{
    var status: String?
    var key: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        key <- map["key"]
        
    }
    
    
}
