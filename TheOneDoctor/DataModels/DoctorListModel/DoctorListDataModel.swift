//
//  DoctorListDataModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 19/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class DoctorListDataModel:Mappable
{
    
    var userId:Int?
    var clinicName:String?
    var firstname:String?
    var lastname:String?
    var email:String?
    var mobile:String?
    var imageVideos:Array<String>?
    var clinicAddress:String?
    var appointmentFees:String?
    var specialityName:String?
    var scheduleMsg:String?
    var clinicLatitude:String?
    var clinicLongitude:String?
    var picture:String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userId <- map["user_id"]
        clinicName <- map["clinicname"]
        firstname <- map["firstname"]
        lastname <- map["lastname"]
        email <- map["email"]
        mobile <- map["mobile"]
        imageVideos <- map["images_videos"]
        clinicAddress <- map["clinicaddress"]
        appointmentFees <- map["AppointmentFees"]
        specialityName <- map["specialityname"]
        scheduleMsg <- map["ScheduleMsg"]
        clinicLatitude <- map["clinic_latitude"]
        clinicLongitude <- map["clinic_longitude"]
        picture   <- map["profile"]
    }
    
    init() {
        
    }
    
}
