//
//  LoginUserDataModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 06/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginUserDataModel:Mappable
{
    var userId:Int?
    var userImg:String?
    var gender:String?

    required init?(map: Map) {
        
    }
    

    func mapping(map: Map) {
        userId <- map ["user_id"]
        userImg <- map ["profile"]
        gender <- map ["sex"]
    }

}
