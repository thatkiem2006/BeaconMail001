//
//  PostalMachine.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation
import Postal
class PostalMachine: MailManager {
    var configuration: Configuration!
    lazy var postal: Postal = Postal(configuration: self.configuration)
    
    init(beaconInfo beacon: BeaconInfo) {
        let username = (beacon.mail?.idPrefix ?? "") + Common.createMailAccount(beacon) + (beacon.mail?.idSuffix ?? "")
        let hostName = beacon.mail?.server ?? ""
        
        print("PostalMachine > init beaconInfo > mail account:\(username)@\(hostName)")
        
        let port = UInt16(beacon.mail?.port ?? "") ?? 143
        let password = beacon.mail?.passwd ?? ""
        let connectType:ConnectionType = (beacon.mail?.encryption == "tsl" || beacon.mail?.encryption == "ssl") ? .tls : .clear
        self.configuration = Configuration(hostname: hostName, port: port, login: username, password: .plain(password), connectionType: connectType, checkCertificateEnabled: false)
        
    }
    
    init(geofence: GeoFenceBean) {
        let username = Common.createMailAccountWith(geofence)
        let hostName = geofence.mail?.server ?? ""
        
        print("PostalMachine > init geofence > mail account:\(username)@\(hostName)")
        
        let port = UInt16(geofence.mail?.port ?? "") ?? 143
        let password = geofence.mail?.passwd ?? ""
        let connectType:ConnectionType = (geofence.mail?.encryption == "tsl" || geofence.mail?.encryption == "ssl") ? .tls : .clear
        self.configuration = Configuration(hostname: hostName, port: port, login: username, password: .plain(password), connectionType: connectType, checkCertificateEnabled: false)
        
    }
    
    static func loadMessage(_ id: Int, beaconInfo: BeaconInfo?, geofence geo: GeoFenceBean?, complete: @escaping (_ result: [MailInfo]?, _ success: Bool) -> Void) {
        var pMachine: PostalMachine!
        if let beaconInfo = beaconInfo {
            if let isEmpty = beaconInfo.mail?.isEmpty(), isEmpty == true{
                complete(nil, false)
                return
            }
            
            print("loadMessage ID")
            pMachine = PostalMachine(beaconInfo: beaconInfo)
        }else if let geo = geo {
            pMachine = PostalMachine(geofence: geo)
        }
        var messages: [FetchResult] = []
        let uids = IndexSet(integer: id)
        let flags: FetchFlag = [.fullHeaders, .body, .flags, .internalDate, .structure]
        pMachine.postal.connect(timeout: Postal.defaultTimeout) { (result) in
            switch result {
            case .success():
                pMachine.postal.fetchMessages("INBOX", uids: uids, flags: flags, onMessage: { (message) in
                    messages.insert(message, at: 0)
                }, onComplete: { (error) in
                    if let error = error {
                        print(error)
                        complete(nil, false)
                    }else if let msg = messages.first {
                        let mailInfo = MailInfo()
                        msg.body?.allParts.forEach({ (singlePart) in
                            var message: NSString?
                            let encode = NSString.stringEncoding(for: (singlePart.data?.decodedData)!, encodingOptions: nil, convertedString: &message, usedLossyConversion: nil)
                            message = message?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString?
                            if singlePart.mimeType == MimeType.textPlain {
                                mailInfo.messageDescription = message as? String ?? ""
                            }else if singlePart.mimeType == MimeType.textHtml {
                                mailInfo.message = message as? String ?? ""
                            }
                        })
                        complete([mailInfo], true)
                    }
                })
            case .failure(let e):
                complete(nil, false)
                print(e)
            }
        }
    }
    
    
    static func loadAllMailForSynServer(_ beaconInfo: BeaconInfo?, geofence: GeoFenceBean?, number: Int, complete: @escaping (_ result: [MailInfo]?, _ success: Bool) -> Void) {
        
        var listMailInfo = [MailInfo]()
        var pMachine: PostalMachine!
        
        if  beaconInfo != nil && beaconInfo?.uuid.isEmpty == false {
            if beaconInfo?.mail?.isEmpty() == nil || beaconInfo?.mail?.isEmpty() == true{
                complete(nil, false)
                return
            }
            print("loadAllMailForSynServer")
            pMachine = PostalMachine(beaconInfo: beaconInfo!)
        }else if let geofence = geofence {
            pMachine = PostalMachine(geofence: geofence)
        }
        var messages: [FetchResult] = []
        
        let flags: FetchFlag = [.fullHeaders, .body, .flags, .internalDate, .structure]
        
        pMachine.postal.connect(timeout: Postal.defaultTimeout) { (result) in
            switch result {
            case .success():
                pMachine.postal.fetchLast("INBOX", last: UInt(number), flags: flags, onMessage: { (message) in
                    messages.insert(message, at: 0)
                }, onComplete: { (error) in
                    if let error = error {
                        print(error)
                        complete(nil, false)
                        
                    }else {
                        
                        for index in 0..<messages.count {
                            let imapMessage = messages[index]
                            let mailInfo = MailInfo()
                            mailInfo.mail_id = "\(imapMessage.uid)"
                            listMailInfo.append(mailInfo)
                        }
                        
                        complete(listMailInfo, true)
                    }
                })
                break
            case .failure(let e):
                complete(nil, false)
                print(e)
            }
        }
    }
    
    static func loadLastMail(_ beaconInfo: BeaconInfo?, geofence: GeoFenceBean?, number: Int, complete: @escaping (_ result: [MailInfo]?, _ success: Bool) -> Void) {
        var pMachine: PostalMachine!
        if  beaconInfo != nil && beaconInfo?.uuid.isEmpty == false {
            if beaconInfo?.mail?.isEmpty() == nil || beaconInfo?.mail?.isEmpty() == true{
                complete(nil, false)
                return
            }
            print("loadLastMail")
            pMachine = PostalMachine(beaconInfo: beaconInfo!)
        }else if let geofence = geofence {
            pMachine = PostalMachine(geofence: geofence)
        }
        var messages: [FetchResult] = []
        let flags: FetchFlag = [.fullHeaders, .body, .flags, .internalDate, .structure]
        pMachine.postal.connect(timeout: Postal.defaultTimeout) { (result) in
            switch result {
            case .success():
                pMachine.postal.fetchLast("INBOX", last: UInt(number), flags: flags, onMessage: { (message) in
                    messages.insert(message, at: 0)
                }, onComplete: { (error) in
                    if let error = error {
                        print(error)
                        complete(nil, false)
                    }else {
                        messages = messages.sorted(by: { (x, y) -> Bool in
                            x.uid > y.uid
                        })
                        pMachine.handleInboxData(messages, beaconInfo: beaconInfo, geofence: geofence, number: number, complete: complete)
                    }
                })
                break
            case .failure(let e):
                complete(nil, false)
                print(e)
            }
        }
    }
    
     func loadLastMail2(_ beaconInfo: BeaconInfo?, geofence: GeoFenceBean?, number: Int, complete: @escaping (_ result: [MailInfo]?, _ success: Bool) -> Void) {
        var pMachine: PostalMachine!
        if  beaconInfo != nil && beaconInfo?.uuid.isEmpty == false {
            if beaconInfo?.mail?.isEmpty() == nil || beaconInfo?.mail?.isEmpty() == true{
                complete(nil, false)
                return
            }
            print("loadLastMail2")
            pMachine = PostalMachine(beaconInfo: beaconInfo!)
        }else if let geofence = geofence {
            pMachine = PostalMachine(geofence: geofence)
        }
        var messages: [FetchResult] = []
        let flags: FetchFlag = [.fullHeaders, .body, .flags, .internalDate, .structure]
        pMachine.postal.connect(timeout: Postal.defaultTimeout) { (result) in
            switch result {
            case .success():
                pMachine.postal.fetchLast("INBOX", last: UInt(number), flags: flags, onMessage: { (message) in
                    messages.insert(message, at: 0)
                }, onComplete: { (error) in
                    if let error = error {
                        print(error)
                        complete(nil, false)
                    }else {
                        messages = messages.sorted(by: { (x, y) -> Bool in
                            x.uid > y.uid
                        })
                        pMachine.handleInboxData(messages, beaconInfo: beaconInfo, geofence: geofence, number: number, complete: complete)
                    }
                })
                break
            case .failure(let e):
                complete(nil, false)
                print(e)
            }
        }
    }
    
    static func loadNewMailWith(_ region: AnyObject, complete: @escaping (_ result: [MailInfo]?, _ success: Bool) -> Void) {
        var beaconInfo: BeaconInfo?
        var geofence: GeoFenceBean?
        var topMailId:Int = 0
        var pMachine: PostalMachine!
        if let beacon = region as? BeaconInfo  {
            beaconInfo = beacon
            if let isEmpty = beacon.mail?.isEmpty(), isEmpty == true{
                complete(nil, false)
                return
            }
            print("loadNewMailWith")
            pMachine = PostalMachine(beaconInfo: beacon)
        }else if let geo = region as? Geofence {
            geofence = geo.toGeoInfo()
            pMachine = PostalMachine(geofence: geofence!)
        }
        loadLastMail(beaconInfo, geofence: geofence, number: NUMBER_MAIL, complete: complete)
    }
    
     func loadNewMailWith2(_ region: AnyObject, complete: @escaping (_ result: [MailInfo]?, _ success: Bool) -> Void) {
        var beaconInfo: BeaconInfo?
        var geofence: GeoFenceBean?
        var topMailId:Int = 0
        var pMachine: PostalMachine!
        if let beacon = region as? BeaconInfo  {
            beaconInfo = beacon
            if let isEmpty = beacon.mail?.isEmpty(), isEmpty == true{
                complete(nil, false)
                return
            }
            print("loadNewMailWith2")
            pMachine = PostalMachine(beaconInfo: beacon)
        }else if let geo = region as? Geofence {
            geofence = geo.toGeoInfo()
            pMachine = PostalMachine(geofence: geofence!)
        }
        loadLastMail2(beaconInfo, geofence: geofence, number: NUMBER_MAIL, complete: complete)
    }
    
    func handleInboxData(_ bundle: [FetchResult], beaconInfo: BeaconInfo?, geofence: GeoFenceBean?, number: Int, complete:(_ result: [MailInfo]?, _ success: Bool) -> Void) {
        var result = [MailInfo]()
        var topMailId = 0
        var account = MailAccount.getMailAccoutBy(beaconInfo, geo: geofence)
        if account == nil {
            account = MailAccount.getMailAccoutBy(beaconInfo, geo: geofence, isDefault: true)
        }
        if let account = account {
            topMailId = account.topMailId?.intValue ?? 0
        }
        
        let fetchedMessagesCnt = bundle.count
        var startIndex = fetchedMessagesCnt - number
        startIndex = startIndex > 0 ? startIndex: 0
        if fetchedMessagesCnt <= startIndex{
            complete([],false)
            return
        }
        for index in startIndex..<fetchedMessagesCnt {
            let imapMessage = bundle[index]
            let mailInfo = MailInfo()
            mailInfo.mail_id = "\(imapMessage.uid)"
            if let header = imapMessage.header{
                mailInfo.subject = header.subject
            }
            mailInfo.create_date = imapMessage.header?.receivedDate
            mailInfo.update_date = imapMessage.header?.receivedDate
            
            if Int(mailInfo.mail_id)! > topMailId {
               
                result.append(mailInfo)
               
                imapMessage.body?.allParts.forEach({ (singlePart) in
                    var message: NSString?
                    let encode = NSString.stringEncoding(for: (singlePart.data?.decodedData)!, encodingOptions: nil, convertedString: &message, usedLossyConversion: nil)
                    message = message?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as! NSString
                    if singlePart.mimeType == MimeType.textPlain {
                        mailInfo.messageDescription = message as? String ?? ""
                    }else if singlePart.mimeType == MimeType.textHtml {
                        mailInfo.message = message as? String ?? ""
                    }
                })
                
            }
        }
        
        //Insert new mail to database local
        if result.count > 0 {
            if let account = account {
                if  let topMail = result.first, let mailId = topMail.mail_id as? String {
                    account.update(hasNewMail: true)
                    account.update(topMailId: Int(mailId))
                    account.update(mailBox: result)
                }
            }
        }
        
        complete(result, true)
    }
    
    static func checkMailExisting(_ beaconInfo: BeaconInfo?, geofence: GeoFenceBean?, mailInfos: [MailInfo], completion: @escaping () -> Void) {
        var pMachine: PostalMachine!
        if let beaconInfo = beaconInfo {
            if beaconInfo.mail?.isEmpty() == nil || beaconInfo.mail?.isEmpty() == true {
                completion()
                return
            }
            print("checkMailExisting")
            pMachine = PostalMachine(beaconInfo: beaconInfo)
        } else if let geofence = geofence {
            pMachine = PostalMachine(geofence: geofence)
        }
        
        pMachine.postal.connect(timeout: Postal.defaultTimeout) { (result) in
            switch result {
            case .success():
                var countSearch = 0
                mailInfos.forEach({ mailInfo in
                    // search mail with subject and uids
                    pMachine.searchMail(mailInfo, completion: {
                        countSearch += 1
                        if countSearch == mailInfos.count {
                            completion()
                        }
                    })
                })
                break
            case .failure(let e):
                print(e)
                completion()
                break
            }
        }
    }
    
    func searchMail(_ mailInfo: MailInfo, completion: @escaping () -> ()) {
        let maiId = mailInfo.mail_id
        if let id = Int(maiId) {
            let filter = .uids(uids: IndexSet(integer: id)) && .subject(value: mailInfo.subject)
            self.postal.search("INBOX", filter: filter) { result in
                completion()
                switch result {
                case .success(let i):
                    print("success: \(i)")
                    guard i.count > 0 else {
                        // remove mailInfo trong DB
                        if let mailBox = MailBox.getMailBy(mailInfor: mailInfo) {
                            let context = DataManager.shared.managedObjectContext
                            context.delete(mailBox)
                            DataManager.shared.saveContext(context)
                        }
                        return
                    }
                case .failure(let e):
                    print("error: \(e)")
                }
            }
        }
    }
    
    func loadMailDetail(_ mailInfo: MailInfo, completion: @escaping () -> ()) {
        let maiId = mailInfo.mail_id
        if let id = Int(maiId) {
            self.postal.fetchMessages("inbox", uids: IndexSet(integer: id), flags: FetchFlag.body, extraHeaders: ["all"], onMessage: { (fetchResult) in
                if let imapMessage = fetchResult as? FetchResult {
                    imapMessage.body?.allParts.forEach({ (singlePart) in
                        var message: NSString?
                        let encode = NSString.stringEncoding(for: (singlePart.data?.decodedData)!, encodingOptions: nil, convertedString: &message, usedLossyConversion: nil)
                        message = message?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as! NSString
                        if singlePart.mimeType == MimeType.textPlain {
                            mailInfo.messageDescription = message as? String ?? ""
                        }else if singlePart.mimeType == MimeType.textHtml {
                            mailInfo.message = message as? String ?? ""
                        }
                    })
                }
                
            }, onComplete: { (error) in
                print(error)
            })
            
        }
    }
}
