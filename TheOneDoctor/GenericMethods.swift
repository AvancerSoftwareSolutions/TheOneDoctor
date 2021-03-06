//
//  GenericMethods.swift
//  TaxApp
//
//  Created by Sanjeev T on 29/12/16.
//  Copyright © 2016 Swift trials. All rights reserved.
//

import UIKit
import Foundation
import CommonCrypto
import Alamofire
import Photos
import SwiftSVG
import SDWebImage
extension UIPanGestureRecognizer {
    
    func isLeft(theViewYouArePassing: UIView) -> Bool {
        let detectionLimit: CGFloat = 50
        let velocityView : CGPoint = velocity(in: theViewYouArePassing)
        if velocityView.x > detectionLimit {
            print("Gesture went right")
            return true
        } else if velocityView.x < -detectionLimit {
            print("Gesture went left")
            return false
        }
        return true
    }
}
extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
extension Date {
    var localizedDescription: String {
        return description(with: .current)
    }
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
}
extension UILabel
{
    func addImage(imageName: String, afterLabel bolAfterLabel: Bool = false)
    {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        
        let lFontSize = round(self.font.pointSize * 1.32)
        let lRatio = attachment.image!.size.width / attachment.image!.size.height
        
        attachment.bounds = CGRect(x: 0, y: ((self.font.capHeight - lFontSize) / 2).rounded(), width: lRatio * lFontSize, height: lFontSize)
        
        let attachmentString = NSAttributedString(attachment: attachment)
        
        //        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        if (bolAfterLabel)
        {
            let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
            strLabelText.append(attachmentString)
            
            self.attributedText = strLabelText
        }
        else
        {
            let strLabelText: NSAttributedString = NSAttributedString(string: self.text!)
            let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            
            self.attributedText = mutableAttachmentString
        }
    }
    
    func removeImage()
    {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}
extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer();
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:self.frame.height - thickness, width:self.frame.width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:self.frame.width - thickness, y: 0, width: thickness, height:self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}
extension String {
    
    public var sha512: String {
        let data = self.data(using: .utf8) ?? Data()
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes({
            _ = CC_SHA512($0, CC_LONG(data.count), &digest)
        })
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}



class GenericMethods: NSObject {
    
//    static let topmostViewcontroller = UIApplication.shared.keyWindow?.rootViewController
//    static var roundRectButtonPopTipView: SwiftPopTipView?
    
    //loading
    
    static var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    static var bgView : UIView = UIView()
    static var loaderView : UIView = UIView()
    static var activityIndicator = UIActivityIndicatorView()
    
    
    class func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    //    static var isLoading : Bool = false
    class func isStringEmpty(_ str: String?) -> Bool {
        if str == nil || ((str?.isEmpty)!) || (str?.count ?? 0) == 0 || (str?.trimmingCharacters(in: CharacterSet.whitespaces).count == 0) {
            
            return true
        }
        return false
    }
    class func attributedText(withString string: String, boldString: String, font: UIFont,color: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
//        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
//        let strrange = (string as NSString).range(of: string)

//        attributedString.addAttributes(boldFontAttribute, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)

        return attributedString
    }
    class func checkNil(str:String) -> String
    {
        if str.isEmpty || GenericMethods.isStringEmpty(str)
        {
            return ""
        }
        else
        {
            return str
        }
    }
    
    class func setTFAttributes(textfield:UITextField)
    {
        textfield.layer.cornerRadius = 5
        textfield.layer.masksToBounds = true
        textfield.layer.borderColor = UIColor.black.cgColor
    }
    class func setTextAttributes( textField: UITextField,with Text: String)
    {
//        textField.layer.borderColor = AppConstants.blueColor.cgColor
//        textField.layer.borderWidth = 1.3
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.textColor = UIColor.black
        textField.attributedPlaceholder = NSAttributedString(string: Text,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.backgroundColor = UIColor.white
    }
    class func isPasswordMatch(_ pwd: String?, withConfirmPwd cnfPwd: String?) -> Bool {
        //asume pwd and cnfPwd has not whitespace
        if (pwd?.count ?? 0) > 0 && (cnfPwd?.count ?? 0) > 0 {
            if (pwd == cnfPwd) {
                //NSLog(@"Hurray! Password matches ");
                return true
            } else {
                //NSLog(@"Oops! Password does not matches");
                self.showAlertMethod(alertMessage: "Password does not matches")
                return false
            }
        } else {
            //NSLog(@"Password field can not be empty");
            self.showAlertMethod(alertMessage: "Password field should not be empty")

            return false
        }
    }
    
    class func setLogoImageView( imgView:UIImageView)
    {
        imgView.image = UIImage(named: "appLogo.png")
        imgView.layer.cornerRadius = imgView.frame.size.height / 2
        imgView.layer.borderWidth = 0.2
        imgView.clipsToBounds = true
        imgView.layer.masksToBounds = true
        imgView.layer.borderColor = UIColor.white.cgColor
//        imgView.contentMode = .scaleToFill
    }
    //MARK: Remove Comma
    class func removeCommaFromStr(str:String) ->String
    {
        let resstr = str.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        print("resstr\(resstr)")
        let str = resstr.replacingOccurrences(of: "\\s+", with: "", options: .regularExpression, range: nil)
        print("str\(str)")
        
        
        //        let str = resstr.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        return str
    }
    //MARK: Remove Space
    class func removeSpaceFromStr(str:String) ->String
    {
        let resstr = str.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        print("resstr\(resstr)")
        let str = resstr.replacingOccurrences(of: "\\s+", with: "", options: .regularExpression, range: nil)
        print("str\(str)")
        
        
        //        let str = resstr.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        return str
    }
    class func roundedCornerTextView(textView:UITextView)
    {
        textView.layer.cornerRadius = 5.0
        textView.layer.masksToBounds = true
        textView.layer.borderColor = AppConstants.appdarkGrayColor.cgColor
        textView.layer.borderWidth = 1.0
        textView.keyboardType = .asciiCapable
        
    }
    //MARK:- Button Attributes
    class func setButtonAttributes ( button:UIButton,with title:String)
    {
        button.backgroundColor = UIColor(named: "AppGreenColor")
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.masksToBounds = true
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        
    }
    class func shadowCellView(view:UIView)
    {
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5.0
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.2
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 2.5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    class func paddedString(_ input: String?) -> String? {
        //This adds some space around the button title just to make it look better
        return "  \(input ?? "")  "
    }
    

    class func setSVGImage(resourceFileName:String,color:UIColor,svgView:UIView)
    {
        let svgURL = Bundle.main.url(forResource: resourceFileName, withExtension: "svg")!
        print("svgURL \(svgURL)")
        let pizza = CALayer(SVGURL: svgURL){ (svgLayer) in
            // Set the fill color
            svgLayer.fillColor = color.cgColor
            // Aspect fit the layer to self.view
            svgLayer.resizeToFit(svgView.bounds)
            // Add the layer to self.view's sublayers
            svgView.layer.addSublayer(svgLayer)
            //            let animation = CABasicAnimation(keyPath:"strokeEnd")
            //            animation.duration = 4.0
            //            animation.fromValue = 0.0
            //            animation.toValue = 1.0
            //            animation.fillMode = CAMediaTimingFillMode.forwards
            //            animation.isRemovedOnCompletion = false
            //            svgLayer.add(animation, forKey: "strokeEndAnimation")
        }
    }
    class func setLeftViewWithSVG(svgView:UIView ,with fileName: String,color:UIColor)
    {
        
        let svgURL = Bundle.main.url(forResource: fileName, withExtension: "svg")!
        print("svgURL \(svgURL)")
        CALayer(SVGURL: svgURL){ (svgLayer) in
            // Set the fill color
            svgLayer.fillColor = color.cgColor
            // Aspect fit the layer to self.view
            svgLayer.resizeToFit(svgView.bounds)
            // Add the layer to self.view's sublayers
            svgView.layer.addSublayer(svgLayer)
            
        }
        
    }
    class func setLeftView(textfield:UITextField ,with fileName: String)
    {
        let pwdimgView = UIImageView()
        pwdimgView.frame = CGRect(x: 5, y: 0, width: 50, height: 30)
        pwdimgView.contentMode = .center
        GenericMethods.setSVGImage(resourceFileName: fileName, color: UIColor.white, svgView: pwdimgView)
        //        pwdimgView.image = UIImage(named: fileName)
        textfield.leftView = pwdimgView
        textfield.leftViewMode = .always
    }

    func topMostController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        
        }
        return topController
    }
    class func searchCountryCode(countryPhoneCode:Int)-> (String)
    {
        let placesData = UserDefaults.standard.object(forKey: "countryList") as? NSData
         var jsonValueArray: [Any]? = nil
        var imageStr:String = ""
        if let placesData = placesData {
            do {
                let placesArray = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(placesData as Data)
                jsonValueArray = placesArray as? [Any]
                var str:String = ""
                str = String((jsonValueArray![0] as? [AnyHashable:Any])?["name"] as? String ?? "")
                print("str \(str)")
//                let predicate = NSPredicate(format: "callingCodes CONTAINS[C] %d", 91)
                
                let predicate = NSPredicate(format: "alpha2Code CONTAINS[C] %@", "IN" )
                let orPredi: NSPredicate? = NSCompoundPredicate(orPredicateWithSubpredicates: [predicate])
                let array = (jsonValueArray! as NSArray).filtered(using: orPredi!)
                print ("array = \(array)")
                imageStr = (array[0]as? [AnyHashable:Any])? ["FlagPng"] as? String ?? ""
                
//                let result = (jsonValueArray! as Array).filter{ predicate.evaluate(with: $0) }
//                print(result)
//
//                print("result: \(result)")
//                var namePredicate = NSPredicate(format: "firstName like %d",countryPhoneCode);
//
//                let filteredArray = arrNames.filter { namePredicate.evaluateWithObject($0) };
//                println("names = ,\(filteredArray)");
                //                    print("placeArray is \(placesArray as Any)")
            } catch {
                //handle error
                print(error)
            }
            
            
        }
       return (imageStr)
    }
    class func savingCountryListInUserDefaults()
    {
        let filePath = Bundle.main.path(forResource: "Country", ofType: "json")
        let data = NSData(contentsOfFile: filePath ?? "") as Data?
        var json: [Any]? = nil
        if let aData = data {
            json = try! JSONSerialization.jsonObject(with: aData, options: []) as? [Any]
        }
        if let aJson = json {
            print("\(aJson.count)")
//            print("\(aJson[0])")
            do {
                let countryListData = try NSKeyedArchiver.archivedData(withRootObject: aJson, requiringSecureCoding: true)
                UserDefaults.standard.set(countryListData, forKey: "countryList")

            } catch {
                //handle error
                print(error)
            }
        }
    }
    class func setProfileImage(imageView: UIImageView,borderColor:UIColor,imageString:String)
    {
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.layer.borderWidth = 0.2
        
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = borderColor.cgColor
        imageView.contentMode = .scaleToFill
        imageView.image = nil
        let placeHolderImg = UIImage(named: "EmptyProfile.png")
        
        imageView.sd_setShowActivityIndicatorView(true)
        imageView.sd_setIndicatorStyle(.gray)
        
        imageView.sd_setImage(with: URL(string: imageString), placeholderImage: placeHolderImg,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
            
            if error == nil
            {
                imageView.image = image
                
            }
            else{
                print(error?.localizedDescription as Any)
                imageView.contentMode = .center
                imageView.image = placeHolderImg
                
            }
            
            // Perform operation.
        })
    }
    //MARK: - Done button Method
    
    
    
    //MARK: Show Hud Loader
    /*
    class func showLoaderMethod(view:UIView,message:String)
    {
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.label.text = nil
        loadingNotification.mode = MBProgressHUDMode.customView
        UIApplication.shared.beginIgnoringInteractionEvents()
        var loaderHudView:LoaderHudView!
        loaderHudView = LoaderHudView(frame: CGRect(x: 0, y: 0, width: 80, height: 70))
        loaderHudView.translatesAutoresizingMaskIntoConstraints = false
        loaderHudView.layer.cornerRadius = 10.0
        loaderHudView.clipsToBounds = true
//        loaderHudView.hudImgView.image = UIImage(named: "app.png")
        loaderHudView.hudTextLbl.text = message
        loadingNotification.customView = loaderHudView
        if let asset = NSDataAsset(name: "Loader") {
            let assetdata = asset.data
            print("data \(assetdata)")
            loaderHudView.hudImgView.image = UIImage.sd_animatedGIF(with: assetdata)
        }

        loadingNotification.bezelView.color = UIColor.clear
        loadingNotification.bezelView.style = .solidColor
        loadingNotification.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        loadingNotification.backgroundView.isUserInteractionEnabled = false
//        loadingNotification.bezelView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        print("customView frame is \(loadingNotification.bounds as Any)")
        
    }
    */
    class func showLoaderMethod(shownView:UIView,message:String)
    {
        UIApplication.shared.beginIgnoringInteractionEvents()
        let loadingNotification = MBProgressHUD.showAdded(to: shownView, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = message
    }
    // MARK:- Date Methods
    class func currentDateTimeString() -> String
    {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppConstants.time24HoursFormat
        dateFormatter.timeZone = TimeZone.current
        let datestr = dateFormatter.string(from: date as Date)
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        print("datestring\(datestr)")
        return datestr
        
    }
    class func currentCalender()-> Calendar
    {
        var currentcalendar = Calendar.current
        currentcalendar.timeZone = TimeZone.current
        currentcalendar.timeZone = TimeZone(secondsFromGMT: 0)!
        currentcalendar.locale = Locale.current
        
        return currentcalendar
    }
    class func dayLimitCalendar() -> Date
    {

        var components = DateComponents()
        components.day = AppConstants.durationPeriod
        let date = Calendar.current.date(byAdding: components, to:Calendar.current.startOfDay(for: Date()))!
        return date
    }
    class func advtDayLimitCalendar() -> Date
    {
        
        var components = DateComponents()
        components.day = AppConstants.advtDurationPeriod
        let date = Calendar.current.date(byAdding: components, to:Calendar.current.startOfDay(for: Date()))!
        return date
    }
    class func currentDateTime() -> Date
    {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppConstants.defaultDateFormat
        dateFormatter.timeZone = TimeZone.current
        let datestr = dateFormatter.string(from: date as Date)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let currentDate = dateFormatter.date(from: datestr)
            else
        {
            return Date()
        }
        return currentDate
    }
    class func convertStringToDate(dateString:String,dateformat:String)-> Date
    {
        print("dateString \(dateString)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  dateformat
        //        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale.current
        
        //        let item = "7:00 PM"
        let date = dateFormatter.date(from: dateString)
        print("Start: \(String(describing: date))") // Start: Optional(2000-01-01 19:00:00 +0000)
        return date!
    }
    class func convert12hrStringToDate(dateString:String)-> Date
    {
        print("dateString \(dateString)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  AppConstants.time12HoursFormat
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale.current
        
        //        let item = "7:00 PM"
        let date = dateFormatter.date(from: dateString)
        print("Start: \(String(describing: date))") // Start: Optional(2000-01-01 19:00:00 +0000)
        return date!
    }
    class func stringToDate(dateString:String)-> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  AppConstants.time24HoursFormat
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
//        let item = "7:00 PM"
        let date = dateFormatter.date(from: dateString)
        print("Start: \(String(describing: date))") // Start: Optional(2000-01-01 19:00:00 +0000)
        return date!
    }
    // MARK:- 24 hrs to 12 hrs
    class func convert24hrto12hrFormat(dateStr:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppConstants.time24HoursFormat
        
        guard let date = dateFormatter.date(from: dateStr) else
        {
            return "00:00 AM"
        }
        dateFormatter.dateFormat = AppConstants.time12HoursInMeridianFormat
        let Date12 = dateFormatter.string(from: date)
//        print("12 hour formatted Date:",Date12)
        if Date12 == "12:00 AM"
        {
            return "00:00 AM"
        }
        return Date12
    }
    // MARK:- 12 hrs to 24 hrs
    class func convert12hrto24hrFormat(dateStr:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppConstants.time12HoursInMeridianFormat
        
        guard let date = dateFormatter.date(from: dateStr) else
        {
            return "00:00"
        }
        dateFormatter.dateFormat = AppConstants.time24HoursFormat
        let Date12 = dateFormatter.string(from: date)
        //        print("12 hour formatted Date:",Date12)
        return Date12
    }
    // MARK:- 24 hrs to 12 hrs
    class func convertHrstoMinsFormat(dateStr:String) -> String
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppConstants.time24HoursFormat
        
        
        guard let date = dateFormatter.date(from: dateStr) else
        {
            return "0 mins"
        }
        dateFormatter.dateFormat = AppConstants.timeHoursFormat
        let hour = dateFormatter.string(from: date)
        dateFormatter.dateFormat = AppConstants.timeMinFormat
        let minute = dateFormatter.string(from: date)
        
        let outputStr = "\(hour)hrs \(minute)mins"
        if outputStr == "12hrs 00mins"
        {
            return "0 mins"
        }
        else if outputStr.contains("12hrs")
        {
            return "\(minute)mins"
        }
        else if outputStr.contains("00mins")
        {
            return "\(hour)hrs"
        }
        return outputStr

    }
    class func getHrsFromDate(dateStr:String,type:String)->Int
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppConstants.time24HoursFormat

        guard let date = dateFormatter.date(from: dateStr) else
        {
            return 0
        }
        
        switch type
        {
        case "hour":
            dateFormatter.dateFormat = AppConstants.timeHoursFormat
            let hour = dateFormatter.string(from: date)
            if hour == "12"
            {
                return 0
            }
            return Int(hour)!
        case "min":
            dateFormatter.dateFormat = AppConstants.timeMinFormat
            let min = dateFormatter.string(from: date)
            return Int(min)!
        case "sec":
            dateFormatter.dateFormat = AppConstants.timeSecFormat
            let sec = dateFormatter.string(from: date)
            return Int(sec)!
        default:
            return 0
        }
    }
    //MARK Date to 12 hrs
    class func convertDateto12hrFormat(dateStr:Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppConstants.time12HoursInMeridianFormat
        let date = dateFormatter.string(from: dateStr)
        return date
    }
    
    class func dateFormatting(createdDateStr:String,dateFormat:String) -> String
    {
        if GenericMethods.isStringEmpty(createdDateStr) || createdDateStr.isEmpty || createdDateStr == "0"
        {
            return ""
        }
        let createdDateFormatter = DateFormatter()
        createdDateFormatter.dateFormat = AppConstants.defaultDateFormat
        let requesteddate = createdDateFormatter.date(from: createdDateStr)
        createdDateFormatter.dateFormat = dateFormat
        let str = createdDateFormatter.string(from: requesteddate!)
        if GenericMethods.isStringEmpty(str) || str.isEmpty || createdDateStr == "0"
        {
            return ""
        }
        return str
    }
    
    class func changeDateFormatting(createdDateStr:String,inputDateFormat:String,resultDateFormat:String) -> String
    {
        if GenericMethods.isStringEmpty(createdDateStr) || createdDateStr.isEmpty || createdDateStr == "0"
        {
            return ""
        }
        let createdDateFormatter = DateFormatter()
        createdDateFormatter.dateFormat = inputDateFormat
        let requesteddate = createdDateFormatter.date(from: createdDateStr)
        createdDateFormatter.dateFormat = resultDateFormat
        let str = createdDateFormatter.string(from: requesteddate!)
        if GenericMethods.isStringEmpty(str) || str.isEmpty || createdDateStr == "0"
        {
            return ""
        }
        return str
    }
    
    class func hideLoaderMethod(view:UIView)
    {
        MBProgressHUD.hide(for: view, animated: true)
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    class func navigateToDashboard()
    {
        let storyboard: UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let dashNavigateVC = storyboard.instantiateViewController(withIdentifier: "dashNavigateVC") as! DashboardNavigateVC
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = dashNavigateVC
        appDelegate?.window?.makeKeyAndVisible()
        
    }
    class func navigateToLogin()
    {
        let storyboard: UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC") as? LoginViewController
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = loginVC
        appDelegate?.window?.makeKeyAndVisible()
    }
    //MARK:- Calendar Methods
    class func checkDateisBetween(date:Date,lastDate:Date)-> Bool
    {
        let selectedDateFormatter = DateFormatter()
        selectedDateFormatter.dateFormat = AppConstants.defaultDateFormat
        selectedDateFormatter.timeZone = TimeZone.current
        let datestr = selectedDateFormatter.string(from: date)
        selectedDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        guard let currentDate = selectedDateFormatter.date(from: datestr)
            else
        {
            return false
        }
        
        selectedDateFormatter.dateFormat =
            AppConstants.postDateFormat
        
        guard let startDate2 = selectedDateFormatter.date(from: selectedDateFormatter.string(from: GenericMethods.currentDateTime()))
            else
        {
            return false
        }
        //        print("startDate2 \(startDate2)")
        let between = currentDate.isBetween(startDate2, and: lastDate)
        if between
        {
            //TODO: selectind slots
            //            print("between")
            return true
            
        }
        else
        {
            return false
        }
    }
    
    
    class func monthYearSelectionMethod(date:Date,previousBtnInstance:UIButton,nextBtnInstance:UIButton,lastDate:Date,dateFormat:String)
    { 
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = dateFormat
        dayFormatter.timeZone = TimeZone.current
        dayFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let firstDate = dayFormatter.date(from: dayFormatter.string(from: GenericMethods.currentDateTime()))
            else
        {
            return
        }
        guard let lastDate = dayFormatter.date(from: dayFormatter.string(from: lastDate))
            else
        {
            return
        }
        
        guard let currentDate = dayFormatter.date(from: dayFormatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: date)!))
            else
        {
            return
        }
        print("firstDate \(firstDate) currentDate \(currentDate) lastDate \(lastDate)")
        if firstDate == currentDate
        {
            print("this month")
            nextBtnInstance.isHidden = false
            previousBtnInstance.isHidden = true
        }
        else if lastDate == currentDate
        {
            nextBtnInstance.isHidden = true
            previousBtnInstance.isHidden = false
        }
        else
        {
            nextBtnInstance.isHidden = false
            previousBtnInstance.isHidden = false
        }
    }
    class func dateSelectionMethod(date:Date,previousBtnInstance:UIButton,nextBtnInstance:UIButton,lastDate:Date,dateFormat:String)
    {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = dateFormat
        dayFormatter.timeZone = TimeZone.current
        dayFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let firstDate = dayFormatter.date(from: dayFormatter.string(from: GenericMethods.currentDateTime()))
            else
        {
            return
        }
        guard let lastDate = dayFormatter.date(from: dayFormatter.string(from: lastDate))
            else
        {
            return
        }
        
        guard let currentDate = dayFormatter.date(from: dayFormatter.string(from: date))
            else
        {
            return
        }
        
        if firstDate == currentDate
        {
            print("this month")
            nextBtnInstance.isHidden = false
            previousBtnInstance.isHidden = true
        }
        else if lastDate == currentDate
        {
            nextBtnInstance.isHidden = true
            previousBtnInstance.isHidden = false
        }
        else
        {
            nextBtnInstance.isHidden = false
            previousBtnInstance.isHidden = false
        }
    }
    
    //MARK:- Getting thumbnail from Video
    class func createThumbnailOfVideoFromRemoteUrl(url: String,imgView:UIImageView,playImgView:UIImageView) {
        let ckeckUrl = FileUpload.checkImgOrVideofromURL(filePath: url)
        if ckeckUrl == AppConstants.videoFileName
        {
            let asset = AVAsset(url: URL(string: url)!)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            //Can set this to improve performance if target size is known before hand
            //assetImgGenerate.maximumSize = CGSize(width,height)
            let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
            do {
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let thumbnail = UIImage(cgImage: img)
                DispatchQueue.main.async {
                    playImgView.isHidden = false
                    imgView.contentMode = .scaleToFill
                    imgView.image = thumbnail
                }
                
            } catch {
                print(error.localizedDescription)
                imgView.contentMode = .center
                imgView.image = AppConstants.errorLoadingImg
            }
        }
        else
        {
            DispatchQueue.main.async {
                playImgView.isHidden = true
                imgView.contentMode = .scaleAspectFit
                imgView.image = nil
                imgView.sd_setShowActivityIndicatorView(true)
                imgView.sd_setIndicatorStyle(.gray)
                imgView.sd_setImage(with: URL(string: url), placeholderImage: AppConstants.docImgListplaceHolderImg,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
                    
                    if error == nil
                    {
                        imgView.image = image
                        
                    }
                    else
                    {
                        print("error is \(error?.localizedDescription as Any)")
                        imgView.contentMode = .center
                        imgView.image = AppConstants.errorLoadingImg
                        
                    }
                    
                    // Perform operation.
                })
                
                
                
                
            }
        }
        
                
        
        
    }
    // MARK:  Encrypt Method
    class func sha512(string:String) -> String
    {
        return string.sha512
    }
    
    class func md5(_ string: String) -> String {
        
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate()
        var hexString = ""
        for byte in digest {
            hexString += String(format:"%02x", byte)
        }
        
        return hexString
    }
//    class func sha512Hex( string: String) -> String {
//        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
//        if let data = string.data(using: String.Encoding.utf8) {
//            let value =  data as NSData
//            CC_SHA512(value.bytes, CC_LONG(data.count), &digest)
//
//        }
//        var digestHex = ""
//        for index in 0..<Int(CC_SHA512_DIGEST_LENGTH) {
//            digestHex += String(format: "%02x", digest[index])
//        }
//
//        return digestHex
//    }
    // MARK:  Email Check
    
    class func validate(YourEMailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: YourEMailAddress)
    }
    //MARK: Ghana Post
    class func validateGhanaPost(ghanaPost: String) -> Bool {
        let REGEX: String
        REGEX = "^((A[23FXYVWCNASGIHB49TEJKUDMO67PQRZ])|(B[UVQRACBDEFJIKLNOPGHSYZ23TXW])|(C[APOJBRSWXCEFGIKMTHUV])|(E[23MATOBXZDEFKPQHIJLNGSUVWY])|(G[AYXDBCESWKLMZNOT])|(N[BP3C4EGRAKMINO2XSUWTFL5DYZ])|(U[AWUBORSGKLNPT])|(X[DJKLONSTWXY])|(V[AFGWXBVHICJMKYZPRQSNODTEU])|(W[HACDBOEJQMNPFGSRUTWXYZ]))(-|)(\\d{3,4}|[0-4]\\d{4})(-|)\\d{4}$"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: ghanaPost)
    }
    //MARK: UserTypeFunction
    class func usertypeCompletionMethod(associatecompletionHandler: @escaping () -> Void,vendorcompletionHandler: @escaping () -> Void,storecompletionHandler: @escaping () -> Void)
    {
        
        switch UserDefaults.standard.object(forKey: "login_type") as! String {
        case "associate":
            associatecompletionHandler()
        case "vendor":
            vendorcompletionHandler()
        case "store":
            storecompletionHandler()
        default:
            break
        }
    }
    //MARK: Set USerdefault
    class func associateVendorUserdefaults(type:String)
    {
        switch type {
        case "associate":
            UserDefaults.standard.set(UserDefaults.standard.value(forKey: "a_user_id") as Any , forKey: "user_id")
            UserDefaults.standard.set(UserDefaults.standard.value(forKey: "a_user_reg_no") as? String ?? "" , forKey: "user_reg_no")
            UserDefaults.standard.set( UserDefaults.standard.value(forKey: "a_user_email") as? String ?? "" , forKey: "user_email")
            UserDefaults.standard.set( UserDefaults.standard.value(forKey: "a_user_firstName") as? String ?? "" , forKey: "user_firstName")
            UserDefaults.standard.set( UserDefaults.standard.value(forKey: "a_user_lastName") as? String ?? "" , forKey: "user_lastName")
            UserDefaults.standard.set( UserDefaults.standard.value(forKey: "a_userType_id") as Any , forKey: "userType_id")
            UserDefaults.standard.set( UserDefaults.standard.value(forKey: "a_verify_mobile") as? String ?? ""  , forKey: "verify_mobile")
            UserDefaults.standard.set("associate" , forKey: "login_type")
            
        case "vendor":
            UserDefaults.standard.set(UserDefaults.standard.value(forKey: "v_user_id") as Any , forKey: "user_id")
            UserDefaults.standard.set(UserDefaults.standard.value(forKey: "v_user_reg_no") as? String ?? "" , forKey: "user_reg_no")
            UserDefaults.standard.set( UserDefaults.standard.value(forKey: "v_user_email") as? String ?? "" , forKey: "user_email")
            UserDefaults.standard.set( UserDefaults.standard.value(forKey: "v_user_firstName") as? String ?? "" , forKey: "user_firstName")
            UserDefaults.standard.set( UserDefaults.standard.value(forKey: "v_user_lastName") as? String ?? "" , forKey: "user_lastName")
            UserDefaults.standard.set( UserDefaults.standard.value(forKey: "v_userType_id") as Any , forKey: "userType_id")
            UserDefaults.standard.set( UserDefaults.standard.value(forKey: "v_verify_mobile") as? String ?? ""  , forKey: "verify_mobile")
            UserDefaults.standard.set("vendor" , forKey: "login_type")
        default:
            break
        }
    }
    /*
    class func showFailureReasonMethod(fromView:String)
    {
        //AppConstants.isBillingEnable = false
        UserDefaults.standard.set(false, forKey: "isBillingEnable")
        
            func alert(reason:String)
            {
                if fromView == ""
                {
                self.showAlert(alertMessage: reason)
                }
            }
        
//        if UserDefaults.standard.value(forKey: "ApprovedStatus") as! String == "1" // success
//        {
//        if UserDefaults.standard.value(forKey: "AgreementStatus") as! String != "2" && UserDefaults.standard.value(forKey: "KYCApproveStatus") as! String != "2" && UserDefaults.standard.value(forKey: "ApprovedStatus") as! String == "1"
//        {
//            alert(reason: "KYC is rejected")
//        }
        
        
            if UserDefaults.standard.value(forKey: "AgreementStatus") as! String == "2" // success
            {
                if UserDefaults.standard.value(forKey: "KYCApproveStatus") as! String == "2" // success
                {
                    if UserDefaults.standard.value(forKey: "ApprovedStatus") as! String == "1" // success
                    {
                        if UserDefaults.standard.value(forKey: "login_type") as! String == "associate"
                        {
                            UserDefaults.standard.set(true, forKey: "isBillingEnable")
                        }
                        else if UserDefaults.standard.value(forKey: "login_type") as! String == "vendor" || UserDefaults.standard.value(forKey: "login_type") as! String == "store"
                        {
                            let expiryDateStr = UserDefaults.standard.value(forKey: "ExpiryDate") as! String
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                            //                        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                            let expirydate = dateFormatter.date(from: "\(expiryDateStr)T11:59:00")
                            print(expirydate  as Any)
                            let now = Date()
                            let presentDateStr = dateFormatter.string(from: now)
                            let presentDate: Date? = dateFormatter.date(from: presentDateStr)
                            print(presentDate  as Any)
                            if expirydate != nil
                            {
                                if expirydate! >= presentDate! //success
                                {
                                    UserDefaults.standard.set(true, forKey: "isBillingEnable")
                                    //AppConstants.isBillingEnable = true
                                    
                                }
                                else
                                {
                                    alert(reason: "Your package is expired")
                                }
                            }
                            else
                            {
                                alert(reason: "Your package is expired")
                            }
                        }
                        
                        
                    }
                    else
                    {
                        alert(reason: "Waiting for admin approval")
                        
                    }
                    
                }
                else if UserDefaults.standard.value(forKey: "KYCApproveStatus") as! String == "1"
                {
                    alert(reason: "KYC is rejected")
                }
                else
                {
                    alert(reason: "Waiting for KYC approval")
                }
            }
            else
            {
                if UserDefaults.standard.value(forKey: "AgreementStatus") as! String == "1"
                {
                    alert(reason: "Agreement is rejected")
                }
                else
                {
                    alert(reason: "Waiting for agreement approval")
                    
                }
                
            }
//        }
//        else
//        {
//            alert(reason: "Waiting for admin approval")
//
//        }
    }
    */
    
    class func showFailureReasonMethod(fromView:String)
    {
        UserDefaults.standard.set(false, forKey: "isBillingEnable")
        
        func checkExpiryMEthod()
        {
            
            let expiryDateStr = UserDefaults.standard.value(forKey: "ExpiryDate") as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            //                        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
            let expirydate = dateFormatter.date(from: "\(expiryDateStr)T11:59:00")
            print(expirydate  as Any)
            let now = Date()
            let presentDateStr = dateFormatter.string(from: now)
            let presentDate: Date? = dateFormatter.date(from: presentDateStr)
            print(presentDate  as Any)
            if expirydate != nil
            {
                if expirydate! >= presentDate! //success
                {
                    UserDefaults.standard.set(true, forKey: "isBillingEnable")
                    //AppConstants.isBillingEnable = true
                    
                }
                else
                {
                    alert(reason: "Your package is expired")
                }
            }
            else
            {
                alert(reason: "Your package is expired")
            }
            
            
        }
        
        func approveExpiryMethod()
        {
            if UserDefaults.standard.value(forKey: "ApprovedStatus") as! String == "1" // success
            {

                    let expiryDateStr = UserDefaults.standard.value(forKey: "ExpiryDate") as! String
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    //                        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                    let expirydate = dateFormatter.date(from: "\(expiryDateStr)T11:59:00")
                    print(expirydate  as Any)
                    let now = Date()
                    let presentDateStr = dateFormatter.string(from: now)
                    let presentDate: Date? = dateFormatter.date(from: presentDateStr)
                    print(presentDate  as Any)
                    if expirydate != nil
                    {
                        if expirydate! >= presentDate! //success
                        {
                            UserDefaults.standard.set(true, forKey: "isBillingEnable")
                            //AppConstants.isBillingEnable = true
                            
                        }
                        else
                        {
                            alert(reason: "Your package is expired")
                        }
                    }
                    else
                    {
                        alert(reason: "Your package is expired")
                    }

                
            }
            else
            {
                alert(reason: "Waiting for admin approval")
                
            }
            
        }
        func agreementApprovalMEthod(kycreason:String)
        {
            
            if UserDefaults.standard.value(forKey: "login_type") as! String == "vendor" || UserDefaults.standard.value(forKey: "login_type") as! String == "store"
            {
                if UserDefaults.standard.value(forKey: "AgreementStatus") as! String != "2"
                {
                    switch UserDefaults.standard.value(forKey: "AgreementStatus") as! String
                    {
                    case "0":
                        kycreason == "" ? alert(reason: "Upload your agreement") : alert(reason: "\(kycreason) & agreement")
                    case "1":
                        kycreason == "" ? alert(reason: "Upload your agreement") : alert(reason: "\(kycreason) & agreement is rejected")
                        alert(reason: "Agreement is rejected")
                    case "3":
                        kycreason == "" ? alert(reason: "Agreement is pending") : alert(reason: "\(kycreason) & agreement is pending for approval")
                    default:
                        break
                    }
                }
                else
                {
                    alert(reason: kycreason)
                }
            }
            else if UserDefaults.standard.value(forKey: "login_type") as! String == "associate"
            { // associate
                if kycreason == ""
                {
                    if UserDefaults.standard.value(forKey: "ApprovedStatus") as! String != "1"
                    {
                        alert(reason: "Waiting for admin approval")
                    }
                    else
                    {
                        UserDefaults.standard.set(true, forKey: "isBillingEnable")
                    }
                }
                else
                {
                   alert(reason: kycreason)
                }
                
            }
            
        }
        func alert(reason:String)
        {
            if fromView == ""
            {
                self.showAlert(alertMessage: reason)
            }
        }
        
        //if UserDefaults.standard.value(forKey: "ApprovedStatus") as! String != "1"
//        {
//            alert(reason: "Waiting for admin approval")
//        }
        
        
        self.usertypeCompletionMethod(associatecompletionHandler: {
            
            if UserDefaults.standard.value(forKey: "verify_mobile") as! String == "1" && UserDefaults.standard.value(forKey: "KYCApproveStatus") as! String == "2"
            {
                if UserDefaults.standard.value(forKey: "ApprovedStatus") as! String != "1"
                {
                    alert(reason: "Waiting for admin approval")
                }
                else
                {
                    UserDefaults.standard.set(true, forKey: "isBillingEnable")
                }
            }
            else
            {
                func kycapproveStatusMethod(mobileVerifyStr:String)
                {
                    switch UserDefaults.standard.value(forKey: "KYCApproveStatus") as! String
                    {
                    case "0":
                        mobileVerifyStr == "" ? alert(reason: "Please Upload your KYC") : alert(reason: "\(mobileVerifyStr) & Upload your KYC")
                    case "1":
                        mobileVerifyStr == "" ? alert(reason: "KYC is rejected") : alert(reason: "\(mobileVerifyStr) & KYC is rejected")
                    case "2":
                        mobileVerifyStr == "" ? alert(reason: "") : alert(reason: "\(mobileVerifyStr)")
                    case "3":
                        mobileVerifyStr == "" ? alert(reason: "KYC is pending") : alert(reason: "\(mobileVerifyStr) & KYC is pending")
                    default:
                        break
                    }
                }
                if UserDefaults.standard.value(forKey: "verify_mobile") as! String != "1"
                { // mobile failure
                    kycapproveStatusMethod(mobileVerifyStr: "Mobile No. is not verified")
//                    UserDefaults.standard.set(true, forKey: "isBillingEnable")
                    
                }
                else
                { // kyc failure
                    kycapproveStatusMethod(mobileVerifyStr: "")
                }
            }
        }, vendorcompletionHandler: {
            
            if UserDefaults.standard.value(forKey: "verify_mobile") as! String == "1" && UserDefaults.standard.value(forKey: "KYCApproveStatus") as! String == "2"
            {
                if UserDefaults.standard.value(forKey: "AgreementStatus") as! String == "2"
                {
                    approveExpiryMethod()
                }
                else
                {
                    agreementApprovalMEthod(kycreason: "")
                }
                
            }
            else if UserDefaults.standard.value(forKey: "verify_mobile") as! String != "1"
            { // mobile failure
                alert(reason: "Mobile No. is not verified")
//                UserDefaults.standard.set(true, forKey: "isBillingEnable")
            }
            else
            { // kyc failure
                switch UserDefaults.standard.value(forKey: "KYCApproveStatus") as! String
                {
                case "0":
                    agreementApprovalMEthod(kycreason: "Upload your KYC")
                case "1":
                    agreementApprovalMEthod(kycreason: "KYC is rejected")
                case "3":
                    agreementApprovalMEthod(kycreason: "KYC is pending")
                default:
                    break
                }
                
            }
        }, storecompletionHandler: {
            
            if UserDefaults.standard.value(forKey: "store_ApprovedStatus") as! String == "1" // success
            {
                
                if UserDefaults.standard.value(forKey: "verify_mobile") as! String == "1" && UserDefaults.standard.value(forKey: "KYCApproveStatus") as! String == "2"
                {
                    if UserDefaults.standard.value(forKey: "AgreementStatus") as! String == "2"
                    {
                        approveExpiryMethod()
                    }
                    else
                    {
                        agreementApprovalMEthod(kycreason: "")
                    }
                    
                }
                else if UserDefaults.standard.value(forKey: "verify_mobile") as! String != "1"
                { // mobile failure
                    alert(reason: "Mobile No. is not verified")
//                    UserDefaults.standard.set(true, forKey: "isBillingEnable")
                }
                else
                { // kyc failure
                    switch UserDefaults.standard.value(forKey: "KYCApproveStatus") as! String
                    {
                    case "0":
                        agreementApprovalMEthod(kycreason: "Upload your KYC")
                    case "1":
                        agreementApprovalMEthod(kycreason: "KYC is rejected")
                    case "3":
                        agreementApprovalMEthod(kycreason: "KYC is pending")
                    default:
                        break
                    }
                    
                }
            }
            else
            {
                alert(reason: "Waiting for admin approval")
            }
            
        })
        
        
        /*
        if UserDefaults.standard.value(forKey: "verify_mobile") as! String == "1"
        {
            //vendor
            if UserDefaults.standard.value(forKey: "AgreementStatus") as! String == "2" || UserDefaults.standard.value(forKey: "KYCApproveStatus") as! String == "2" // success
            {
                approveExpiryMethod()
            }
            else
            {
                if UserDefaults.standard.value(forKey: "KYCApproveStatus") as! String != "2"
                {
                    switch UserDefaults.standard.value(forKey: "KYCApproveStatus") as! String
                    {
                    case "0":
                        agreementApprovalMEthod(kycreason: "Upload your KYC")
                    case "1":
                        agreementApprovalMEthod(kycreason: "KYC is rejected")
                    case "3":
                        agreementApprovalMEthod(kycreason: "KYC is pending")
                    default:
                        break
                    }
                }
                else
                {
                    agreementApprovalMEthod(kycreason: "")
                }
                
            }
        }
        else
        {
            alert(reason: "Mobile No. is not verified")
        }
        */
    }
    class func convertingAmountValueToStr(sendValue:Any)->String
    {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencySymbol = ""
        // localize to your grouping and decimal separator
        //        currencyFormatter.locale = Locale.current
        currencyFormatter.locale = Locale(identifier: "en_IN")
        
        print("sendValue \(sendValue as Any)")
        if sendValue as? String ?? "" != ""
        {
            let doubleValue:Double = Double(sendValue as! String)!
//            print("doubleValue is \(doubleValue)")
            // We'll force unwrap with the !, if you've got defined data you may need more error checking
            let priceString = currencyFormatter.string(from: NSNumber(value: doubleValue))!
//            print("priceString is \(priceString)")
            if priceString.contains(".00")
            {
                let newString = priceString.replacingOccurrences(of: ".00", with: "", options: .literal, range: nil)
//                print("newString is \(newString)")
                return newString
            }
            return priceString
//            return sendValue as! String
        }
        else
        {
            if sendValue as? Int ?? 0 != 0
            {
                let myInt = sendValue as! Int
//                print("myInt is \(myInt)")
                // We'll force unwrap with the !, if you've got defined data you may need more error checking
                let priceString = currencyFormatter.string(from: NSNumber(value: myInt))!
                if priceString.contains(".00")
                {
                    let newString = priceString.replacingOccurrences(of: ".00", with: "", options: .literal, range: nil)
//                    print("newString is \(newString)")
                    return newString
                }
                return priceString
//                return "\(sendValue as! Int)"
            }
            else
            {
                if sendValue as? Double ?? 0.0 == 0.0
                {
                    return "0"
                }
                else
                {
//                    return "\(Double(round(100 * (sendValue as! Double))/100))"
                    let myDouble = Double(round(100 * (sendValue as! Double))/100)
//                    print("myDouble is \(myDouble)")
                    // We'll force unwrap with the !, if you've got defined data you may need more error checking
                    let priceString = currencyFormatter.string(from: NSNumber(value: myDouble))!
//                    print("priceString is \(priceString)")
                    if priceString.contains(".00")
                    {
                        let newString = priceString.replacingOccurrences(of: ".00", with: "", options: .literal, range: nil)
//                        print("newString is \(newString)")
                        return newString
                    }
                    return priceString
                }
            }
        }
        /*
        let myDouble = Double(round(100 * (sendValue as! Double))/100)
        print("myDouble is \(myDouble)")
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        //        currencyFormatter.locale = Locale.current
        currencyFormatter.locale = Locale(identifier: "en_IN")
        
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        let priceString = currencyFormatter.string(from: NSNumber(value: myDouble))!
        print("priceString is \(priceString)")
        
        return priceString
        */
//        return ""
    }
    //MARK: Convert Any to String
    class func convertingAnyToStr(sendValue:Any) -> String
    {
        if sendValue as? String ?? "" != ""
        {
            return sendValue as! String
        }
        else
        {
            if sendValue as? Int ?? 0 != 0
            {
                return "\(sendValue as! Int)"
            }
            else
            {
                if sendValue as? Double ?? 0.0 == 0.0
                {
                    return "0"
                }
                else
                {
                    return "\(Double(round(100 * (sendValue as! Double))/100))"
                }
            }
        }
    }
    //MARK:
    class func getPermissionforPHAsset(vc:UIViewController)
    {
        PHPhotoLibrary.requestAuthorization({status in
            switch status {
            case .authorized:
                break
            case .denied:
                print("denied")
                FileUpload.galleryDenied(vc: vc)
                
            // probably alert the user that they need to grant photo access
            case .notDetermined:
                print("not determined")
            case .restricted:
                print("restricted")
                // probably alert the user that photo access is restricted
            }
        })
    }
    
    //MARK: AlertController
    class func showAlertMethod(alertMessage: String)
    {
        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
         GenericMethods.hideLoading()
        UIApplication.shared.topMostViewController()?.present(alert, animated: true)
        let duration: Int = 1 // duration in seconds
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Double(duration) * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
            alert.dismiss(animated: true)
        })
    }
    class func showAlert(alertMessage: String)
    {
        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle:
            .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            UIApplication.shared.topMostViewController()?.present(alert, animated: true, completion: nil)
            GenericMethods.hideLoading() // Hide any loader presented
        }
    }
    class func showAlertwithPopNavigation(alertMessage:String,vc:UIViewController)
    {
        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle:
            .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            alert.dismiss(animated: true, completion: nil)
            vc.navigationController?.popViewController(animated: true)
        }))
        
        DispatchQueue.main.async {
            UIApplication.shared.topMostViewController()?.present(alert, animated: true, completion: nil)
            GenericMethods.hideLoading() // Hide any loader presented
        }
    }
    class func showAlertWithTitle(alertTitle: String,alertMessage: String)
    {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle:
            .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            UIApplication.shared.topMostViewController()?.present(alert, animated: true, completion: nil)
            GenericMethods.hideLoading() // Hide any loader presented
        }
    }


    // MARK: Reset Userdefaults
    class func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            print(key)
            if key != "device_token"
            {
               defaults.removeObject(forKey: key)
            }
            
        }
        
    }

    //MARK: AlertController
    class func showYesOrNoAlertWithCompletionHandler(alertTitle:String, alertMessage: String, completionHandlerForOk : @escaping (UIAlertAction) -> Void)
    {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle:
            .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: completionHandlerForOk))
        
        DispatchQueue.main.async {
            UIApplication.shared.topMostViewController()?.present(alert, animated: true, completion: nil)
            GenericMethods.hideLoading() // Hide any loader presented
        }
    }

    class func showAlertWithCompletionHandler(alertMessage: String, completionHandlerForOk : @escaping (UIAlertAction) -> Void)
    {
        let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle:
            .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completionHandlerForOk))

        DispatchQueue.main.async {
            UIApplication.shared.topMostViewController()?.present(alert, animated: true, completion: nil)
            GenericMethods.hideLoading() // Hide any loader presented
        }
    }

    //MARK:ActionSheet
    class func showActionSheet(actions: [String]) {
        let alert = UIAlertController(title: "Greetings!", message: nil, preferredStyle:
            .actionSheet)
        
        for stringIndex in actions {
            
            alert.addAction(UIAlertAction(title: stringIndex, style: .default, handler: nil))
            
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            UIApplication.shared.topMostViewController()?.present(alert, animated: true, completion: nil)
        }
    }

    


    class func showNoInternetAlert()
    {
        
        let alert = UIAlertController(title: "No Internet Connection", message: "\nCheck your network settings and try again", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction) in
        })
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler:{ (action:UIAlertAction) in
            guard let settingsUrl = URL(string: AppConstants.UIApplicationOpenSettingsURLString)
                else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl)
            {
                if #available(iOS 10.0, *)
                {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Back to app From Settings: \(success)") // Prints true
                    })
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(settingsUrl)
                }
            }
        })
        
        alert.addAction(okAction)
        alert.addAction(settingsAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
   
    
    
    class func showLoading()
    {
        
        if appDelegate.isLoading == false
        {
            appDelegate.isLoading = true
            DispatchQueue.main.async {
                bgView = UIView(frame: CGRect(x: 0, y: 0, width: (appDelegate.window?.frame.size.width)!, height: (appDelegate.window?.frame.size.height)!))
                bgView.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.5)
                appDelegate.window?.addSubview(bgView)
                appDelegate.window?.bringSubviewToFront(bgView)
                
                loaderView = UIView(frame: CGRect(x: (bgView.frame.size.width - 100)/2 , y: (bgView.frame.size.height - 100)/2 , width: 100, height: 100))
                loaderView.backgroundColor = UIColor.black
                loaderView.layer.cornerRadius = 15
                loaderView.layer.masksToBounds = true
                appDelegate.window?.addSubview(loaderView)
                
                activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
                activityIndicator.frame = CGRect(x: (loaderView.frame.size.width - 50)/2 , y: (loaderView.frame.size.height - 50)/2 , width: 50, height: 50)
                activityIndicator.startAnimating()
                loaderView.addSubview(activityIndicator)
            }
        }
    }
    class func hideLoading()
    {
        if appDelegate.isLoading == true || AppConstants.isLoading == true
        {
            appDelegate.isLoading = false
            DispatchQueue.main.async {
                activityIndicator.removeFromSuperview()
                bgView.removeFromSuperview()
                loaderView.removeFromSuperview()
            }
        }
    }
//    class func createLeftMenu(viewController:UIViewController)
//    {
//        let button1 = UIBarButtonItem(image: UIImage(named: "Menu"), style: .plain, target: self, action: #selector(self.menuAction(vc:viewController)))
//        viewController.navigationItem.leftBarButtonItem  = button1
//    }
//    @objc func menuAction(vc:UIViewController)
//    {
//        vc.sideMenuViewController!.presentLeftMenuViewController()
//    }

}
