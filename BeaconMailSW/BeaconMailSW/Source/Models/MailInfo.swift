//
//  MailInfo.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import CoreData

class MailInfo: BaseInfo {
    var mail_id:String = ""
    var subject:String = ""
    var message:String = ""
    var messageDescription:String = ""
    var is_read:Bool = false
    var is_favorite:Bool = false
    var create_date: Date?
    var update_date: Date?
    
    var beacon: BeaconInfo?
    var geofence: GeoFenceBean?
    
    static func getNumberNewMailOfBeacon(_ beaconInfo:BeaconInfo)->Int {
        // return
        return beaconInfo.new_mail_cnt
    }
    
    static func getNumberNewMail()->Int {
        var allNewMail = 0
        
        let listBeacons = Beacon.getAll()
        
        for beaconInfo in listBeacons {
            allNewMail = allNewMail + MailInfo.getNumberNewMailOfBeacon(beaconInfo)
        }
        return allNewMail
    }
    
}
