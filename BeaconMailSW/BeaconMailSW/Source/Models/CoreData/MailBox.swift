//
//  MailBox.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation
import CoreData
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class MailBox: NSManagedObject {
    //MARK: GET
    static func getMailBy(_ beacon:BeaconInfo? = nil, geofence geo: GeoFenceBean? = nil) -> [MailInfo] {
        var account = MailAccount.getMailAccoutBy(beacon, geo: geo)
        if account == nil {
            account = MailAccount.getMailAccoutBy(beacon, geo: geo, isDefault: true)
        }
        if let account = account {
            
            if let mailbox = account.mailbox?.allObjects {
                
                var result = [MailInfo]()
                for mailDB in (mailbox  as? [MailBox])! {
                    if mailDB.is_hidden == false || mailDB.is_hidden == nil {
                        
                        if let mail = mailDB as? MailBox {
                            result.append(mail.toMailInfo())
                        }
                    }
                }
                result = result.sorted(by: { (x, y) -> Bool in
                    x.create_date! > y.create_date!
                })
                return result
            }
        }
        return []
    }
    
    static func getAll(isFavorite favorite: Bool = false) -> [MailInfo] {
        let context = DataManager.shared.managedObjectContext
        let mailFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_MAIL)
        let isReadPredicate = NSPredicate(format: "is_favorite = %@", favorite as CVarArg)
        mailFetch.predicate = isReadPredicate
        do {
            if  let results = try context.fetch(mailFetch) as? [MailBox]{
                return results.map({ (db) -> MailInfo in
                    return db.toMailInfo()
                })
            }
            
        } catch  {
            print("Could not fetch ")
        }
        return []
    }
    
    static func checkMailExist(_ mail: MailInfo, isFavorite:Bool) ->Bool {
        let context = DataManager.shared.managedObjectContext
        let mailFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_MAIL)
        let createAt = NSPredicate(format: "create_date = %@", mail.create_date! as CVarArg)
        let mailId = NSPredicate(format: "mail_id = %@", mail.mail_id)
        var conditonPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [createAt, mailId])
        if isFavorite == true {
            let favorite = NSPredicate(format: "is_favorite = %@", true as CVarArg)
            conditonPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [createAt, mailId, favorite])
        }
        
        mailFetch.predicate = conditonPredicate
        mailFetch.resultType = .countResultType
        do {
            var error: NSError? = nil
            let results = try context.count(for: mailFetch)
            return results > 0
        } catch  {
            print("Could not fetch ")
        }
        return false
    }
    
    static func checkMailExist(_ mail: MailInfo) ->Bool {
        let context = DataManager.shared.managedObjectContext
        let mailFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_MAIL)        
        let predicate = NSPredicate(format: "mail_id = %@ and subject = %@", mail.mail_id, mail.subject)
        
        mailFetch.predicate = predicate
        mailFetch.resultType = .countResultType
        do {
            var error: NSError? = nil
            let results = try context.count(for: mailFetch)
            return results > 0
        } catch  {
            print("Could not fetch ")
            return false
        }
        
        return false
    }
    
    
    static func countNumberMail(isRead: Bool) -> Int {
        let context = DataManager.shared.managedObjectContext
        let mailFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_MAIL)
        let isReadPredicate = NSPredicate(format: "is_read = %@", isRead as CVarArg)
        let isHiddenPredicate = NSPredicate(format: "is_hidden = %@", false as CVarArg)
        let compoundPredicate = isReadPredicate
        mailFetch.predicate = compoundPredicate
        mailFetch.resultType = .countResultType
        do {
            var error: NSError? = nil
            let results = try context.count(for: mailFetch)
            return results
            
        } catch  {
            print("Could not fetch ")
        }
        return 0
    }
    
    static func getMailBy(mailInfor infor: MailInfo) -> MailBox? {
        let context = DataManager.shared.managedObjectContext
        let mailFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_MAIL)
        let mailIdPredicate = NSPredicate(format: "mail_id = %@", infor.mail_id)
        var condition = NSPredicate()
        if let beacon = infor.beacon, beacon.isEmpty() == false {
            let uuidPredicate = NSPredicate(format: "mailAccount.beacon.uuid = %@", beacon.uuid)
            let majorPredicate = NSPredicate(format: "mailAccount.beacon.major = %@", beacon.major)
            let minorPredicate = NSPredicate(format: "mailAccount.beacon.minor = %@", beacon.minor)
            let conditionArr = [uuidPredicate, mailIdPredicate, majorPredicate, minorPredicate]
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: conditionArr)
            condition = compoundPredicate
        }else if let geo = infor.geofence {
            let identifierPredicate = NSPredicate(format: "mailAccount.geofence.geofence_id = %@", geo.identifier)
            let conditionArr = [identifierPredicate, mailIdPredicate]
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: conditionArr)
            condition = compoundPredicate
        }else {
            return nil
        }
        
        mailFetch.predicate = condition
        do {
            if  let results = try context.fetch(mailFetch) as? [MailBox] {
                return results.first
            }
            
        } catch  {
            print("Could not fetch ")
        }
        return nil
    }
    //MARK: UPDATE
    static func delete(array infoList: [MailInfo], applyForFavorite applyFavorite: Bool = false) {
        for mailInfo in infoList {
            if let mailBox = getMailBy(mailInfor: mailInfo) {
                let context = DataManager.shared.managedObjectContext
                if applyFavorite == true {
                    if mailBox.is_hidden == true {
                        context.delete(mailBox)
                    }else {
                        mailBox.is_favorite = false
                    }
                }else if mailBox.is_favorite == true {
                    mailBox.is_hidden = true
                }else {
                    context.delete(mailBox)
                }
                DataManager.shared.saveContext(context)
            }
        }
        DispatchQueue.main.async(execute: {
            print("MailBox > delete> kReloadLeftMenuNotification ")
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: kReloadLeftMenuNotification), object: nil, userInfo: nil)
        })
    }
    
    static func updateFavorite(_ mail: [MailInfo], isFavorite: Bool) {
        for mailInfo in mail {
            if let mailBox = getMailBy(mailInfor: mailInfo) {
                mailBox.is_favorite = isFavorite as NSNumber
                let context = DataManager.shared.managedObjectContext
                DataManager.shared.saveContext(context)
            }
        }
    }
    
    static func updateMailContent(_ mailInfo: MailInfo, fromFavorite:Bool) {
        if let mailBox = getMailBy(mailInfor: mailInfo) {
            mailBox.message = mailInfo.message
            let context = DataManager.shared.managedObjectContext
            DataManager.shared.saveContext(context)
        }
    }
    
    static func updateIsRead(_ mailInfo:MailInfo, isRead:Bool, fromFavorite:Bool) {
        if let mailBox = getMailBy(mailInfor: mailInfo) {
            mailBox.is_read = isRead as NSNumber
            let context = DataManager.shared.managedObjectContext
            DataManager.shared.saveContext(context)
            
            print("MailBox > updateIsRead > kReloadLeftMenuNotification")
            
            NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: kReloadLeftMenuNotification), object: nil, userInfo: nil)
        }
    }
    
    
    //MARK: OTHER
    static func optimizeMemory(_ beacon: BeaconInfo? = nil, geo: GeoFenceBean? = nil, applyForFavorite apply: Bool = false) {
        let account = MailAccount.getMailAccoutBy(beacon, geo: geo);
        if account == nil {
            let account = MailAccount.getMailAccoutBy(beacon, geo: geo, isDefault: true);
        }
        
        if let account = account, let mailbox = account.mailbox?.allObjects as? [MailBox]{
            if mailbox.count > NUMBER_MAIL {
                let sortBox = mailbox.sorted(by: { (x, y) -> Bool in
                    x.create_date! > y.create_date!
                })
                for i in NUMBER_MAIL..<mailbox.count {
                    let mail = sortBox[i]
                    let context = DataManager.shared.managedObjectContext
                    context.delete(mail)
                    DataManager.shared.saveContext(context)
                }
            }
        }
    }
    
    func map(_ mailInfo: MailInfo) {
        self.mail_id = mailInfo.mail_id
        self.subject = mailInfo.subject
        self.message = mailInfo.message
        self.messageDescription = mailInfo.messageDescription
        self.is_favorite = mailInfo.is_favorite as NSNumber
        self.is_read = mailInfo.is_read as NSNumber
        self.create_date = mailInfo.create_date
        self.update_date = mailInfo.update_date
    }
    
    func toMailInfo() -> MailInfo {
        let mailInfo = MailInfo()
        mailInfo.mail_id = self.mail_id ?? ""
        mailInfo.subject = self.subject ?? ""
        mailInfo.message = self.message ?? ""
        mailInfo.messageDescription = self.messageDescription ?? ""
        mailInfo.is_favorite = self.is_favorite?.boolValue ?? false
        mailInfo.is_read = self.is_read?.boolValue ?? false
        mailInfo.create_date = self.create_date
        mailInfo.update_date = self.update_date
        if let beaconInfo = self.mailAccount?.beacon?.toBeaconInfo() {
            mailInfo.beacon = beaconInfo
        }
        
        if let geoInfo = self.mailAccount?.geofence?.toGeoInfo() {
             mailInfo.geofence = geoInfo
        }
        
        return mailInfo
    }
    
}
