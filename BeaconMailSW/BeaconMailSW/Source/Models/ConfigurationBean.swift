//
//  ConfigurationBean.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation
import SwiftyXMLParser
class ConfigurationBean {
    static let fileName = "Configuration"
    var daysToLive = 0
    var profileName: String?
    var readReceiptUrl:String?
    var xmlUrlForGf:String?
    var ibeaconList:[BeaconInfo]?
    var geofenceList:[GeoFenceBean]?
    var infoGroup: [String: MailXML]?
    
    class func loadLocal(_ complete: @escaping (_ success: Bool, _ data: ConfigurationBean?) -> ()){
        ConfigurationBean.readFile { (success, data) in
            if let configData = data, let geoList = configData.geofenceList {
                let mapGeofenceList = geoList.map({ (objectInFile) -> GeoFenceBean in
                    if let geoExistInDB = Geofence.fetch(geofence: objectInFile).first{
                        objectInFile.identifier = geoExistInDB.identifier
                        return objectInFile
                    }
                    return objectInFile
                })
                data?.geofenceList = mapGeofenceList
            }
            complete(success, data)
        }
    }
    
    fileprivate class func readFile(_ complete: @escaping (_ success: Bool, _ data: ConfigurationBean?) -> ()){
        readFileFromDisk(fileName, complete: { (success, data, error) in
            guard let beforeSectionDate = UserDefaults.standard.object(forKey: "daysToLive") as? Date else{
                complete(false, nil)
                return
            }
            if let config = self.parseFrom(data, option: "") {
                let duration = Date().daysFrom(beforeSectionDate)
                if duration > config.daysToLive {
                    complete(false, nil)
                }else {
                    complete(true, config)
                }
            }else {
                complete(false, nil)
            }
            
        })
    }
    
    class func writeToFile(_ data: Data?) {
        guard let data = data else{
            return
        }
        writeToDisk(fileName, data: data) { (success) in
            if success {
                let dataDefault = UserDefaults.standard
                dataDefault.set(Date(), forKey: "daysToLive")
                dataDefault.synchronize()
            }
        }
    }
    
    class func parseFrom(_ data: Data?, option: String = "") -> ConfigurationBean? {
        guard let data = data else {
            return nil
        }
        let result = ConfigurationBean()
        let xml = try! XML.parse(data)
        let root = xml["data"]
        let profile = root["profile"]
        result.profileName = profile["name"].text ?? ""
        result.readReceiptUrl = profile["readReceiptUrl"].text ?? ""
        result.xmlUrlForGf = profile["xmlUrlForGf"].text ?? ""
        
        // Handle daToLive
        let dayToLive = profile["daysToLive"].int ?? 0        

        if dayToLive != 0 {
            // Save time getting present xml file
            let timeString = Common.convertDateToString(Date(), format: FORMAT_DATE_YYYY_SS)
            UDSet(TIME_GET_PRESENT_XML, value: timeString as AnyObject)
        }
        
        result.daysToLive = dayToLive
        let inforGroup = root["infoGroup", "info"]
        result.infoGroup = [:]
        for info in inforGroup {
            let infoObject = MailXML(xml: info)
            result.infoGroup![infoObject.lang] = infoObject
        }
        let beaconList = root["ibeaconList"]["ibeacon"]
        result.ibeaconList = []
        for bcon in beaconList {
            let uuid = bcon["uuid"].text ?? ""
            let xmlUrl = bcon["xmlUrl"].text ?? ""
            let beacon = BeaconInfo(uuid: uuid, xmlURL: xmlUrl)
            result.ibeaconList?.append(beacon)
        }
        let geoFenceList = root["geofenceList"]["geofence"]
        result.geofenceList = []
        for dict in geoFenceList {
            let objectGeo = GeoFenceBean(fromConfiguration: dict)
            objectGeo.saveNotificationInfo()
            result.geofenceList?.append(objectGeo)
        }
        return result
    }
}

extension Date {
    func yearsFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    func weeksFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    func daysFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date: Date) -> Int {
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date: Date) -> Int{
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    func secondsFrom(_ date: Date) -> Int{
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
    func offsetFrom(_ date: Date) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}
