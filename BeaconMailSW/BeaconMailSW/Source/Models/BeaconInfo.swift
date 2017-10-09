//
//  BeaconInfo.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import SwiftyXMLParser


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

class BeaconInfo: BaseInfo {
    // base info
    var uuid:String = ""
    var major:String = ""
    var minor:String = ""
    var rssi:String = ""
    var identifier:String = ""
    var proximity:CLProximity = CLProximity.unknown
    var create_date: Date?
    var update_date: Date?
    var beacon_id: String?
    var xmlUrl: String?
    
    // add
    var unread_cnt:Int = 0
    var new_mail_cnt:Int = 0
    var new_mail_id:Int = 0
    var update_date_newmail: Date?
    var protected:Bool = false
    
    var xmlData:Data? {
        didSet {
            if let data = xmlData  {
                let xml = XML.parse(data)
                let infor = BeaconInfo(xml: xml)
                self.mailGroup = infor.mailGroup
                self.webGroup = infor.webGroup
                self.notifiGroup = infor.notifiGroup
                self.profile = infor.profile
            }
        }
    }
    
    var mailGroup:[String: MailXML]?
    var webGroup: [String: [String: WebXML]]?
    var notifiGroup: [String: Notification]?
    
    //MARK: - Computed property
    var mail: MailXML? {
        get {
            let mail = mailGroup?[UDGet(kLanguage)!] ?? mailGroup?[kLanguageCodeDefault]
            if isDefault() {
                mail?.name = kprofile_name_default
            }
            return mail
        }
    }
    
    var web: WebXML? {
        get {
            let web = getWebBy(self.proximity.intValue(), languageCode: UDGet(kLanguage)!)
            return web
        }
    }
    var notification: Notification? {
        get {
            if self.isDefault() {
                let defautBeacon = Common.getDefaultBeacon()
                let notification = Notification()
                notification.message = "Loading now ..."
                return notification
            }
            let notification = notifiGroup?[UDGet(kLanguage)!] ?? notifiGroup?[kLanguageCodeDefault]
            return notification
        }
    }
    fileprivate var _profile:iBeaconProfile?
    var profile: iBeaconProfile? {
        get {
            if self.isDefault() {
                _profile = iBeaconProfile()
                _profile?.iconURl = kimage_icon_default
                _profile?.bannerUrl = kimage_banner_default
            }
            return _profile
        }
        set (newProfile){
            _profile = newProfile
        }
    }
    
    //MARK: - Initial
    
    override init() {
        super.init()
    }
    init(uuid: String, xmlURL: String?) {
        super.init()
        self.uuid = uuid
        self.xmlUrl = xmlURL
    }
    
    init(beacon: CLBeacon, identifier: String) {
        
        self.uuid = beacon.proximityUUID.uuidString
        self.major = "\(beacon.major)"
        self.minor = "\(beacon.minor)"
        self.rssi = "\(beacon.rssi)"
        self.proximity = beacon.proximity
        self.identifier = identifier
    }
    
    init(uuid: String, major: String, minor: String) {
        self.uuid = uuid
        self.major = major
        self.minor = minor
    }
    init(beacon: BeaconInfo) {
        super.init()
        self.clone(beacon)
    }
    init(xml accessor: XML.Accessor) {
        super.init()
        let data = accessor["data"]
        let profile = data["profile"]
        self.profile = iBeaconProfile(xml: profile)
        
        let mailGroup = data["mailGroup", "mail"]
        self.mailGroup = [:]
        for mailRaw in mailGroup {
            let mail = MailXML(xml: mailRaw)
            self.mailGroup?[mail.lang] = mail
        }
        
        let notifiGroup = data["notifGroup", "notif"]
        self.notifiGroup = [:]
        for mailR in notifiGroup {
            let notifi = Notification(xml: mailR)
            self.notifiGroup?[notifi.lang] = notifi
        }
        
        let proximityRaw = data["proximity"]
        self.webGroup = [String: [String: WebXML]]()
        if let proximityElement = proximityRaw.element?.childElements {
            for element in proximityElement {
                let webList = proximityRaw[element.name, "web"]
                var webListObject = [String: WebXML]()
                for webR in webList {
                    let webObject = WebXML(xml: webR)
                    webListObject[webObject.lang] = webObject
                }
                self.webGroup?[element.name] = webListObject
            }
        }
        
    }
    
    func getWebBy(_ proximity: Int, languageCode:String = UDGet(kLanguage) ?? kLanguageCodeDefault) -> WebXML? {
        // taopd fix
        var web: WebXML?
        if let webGroup = webGroup {
            if let proximityArr = webGroup[proximity.proximityMap()] {
                web = proximityArr[languageCode] ?? proximityArr[kLanguageCodeDefault]
            } else if let proximityFirst = webGroup.first?.1 {
                web = proximityFirst[languageCode] ?? proximityFirst[kLanguageCodeDefault]
            }
        }
        
        return web
    }
    
    func copy(iBeacon beacon: BeaconInfo?) {
        guard let beacon = beacon else {
            return
        }
        self.webGroup = beacon.webGroup
        self.notifiGroup = beacon.notifiGroup
        self.mailGroup = beacon.mailGroup
    }
    
    ////
    override var description: String {
        return "\(major)/\(minor) RSSI: \(rssi) Prox: \(proximity.description())"
    }
    
    //MARK: - Private
    //MARK: - Public
    func clone(_ beacon: BeaconInfo) {
        self.uuid = beacon.uuid
        self.major = beacon.major
        self.minor = beacon.minor
        self.rssi = beacon.rssi
        self.proximity = beacon.proximity
        self.identifier = beacon.identifier
        self.xmlData = beacon.xmlData
    }
    
    func isEqualUUID(_ beaconInfo:BeaconInfo?)->Bool {
        if let beacon = beaconInfo {
            if self.uuid == beacon.uuid{
                return true
            }
        }
        return false
    }
    func isEqualBeacon(_ beaconInfo:BeaconInfo?)->Bool {
        guard let beacon = beaconInfo else {
            return false
        }
        if self.uuid == beacon.uuid &&
            self.major == beacon.major &&
            self.minor == beacon.minor {
            return true
        }
        return false
    }
    
    func isDefault() -> Bool {
        if self.uuid == kuuid_default &&
            self.major == kmajor_default &&
            self.minor == kminor_default {
            return true
        }
        return false
    }
    
    func isEmpty() ->Bool {
        if self.uuid.isEmpty ||
            self.major.isEmpty ||
            self.minor.isEmpty {
            return true
        }
        return false
    }
    func comparePromixity(_ beaconInfo:BeaconInfo?)->Int {
        if let beacon = beaconInfo {
            // Closer
            if self.proximity.intValue() < beacon.proximity.intValue() {
                return 1
                // Far
            }else  if self.proximity.intValue() > beacon.proximity.intValue() {
                return -1
                // Equal
            }else {
                return 0
            }
        }
        return -1
    }
    func compareRSSI(_ beaconInfo:BeaconInfo?)->Int {
        if let beacon = beaconInfo {
            // Closer
            if Int(self.rssi) < Int(beacon.rssi)
            {
                return 1
                // Far
            }else  if Int(self.rssi) > Int(beacon.rssi)
            {
                return -1
                // Equal
            }else
            {
                return 0
            }
        }
        
        // Far
        return -1
    }
    
    //MARK: - Class method
    static func copyBeacon(_ beaconInfo:BeaconInfo)->BeaconInfo {
        // create beacon
        let copyBeaconInfo = BeaconInfo()
        copyBeaconInfo.uuid = beaconInfo.uuid
        copyBeaconInfo.major = beaconInfo.major
        copyBeaconInfo.minor = beaconInfo.minor
        copyBeaconInfo.rssi = beaconInfo.rssi
        copyBeaconInfo.proximity = beaconInfo.proximity
        copyBeaconInfo.identifier = beaconInfo.identifier
        return copyBeaconInfo
    }
    
    static func updateBeaconProtectToDb(_ beaconInfo:BeaconInfo)-> Bool {
        let mocContext = DataManager.shared.managedObjectContext
        // get list beacons in db
        let listBeaconEntities = BaseInfo.getEntitiesFromMajorMinor(beaconInfo.major, minor:beaconInfo.minor,entityName: ENTITY_BEACON,context: mocContext)
        
        if listBeaconEntities.count != 0{
            
            let managedObject = listBeaconEntities[0]
            managedObject.setValue(beaconInfo.protected, forKey: "protected")
            // save
            DataManager.shared.saveContext(mocContext)
            
            return true
        }
        
        return false
    }
    
    static func deleteBeaconInDb(_ beaconInfo:BeaconInfo) {
        let mocContext = DataManager.shared.managedObjectContext
        // get list XML entities in db with major and minor
        let listEntities = BaseInfo.getEntitiesFromMajorMinor(beaconInfo.major,minor:beaconInfo.minor,entityName:ENTITY_BEACON, context: mocContext)
        
        if listEntities.count > 0 {
            BaseInfo.deleteEntities(listEntities)
        }
    }
    
    
    static func checkBeaconInDb(_ beaconInfo:BeaconInfo)->Bool {
        // get beacon info if it is exist in db
        if let _ = BeaconInfo.getBeaconWithMajorMinor(beaconInfo.major,minor:beaconInfo.minor)
        {
            return true
        }
        
        return false
    }
    
    static func getBeaconWithMajorMinor(_ major:String, minor:String)->BeaconInfo? {
        // create MOC
        let mocContext = DataManager.shared.managedObjectContext
        
        // get list beacons in db
        let listBeacons = BaseInfo.getEntitiesFromMajorMinor(major,minor:minor,entityName:ENTITY_BEACON, context: mocContext)
        
        for beacon in listBeacons {
            
            // create beacon info
            let beaconInfo = BeaconInfo()
            beaconInfo.uuid = (beacon.value(forKey: "uuid") as? String)!
            beaconInfo.major = (beacon.value(forKey: "major") as? String)!
            beaconInfo.minor = (beacon.value(forKey: "minor") as? String)!
            beaconInfo.rssi = (beacon.value(forKey: "rssi") as? String)!
            
            //proximity
            let proximity = (beacon.value(forKey: "proximity") as? String)!
            beaconInfo.proximity = proximity.toCLProximity()
            beaconInfo.protected = (beacon.value(forKey: "protected") as? Bool)!
            // date
            beaconInfo.update_date = (beacon.value(forKey: "update_date") as? Date)!
            beaconInfo.create_date = (beacon.value(forKey: "create_date") as? Date)!
            
            // return
            return beaconInfo
        }
        
        return nil
    }
    
    static func getListBeaconEntities()-> [NSManagedObject] {
        return BaseInfo.getEntities(NUMBER_BEACON, entityName: ENTITY_BEACON)
    }
}
