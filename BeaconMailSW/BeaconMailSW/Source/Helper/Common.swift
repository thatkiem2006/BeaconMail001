//
//  Common.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import CoreLocation
extension CLProximity {
    func description()->String{
        switch self
        {
        case CLProximity.immediate:
            return "immediate"
        case CLProximity.near:
            return "near"
        case CLProximity.far:
            return "far"
        default:
            return "unknow"
        }
    }
    
    
    func intValue()->Int {
        switch self
        {
        case CLProximity.immediate:
            return 1
        case CLProximity.near:
            return 2
        case CLProximity.far:
            return 3
        default:
            return 4
        }
    }
}

extension String {
    func toCLProximity()->CLProximity
    {
        switch self {
        case "1":
            return CLProximity.immediate
        case "2":
            return CLProximity.near
        case "3":
            return CLProximity.far
        default:
            return CLProximity.unknown
        }
    }
    subscript (i: Int) -> Character {
        //        return self[advance(self.startIndex, i)]
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        //        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
        return self.substring(with: (self.characters.index(self.startIndex, offsetBy: r.lowerBound) ..< self.characters.index(self.startIndex, offsetBy: r.upperBound)))
    }
    func plainTextFromHTML() -> String? {
        let regexPattern = "<.*?>"
        do {
            let stripHTMLRegex = try NSRegularExpression(pattern: regexPattern, options: NSRegularExpression.Options.caseInsensitive)
            let plainText = stripHTMLRegex.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, self.characters.count), withTemplate: "")
            return plainText
        } catch {
            print("Warning: failed to create regular expression from pattern: \(regexPattern)")
            return nil
        }
    }
    
    var localizedString: String {
        var resourceName = "ja"
        
        //Check language :  en-VN , ja-VN
        if Locale.preferredLanguages[0].contains("en") {
            resourceName = "en"
        }
        
        let path = Bundle(for: type(of: Common.shared)).path(forResource: resourceName, ofType: "lproj")
        let langBundle = Bundle(path: path!)
        
        if let resultForKey = langBundle?.localizedString(forKey: self, value: "", table: nil) {
            return resultForKey
            
        } else {
            return NSLocalizedString(self, tableName: nil, bundle: Bundle(for: type(of: Common.shared)), value: "", comment: "")
        }
    }
    
    var attributedString: NSAttributedString? {
        do {
            let data = self.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let data = data {
                let str = try NSAttributedString(data: data,
                                                 options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                 documentAttributes: nil)
                return str
            }
        } catch {
        }
        return nil
    }
    
}
class Common: NSObject {
    
    class var shared : Common {
        struct Static {
            static let instance : Common = Common()
        }
        return Static.instance
    }
        
    static func getTermCondition() -> String {
        var fileName = "jp_term_condition"
        let lang = Locale.preferredLanguages[0] //en-VN , ja-VN
        if lang.lowercased().contains("en") {
            fileName = "en_term_condition"
        }
        return   readFileFromBundle(fileName, ofType: "txt")
    }
    
    static func getPrivacyPolicy() -> String {
        var fileName = "jp_privacy_policy"
        let lang = Locale.preferredLanguages[0]
        if lang.lowercased().contains("en") {
            fileName = "en_privacy_policy"
        }
        return   readFileFromBundle(fileName, ofType: "txt")
    }
    
    static  func readFileFromBundle(_ fileName: String, ofType: String) -> String {
        var content = ""
        if let filepath = Bundle(for: type(of: Common.shared)).path(forResource: fileName, ofType: ofType) {
            do {
                content = try String(contentsOfFile: filepath)
            }
            catch {
                return ""
            }
        }
        return content
    }
    
    static func convertIntToHex(_ number:Int, maxCharacter: Int = 4) ->String{
        var hex = NSString(format:"%X", number)
        if hex.length < maxCharacter {
            var fullHex:String = hex as String;
            let lossNumber = maxCharacter - hex.length;
            for _ in 0..<lossNumber {
                fullHex = "0\(fullHex)"
            }
            hex = fullHex as NSString
        }
        return hex.lowercased
    }
    
    
    static func secondsFrom(_ fromDate:Date,toDate:Date) -> Int{
        return (Calendar.current as NSCalendar).components(NSCalendar.Unit.second, from: fromDate, to: toDate, options: []).second!
    }
    
    static func convertDateToString(_ fromDate:Date?,format:String) -> String{
        
        if let convertDate = fromDate
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            
            return dateFormatter.string(from: convertDate)
            
        }else
        {
            return ""
        }
        
    }
    
    static func convertStringToDate(_ fromString:String,format:String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: fromString)
    }
    
    
    static func convertHtmlToString(_ htmlString:String)->String
    {
        var html = htmlString.convertingHTMLToPlainText()
        html = html?.replacingOccurrences(of: "/*", with: "")
        html = html?.replacingOccurrences(of: "*/", with: "")
        html = html?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        return  html!.convertingHTMLToPlainText().components(separatedBy: "\n")[0]
    }
    
    static func convertFloatToHex(_ number: Float) -> String
    {
        let hex = NSString(format: "%X", number)
        return hex.lowercased
    }
    
    static func getBoolFromKey(_ key:String) ->Bool
    {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: key)
    }
    
    static func setBoolValueFromKey(_ value:Bool,key:String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    static func getProximityFromString(_ proximity:String)->CLProximity
    {
        switch proximity
        {
        case "immediate":
            return CLProximity.immediate
        case "near":
            return CLProximity.near
        case "far":
            return CLProximity.far
        default:
            return CLProximity.unknown
        }
    }
    
    // MARK: - Key
    static func getLoadMailIdKey(_ uuid:String, major:String, minor:String) ->String{
        return "\(uuid)  \(major) \(minor) loadMailId"
    }
    
    // Default account
    static func getDefaultBeacon() ->BeaconInfo {
        let beaconInfo = BeaconInfo()
        beaconInfo.uuid = kuuid_default
        beaconInfo.major = kmajor_default
        beaconInfo.minor = kminor_default
        return beaconInfo
        
    }
    
    static func sendNotification(_ beaconInfo:BeaconInfo?, geo: GeoFenceBean? = nil) {
        print("sendNotification beaconInfo & geo")
        var userInfo = [String: String]()
        
        var title = ""
        var message = ""
        var imageIconURL = ""
        var imageBannerURL = ""
        if let beacon = beaconInfo {
            userInfo["uuid"] = beacon.uuid
            userInfo["major"] = beacon.major
            userInfo["minor"] = beacon.minor
            userInfo["proximity"] = beacon.proximity.description()
            userInfo["profile_name"] = beacon.mail?.name ?? ""
            imageIconURL = beacon.profile?.iconURl ?? ""
            imageBannerURL = beacon.profile?.bannerUrl ?? ""
            title = beacon.notification?.title ?? ""
            message = beacon.notification?.message ?? ""
            
        } else if let geo = geo {
            userInfo["geoXMLID"] = geo.xmlID;
            imageIconURL = geo.profile?.iconURl ?? ""
            imageBannerURL = geo.profile?.bannerUrl ?? ""
            message = geo.notification?.message ?? (geo.notify_message ?? "")
            title = geo.notification?.title ?? (geo.notify_title ?? "")
            userInfo["profile_name"] = title
        }
        userInfo["image_icon"] = imageIconURL
        userInfo["image_banner"] = imageBannerURL
        userInfo["message"] = message
        
        if #available(iOS 10.0, *) {
            showNotificationIOS10(title: title, subtitle: "", body: message, iconUrl: imageIconURL, userInfo: userInfo)
            
        } else {
            let notification = UILocalNotification()
            //let message = String.init(format: "%@: %@", title,message)
            let message = String.init(format: "%@\n%@", title,message)
            notification.alertBody = message
            notification.userInfo = userInfo
            notification.fireDate = Date()
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    @available(iOS 10.0, *)
    static func showNotificationIOS10(title: String, subtitle: String, body: String, iconUrl: String?, userInfo: [AnyHashable : Any]?) {
        
        if title.isEmpty == true && body.isEmpty == true {
            return
        }
        
            print("showNotificationIOS10")
            let content = UNMutableNotificationContent()
            content.title = title
            content.subtitle = subtitle
            content.body = body
            if let userInfo = userInfo {
                content.userInfo = userInfo
            }
        
            content.sound = UNNotificationSound.default()
            
            //To Present image in notification
            if let iconUrl = iconUrl {
                if let url = URL(string: iconUrl) {
                    do {
                        let attachment = try UNNotificationAttachment(identifier: "iconImage", url: url, options: nil)
                        content.attachments = [attachment]
                    } catch {
                        print("attachment not found.")
                    }
                }
            }
                        
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

            UNUserNotificationCenter.current().add(request){(error) in
                if (error != nil){
                    print(error ?? "")
                }
            }
    }

    //MARK: TODO HERE
    
    /*
     Về notification khi bắt GEO và beacon.
     
     1. Nếu là GEO hoặc beacon mới ( bắt lần đầu tiên ) thì get mail và nếu là hòm thư có mail hiển thị title của mail. Nếu không có mail thì hiển thị message của XML.
     2. Nếu là GEO hoặc beacon cũ ( trước đây đã từng bắt rồi ) thì khi vào GEO (beacon) đấy, nếu có mail mới thì  hiển thị title của mail mới đấy, còn ko có mail mới thì không hiển thị gì.
     
     Lý do: Để tránh trường hợp cứ mỗi lần detect thì lại hiển thị cùng nội dung mail.
     */
    static func sendNotifyByHasNewMail(_ mailInfo: MailInfo, beaconInfo: BeaconInfo?, geoFence: GeoFenceBean?) {
        print("sendNotifyByHasNewMail")
        print("mailInfo.subject:%@",mailInfo.subject)
        //Set title & message
        var title = ""
        var message = ""
        
        if let beacon = beaconInfo{
            title = beacon.notification?.title ?? ""
            message = beacon.notification?.message ?? ""
        } else {
            if let geofence = geoFence{
                title = geofence.notification?.title ?? (geofence.notify_title ?? "")
                message = geofence.notification?.message ?? (geofence.notify_message ?? "")
            }
        }
        
        if mailInfo.subject.isEmpty == false {
            message = mailInfo.subject
        }
        
        //Set UserInfo
        var userInfo = [String: String]()
        
        var imageIconURL = ""
        var imageBannerURL = ""
        if let beacon = beaconInfo {
            userInfo["uuid"] = beacon.uuid
            userInfo["major"] = beacon.major
            userInfo["minor"] = beacon.minor
            userInfo["proximity"] = beacon.proximity.description()
            userInfo["profile_name"] = beacon.mail?.name ?? ""
            imageIconURL = beacon.profile?.iconURl ?? ""
            imageBannerURL = beacon.profile?.bannerUrl ?? ""
            
            
            
        } else if let geo = geoFence {
            userInfo["geoXMLID"] = geo.xmlID;
            imageIconURL = geo.profile?.iconURl ?? ""
            imageBannerURL = geo.profile?.bannerUrl ?? ""
            userInfo["profile_name"] = title
        }
        userInfo["image_icon"] = imageIconURL
        userInfo["image_banner"] = imageBannerURL
        userInfo["message"] = message
        
        if #available(iOS 10.0, *) {
            Common.showNotificationIOS10(title: title, subtitle: "", body: message, iconUrl: "", userInfo: userInfo)
            
        } else {
            
            let notification = UILocalNotification()
            //let message = String.init(format: "%@: %@", title,message)
            let message = String.init(format: "%@\n%@", title,message)
            notification.alertBody = message
            notification.fireDate = Date()
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    static func sendNotificationWithMessageWithBeacon(_ message:String, beaconInfo: BeaconInfo) {
        print("sendNotificationWithMessageWithBeacon")
        
        let title = beaconInfo.notification?.title ?? ""
        
        if #available(iOS 10.0, *) {
            Common.showNotificationIOS10(title: title, subtitle: "", body: message, iconUrl: "", userInfo: nil)
            
        } else {
            let notification = UILocalNotification()
            //let message = String.init(format: "%@: %@", title,message)
            let message = String.init(format: "%@\n%@", title,message)
            notification.alertBody = message
            notification.fireDate = Date()
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    static func sendNotificationWithMessage(_ message: String)
    {
        print("sendNotificationWithMessage:\(message)")
        
        if #available(iOS 10.0, *) {
            Common.showNotificationIOS10(title: "", subtitle: "", body: message, iconUrl: "", userInfo: nil)
            
        } else {
            let notification = UILocalNotification()
            notification.alertBody = message
            StaticData.shared.string = "test"
            notification.fireDate = Date()
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    static func sendNotificationWith(_ message:String, title: String)
    {
        if #available(iOS 10.0, *) {
            Common.showNotificationIOS10(title: title, subtitle: "", body: message, iconUrl: "", userInfo: nil)
       
        } else {
            let notification = UILocalNotification()
            //let message = String.init(format: "%@: %@", title,message)
            let message = String.init(format: "%@\n%@", title,message)
            notification.alertBody = message
            notification.fireDate = Date()
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }

    static func createMailAccount(_ beaconInfo:BeaconInfo)->String {
        if beaconInfo.isEqualBeacon(Common.getDefaultBeacon()) {
            return (beaconInfo.mail?.id)!
        }
        if beaconInfo.isEmpty() {
            return ""
        }
        let uuid = beaconInfo.uuid
        let major = Common.converStringTo4Digit(Common.convertIntToHex(Int(beaconInfo.major)!))
        let minor = Common.converStringTo4Digit(Common.convertIntToHex(Int(beaconInfo.minor)!))
        let majorminor =  String(format: "%@%@", major, minor)
        
        var inputString  = ""
        if uuid.characters.count >= 36
        {
            //create input string
            inputString = "\(uuid[11..<13])\(uuid[16..<18])\(uuid[21..<23])\(uuid[34..<36])\(majorminor)"
        }
        
        
        // encode
        let encodeString = TripleDES.encode(inputString.uppercased(), withKey: KEY_TRIPLE_DES, ivKey: KEY_TRIPLE_DES_IV)
        
        // return
        return encodeString!
    }
    
    // create mail account from Location
    static func createMailAccountWith(_ geofence: GeoFenceBean) -> String {
        let prefix = geofence.mail?.idPrefix ?? ""
        let suffix = geofence.mail?.idSuffix ?? ""
        let inputString = geofence.xmlID.replacingOccurrences(of: "/", with: "")
        let encodeString = TripleDES.encode(inputString, withKey: KEY_TRIPLE_DES, ivKey: KEY_TRIPLE_DES_IV)
        let account =  prefix + encodeString! + suffix
        print("createMailAccountWith geo=\(geofence)  & account=\(account)")
        return account//encodeString!
    }
    
    static func converStringTo4Digit(_ inputString:String) ->String {
        var convertString = inputString
        if inputString.characters.count < 4 {
            let lossNumberChar = 4 - inputString.characters.count
            for _ in 0..<lossNumberChar {
                convertString = "0" + convertString
            }
        }
        return convertString
    }
    
    
}

