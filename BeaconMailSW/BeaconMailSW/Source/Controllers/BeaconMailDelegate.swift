//
//  BeaconMailDelegate.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
class BeaconMailDelegate: NSObject {
    var fetchStart: Date?
    var count: Int = 0
    var isFromNotification = false
    var isWillEnter = false
    lazy var window = UIApplication.shared.keyWindow
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    static var shared : BeaconMailDelegate?

    func application(_ application: UIApplication) {
        
        
        BeaconMailDelegate.shared = self
        
         UIApplication.shared.cancelAllLocalNotifications()
        
        //application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    
        application.setMinimumBackgroundFetchInterval(TIME_GET_BACKGROUND)
        
        AppConfig.initValueUserDefaults()
        AppManager.requestAuthorizationNotification()
        
        //self.setBadge()
        self.startMonitoring()
        
        //more time for check and run background
        self.backgroundTask = UIApplication.shared.beginBackgroundTask (expirationHandler: {
            [unowned self] in
            self.endBackgroundTask()
        })
    }
    
    func application(_ application: UIApplication, startInView: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: BeaconMailDelegate.self))
        let splashVC = storyboard.instantiateViewController(withIdentifier: "SplashViewController")
        startInView.present(splashVC, animated: false, completion: nil)
        delay(3, closure: {
            
        })
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        BeaconDetectManager.shared.checkBlueToothPermissionCallOneTime = false
        BeaconDetectManager.shared.checkLocationPermissionCallOneTime = true
        self.isFromNotification = false
        self.isWillEnter = false
        self.setBadge()
        BeaconDetectManager.shared.delegate = self
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.isWillEnter = true
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: kClearCacheViewController), object: nil, userInfo: nil)
        
        if self.isFromNotification {
            self.isFromNotification = false
            return
        }
        if MailAccount.getLatestMailAccount() == nil{
            if !self.isWillEnter {
                self.isWillEnter = true
                return
            }
        }
        let topViewController = getTopViewController()
        var swRevealVC:SWRevealViewController!
        var loadMailVC: LoadMailViewController!
        var isReNew = false
        if let topVC = topViewController,
            let revealVC = topVC as? SWRevealViewController,
            let fontVC = revealVC.frontViewController, let nav = fontVC as? UINavigationController,
            let viewcontroller = nav.viewControllers.first as? LoadMailViewController {
            swRevealVC = revealVC
            loadMailVC = viewcontroller
            self.reloadMailWhenAppAcitive(loadMailVC)
        }
        if loadMailVC == nil, let splashVC = topViewController as? SplashViewController {
//            let isDownloadConfigSuccess: Bool = UDGet(KEY_DOWNLOAD_CONFIG_SUCCESS) ?? false
//            if isDownloadConfigSuccess == false {
//                splashVC.downloadConfigXML()
//            }
//            
            return
        }else {
            self.startMonitoring()
        }
    }
    
    func reloadMailWhenAppAcitive(_ loadMailVC: LoadMailViewController) {
        print("reloadMailWhenAppAcitive")
        self.startMonitoring()
        loadMailVC.isFromIconOrNotification = true
        if MailBox.countNumberMail(isRead: false) != 0 {
            let mailAccount = MailAccount.getLatestUpdate()
            if let beacon = mailAccount?.beacon {
                loadMailVC.beaconInfo = beacon.toBeaconInfo()
            }
            if let xmlID = mailAccount?.geofence?.toGeoInfo().xmlID {
                let geo = Geofence.getGeoBy(xmlID: xmlID)
                loadMailVC.geofence = geo
            }
            loadMailVC.isFromIconOrNotification = false
            loadMailVC.initForView()
        }else if let account = MailAccount.getLatestMailAccount() {
            if let beacon = account.beacon {
                loadMailVC.beaconInfo = beacon.toBeaconInfo()
            }
            loadMailVC.geofence = account.geofence?.toGeoInfo()
            loadMailVC.isFromIconOrNotification = false
            loadMailVC.initForView()
        }
        
        print("reloadMailWhenAppAcitive")
        NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: kReloadLeftMenuNotification), object: nil, userInfo: nil)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Remove geoCached in UserDefault
        let listGeoEnter = Geofence.getGeoEnterRegion().map { (geo) -> GeoFenceBean in
            return geo.toGeoInfo()
        }
        
        for geo in listGeoEnter {
            if UserDefaults.standard.value(forKey: geo.identifier) != nil {
                UserDefaults.standard.removeObject(forKey: geo.identifier)
            }
        }
        
        DataManager.shared.saveContext(DataManager.shared.managedObjectContext)
    }
    
    func application(_ application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {                
        self.isFromNotification = true
        print("didReceiveLocalNotification")
        let beaconInfo = BeaconInfo()
        var geofence:GeoFenceBean?
        var iconURL = ""
        var bannerURL = ""
        var title = ""
        var message = ""
        if let userInfo = notification.userInfo as? [String: String], userInfo.count > 0{
            title = userInfo["profile_name"] ?? ""
            iconURL = userInfo["image_icon"] ?? ""
            bannerURL = userInfo["image_banner"] ?? ""
            message = userInfo["message"] ?? ""
            if let id = userInfo["geoXMLID"] {
                geofence = Geofence.getGeoBy(xmlID: id)
            }else if let uuid = userInfo["uuid"]  {
                beaconInfo.uuid = uuid
                beaconInfo.major = userInfo["major"]!
                beaconInfo.minor = userInfo["minor"]!
                let profile = iBeaconProfile()
                profile.bannerUrl = bannerURL
                profile.iconURl = iconURL
                beaconInfo.profile = profile
                let lang:String = UDGet(kLanguage) ?? kLanguageCodeDefault
                let maildefault = MailXML()
                maildefault.name = title
                beaconInfo.mailGroup = [lang : maildefault]
                let proximity =  userInfo["proximity"]!
                beaconInfo.proximity = Common.getProximityFromString(proximity)
            }
        }
        var topViewController = getTopViewController()
        var revealVC:SWRevealViewController!
        // statte is inactive, goto webview if app of state is forground or background go to loadMailViewController
        if (application.applicationState == UIApplicationState.inactive  ||
            application.applicationState == UIApplicationState.background) {
            if let topVC = topViewController {
                revealVC = topVC as? SWRevealViewController
            }
            
            if revealVC == nil {
                return
            }
            
            if let fontVC = revealVC.frontViewController as? UINavigationController, let loadMailVC = fontVC.viewControllers.first as? LoadMailViewController {
                loadMailVC.beaconInfo = beaconInfo
                loadMailVC.geofence = geofence
                loadMailVC.isFromIconOrNotification = true
                loadMailVC.initForView()
            }
        }else {
            print("image url: \(iconURL)")
            if (iconURL.isEmpty || iconURL == "") && (message.isEmpty && message == "")  {
                return
            }
                        
            if let topVC = topViewController as? UIAlertController {
                print("Current is UIAlertController -> dont show TSMessage")
                return
            }
            
            TSMessage.showNotification(in: topViewController, title: title, subtitle: message, imageUrl: iconURL, type: TSMessageNotificationType.message, duration: 0, callback: nil, buttonTitle: "", buttonCallback:nil, at: TSMessageNotificationPosition.top, canBeDismissedByUser: true)
            
        }
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.newData)
        
        self.fetchStart = Date()
//        if AppConfig.getMailBackground == false {
//            completionHandler(UIBackgroundFetchResult.noData)
//            return
//        }
        
        //more time for check and run background
        self.backgroundTask = UIApplication.shared.beginBackgroundTask (expirationHandler: {
            [unowned self] in
            self.endBackgroundTask()
        })
        
        
        self.getNewMailInBackground()
    }
    
    func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundTask)
        self.backgroundTask = UIBackgroundTaskInvalid
    }
    
    func startMonitoring() {
        if let configService = StaticData.shared.bmConfiguration {
            //for Location
            if LocationManager.isAlwaysOn {
                LocationManager.shared.startSignificantChangeUpdates()
                LocationManager.shared.startMonitoringForRegionCircular()
            }
            LocationManager.shared.delegate = self
            //for iBeacon
            BeaconDetectManager.shared.stopBeacons()
            BeaconDetectManager.shared.delegate = self
            BeaconDetectManager.shared.startMonitoringBeacon()
        }else {
            ConfigurationBean.loadLocal({ (success, data) in
                if success {
                    StaticData.shared.bmConfiguration = data;
                    self.startMonitoring()
                }
            })
        }
    }
    
    fileprivate func redirectWhenEnterRegion(_ ibeacon: BeaconInfo?, geofence: GeoFenceBean?) {
        // Send notification with beaconInfo to update left menu
        print("redirectWhenEnterRegion")
        NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: kReloadLeftMenuNotification), object: nil, userInfo: nil)
        
        // if running in background
        //        if UIApplication.shared.applicationState == UIApplicationState.background {
        //            return
        //        }
        
        var webURL = ""
        if let beaconInfo = ibeacon {
            let proximity = beaconInfo.proximity.description()
            //            let web = beaconInfo.getWebBy(proximity.toCLProximity().intValue()) // taopd
            let web = beaconInfo.getWebBy(beaconInfo.proximity.intValue())
            DLog(infor: "redirectWhenEnterRegion_Beacon: proximity: \(proximity) webURL: \(web?.url)")
            let webAccess = beaconInfo.getWebAccess()
            webURL = webAccess.webAccess_url
        }else if let geo = geofence {
            webURL = geo.web?.url ?? ""
        }
        
        if webURL.isEmpty == false {
            let topViewController = getTopViewController()
            let revealVC = topViewController as? SWRevealViewController
            let navigation = revealVC?.frontViewController as? UINavigationController
            if  revealVC != nil {
                if let navigationController = navigation {
                    if let controller = navigationController.topViewController as? WebViewController {
                        controller.beaconDetectFinish(ibeacon, geoFence: geofence)
                    } else if let _ = navigationController.topViewController as? DebugModeViewController {
                        
                    } else if let controller = navigationController.topViewController as? BaseViewController {
                        OperationQueue.main.addOperation{() -> Void in
                            controller.gotoWebView(ibeacon, geoFence: geofence)
                        }
                    }
                }
            }
        }
    }
    
    func getNewMailInBackground() {
        
        if AppConfig.getMailBackground == false {
            return
        }
        
        //Get new mail only background mode
        if  UIApplication.shared.applicationState == .active {
            return
        }
        
        //Check time get mail
        if let lastTimeGetNewMail:String = UDGet(KEY_CHECK_TIME_GET_NEW_MAIL) {
            print("CheckTimeGetMail lastTimeGetNewMail:",lastTimeGetNewMail)
            
            if  let prvDate = Common.convertStringToDate(lastTimeGetNewMail, format: FORMAT_DATE_YYYY_SS){
                let seconds = Common.secondsFrom(prvDate, toDate: Date())
                if seconds < TIME_GET_NEW_MAIL_BACK_GROUND {
                    
                    print("seconds < TIME_GET_NEW_MAIL_BACK_GROUND => return")
                    
                    return
                }
            }
        }
        
        //Save time get mail in local
        let currentDateString = Common.convertDateToString(Date(), format: FORMAT_DATE_YYYY_SS)
        UDSet(KEY_CHECK_TIME_GET_NEW_MAIL, value: currentDateString as AnyObject)
        
        print("CheckTimeGetMail currentDateString:",currentDateString)
        
        let listBeacons = Beacon.getAll()
        let listGeofence = Geofence.getGeoEnterRegion()
        var listRegion = NSMutableArray(array: listBeacons)
        listRegion.addObjects(from: listGeofence)
        
        if listBeacons.count == 0 {
            //completionHandler(UIBackgroundFetchResult.noData)
            self.endBackgroundTask()
            return
        }

        var newMailCnt = 0
        var loadMailCnt = 0
        var listlastNewMail: [MailInfo] = [MailInfo]()
        
        for index in 0..<listRegion.count {
            let region = listRegion[index]
            
            var postalMachine: PostalMachine!
            
            if let geo = region as? Geofence {
                let geoFenceBean = geo.toGeoInfo()
                postalMachine = PostalMachine.init(geofence: geoFenceBean)
            }
            
            if let beacon = region as? BeaconInfo {
                postalMachine = PostalMachine.init(beaconInfo: beacon)
            }

            
            DispatchQueue.main.async {
                postalMachine.loadNewMailWith2(region as AnyObject) { (result, success) in
                   
                    print("indexRegion:\(loadMailCnt)")
                    
                    defer {
                        self.endBackgroundTask()
                    }
                    
                    loadMailCnt += 1

                    if let result = result {
                        
                        newMailCnt += result.count
                        
                        if let lastNewMail = result.first {
                            listlastNewMail.append(lastNewMail)
                        }
                    }
                    
                    //Check and show notification
                    if loadMailCnt == listRegion.count {
                        
                        if newMailCnt > 0 {
                            // get unread count mail
                            self.setBadge()
                            
                            let messageCount = String.init(format: "notify_total_message".localizedString, newMailCnt)
                            listlastNewMail = listlastNewMail.sorted(by: { (x, y) -> Bool in
                                x.create_date! > y.create_date!
                            })
                            
                            let subjectNewMail = listlastNewMail.first?.subject ?? ""
                            
                            let message = String.init(format: "%@\n%@", messageCount,subjectNewMail)
                            
                            print("Send notify >message:%@",message)
                            
                            // send notification
                            Common.sendNotificationWithMessage(message)
                            
                            // post notification for menu tableView
                            print("getNewMailInBackground -> kReloadLeftMenuNotification")
                            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: kReloadLeftMenuNotification), object: nil, userInfo: nil)
                            
                            // completion handle
                            //completionHandler(UIBackgroundFetchResult.newData)
                            
                        } else {
                            // completion handle
                            //completionHandler(UIBackgroundFetchResult.newData)
                        }
                        
                    }
                }

            }
            
            
        }
    }
    
    fileprivate func updateMail(by region: AnyObject) {
        if let beaconInfo = region as? BeaconInfo {
            MailBox.optimizeMemory(beaconInfo, geo: nil)
        }
        if let geofence = region as? Geofence {
            let geofenceBean = geofence.toGeoInfo()
            MailBox.optimizeMemory(nil, geo: geofenceBean)
        }
    }
    
    func setBadge()->Int {
        //UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.cancelAllLocalNotifications()
        var numberAllMailUnread = 0
        let beaconList = Beacon.getAll()
        let geoList = Geofence.getAll()
        
        for beacon in beaconList {
            numberAllMailUnread += beacon.unread_cnt
        }
        for geo in geoList {
            numberAllMailUnread += geo.unread_cnt
        }
        UIApplication.shared.applicationIconBadgeNumber = numberAllMailUnread
        return numberAllMailUnread
    }
    
    func requestNotificationPermission() {
        if #available(iOS 8.0, *) {
            let types = UIUserNotificationType([UIUserNotificationType.alert, UIUserNotificationType.sound, UIUserNotificationType.badge])
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: types, categories: nil))
            
        } else {
            let types = UIRemoteNotificationType([UIRemoteNotificationType.alert,UIRemoteNotificationType.badge,UIRemoteNotificationType.sound])
            UIApplication.shared.registerForRemoteNotifications(matching: types)
        }
    }
}
extension BeaconMailDelegate: BeaconDetectDelegate {
    func beaconDetectFinish(_ beaconInfo: BeaconInfo) {
        self.redirectWhenEnterRegion(beaconInfo, geofence: nil)
        
    }
}
extension BeaconMailDelegate: LocationManageDetectDelegate {
    func geoFenceDetectFinish(_ geofence: GeoFenceBean) {
        self.redirectWhenEnterRegion(nil, geofence: geofence)
    }
}
