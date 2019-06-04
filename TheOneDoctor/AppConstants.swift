//
//  APIConfig.swift
//  TruckLogicsLite
//
//  Created by Span Technology Services on 28/09/17.
//  Copyright © 2017 SPAN Technology Services. All rights reserved.
//  Downline, Vendor Finance report  ₹

import Foundation
import UIKit

    /*
        APIConfig.swift has Config(URL for Sprint, Staging, Live) and WebApi(All API of PayWow) maintained as Struct
    */

//Terms

//Clocked In Hours - Total Time from Clock In to Clock Out including break
//Work Hours - Total Time from Clock In to Clock Out Excluding break

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
    static let appVersion: String = "/IOS/1.1.4"
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
    
    //local
    
//    static let BaseUrl = "http://192.168.1.9/Avancer_rapidwallet_testing/api/v1/"

    //Demo
     static let BaseUrl = "http://139.59.70.228/Avancer_rapidwallet_testing/api/v1/"
    
    //  http://rapidwallet.biz/RWDemo/
    
//    static let BaseUrl = "http://rapidwallet.biz/RWDemo/api/v1/"
    
    static let downloadURL = "http://192.168.1.9/Avancer_rapidwallet_testing/Apidownload/test"
    
    static let IFSCcheckUrl = "https://ifsc.razorpay.com/"
    static let PincodeCheckUrl = "http://postalpincode.in/api/pincode/"
    static let associateLinkUrl = "http://139.59.70.228/Avancer_rapidwallet_testing/refer-register/Pg1YPRHXgV7NbxFdmXmhbPbOjsGlJhWWC80XnQei5b9ruIwzxnVYzZqRJI0E3OwgNVeMyuFhA4PftdgrzHUmzg~~/0"
    static let vendorLinkUrl = "http://139.59.70.228/Avancer_rapidwallet_testing/refer-register/Pg1YPRHXgV7NbxFdmXmhbPbOjsGlJhWWC80XnQei5b9ruIwzxnVYzZqRJI0E3OwgNVeMyuFhA4PftdgrzHUmzg~~/1"
    static let agreementFormUrl = "https://rapidwallet.biz/RWDemo/assets/uploads/KYC/Vendor%20Agreement.pdf"
    
    
    static let fbURL = "https://www.facebook.com/RapidWallet/"
    static let youtubeURL = "https://www.youtube.com/channel/UC1ByrabxqEgMWf_LX7kgg5w"
    static let whatsappURL = "https://chat.whatsapp.com/invite/KGTJJuMkcTZIq4s4GX5dEd"
    static let telegramURL = "https://t.me/RapidWallet"
    
    static let iTunesLink = "https://itunes.apple.com/us/app/myapp/id0005464?ls=1&mt=8"
    
    static var fcmToken:String = ""
    static let appId:String = "set app id"
    static let publicKey = ""
    static let privateKey = ""
    static let isLive: Bool = false
    
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

    static let isiPad: Bool = (UIDevice.current.userInterfaceIdiom == .pad ? true : false)
//    static let defaultDateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    static let defaultDateFormatWithOutSeconds = "yyyy-MM-dd'T'HH:mm"
    static let dateFormatWithFwdSlashMonthStart = "MM/dd/yyyy"
    static let dateFormatWithShortMonthAndDay = "EEEE, MMM d yyyy"
    static let dateFormatWithShortMonth = "MMM dd, yyyy"
    static let timeFormat = "HH:mm:ss"
    
    static let differentDateFormatWithMeridian = "MM/dd/yyyy hh:mm aa"

    static let DefaultUserId = "00000000-0000-0000-0000-000000000000"
    static let DefaultBusinessId = "00000000-0000-0000-0000-000000000000"
    static let DefaultEmployeeId = "00000000-0000-0000-0000-000000000000"

    static let PercentageTxtCharacters = "0123456789."
    
    static let overallWorkingTime = 86400 //86400 - 24 hours  //28800 - 8 hours
    static let overallWorkingHours = 24
    static let localNotificationSecForEightHours = 28800
    static let localNotificationSecForTwentyFourHours = 86400
    static let UIApplicationOpenSettingsURLString = UIApplication.openSettingsURLString
    
}




// MARK:- WEB API Structure
struct WebApi {

    // MARK:- API
    //TimeClock
    static let SYNC_TIMECLOCK_FROM_DEVICE_TO_WEB = "Api Name"
    
}


