//
//  Region.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyXMLParser
class Region: CustomStringConvertible {
    var description: String {
        return description
    }
}

struct MaiBoxInfo {
    var latestMailId = 0
    var numberNewMail = 0
}

class GeoFenceBean: Region {
    var latitude: String!
    var longitude: String!
    var radius: String!
    var identifier: String! = ""
    var isEnterGeo:Bool? = false
    var mailboxInfo = MaiBoxInfo()
    
    var profile: ProfileXML?
    var mailGroup:[String: MailXML]?
    var webGroup: [String: WebXML]?
    var notifiGroup: [String: Notification]?
    var create_date: NSDate?
    var update_date: NSDate?
    var distanceToUser: Double = 0
    var unread_cnt:Int = 0
    
    var notify_title: String?
    var notify_message: String?
    
    var mail: MailXML? {
        get {
            let mail = mailGroup?[UDGet(kLanguage) ?? kLanguageCodeDefault] ?? mailGroup?[kLanguageCodeDefault]
            return mail
        }
    }
    
    var web: WebXML? {
        get {
            let web = webGroup?[UDGet(kLanguage) ?? kLanguageCodeDefault] ?? webGroup?[kLanguageCodeDefault]
            return web
        }
    }
    
    var notification: Notification? {
        get {
            let notification = notifiGroup?[UDGet(kLanguage) ?? kLanguageCodeDefault] ?? notifiGroup?[kLanguageCodeDefault]
            return notification
        }
    }
    
    var xml_file_id: String?
    var xmlID: String! {
        get {
            if xml_file_id == nil {
                xml_file_id = self.genarateXMLID()
            }
            return xml_file_id
        }
    }
    var xmlData:Data? {
        didSet {
            if let data = xmlData  {
                let xml = XML.parse(data)
                let infor = GeoFenceBean(xml: xml)
                self.mailGroup = infor.mailGroup
                self.webGroup = infor.webGroup
                //self.notifiGroup = infor.notifiGroup
                self.profile = infor.profile
            }
        }
    }
    //MARK: Initial
    init(latitude: String, longitude: String, radius: String){
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.identifier = NSUUID().uuidString
    }
    override init() {
        super.init()
    }
    
    init(geo: GeoFenceBean) {
        super.init()
        geo.clone(geo: geo)
        //geo.clone; //fix error
    }
    
    init(xml accessor: XML.Accessor) {
        let data = accessor["data"]
        let profile = data["profile"]
        self.profile = ProfileXML(xml: profile)
        
        let mailGroupRaw = data["mailGroup", "mail"]
        self.mailGroup = [:]
        for mailR in mailGroupRaw {
            let mail = MailXML(xml: mailR)
            self.mailGroup?[mail.lang] = mail
        }
        let webList = data["webGroup", "web"]
        self.webGroup = [:]
        for webR in webList {
            let web = WebXML(xml: webR)
            webGroup?[web.lang] = web
        }
        
    }
    
    init(fromConfiguration xml: XML.Accessor) {
        let location = xml["location"]
        self.latitude = location["latitude"].text ?? ""
        self.longitude = location["longitude"].text ?? ""
        self.radius = location["radius"].text ?? ""
        self.identifier = NSUUID().uuidString //"0000-0000"
        
        let notifiList = xml["notifGroup"]["notif"]
        self.notifiGroup = [:]
        for notiRaw in notifiList {
            let objectNotifi = Notification(xml: notiRaw)
            self.notifiGroup![objectNotifi.lang] = objectNotifi
            
//            if let message = objectNotifi.message as? String {
//                self.notify_title = objectNotifi.title
//                self.notify_message = message
//            }
        }        
    }
    
    func saveNotificationInfo() {
        self.notify_title =  notification?.title
        self.notify_message = notification?.message
    }
    
    func sycXMLObjectData(geo: GeoFenceBean) {
        self.mailGroup = geo.mailGroup
        self.webGroup = geo.webGroup
        self.notifiGroup = geo.notifiGroup
        self.profile = geo.profile
    }
    func clone(geo: GeoFenceBean) {
        self.identifier = geo.identifier
        self.longitude = geo.longitude
        self.latitude = geo.latitude
        self.radius = geo.radius
        self.isEnterGeo = geo.isEnterGeo
    }
    
    override var description: String {
        let lat = NSString(format: "%@", latitude ?? "0")
        let long = NSString(format: "%@", longitude ?? "0")
        let rad = NSString(format: "%@", radius ?? "0")
        return "\(lat), \(long), \(rad) m"
    }
    
    //MARK: - Private
    /* //fix error
    private func genarateXMLID() -> String {
        let latitude = self.latitude.stringByReplacingOccurrencesOfString(".", withString: "") ?? "0"
        
        let longitude = self.longitude.stringByReplacingOccurrencesOfString(".", withString: "") ?? "0"
        
        var latHex = Common.convertIntToHex(Int(latitude)!, maxCharacter: 8)
        let longHex = Common.convertIntToHex(Int(longitude)!, maxCharacter: 8)
        return "\(latHex)/\(longHex)"
    }
    */
    //fix error
    private func genarateXMLID() -> String {
        
        let latitude = self.latitude.replacingOccurrences(of: ".", with: "")
        let longitude = self.longitude.replacingOccurrences(of:".", with: "")
        
        let latHex = Common.convertIntToHex(Int(latitude)!, maxCharacter: 8)
        let longHex = Common.convertIntToHex(Int(longitude)!, maxCharacter: 8)
        return "\(latHex)/\(longHex)"
        
    }
    
    func region() -> CLCircularRegion {
        let ceter = CLLocationCoordinate2DMake(Double(latitude)!, Double(longitude)!)
        let region = CLCircularRegion(center: ceter, radius: Double(radius)!, identifier: identifier)
        region.notifyOnEntry = true
        return region
    }
}
