//
//  RevenueListModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 26/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class RevenueListModel:Mappable
{
    
    var status:StatusDataModel?
    var referralData:Array<RevenueListDataModel>?
    var totalValue:Double?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        referralData <- map["data"]
        totalValue <- map["Total"]
    }
    
    init() {
        
    }
    
}

class RevenueListDataModel:Mappable
{
    
    var name:String?
    var value:Double?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        value <- map["value"]
        
        
    }
    
    init() {
        
    }
    
}
