///
//  BeaconDetectManager.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
let kDidRangeBeaconsNotification = "kDidRangeBeaconsNotification"
@objc protocol BeaconDetectDelegate{
    func beaconDetectFinish(_ beaconinfo:BeaconInfo)
}

class BeaconDetectManager: RegionManager, CBCentralManagerDelegate{
    fileprivate static let kKeyLocationLatitude = "key location keeping latitude"
    fileprivate static let kKeyLocationLongitude = "key location keeping longitude"
    var bluetoothManager:CBCentralManager?
    var delegate:BeaconDetectDelegate?
    var isLoadingXml = false
    var isLoadingGeofence = false
    var timer: Timer?
    static var lastestDetectBeacon: String?
    var beaconRegionBundle: [CLBeaconRegion]?
    var beaconDetected:BeaconInfo?
    var beaconInARegion = [String: BeaconInfo]()
    var checkBlueToothPermissionCallOneTime = false
    var checkLocationPermissionCallOneTime = false
    var regionId = ""
    var count: Int = 0
    
    override class var shared : BeaconDetectManager {
        struct Static {
            static let instance : BeaconDetectManager = BeaconDetectManager()
        }
        return Static.instance
    }
    static var location:(Double,Double) {
        get {
            let lat:Double = UDGet(BeaconDetectManager.kKeyLocationLatitude)
            let long:Double = UDGet(BeaconDetectManager.kKeyLocationLongitude)
            if lat == 0.0 && long == 0.0 {
                return kGoogleMapLocationDefault
            }
            return (lat,long)
        }
        set(value){
            UDSet(BeaconDetectManager.kKeyLocationLatitude, double: value.0)
            UDSet(BeaconDetectManager.kKeyLocationLongitude, double: value.1)
        }
        
    }
    override init() {
        super.init()
        if #available(iOS 10, *) {
        } else {
            self.bluetoothManager =  CBCentralManager(delegate: self, queue: nil)
        }
        self.startLocationServices()
    }
    //MARK: - Public
    func startMonitoringBeacon() {
        
        //print("startMonitoringBeacon")
        
        self.stopBeacons()
        let bmConfig = StaticData.shared.bmConfiguration
        if let uuidString = bmConfig?.ibeaconList?.map({ (beaconInfo) -> String in
            return beaconInfo.uuid
        }){
            self.startMonitoringForBeacon(uuidString)
        }
    }
    func stopBeacons() {
        if let bundle = self.beaconRegionBundle{
            for beaconRegion in bundle {
                self.locationManager.stopMonitoring(for: beaconRegion)
                self.locationManager.stopRangingBeacons(in: beaconRegion)
            }
            self.beaconRegionBundle?.removeAll()
        }
        self.beaconDetected = nil
        self.beaconInARegion = [:]
//        self.locationManager.delegate = nil
        self.locationManager = CLLocationManager()
    }
    
    //MARK: - Private
    fileprivate func startMonitoringForBeacon(_ beaconUUID: [String]) {
        self.beaconRegionBundle = []
        for idItem in beaconUUID {
            if let uuid = UUID(uuidString: idItem){
                let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: idItem)
                beaconRegion.notifyEntryStateOnDisplay = true
                locationManager.startMonitoring(for: beaconRegion)
                locationManager.startRangingBeacons(in: beaconRegion)
                self.beaconRegionBundle?.append(beaconRegion)
            }
        }
        locationManager.delegate = self
    }
    
    fileprivate func getXmlInfoOfBeacon(_ beaconInfo:BeaconInfo) {
        print("getXmlInfoOfBeacon:",beaconInfo)
        
        // if is loading xml in server, return
        if self.isLoadingXml == true {
            return
        }
        self.isLoadingXml = true
        APIClient.shared.requestGetiBeaconXMLFile(beaconInfo) { (xmlParserError, ibeacon) in
            // send notification if parse xml error
            if xmlParserError {
                var message = "Server information getting error"
                let lang:String = UDGet(kLanguage) ?? kLanguageCodeDefault
                if lang == kLanguageCodeDefault {
                    message = "サーバー情報の習得が出来ませんでした。"
                }
                
                Common.sendNotificationWith(message, title: "-1011")
            }
            
            if let beaconConfig = ibeacon {
                self.handleWhenGetXMLSuccess(beaconConfig)
            }else if beaconInfo.isEqualBeacon(self.beaconDetected) == false {
                self.resetBeaconDetected()
                self.isLoadingXml = false
            }
            if self.bluetoothManager != nil {
                self.centralManagerDidUpdateState(self.bluetoothManager!)
            }
        }
    }
    fileprivate func handleWhenGetXMLSuccess(_ beacon: BeaconInfo){
        if Beacon.isExits(beacon) {
            self.publicBeacon(beacon, false)
            self.isLoadingXml = false
        } else {
            // If this beacon has securityKey
            if let security = beacon.profile?.securityKey {
                guard UIApplication.shared.applicationState == .active else {
                    Common.sendNotification(beacon)
                    self.isLoadingXml = false
                    return
                }

                let alert = UIAlertController(title: "format_security_key".localizedString, message: beacon.notification?.title, preferredStyle: .alert)
                alert.addTextField(configurationHandler: { (txt) in
                })
                alert.addAction(UIAlertAction.init(title: "button_ok".localizedString, style: .cancel, handler: { (action) in
                    let txt = alert.textFields![0]
                    if txt.text == security {
                        self.publicBeacon(beacon, true)
                    }
                    self.isLoadingXml = false
                }))
                delay(3, closure: {
                    getTopViewController()?.present(alert, animated: true, completion: nil)
                })
            } else {
                self.publicBeacon(beacon, true)
                self.isLoadingXml = false
            }
        }
    }
    
    open func publicBeacon(_ beacon: BeaconInfo, _ isPushNotification: Bool) {
        print("publicBeacon > beacon:",beacon)
        let beacon = BeaconInfo(beacon: beacon)
        Beacon.insert(beacon)
        self.checkToSendNotification(beacon, isPushNotification)
        self.beaconDetected = BeaconInfo.copyBeacon(beacon)
    }
    
    fileprivate func checkToSendNotification(_ beaconInfo:BeaconInfo, _ isPushNotification: Bool = false) {
        if BeaconInfo.getBeaconWithMajorMinor(beaconInfo.major, minor: beaconInfo.minor) != nil {
//            let seconds = Common.secondsFrom(beacon.update_date!, toDate: Date())
//            if seconds >= TIME_NOTIFY {
//                if let isPush = isPushNotification, isPush == true {
//                    Common.sendNotification(beaconInfo)
//                }
//                
               print("checkToSendNotification > checkHasNewMail")
                checkHasNewMail(beaconInfo, isPushNotification: isPushNotification)
            }
    }
    
    fileprivate func checkHasNewMail(_ beaconInfo:BeaconInfo, isPushNotification: Bool = false) {
        PostalMachine.loadLastMail(beaconInfo, geofence: nil, number: NUMBER_MAIL, complete: {(result, success) in
            // This beacon has NO mail
            guard success else {
                if isPushNotification {
                    Common.sendNotification(beaconInfo)
                }
                
                return
            }
            
            // This beacon has mails
            if let result = result {
                var account = MailAccount.getMailAccoutBy(beaconInfo)
                if account == nil {
                    account = MailAccount.getMailAccoutBy(beaconInfo, isDefault: true)
                }
                account?.update(mailBox: result)
                if result.count > 0 {
                    MailBox.optimizeMemory(beaconInfo)
                }
                account?.update(hasNewMail: false)
                
                // This beacon has new mail
                if let firstMail = result.first {
                    Common.sendNotifyByHasNewMail(firstMail, beaconInfo: beaconInfo, geoFence: nil)
                }
            } else {
                if isPushNotification {
                    Common.sendNotification(beaconInfo)
                }
            }
            
            // Reload leftmenu
            self.delegate?.beaconDetectFinish(beaconInfo)
        })
    }
    
    fileprivate func resetBeaconDetected() {
        guard let beaconDetected = self.beaconDetected else {
            return
        }
        
        if let profile = beaconDetected.profile, !profile.saveMailbox {
            Beacon.delete(beacon: beaconDetected)
        }
        
        self.beaconDetected = BeaconInfo()
        self.delegate?.beaconDetectFinish(self.beaconDetected!)
    }
    
    fileprivate func stopMonitoringSignificantLocationChanges () -> Void {
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            self.locationManager.stopMonitoringSignificantLocationChanges()
        }
    }
    //MARK: LocationManager- Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.notDetermined:
            AppManager.requestAuthorizationLocation(manager, isAlways: true)
            break
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            if #available(iOS 8.0, *) {
                if !(UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert))! {
                    BeaconDetectManager.shared.startMonitoringBeacon()
                    AppManager.requestAuthorizationNotification()
                    
                    if  !BeaconDetectManager.shared.checkBlueToothPermissionCallOneTime {

                        if self.bluetoothManager?.state == .poweredOff {
                            let delayTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                                self.bluetoothManager =  CBCentralManager(delegate: self, queue: nil)
                                BeaconDetectManager.shared.checkBlueToothPermissionCallOneTime = true
                            }
                        }
                    }
                } else {
                    if  !BeaconDetectManager.shared.checkBlueToothPermissionCallOneTime {
                        //self.bluetoothManager?.state != CBCentralManagerState.poweredOn
                        if self.bluetoothManager?.state == .poweredOn {
                            self.bluetoothManager =  CBCentralManager(delegate: self, queue: nil)
                            BeaconDetectManager.shared.checkBlueToothPermissionCallOneTime = true
                        }
                        
                    }
                    
                }
            }
            break
        case .authorizedWhenInUse:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
//        DLog(infor: "monitoringDidFailForRegion \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        guard region is CLBeaconRegion else {
            return
        }
        
        print("BeaconDetectManager> didEnterRegion")
        
        let beaconRegion = region as! CLBeaconRegion
        manager.startRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        guard region is CLBeaconRegion else {
            return
        }
        
        print("BeaconDetectManager> didExitRegion")
        
        let clBeaconRegion = region as! CLBeaconRegion
        manager.stopRangingBeacons(in: clBeaconRegion)
        DLog(infor: "did Exit beacon")
        if let beacon = self.beaconDetected {
            self.beaconInARegion.removeValue(forKey: beacon.identifier)
            self.resetBeaconDetected()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        if region is CLBeaconRegion {
            if state == CLRegionState.inside {
            }
            if state == CLRegionState.outside {
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {

        var keyTimeDetechBeacon = KEY_TIME_DETTECT_BEACON + "\(region.identifier)"
        if let dateString:String = UDGet(keyTimeDetechBeacon) {
            if  let prvDate = Common.convertStringToDate(dateString, format: FORMAT_DATE_YYYY_SS){
                let seconds = Common.secondsFrom(prvDate, toDate: Date())
                if seconds < TIME_DETECT_BEACON {
                    return
                }
            }
            let currentDateString = Common.convertDateToString(Date(), format: FORMAT_DATE_YYYY_SS)
            UDSet(keyTimeDetechBeacon, value: currentDateString as AnyObject)
        }else {
            let dateString = Common.convertDateToString(Date(), format: FORMAT_DATE_YYYY_SS)
            UDSet(keyTimeDetechBeacon, value: dateString as AnyObject)
        }
        
        //Check time and get new mail in background
        BeaconMailDelegate.shared?.getNewMailInBackground()
        
        DLog(infor:"beacon count: \(beacons.count)")
        let userInfo = ["beacons": beacons, "region": region] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kDidRangeBeaconsNotification), object: nil, userInfo: userInfo)
        
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons.max(by: { (x, y) -> Bool in
                x.proximity.intValue() > y.proximity.intValue()
            }) ?? knownBeacons[0] as CLBeacon
           
            DLog(infor:"number beacon found \(knownBeacons.count) - closet \(closestBeacon.major) - \(closestBeacon.minor)")
            
            BeaconDetectManager.lastestDetectBeacon = Common.convertDateToString(Date(), format: FORMAT_DATE_YYYY_SS)
           
            let beaconInfo = BeaconInfo(beacon: closestBeacon, identifier: "\(region.identifier)")
            self.beaconInARegion[region.identifier] = beaconInfo
            var closestBeaconInfo = BeaconInfo()
            let allKey = Array(self.beaconInARegion.keys)
            if allKey.count > 1 {
                closestBeaconInfo = self.beaconInARegion[allKey[0]]!
                let values = Array(self.beaconInARegion.values)
                for value in values {
                    let intComparePromixity = value.comparePromixity(closestBeaconInfo)
                    let intCompareRSSI = value.compareRSSI(closestBeaconInfo)
                    if  intComparePromixity > 0 || (intComparePromixity == 0 && intCompareRSSI > 0) {
                        closestBeaconInfo = value
                    }
                }
                
            }else if allKey.count > 0{
                closestBeaconInfo = self.beaconInARegion[allKey[0]]!
            }
            
            if self.beaconDetected == nil || self.beaconDetected!.uuid.isEmpty == true{
                self.getXmlInfoOfBeacon(closestBeaconInfo)
            }else {
                // detect other beacon,if beaconInfo is closer than beaconDetecting
                let intComparePromixity = closestBeaconInfo.comparePromixity(self.beaconDetected)
                if  closestBeaconInfo.isEqualBeacon(self.beaconDetected) == false ||
                    (closestBeaconInfo.isEqualBeacon(self.beaconDetected) == true &&
                        intComparePromixity > 0) {
                    self.getXmlInfoOfBeacon(closestBeaconInfo)
                }
            }
        } else if let lastDate = BeaconDetectManager.lastestDetectBeacon, let prvDate = Common.convertStringToDate(lastDate, format: FORMAT_DATE_YYYY_SS){
            let seconds = Common.secondsFrom(prvDate, toDate: Date())
            if seconds > 10 {
                if let beacon = self.beaconInARegion[region.identifier] {
                    self.beaconInARegion.removeValue(forKey: region.identifier)
                }else {
                    self.beaconInARegion.removeAll()
                }
                if region.identifier == self.beaconDetected?.identifier{
                    self.resetBeaconDetected()
                }
            }
        }
    }
    
//    // MARK: - CBCentralManagerDelegate
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        let state = central.state
//        if state == CBCentralManagerState.poweredOff {
//            self.resetBeaconDetected()
//        }
//    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            NSLog("poweredOn")
        case .poweredOff:
            self.resetBeaconDetected()
        default:
            NSLog("蓝牙未开启")
        }
    }
}
extension BeaconDetectManager {
    func isDetectingBeacon(_ beaconInfo:BeaconInfo?)-> Bool {
        guard let beaconInfo = beaconInfo else{
            return false
        }
        return beaconInfo.isEqualBeacon(self.beaconDetected)
    }
}

