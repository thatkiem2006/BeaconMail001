//
//  StaticData.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation
class StaticData: NSObject {
    var bmConfiguration:ConfigurationBean?
    var string: String = ""
    class var shared : StaticData {
        struct Static {
            static let instance : StaticData = StaticData()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
    }
}
