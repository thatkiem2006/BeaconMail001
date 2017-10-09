//
//  DeviceInfo.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit

class DeviceInfo: NSObject {
    
    static func getUUID() -> String{
        return UIDevice.current.identifierForVendor!.uuidString
    }
}
