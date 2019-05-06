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
    var code:String?
    var message:String?
    var userData:LoginUserDataModel?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        userData <- map["userdata"]
    }
    
    init() {
        
    }
    
}
