//
//  AppDelegate.swift
//  BeaconAppTestSW
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import CoreData
import BeaconMailSW
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        BeaconMail.initWith(application)
        
        //Check log for crash
        Fabric.with([Crashlytics.self])
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        BeaconMail.didEnterBackground(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        BeaconMail.willEnterForeground(application)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        BeaconMail.open(application, inViewController: nil)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        BeaconMail.willTerminate(application)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification){
        BeaconMail.receiveLocalNotification(application, didReceiveLocalNotification: notification)
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        BeaconMail.fetchBackground(application, performFetchWithCompletionHandler: completionHandler)
    }
}

