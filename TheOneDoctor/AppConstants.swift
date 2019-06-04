//
//  AppConstants.swift
//  TheOneDoctor
//
//  Created by MyMac on 04/06/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import Foundation
import UIKit

//  MARK:- Config Structure
struct AppConstants
{
    static var fourDigitNumber: String {
        var result = ""
        repeat {
            // Create a string with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(10000) )
        } while result.count < 4
        return result
    }
    
    static let downloadURL = ""
    static let BaseUrl = ""
    
    static let AppName: String = "The ONE"
    static let AppstoreUrl: String = "Url of my app"
    static let GoogleApiKey : String = "Api Key"
    static let storageFolderName : String = "TheONE"
    static let imageFileName: String = "image"
    static let videoFileName: String = "video"
    static let docImgListplaceHolderImg = UIImage(named: "LoaderImage")
    static let errorLoadingImg = UIImage(named: "ErrorImage")
    static let imgPlaceholder = UIImage(named: "emptyProfile.png")
    static var resultDateDict:NSMutableDictionary = [:]
    static var resultDateArray:NSMutableArray = []
    //  ****************************************************************************
    
    
    static var fcmToken:String = ""
    static let appId:String = "set app id"
    
    
    static let appGreenColor:UIColor = #colorLiteral(red: 0.537254902, green: 0.7254901961, blue: 0.2470588235, alpha: 1) // 89B93F // R-137 B-185 G-63
    
    static let appdarkGrayColor:UIColor = #colorLiteral(red: 0.2588235294, green: 0.2549019608, blue: 0.262745098, alpha: 1) //424143 - darkGray
    static let appyellowColor:UIColor = #colorLiteral(red: 1, green: 0.8256910443, blue: 0, alpha: 1) // FFCB04 // R-225 B-4 G-203
    
    static let khudColour:UIColor =  UIColor(red: 100/255.0 , green: 166/255.0, blue: 35/255.0, alpha: 1)
    static var changeViewClick:Bool = false
    
    static var isLoading:Bool = false
    static var isAppReferred:Bool = false
    static var referralCode:String = ""
    static var referralType:String = ""
    static var leftMenuLoad:Bool = false
    static var isNotified:Bool = false
    
    static var schedulefilteredStatus = 0
    
    static var updateDaysArray:NSMutableArray = []
    
    
    //  ****************************************************************************
    
    //MARK:- DateFormats
    
    static let monthDayFormat = "MMM yyyy"
    static let postDateFormat = "yyyy-MM-dd"
    static let dayMonthYearFormat = "E, MMM d"
    static let defaultDateFormat = "yyyy-MM-dd HH:mm:ss"
    static let monthYearFormat = "MM-yyyy"
    static let time12HoursInMeridianFormat = "h:mm a"
    static let timeHoursFormat = "h"
    static let timeMinFormat = "mm"
    static let time24HoursFormat = "HH:mm"
    static let titleDateFormat = "d, MMM yyyy"
    static let dayFormat = "EEEE"
    static let datePickerFormat = "dd-MM-yyyy HH:mm:ss Z"
    
    static let durationPeriod = 28
    
    
    
    static let UIApplicationOpenSettingsURLString = UIApplication.openSettingsURLString
    
}
