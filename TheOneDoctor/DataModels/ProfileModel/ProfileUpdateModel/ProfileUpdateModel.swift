//
//  ProfileUpdateModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 21/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class ProfileUpdateModel:Mappable
{
    
    var status:StatusDataModel?
    var profileData:ProfileDataModel?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        profileData <- map["Profile"]
        
    }
    
    init() {
        
    }
    
}
