//
//  InfoGroup.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import CoreData

class InfoGroup: BaseInfo {
    
    var id: NSString = ""
    var idPrefix: NSString = ""
    var isDefault: Bool = false
    var lang: NSString = ""
    var password: NSString = ""
    var port: NSString = ""
    var server: NSString = ""
    var encryption: NSString = ""
    
    var create_date: Date?
    var update_date: Date?
    
    override init() {
        super.init()
        
    }
    
    static func getListInfoGroups()-> [InfoGroup] {
        
        let listInfoGroup: [InfoGroup] = []
        let listInfoGroupEntities = InfoGroup.getListInfoGroupEntities()
        
        for infoGroup in listInfoGroupEntities {
            let info = InfoGroup()
            info.encryption = (infoGroup.value(forKey: "encryption") as? String)! as NSString
            info.idPrefix = (infoGroup.value(forKey: "idPrefix") as? String)! as NSString
            info.isDefault = (infoGroup.value(forKey: "isDefault") as? Bool)!
            info.lang = (infoGroup.value(forKey: "lang") as? String)! as NSString
            info.password = (infoGroup.value(forKey: "password") as? String)! as NSString
            info.port = (infoGroup.value(forKey: "port") as? String)! as NSString
            
        }
        return listInfoGroup
    }
    static func getListInfoGroupEntities()-> [NSManagedObject] {
        return BaseInfo.getEntities(0, entityName: ENTITY_INFOGROUP)
    }
    
}
