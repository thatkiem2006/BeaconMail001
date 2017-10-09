//
//  XMLInfo.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import SwiftyXMLParser
class WebAccessInfo: NSObject {
    var webAccess_proximity:CLProximity = CLProximity.unknown
    var webAccess_url:String = ""
    var webAccess_userId:String = ""
    var webAccess_passwd:String = ""
    var webAccess_elementIdOfUserId:String = ""
    var webAccess_elementIdOfPasswd:String = ""
    
    func map(_ web: WebXML?) {
        guard let web = web else {
            return
        }
        self.webAccess_url = web.url 
        self.webAccess_userId = web.userId ?? ""
        self.webAccess_passwd = web.passwd ?? ""
        self.webAccess_elementIdOfUserId = web.elementIdOfUserId ?? ""
        self.webAccess_elementIdOfPasswd = web.elementIdOfPasswd ?? ""
    }
}

class XMLInfo: BaseInfo {
    var type: String!
    
    var is_loadMail:Bool = false
    var mail = MailXML()
    var create_date: Date?
    var update_date: Date?
    var dataRaw: Data?
    init(type: String) {
        self.type = type
    }
    
    // MARK:
    func isEmpty() ->Bool {
        if self.mail.server.isEmpty || (self.mail.passwd ?? "").isEmpty {
            return true
        }
        return false
    }
    
    func geoFromXMLFile() -> GeoFenceBean? {
        return nil
    }
}
extension BeaconInfo {
    func getWebAccess() -> WebAccessInfo {
//        let proximityInt = self.proximity.intValue()
//        let identifier = self.uuid + (UDGet(kLanguage) ?? kLanguageCodeDefault)
//        let chainProximity: AnyObject? = UDGet(identifier)
//        //fix error
////        if chainProximity as? [Int] == nil {
////            chainProximity []
////        }
//        var mutableChain = chainProximity as! [Int]
//        //fix error _
//        if let _ = self.getWebBy(proximityInt), mutableChain.contains(proximityInt) == false{
//            mutableChain.append(proximityInt)
//            UDSet(identifier, object: mutableChain as AnyObject)
//        }
//        let maxProximity = mutableChain.sorted().first ?? 4
        let webAccess = WebAccessInfo()
        webAccess.webAccess_proximity = self.proximity
        let proximityInt = self.proximity.intValue()
        
        let languge: String = UDGet(kLanguage) ?? kLanguageCodeDefault
        let web = self.getWebBy(proximityInt, languageCode: languge)
        webAccess.map(web)
        return webAccess
    }
}
