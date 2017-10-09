//
//  BeaconMail.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation
open class BeaconMail: NSObject {
    fileprivate static let beaconMailDelegate = BeaconMailDelegate()
    
    open static func initWith(_ application: UIApplication){
        beaconMailDelegate.application(application)
        
    }
    open static func open(_ application: UIApplication, inViewController vc: UIViewController?){
        if let vc = vc {
            beaconMailDelegate.application(application, startInView: vc)
        }else {
            beaconMailDelegate.applicationDidBecomeActive(application)
        }
        
    }
    
    open static func willTerminate(_ application: UIApplication){
        beaconMailDelegate.applicationWillTerminate(application)
    }
    //fix error
    open static func fetchBackground(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        beaconMailDelegate.application(application, performFetchWithCompletionHandler: completionHandler)
        //beaconMailDelegate.application(application, performFetchWithCompletionHand
       // completionHandler(UIBackgroundFetchResult.newData)

        
    }
    
    
    open static func receiveLocalNotification(_ application: UIApplication, didReceiveLocalNotification notification: UILocalNotification){
        beaconMailDelegate.application(application, didReceiveLocalNotification: notification)
    }
    
    open static func willEnterForeground(_ application: UIApplication){
        beaconMailDelegate.applicationWillEnterForeground(application)
    }
    
    open static func didEnterBackground(_ application: UIApplication){
        beaconMailDelegate.applicationDidEnterBackground(application)
    }
    
    open static func reloadMonitoringRegion() {
        beaconMailDelegate.startMonitoring()
    }
    
}
