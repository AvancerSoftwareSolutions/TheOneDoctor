//
//  DoctorListModel.swift
//  TheOneDoctor
//
//  Created by MyMac on 19/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import ObjectMapper

class DoctorListModel:Mappable
{
    
    var status:StatusDataModel?
    var doctorList:Array<DoctorListDataModel>?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        doctorList <- map["DoctorList"]
        
    }
    
    init() {
        
    }
    
}
