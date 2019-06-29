//
//  AppDelegate.swift
//  TheOneDoctor
//
//  Created by MyMac on 06/05/19.
//  Copyright © 2019 MyMac. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseCore
import FirebaseDynamicLinks
import FirebaseMessaging
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isLoading:Bool = false
    let gcmMessageIDKey = "gcm.message_id"
    
    var refreshedToken:String = ""
    var instanceToken:String = ""
    var device_token:String = ""



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("first date \(GenericMethods.dayLimitCalendar())")
        
         guard let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {
         return false
         }
         statusBarView.backgroundColor = UIColor(named: "AppStatusBarColor")
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if #available(iOS 10, *) {
            print("iOS 10 up")
            UNUserNotificationCenter.current().delegate = self
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                guard error == nil else {
                    print("regist fail = \(String(describing: error))")
                    return
                }
                if granted {
                    print("allow regist")
                } else {
                    //Handle user denying permissions..
                    print("deny regist")
                    
                    let alert = UIAlertController(title: "Notification Services Disabled!", message: "Please open this app's settings enable Notifications to get important Updates!", preferredStyle:
                        .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (alertAction) in
                        
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                            })
                        }
                        
                    }))
                    DispatchQueue.main.async {
                        UIApplication.shared.topMostViewController()?.present(alert, animated: true, completion: nil)
                        GenericMethods.hideLoading() // Hide any loader presented
                    }
                    
                }
            }
        } else {
            print("iOS 9 down")
            let pushNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings( pushNotificationSettings )
        }
        application.registerForRemoteNotifications()
        
        user_idChecking()
 
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = false

        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        ConnectToFCM()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    func ConnectToFCM() {
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                print("DCS: " + result.token)
                
                UserDefaults.standard.set(result.token, forKey: "device_token")
                print(UserDefaults.standard.value(forKey: "device_token") as? String ?? "empty")
                
                //                if let token = InstanceID.instanceID().token() {
                //                    print("DCS: " + token)
                //                }
                //                self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
            }
        }
        
    }
    func current()
    {
        print("xx \(GenericMethods.currentDateTime())")
    }
    func autoRefreshMethod()
    {
        if ((UIApplication.shared.topMostViewController() as? QueueViewController) != nil)
        {
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshQueue"), object: nil)

        }
        else if ((UIApplication.shared.topMostViewController() as? AppointmentsViewController) != nil)
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshAppointments"), object: nil)
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TheOneDoctor")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func user_idChecking()
    {
        print("user_idChecking")
        if UserDefaults.standard.value(forKey: "user_id") != nil
        {
            GenericMethods.navigateToDashboard()
        }
        else
        {
            GenericMethods.navigateToLogin()
        }
    }
    func jsonConversion(_ key: Any?) {
        
        var str: String? = nil
        if let aKey = key {
            str = "\(aKey)"
        }
        //        var err: Error? = nil
        var alertacceptDict: [AnyHashable : Any]? = nil
        if let anEncoding = str?.data(using: .utf8) {
            alertacceptDict = try! JSONSerialization.jsonObject(with: anEncoding, options: .mutableContainers) as? [AnyHashable : Any]
        }
        if let aDict = alertacceptDict {
            print("responseDict \(aDict)")
        }
        if let aKey = alertacceptDict?["type"] {
            print("Type is \("\(aKey)")")
        }
        
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func registerPushNotification(_ application: UIApplication) {
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        
        // For iOS 10 data message (sent via FCM)
        Messaging.messaging().delegate = self
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //When the notifications of this code worked well, there was not yet.
        Messaging.messaging().apnsToken = deviceToken
        device_token = "\(deviceToken)"
        device_token = device_token.replacingOccurrences(of: " ", with: "")
        device_token = device_token.replacingOccurrences(of: ">", with: "")
        device_token = device_token.replacingOccurrences(of: "<", with: "")
        print("device token is \(device_token)")
//        UserDefaults.standard.set(device_token, forKey: "device_token")
        ConnectToFCM()
        
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        print("didReceiveRemoteNotification")
        if let messageID = userInfo[gcmMessageIDKey] {
            debugPrint("Message ID: \(messageID)")
        }
        
        // Print full message.
        debugPrint(userInfo)
        print("HANDLE PUSH, didReceiveRemoteNotification: \(userInfo)")
        //        if UIApplication.shared.applicationState == .inactive {
        //            print("INACTIVE")
        //            NSAssertionHandler(UIBackgroundFetchResult)
        //        } else if UIApplication.shared.applicationState == .background {
        //            print("BACKGROUND")
        //            completionHandler(UIBackgroundFetchResultNewData)
        //        } else {
        //            print("FOREGROUND")
        //            completionHandler(UIBackgroundFetchResultNewData)
        //        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification2")
        
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        debugPrint(userInfo)
        
        completionHandler(.newData)
        AppConstants.isNotified = true
        let foregroundcenter = UNUserNotificationCenter.current()
        foregroundcenter.removeAllDeliveredNotifications()
        foregroundcenter.removeAllPendingNotificationRequests()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("\(userInfo)")
        if let key1 = userInfo["key1"]
        {
            print(key1)
            jsonConversion(key1)
        }
        
//        let content = UNMutableNotificationContent()
//        content.title = "Title"
//        content.body = "Body"
//        content.sound = UNNotificationSound.default
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//        let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // showing push notification
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceiveuserNotificationCenter")
        //        if let userInfo = response.notification.request.content.userInfo as? [String : Any] {
        //            let routerManager = RouterManager()
        //            routerManager.launchRouting(userInfo)
        //        }
        completionHandler()
        print("\(response.notification.request.content.userInfo)")
        if UIApplication.shared.applicationState == .inactive {
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
            UIApplication.shared.applicationIconBadgeNumber = 0
            print("\(response.notification.request.content.userInfo)")
            if let key1 = response.notification.request.content.userInfo["key1"]
            {
                print(response.notification.request.content.userInfo)
                jsonConversion(key1)
            }
            
            print("INACTIVE")
        }
        else if UIApplication.shared.applicationState == .background {
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
            UIApplication.shared.applicationIconBadgeNumber = 0
            print("\(response.notification.request.content.userInfo)")
            if let key1 = response.notification.request.content.userInfo["key1"]
            {
                print(response.notification.request.content.userInfo)
                jsonConversion(key1)
            }
            print("BACKGROUND")
        }
        else {
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
            
            UIApplication.shared.applicationIconBadgeNumber = 0
            print("\(response.notification.request.content.userInfo)")
            if let key1 = response.notification.request.content.userInfo["key1"]
            {
                print(response.notification.request.content.userInfo)
                jsonConversion(key1)
            }
            
            print("FOREGROUND")
        }
        
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("applicationReceivedRemoteMessage")
        print(remoteMessage)
        print("appdata \(remoteMessage.appData)")
        
        
        guard let data =
            try? JSONSerialization.data(withJSONObject: remoteMessage.appData, options: .prettyPrinted),
            let prettyPrinted = String(data: data, encoding: .utf8) else { return }
        print("Received direct channel message:\n\(prettyPrinted)")
        var alertacceptDict: [AnyHashable : Any]? = nil
        
        alertacceptDict = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [AnyHashable : Any]
        if let aDict = alertacceptDict {
            print("responseDict \(aDict)")
        }
        if let body = alertacceptDict?["body"] {
            print("body is \("\(body)")")
        }
        if let title = alertacceptDict?["title"] {
            print("title is \("\(title)")")
        }
        if let ClinicName = alertacceptDict?["Clinic Name"] {
            print("Clinic Name is \("\(ClinicName)")")
        }
        if let Address = alertacceptDict?["Address"] {
            print("Address is \("\(Address)")")
        }
        if let type = alertacceptDict?["type"] as? String {
            print("type is \("\(type)")")
            switch type
            {
            case "100":
                autoRefreshMethod()
            default:
                break
            }
            
        }
    }
    func application(received remoteMessage: MessagingRemoteMessage) {
        print("Received Remote Message: 3\nCheck In:\n")
        debugPrint(remoteMessage.appData)
        print("Received Remote Message: 3\nCheck Out:\n")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent")
        
        //        if let userInfo = notification.request.content.userInfo as? [String : Any] {
        //            if let categoryID = userInfo["categoryID"] as? String {
        //                if categoryID == RouterManager.Categories.newMessage.id {
        //                    if let currentConversation = ChatGeneralManager.shared.currentChatPersonalConversation, let dataID = userInfo["dataID"] as? String  {
        //                        // dataID is conversationd id for newMessage
        //                        if currentConversation.id == dataID {
        //                            completionHandler([])
        //                            return
        //                        }
        //                    }
        //                }
        //            }
        //            if let badge = notification.request.content.badge {
        //                AppBadgesManager.shared.pushNotificationHandler(userInfo, pushNotificationBadgeNumber: badge.intValue)
        //            }
        //        }
        completionHandler([.alert,.sound, .badge])
        AppConstants.isNotified = true
        let foregroundcenter = UNUserNotificationCenter.current()
        foregroundcenter.removeAllDeliveredNotifications()
        foregroundcenter.removeAllPendingNotificationRequests()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("\(notification.request.content.userInfo)")
        if let key1 = notification.request.content.userInfo["key1"]
        {
            print(notification.request.content.userInfo)
            jsonConversion(key1)
        }
        
        
    }
    
}

// [START ios_10_data_message_handling]
extension AppDelegate : MessagingDelegate {
    
    private func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        ConnectToFCM()
    }
    
    
    // Receive data message on iOS 10 devices while app is in the foreground.
//    func application(received remoteMessage: MessagingRemoteMessage) {
//        debugPrint(remoteMessage.appData)
//    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        AppConstants.fcmToken = fcmToken
        
        
        //        let dataDict:[String: String] = ["token": fcmToken]
        //        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
}
