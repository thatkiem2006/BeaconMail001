//
//  LeftMenuInfo.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit

enum LeftMenuType
{
    case beacon
    case beacon_DEFAULT
    case menu
    case menu_ABOUT
    case geofence
    
    func toString()-> String {
        switch self {
        case .beacon_DEFAULT:
            return "BEACON_DEFAULT"
        case .menu:
            return "MENU"
        case .beacon:
            return "BEACON"
        case .menu_ABOUT:
            return "MENU_ABOUT"
        case .geofence:
            return "GEOFENCE"
        }
    }
}

class LeftMenuInfo: NSObject {
    var imageIcon:String = ""
    var name:String = ""
    var type:LeftMenuType = LeftMenuType.menu
    var naviName:NaviName?
    var unreadCnt:Int = 0
    var beaconInfo:BeaconInfo?
    var geofenceInfor: GeoFenceBean?
    var updateDate: Date?
    var presentID: String{
        get {
            let key = type.toString() + "-" + name
            return key
        }
    }
    // MARK: Init
    override init() {
        super.init()
    }
    
    init(geofence: GeoFenceBean) {
        self.name = geofence.mail?.name ?? ""
        self.imageIcon = geofence.profile?.iconURl ?? ""
        self.naviName = NaviName.beacon
        self.geofenceInfor = geofence
        self.type = .geofence
        self.updateDate = geofence.update_date! as Date
        var unreadCnt = geofence.unread_cnt
        unreadCnt = unreadCnt > 100 ? 100 : unreadCnt
        self.unreadCnt = unreadCnt
    }
    
    init(iBeacon beacon: BeaconInfo) {
        self.name = beacon.mail?.name ?? ""
        self.imageIcon = beacon.profile?.iconURl ?? ""
        self.naviName = NaviName.beacon
        self.updateDate = beacon.update_date
        var unreadCnt = (beacon.new_mail_cnt + beacon.unread_cnt)
        unreadCnt = unreadCnt > 100 ? 100 : unreadCnt
        self.unreadCnt = unreadCnt
        self.beaconInfo = beacon
    }
    
    
    
}
