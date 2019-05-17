//
//  ProfileModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 07/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class ProfileModel:Mappable
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
