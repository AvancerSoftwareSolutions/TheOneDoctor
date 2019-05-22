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
    var designation:String?
    var short_biography:String?
    var picture:String?
    var specialityList:Array<ProfileSpecialityDataModel>?
    var subspecialityList:Array<SubSpecialityDataModel>?
    var additionalPictureList:Array<String>?
    var additionalVideoList:Array<String>?
    var uploadingPictureList:Array<String>?
    var uploadingVideoList:Array<String>?
    
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
        picture <- map["picture"]
        gender <- map["sex"]
        maxcount <- map["maxcount"]
        designation <- map["designation"]
        specialityList <- map["speciality"]
        subspecialityList <- map["subspeciality"]
        additionalPictureList <- map["additionalpictures"]
        additionalVideoList <- map["additionalvideos"]
        uploadingPictureList <- map["additionalpicture"]
        uploadingVideoList <- map["additionalvideo"]
        short_biography <- map["short_biography"]
    }
    
    
}
