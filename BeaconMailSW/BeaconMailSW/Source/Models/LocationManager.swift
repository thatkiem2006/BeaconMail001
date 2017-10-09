//
//  LocationManager.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit

import CoreLocation
import Toast
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

enum DeviceInRegionType {
    case iBeacon
    case geofence
    case unknown
}
protocol LocationManageDetectDelegate{
    func geoFenceDetectFinish(_ geofence: GeoFenceBean)
}
class RegionManager: NSObject, CLLocationManagerDelegate {
    var locationManager:CLLocationManager!
    class var shared : RegionManager {
        struct Static {
            static let instance : RegionManager = RegionManager()
        }
        return Static.instance
    }
    
    static var isAlwaysOn:Bool {
        if #available(iOS 8.0, *) {
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways {
                return true
            }
        }
        return false
    }
    
    static var isNotDetermined:Bool {
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            return true
        }
        return false
    }
    
    static func inRegion(_ beacon: BeaconInfo?, geo: GeoFenceBean?) -> DeviceInRegionType {
        //        if BeaconDetectManager.shared.isDetectingBeacon(beacon) == true {
        //            return .iBeacon
        //        }
        if LocationManager.shared.isDetectingGeofence(geo) == true {
            return .geofence
        }
        return .unknown
    }
    
    func startLocationServices() -> Void {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.activityType = CLActivityType.fitness
        locationManager.startUpdatingLocation()

    }
    
    
    func distanceFrom(_ fromLocation:CLLocation, toLocation:CLLocation) -> Double {
        return toLocation.distance(from: fromLocation)
    }
}

class LocationManager: RegionManager {
    var isAvoidCallTwice: Bool = true
    var isFirstTime = true
    
    fileprivate var listGeofenceActive = [String:GeoFenceBean]()
    fileprivate var userLocation:CLLocation?
    
    var delegate: LocationManageDetectDelegate?
    
    override class var shared : LocationManager {
        struct Static {
            static let instance: LocationManager = LocationManager()
        }
        return Static.instance
    }
    
    // init
    override init() {
        super.init()
        self.startLocationServices()
    }
    
    //MARK: - Setup
    func startStandardUpdates() -> Void {
        if CLLocationManager.locationServicesEnabled() {
             self.locationManager.pausesLocationUpdatesAutomatically = true
            if #available(iOS 9.0, *) {
                self.locationManager.allowsBackgroundLocationUpdates = true
            }
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.activityType = CLActivityType.fitness
            self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters //kCLDistanceFilterNone
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func startMonitoringForRegionCircular() -> Void {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            print("Geofencing is not supported on this device!")
            return
        }
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            print("Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
        }
        if let geoFenceList = StaticData.shared.bmConfiguration?.geofenceList {
            self.filterGeoFlowDistance(geoFenceList)
        }
    }
    fileprivate func startMonitoringForGeoFences(_ geoFence: [GeoFenceBean]) -> Void {
        print("startMonitoringForGeoFences")
        
        stopMonitoringForRegionCircular()
        
        for geo in geoFence {
            self.startMonitoringForGeoFence(geo)
        }
    }
    
    fileprivate func startMonitoringForGeoFence(_ geoFence: GeoFenceBean) -> Void {
        if Double(geoFence.radius) > locationManager.maximumRegionMonitoringDistance {
            geoFence.radius = "\(locationManager.maximumRegionMonitoringDistance)"
        }
        
        locationManager.startMonitoring(for: geoFence.region())
        
        // Determine state of geofence as soon as start monitoring
        if geoFence.region().contains((userLocation?.coordinate)!) {
            
            if isAvoidCallTwice == false || UserDefaults.standard.value(forKey: geoFence.identifier) != nil {
                return
            }
            isAvoidCallTwice = false
            self.locationManager(self.locationManager, didEnterRegion: geoFence.region())
        }
        
    }
    
    func stopMonitoringForRegionCircular() -> Void {
        for region: CLRegion in locationManager.monitoredRegions {
            if region is CLCircularRegion {
                locationManager.stopMonitoring(for: region)
            }
        }
    }
    fileprivate func filterGeoFlowDistance(_ bundle: [GeoFenceBean]){
        if bundle.count <= 20 {
            self.startMonitoringForGeoFences(bundle)
            return
        }
        guard let lc = userLocation else {
            self.locationManager.startUpdatingLocation()
            return
        }
        var distance = Array<GeoFenceBean>()
        for geo in bundle {
            let nearLC = CLLocation(latitude: Double(geo.latitude)!, longitude: Double(geo.longitude)!)
            let meters = lc.distance(from: nearLC)
            geo.distanceToUser = meters
            
            distance.append(geo)
        }
        let sortDistance = distance.sorted { (x, y) -> Bool in
            x.distanceToUser < y.distanceToUser
        }
        let minDistance = Array(sortDistance.prefix(20))
        self.startMonitoringForGeoFences(minDistance)
        
        userLocation = nil
    }
    // MARK: - Location
    func startSignificantChangeUpdates() -> Void {
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
                      self.locationManager?.pausesLocationUpdatesAutomatically = true
            if #available(iOS 9.0, *) {
                    self.locationManager?.allowsBackgroundLocationUpdates = true
            }
                    self.locationManager?.pausesLocationUpdatesAutomatically = true
            self.locationManager?.activityType = CLActivityType.automotiveNavigation
            self.locationManager?.startMonitoringSignificantLocationChanges()
        }
        
        self.startMonitoringForRegionCircular()
    }
    
    func stopMonitoringSignificantLocationChanges () -> Void {
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            self.locationManager?.stopMonitoringSignificantLocationChanges()
        }
    }
    
    func requestLocationPermission() {
        if #available(iOS 8.0, *) {
            if( self.locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization))) {
                self.locationManager.requestAlwaysAuthorization()
            } else {
                if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
                    locationManager.requestWhenInUseAuthorization()
                }
            }
        }
        
    }
    
    fileprivate func handleWhenEnterGeofence(_ geoFence: GeoFenceBean) {
        self.listGeofenceActive[geoFence.identifier] = geoFence
        GeoFenceMonitorViewController.shared?.addGeoFence(geoFence)
        
        // Get XML of this geofence
        self.getXMLFie(geoFence)
    }
    
    fileprivate func getXMLFie(_ geoFence: GeoFenceBean){
        APIClient.shared.requestGetGeoFenceXMLFile(geoFence) { (xmlParserError, geoConfig) in
            if xmlParserError == true || geoConfig == nil {
                
                //Only send notification when app is active
                if UIApplication.shared.applicationState == .active {
                    let message = "message_request_geofence_xml_error".localizedString
                    Common.sendNotificationWith(message, title: "")
                }
                
                self.isAvoidCallTwice = true
                
                return
            }
            
            let identifierCheck = UserDefaults.standard.value(forKey: geoFence.identifier) as? String
            if identifierCheck == nil || (identifierCheck?.isEmpty)! {
                // Check exist of the geofence
                guard !Geofence.isExists(geoFence) else {
                    self.didFinishDetectGeofence(geoFence, geoConfig: geoConfig, false)
                    return
                }
                
                //Push notification in background
                if  UIApplication.shared.applicationState != .active {
                    Common.sendNotification(nil, geo: geoFence)
                }
                
                if let security = geoConfig?.profile?.securityKey {
                    
                    let alert = UIAlertController(title: "format_security_key".localizedString, message: geoFence.notify_title ?? "", preferredStyle: .alert)
                    alert.addTextField(configurationHandler: { (txt) in
                    })
                    
                    alert.addAction(UIAlertAction.init(title: "button_ok".localizedString, style: .cancel, handler: { (action) in
                        let txt = alert.textFields![0]
                        if txt.text == security {
                            self.didFinishDetectGeofence(geoFence, geoConfig: geoConfig, false)
                        } else {
                            self.isAvoidCallTwice = true
                        }
                    }))
                    delay(3, closure: {
                        getTopViewController()?.present(alert, animated: true, completion: nil)
                    })
                } else {
                    self.didFinishDetectGeofence(geoFence, geoConfig: geoConfig, false)
                }
            } else {
                // Have gone inside this geofence
                self.didFinishDetectGeofence(geoFence, geoConfig: geoConfig, false)
            }
        }
    }
    
    fileprivate func didFinishDetectGeofence(_ geoDetect: GeoFenceBean, geoConfig : GeoFenceBean?, _ isPushNotification: Bool? = false) {
        // save identifier when detected Geofence
        
        if let geoConfig = geoConfig {
            // The geofence has inputed security key
            UserDefaults.standard.set(geoDetect.identifier, forKey: geoDetect.identifier)
            
            // Change state of the geofence to Entered
            Geofence.enterRegion(geoDetect, isEnter: true)
            
            Geofence.updateGeofence(geoConfig)
            
            // Check New Mail
            self.checkHasNewMail(geoDetect, isPushNotification)
        } else {
            getTopViewController()?.view.makeToast("Enter geofence but not loaded geofence file")
            self.isAvoidCallTwice = true
        }
        
        //        if let geoRaw = StaticData.shared.bmConfiguration?.geofenceList?.filter({ (geo) -> Bool in
        //            geo.identifier == geoDetect.identifier
        //
        //        }).first, let notification = geoRaw.notification {
        //            geoRaw.clone(geo: geoDetect)
        //            geoRaw.profile = geoConfig?.profile
        //            // taopd
        //            self.checkHasNewMail(geoRaw, isPushNotification)
        //        }
        //
    }
    
    /*
     Kiem tra neu co mail moi thi send notification mail
     */
    
    fileprivate func checkHasNewMail(_ geoFence: GeoFenceBean, _ isPushNotification: Bool? = false) {
        PostalMachine.loadLastMail(nil, geofence: geoFence, number: NUMBER_MAIL, complete: {(result, success) in
            guard success else {
                if let isPush = isPushNotification, isPush {
                    Common.sendNotification(nil, geo: geoFence)
                }
                
                // Reload leftmenu
                self.delegate?.geoFenceDetectFinish(geoFence)
                
                self.isAvoidCallTwice = true
                return
            }
            
            if let result = result {
                var account = MailAccount.getMailAccoutBy(geo: geoFence)
                if account == nil {
                    account = MailAccount.getMailAccoutBy(geo: geoFence, isDefault: true)
                }
                account?.update(mailBox: result)
                if result.count > 0 {
                    MailBox.optimizeMemory(geo: geoFence)
                }
                account?.update(hasNewMail: false)
                
                if let firstMail = result.first {
                    Common.sendNotifyByHasNewMail(firstMail, beaconInfo: nil, geoFence: geoFence)
                }
            } else {
                if let isPush = isPushNotification, isPush {
                    Common.sendNotification(nil, geo: geoFence)
                }
            }
            
            // Reload leftmenu
            self.delegate?.geoFenceDetectFinish(geoFence)
            
            self.isAvoidCallTwice = true
        })
    }
    
    @objc fileprivate func enableAvoidCallTwice() {
        isAvoidCallTwice = true
    }
    
    //MARK: - LocationManager Delegate
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        //Check time and get new mail in background
        BeaconMailDelegate.shared?.getNewMailInBackground()
        
        print("didDetermineState state:",state.rawValue)
        guard region is CLCircularRegion else {
            return
        }
        
        switch state {
        case .inside: break
            
        //Remove account from left menu
        case .outside:
                let identifierCheck = UserDefaults.standard.value(forKey: region.identifier) as? String
                if identifierCheck != nil  {
                    self.locationManager(manager, didExitRegion: region)
                }
                break
            
        default: break
            //
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations  locations:%@",locations)
                
        //Check time and get new mail in background
        BeaconMailDelegate.shared?.getNewMailInBackground()
        
        
        if let latestLocation = locations.last {
            if userLocation != nil || abs(latestLocation.horizontalAccuracy) > 65.0 {
                return
            }
            manager.stopUpdatingLocation()
            userLocation = latestLocation
            self.startMonitoringForRegionCircular()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        //Check time and get new mail in background
        BeaconMailDelegate.shared?.getNewMailInBackground()
        
        guard region is CLCircularRegion else {
            return
        }
        
        let identifier = region.identifier
        if let geoFence = Geofence.getGeoBy(id: identifier) {
            self.handleWhenEnterGeofence(geoFence)
            
            //Monitor geo for debug
            GeoFenceMonitorViewController.shared?.didEnterRegionBlock(geofence: geoFence)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        //Monitor geo for debug
        GeoFenceMonitorViewController.shared?.didExitRegionBlock(identifier: region.identifier)
        
        //Check time and get new mail in background
        BeaconMailDelegate.shared?.getNewMailInBackground()
        
        guard region is CLCircularRegion else {
            return
        }
        print("EXIT GEOFENCE: \(region.identifier)")
        
        // Remove geofence account from left menu if its saveMailbox = false
        guard var geofence = Geofence.getGeoBy(id: region.identifier) else {
            return
        }
        
        if let geofenceProfile = geofence.profile, !geofenceProfile.saveMailbox {
            Geofence.enterRegion(geofence, isEnter: false)
        }
        
        self.listGeofenceActive.removeValue(forKey: region.identifier)
        
        
        geofence = GeoFenceBean()
        self.delegate?.geoFenceDetectFinish(geofence)
        //        if self.geofenceActive.identifier == region.identifier {
        //            self.geofenceActive = GeoFenceBean()
        //            self.delegate?.geoFenceDetectFinish(self.geofenceActive)
        //        }
    }
}

extension LocationManager {
    func isDetectingGeofence(_ geo: GeoFenceBean?) -> Bool {
        guard let geo = geo else {
            return false
        }
        
        if self.listGeofenceActive[geo.identifier] != nil {
            return true
        }
        
        return false
    }
}

