//
//  AppManager.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import CoreLocation

class AppManager: NSObject {
    // shared instance
    class var shared : AppManager {
        struct Static {
            static let instance : AppManager = AppManager()
        }
        return Static.instance
    }
    
    static func requestAuthorizationNotification()
    {
        // IOS >= 8.0
        // notification
        if #available(iOS 8.0, *) {
            let types = UIUserNotificationType([UIUserNotificationType.alert, UIUserNotificationType.sound, UIUserNotificationType.badge])
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: types, categories: nil))
        } else {
            let types = UIRemoteNotificationType([UIRemoteNotificationType.alert,UIRemoteNotificationType.badge,UIRemoteNotificationType.sound])
            UIApplication.shared.registerForRemoteNotifications(matching: types)
        }
        
    }
    static func requestAuthorizationLocation(_ locationManager:CLLocationManager,isAlways:Bool) {
        if CLLocationManager.locationServicesEnabled(){
            if isAlways
            {
                if #available(iOS 8.0, *) {
                    if locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)) {
                        locationManager.requestAlwaysAuthorization()
                    }
                }
                
            }else{
                if #available(iOS 8.0, *) {
                    if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
                        locationManager.requestWhenInUseAuthorization()
                    }
                }
            }
        }
    }
    
}
