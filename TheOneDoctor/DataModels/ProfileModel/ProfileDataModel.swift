//
//  ProfileDataModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 07/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class ProfileDataModel:Mappable
{
    var userId:String?
    var firstname:String?
    var lastname:String?
    var email:String?
    var mobile:String?
    var profPicture:String?
    var experience:String?
    var gender:String?
    var maxcount:String?
    var specialityList:Array<ProfileSpecialityDataModel>?
    var subspecialityList:Array<ProfileSpecialityDataModel>?
    var additionalPictureList:Array<String>?
    var additionalVideoList:Array<String>?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        userId <- map["user_id"]
        firstname <- map["firstname"]
        lastname <- map["lastname"]
        email <- map["email"]
        mobile <- map["mobile"]
        experience <- map["experience"]
        profPicture <- map["profile"]
        gender <- map["sex"]
        maxcount <- map["maxcount"]
        specialityList <- map["speciality"]
        subspecialityList <- map["subspeciality"]
        additionalPictureList <- map["additionalpictures"]
        additionalVideoList <- map["additionalvideos"]
    }
    
    
}
