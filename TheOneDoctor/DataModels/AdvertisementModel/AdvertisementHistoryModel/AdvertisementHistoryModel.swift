//
//  AdvertisementHistoryModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class AdvertisementHistoryModel:Mappable
{
    
    var status:StatusDataModel?
    var advtHistoryData:Array<AdvertisementHistoryDataModel>?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        advtHistoryData <- map["data"]
    }
    
    init() {
        
    }
    
}
class AdvertisementHistoryDataModel:Mappable
{
    
    var specialityName:String?
    var typename:String?
    var fromdate:String?
    var todate:String?
    var currency_code:String?
    var status:String?
    var created_date:String?
    var price:String?
    var picture:String?
    var comments:String?
    var adTypeID:Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        specialityName <- map["specialityname"]
        typename <- map["typename"]
        fromdate <- map["fromdate"]
        todate <- map["todate"]
        currency_code <- map["currency_code"]
        status <- map["status"]
        created_date <- map["created_date"]
        price <- map["price"]
        picture <- map["picture"]
        comments <- map["comments"]
        adTypeID <- map["typeid"]
    }
    
    init() {
        
    }
    
}
