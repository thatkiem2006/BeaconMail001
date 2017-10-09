//
//  AppDefine.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//


import Foundation
let ENTITY_BEACON = "Beacon"
let ENTITY_XML = "XMLFileData"
let ENTITY_MAILACCOUNT = "MailAccount"
let ENTITY_MAIL = "MailBox"
let ENTITY_GEOFENCE = "Geofence"
let kCheckMailsExist = "Check mails exist on server"
let kReloadLeftMenuNotification = "Reload left menu notification"
let kClearCacheViewController = "clear_cache_view_controller"

public enum LocationKey:String {
    case newLocation = "new location"
    case newBeacon = "new beacon"
    case enterRegionCircular = "enter region circular"
    case exitRegionCircular = "exit region circular"
    case enterRegionBeacon = "enter region beacon"
    
}

public enum LocationEvent:String {
    case newLocation = "key notification location new location"
    case newBeacon = "key notification location new beacon"
    case hasNoBeacon = "key has no beacon"
    case enterRegionCircular = "key notification location enter region circular"
    case exitRegionCircular = "key notification location exit region circular"
    case enterRegionBeacon = "key notification location enter region beacon"
    case exitRegionBeacon = "key notification location exit region beacon"
}

// BASE
let BASE_URL = ""
let URL_SEND_UUID = "https://beaconlog.idio.info/mailbeaconlog/mailbeaconlog.aspx?k="
let URL_SEND_MAIL = "admin@b.idio.info"

// Key Encode
let KEY_DEBUG_MODE_ENABLE = "enable debug mode"
let KEY_UUID_DEBUG_1 = "uuid debug 1"
let KEY_UUID_DEBUG_2 = "uuid debug 2"
let KEY_TRIPLE_DES = "ccbcc740f07a8918ccbcc740"
let KEY_TRIPLE_DES_IV = "d0faef14"
let KEY_TIME_DETTECT_BEACON = "time dettect beacon"
let KEY_FIRST_OPEN_APP = "insert default beacon"
let KEY_DOWNLOAD_CONFIG_SUCCESS = "KEY_DOWNLOAD_CONFIG_SUCCESS"
let KEY_CHECK_TIME_GET_NEW_MAIL = "KEY_CHECK_TIME_GET_NEW_MAIL"

let kLanguage = "kLanguageApp"
let kLanguageCodeDefault = "ja"

let kGoogleMapLocationDefault = (35.702069100000003, 139.77532690000001)

let GEOFENCE_URL = "http://project.adnet.space/geofence.xml"
// ADNET #1
//let URL_HOMEPAGE = "http://idio.info"
//let kMailDefaultServer = "m5.coreserver.jp"
//let kMailDefaultPort = "993"
//let kMailDefaultEncryption = "ssl"
//let kMailDefaultAccount = "bminfo@oremou.com"
//let kMailDefaultPasswd = "0000"
//
//let VALUE_UUID_DEFAULT_1 = "52CFF8BF-4437-1801-9193-001C4D21B2A7"
//let VALUE_UUID_DEFAULT_2 = "F02AAD48-4437-1801-BBED-001C4D713797"
//let VALUE_URL_XML_SETTING_DEFAULT_1 = "http://ibeacon.xvs.jp/"


// CLIENT #2
//let URL_HOMEPAGE = "http://idio.info"
//let kMailDefaultServer = "mail.medionlink.com"
//let kMailDefaultPort = "993"
//let kMailDefaultEncryption = "ssl"
//let kMailDefaultAccount = "b58a39c4a7a9711c"
//let kMailDefaultPasswd = "64641286464128"
//
//let VALUE_UUID_DEFAULT_1 = "00000000-4BF2-1001-B000-001C4D1300D3"
//let VALUE_UUID_DEFAULT_2 = "E20A39F4-73F5-4BC4-A12F-17D1AD07A961"
//let VALUE_URL_XML_SETTING_DEFAULT_1 = "http://idio.info/01C4D1300D37D1AD07A961/"


// BEACONMAIL #3
let URL_HOMEPAGE = "http://idio.info"
let kMailDefaultServer = "mail.medionlink.com"
let kMailDefaultPort = "993"
let kMailDefaultEncryption = "ssl"
let kMailDefaultAccount = "b58a39c4a7a9711c"
let kMailDefaultPasswd = "64641286464128"
let kDayToSecond = 24*60*60
//
let VALUE_UUID_DEFAULT_1 = "52CFF8BF-4437-1801-9193-001C4D21B2A7" // test
//let VALUE_UUID_DEFAULT_1 = "00000000-4BF2-1001-B000-001C4D1300D3"
let VALUE_UUID_DEFAULT_2 = "B628F65E-4BF2-1801-A7D1-001C4D7629EF"
//let VALUE_URL_XML_SETTING_DEFAULT_1 = "http://idio.info/01C4D1300D37D1AD07A961/"
let VALUE_INITIAL_KEY = ""
//http://ibeacon.xvs.jp
//Bundle Id :  info.idio.beaconmail
//Name : BeaconMail


/*
 // LALANET #4
 let URL_HOMEPAGE = "http://idio.info/lalanet/"
 let kMailDefaultServer = "mail.medionlink.com"
 let kMailDefaultPort = "993"
 let kMailDefaultEncryption = "ssl"
 let kMailDefaultAccount = "lalanet"
 let kMailDefaultPasswd = "Nn7mJBo0"
 //
 let VALUE_UUID_DEFAULT_1 = "52CFF8BF-4437-1801-9193-001C4D21B2A7" // test
 //let VALUE_UUID_DEFAULT_1 = "BEDA70E1-4BF2-1801-8E8E-001C4DE50929"
 let VALUE_UUID_DEFAULT_2 = "7AC40023-4BF2-1801-9788-001C4DA68D81"
 //let VALUE_URL_XML_SETTING_DEFAULT_1 = "http://idio.info/169A70DA1D73D0031D4C10/"
 let VALUE_URL_XML_SETTING_DEFAULT_1 = "http://ibeacon.xvs.jp/" // test
 //Bundle Id :  info.idio.lalanet
 //Name : ララネット
 */
/*
 // DUET #5
 let URL_HOMEPAGE = "http://idio.info"
 let kMailDefaultServer = "mail.medionlink.com"
 let kMailDefaultPort = "993"
 let kMailDefaultEncryption = "ssl"
 let kMailDefaultAccount = "b58a39c4a7a9711c"
 let kMailDefaultPasswd = "64641286464128"
 //
 let VALUE_UUID_DEFAULT_1 = "B628F65E-4BF2-1801-A7D1-001C4D7629EF"
 let VALUE_UUID_DEFAULT_2 = "7AC40023-4BF2-1801-9788-001C4DA68D81"
 let VALUE_URL_XML_SETTING_DEFAULT_1 = "http://idio.info/7D1AD07A96101C4D1300D3/"
 //Bundle Id :  info.idio.duet
 //Name : duet
 */

/*
 // Miyake #6
 let URL_HOMEPAGE = "http://www.miyake.or.jp/"
 let kMailDefaultServer = "smail.miyake.or.jp"
 let kMailDefaultPort = "993"
 let kMailDefaultEncryption = "ssl"
 let kMailDefaultAccount = "mmib58a39c4a7a9711c"
 let kMailDefaultPasswd = "64641286464128"
 ////
 let VALUE_UUID_DEFAULT_1 = "E16D142A-4BF2-1801-BC12-001C4DAAC873"
 let VALUE_UUID_DEFAULT_2 = "B628F65E-4BF2-1801-A7D1-001C4D7629EF"
 let VALUE_URL_XML_SETTING_DEFAULT_1 = "http://idio.info/1C4D7629EF001C4DAAC873/"
 //Bundle Id :  jp.or.miyake.mmig
 //Name : MMIG
 */
/*
 //Kamado #7
 let URL_HOMEPAGE = ""
 let kMailDefaultServer = "mail.medionlink.com"
 let kMailDefaultPort = "993"
 let kMailDefaultEncryption = "ssl"
 let kMailDefaultAccount = "kdedad07a961169a7"
 let kMailDefaultPasswd = "64641286464128"
 ////
 let VALUE_UUID_DEFAULT_1 = "DE92A079-4BF2-1801-BDED-001C4D037604"
 let VALUE_UUID_DEFAULT_2 = "7AC40023-4BF2-1801-9788-001C4DA68D81"
 let VALUE_URL_XML_SETTING_DEFAULT_1 = "http://idio.info/DEDAD07A961169A70DA1D73/"
 //Bundle Id :  jp.co.artoffice.kamado
 //Name : Kamado
 */


// Entity
let ENTITY_MAIL_FARVORITE = "FavoriteMailBox"
let ENTITY_BEACONREGION = "BeaconRegion"
let ENTITY_INFOGROUP = "InfoGroup"
let ENTITY_NOTIFICATION = "Notification"
let ENTITY_PROFILE = "Profile"

// format date
let FORMAT_DATE_YYYY_SS = "yyyy/MM/dd HH:mm:ss"
let FORMAT_DATE_YYYY_MM = "yyyy/MM/dd HH:mm"
let FORMAT_DATE_YYYY_DD = "yyyy/MM/dd"

// auto increment
let KEY_AUTO_INCREMENT_MAIL = "key auto increment mail"

// BEACONS
let REIGON_BEACON_1 = "idio1"
let REIGON_BEACON_2 = "idio2"

// COLOR
let COLOR_HEX_BEACON_DETECT = "#FFCCCC"
let COLOR_HEX_BEACON_PROTECT = "#FFF2CC"

// TIMER
let TIME_GET_BACKGROUND = Double(60 * 1)  // 60s * 1m
let TIME_NOTIFY = 60 * 60
let TIME_GET_PRESENT_XML = "time_get_present_xml"
//let TIME_GET_BACKGROUND = Double(10 * 1)
//let TIME_NOTIFY = 10

let TIME_DETECT_BEACON = 2

let TIME_GET_NEW_MAIL_BACK_GROUND = 5*60

// TITLE
let TITLE_BLUETOOTH = "Bluetooth"

// MESSAGES
let MESSAGE_DEBUG_SAVE = "dialog_save_configuration_message".localizedString
let MESSAGE_MAIL_DELETE = "favorite_delete_message".localizedString
let MESSAGE_MAIL_ADD_FAVORITE = "mail_add_favorite".localizedString

// MAIL
let NUMBER_MAIL = 100
let NUMBER_MAIL_FAVORITE = 200
let NUMBER_BEACON = 100
let geofenceKm = Double(1)

let radius = Double(1.5)
// TEXT
let kuuid_default = "default - beacon - uuid"
let kmajor_default = "99999"
let kminor_default = "99999"
let kprofile_name_default = "menu_information".localizedString
let kimage_icon_default = "ic_default_mail.png"
let kimage_banner_default = "img_logo_default_mail.png"
