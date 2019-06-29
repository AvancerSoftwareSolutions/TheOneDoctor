//
//  DealsHistoryModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class DealsHistoryModel:Mappable
{
    
    var status:StatusDataModel?
    var dealsListData:Array<DealsHistoryDataModel>?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        dealsListData <- map["bestdeals"]
        
    }
    
    init() {
        
    }
    
}
class DealsHistoryDataModel:Mappable
{
    
    var name:String?
    var title:String?
    var description:String?
    var amount:String?
    var percentage:String?
    var currencyCode:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        title <- map["title"]
        description <- map["discription"]
        amount <- map["amount"]
        percentage <- map["percentage"]
        currencyCode <- map["currencyCode"]
        
    }
    
    init() {
        
    }
    
}
