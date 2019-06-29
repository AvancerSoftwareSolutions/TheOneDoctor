//
//  AdvertisementModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 19/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class AdvertisementModel:Mappable
{
    
    var status:StatusDataModel?
    var adType:Array<AdvertisementTypeModel>?
    var adPrice:Array<AdvertisementPriceModel>?
    var speciality:Array<AdvertisementSpecialityModel>?
    var addDetails:Array<AdvertisementDataModel>?
    var adPriorityType:Array<AdvertisementTypeModel>?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        adType <- map["Adtypes"]
        adPrice <- map["Adprice"]
        speciality <- map["speciality"]
        addDetails <- map["Addetails"]
        adPriorityType <- map["Adspriority"]
    }
    
    init() {
        
    }
    
}
