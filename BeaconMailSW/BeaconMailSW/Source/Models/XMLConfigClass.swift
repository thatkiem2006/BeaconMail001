//
//  XMLConfigClass.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation
import SwiftyXMLParser
class ProfileXML {
    var iconURl: String?
    var bannerUrl: String?
    var saveMailbox = false
    var securityKey: String?
    init(xml: XML.Accessor){
        self.iconURl = xml["iconUrl"].text
        self.bannerUrl = xml["bannerUrl"].text
        self.saveMailbox = xml["saveMailbox"].bool ?? false
        self.securityKey = xml["securityKey"].text
    }
    init() {
    }
    
}
class MailXML {
    var lang: String = ""
    var name: String = ""
    var server: String = ""
    var encryption: String?
    var port: String?
    var idPrefix: String?
    var idSuffix: String?
    var passwd: String?
    var id: String = ""
    var isDefault = false
    
    init(xml root: XML.Accessor){
        self.isDefault = root.attributes["default"] == nil ? false: true
        self.lang = root.attributes["lang"] ?? ""
        self.name = root["id"].text ?? root["name"].text ?? ""
        self.id = root["id"].text ?? ""
        self.server = root["server"].text ?? ""
        self.encryption = root["encryption"].text ?? ""
        self.port = root["port"].text
        self.idPrefix = root["idPrefix"].text
        self.idSuffix = root["idSuffix"].text
        self.passwd = root["passwd"].text
    }
    
    init(){
        
    }
    
    func isEmpty() ->Bool {
        if self.server.isEmpty || (self.passwd ?? "").isEmpty {
            return true
        }
        return false
    }
}
class WebXML {
    var lang: String = ""
    var url: String = ""
    var userId: String?
    var passwd: String?
    var elementIdOfUserId: String?
    var elementIdOfPasswd: String?
    
    init(xml root: XML.Accessor){
        self.lang = root.attributes["lang"] ?? ""
        self.url = root["url"].text ?? ""
        self.userId = root["userId"].text
        self.passwd = root["passwd"].text
        self.elementIdOfUserId = root["elementIdOfUserId"].text
        self.elementIdOfPasswd = root["elementIdOfPasswd"].text
    }
}

class Notification {
    var id: String = ""
    var geofence_id = ""
    var isDefault: Bool = false
    var lang: String = ""
    var message: String = ""
    var title: String = ""
    var create_date: Date?
    var update_date: Date?
    init(xml: XML.Accessor) {
        self.lang = xml.attributes["lang"] ?? ""
        self.title = xml["title"].text ?? ""
        self.message = xml["message"].text ?? ""
    }
    init(){
        
    }
}


extension String {
    func toBool() -> Bool {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return false
        }
    }
}
