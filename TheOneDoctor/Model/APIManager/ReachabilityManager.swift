//
//  ReachabilityManager.swift
//  PayWow
//
//  Created by STS-197 on 5/18/18.
//  Copyright © 2018 Manoj Ellappan. All rights reserved.
//

import UIKit
import Reachability

class ReachabilityManager: NSObject {

    static let shared = ReachabilityManager()  // 2. Shared instance
    
    // 3. Boolean to track network reachability
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .none
    }
    
    // 4. Tracks current NetworkStatus (notReachable, reachableViaWiFi, reachableViaWWAN)
    var reachabilityStatus: Reachability.Connection = .none
    
    // 5. Reachibility instance for Network status monitoring
    let reachability = Reachability()!
    
    
    // Called whenever there is a change in NetworkReachibility Status
    ///
    /// — parameter notification: Notification with the Reachability instance
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .none:
            debugPrint("Network became unreachable")
        case .wifi:
//            Sync.startSync()
            debugPrint("Network reachable through WiFi")
        case .cellular:
//            Sync.startSync()
            debugPrint("Network reachable through Cellular Data")
        }
    }
    
    
    func isConnectedToNetwork() -> Bool{
        let reachability = Reachability()
        var flag : Bool = false
        switch reachability?.connection {
        case .none?:
            debugPrint("Network became unreachable")
            flag = false
        case .wifi?:
            debugPrint("Network reachable through WiFi")
            flag = true
        case .cellular?:
            debugPrint("Network reachable through Cellular Data")
            flag = true
            
        case .none:
            debugPrint("None")
            flag = false
        }
        return flag
    }
    
    /// Starts monitoring the network availability status
    func startMonitoring() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: Notification.Name.reachabilityChanged,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            debugPrint("Could not start reachability notifier")
        }
    }
    
    /// Stops monitoring the network availability status
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged,
                                                  object: reachability)
    }
    
    
}
