//
//  AdvertisementPriceModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 19/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class AdvertisementPriceModel:Mappable
{
    
    var id:Int?
    var availability:String?
    var price:String?
    var currencyCode:String?
    var priceId:Int?
    var noOfDays:Int?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        availability <- map["availability"]
        price <- map["price"]
        currencyCode <- map["currency_code"]
        priceId <- map["price_id"]
        noOfDays <- map["no_of_days"]
    }
    
    init() {
        
    }
    
}
