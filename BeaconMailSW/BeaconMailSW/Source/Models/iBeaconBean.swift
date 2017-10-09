//
//  iBeaconBean.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation
import SwiftyXMLParser
class iBeaconProfile: ProfileXML {
    var allowProximity: String?
    var security: String?
    override init(xml: XML.Accessor) {
        super.init(xml: xml)
        self.allowProximity = xml["allowProximity"].text
        self.security = xml["securityKey"].text
    }
    override init() {
        super.init()
    }
}
extension BeaconInfo {
    
}
extension Int {
    func proximityMap()->String{
        switch self {
        case 1:
            return "immediate"
        case 2:
            return "near"
        case 3:
            return "far"
        default:
            return "unknow"
        }
    }
}
