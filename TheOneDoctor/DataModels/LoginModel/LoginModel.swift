//
//  LoginModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 06/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginModel:Mappable
{
    
    var status: StatusDataModel?
    var userData: LoginUserDataModel?
    
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map ["status"]
        userData <- map ["user_data"]
        
    }
    
    
    
}
