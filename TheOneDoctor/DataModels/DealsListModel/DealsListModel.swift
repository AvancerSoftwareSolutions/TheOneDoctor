//
//  DealsListModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class DealsListModel:Mappable
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

