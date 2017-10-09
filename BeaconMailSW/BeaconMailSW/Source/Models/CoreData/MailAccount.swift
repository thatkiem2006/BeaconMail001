//
//  MailAccount.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation
import CoreData

class MailAccount: NSManagedObject {
    //MARK: GET
    
    static func getMailAccoutBy(_ beacon: BeaconInfo? = nil, geo: GeoFenceBean? = nil, key: String = UDGet(kLanguage)!, isDefault: Bool = false) -> MailAccount? {
        let context = DataManager.shared.managedObjectContext
        let accountFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_MAILACCOUNT)
        var _: NSPredicate!
        var identifier = ""
        if let beacon = beacon, beacon.isEmpty() == false {
            identifier = beacon.uuid + beacon.major + beacon.minor
        }else if let geo = geo{
            identifier = geo.identifier
        }
        let regionNamePredicate = NSPredicate(format: "region_name = %@", identifier)
        let condion: NSPredicate!
        if isDefault {
            let defaultPredicate = NSPredicate(format: "isDefault = %@", true as CVarArg)
            condion = NSCompoundPredicate(andPredicateWithSubpredicates: [regionNamePredicate, defaultPredicate])
        }else{
            let languagePredicate = NSPredicate(format: "lang = %@", key)
            condion = NSCompoundPredicate(andPredicateWithSubpredicates: [regionNamePredicate, languagePredicate])
        }
        accountFetch.predicate = condion
        do {
            if  let results = try context.fetch(accountFetch) as? [MailAccount] {
                return results.first
            }
            
        } catch  {
            print("Could not fetch ")
        }
        return nil
    }
    
    static func getLatestMailAccount(_ language: String = UDGet(kLanguage)!) -> MailAccount? {
        let context = DataManager.shared.managedObjectContext
        let accountFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_MAILACCOUNT)
        let langPredicate = NSPredicate(format: "lang = %@", language)
        let hasNewPredicate = NSPredicate(format: "hasNewMail = %@", true as CVarArg)
        accountFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [langPredicate, hasNewPredicate])
        let sortDescriptor = NSSortDescriptor(key: "update_time", ascending: false)
        accountFetch.sortDescriptors = [sortDescriptor]
        do {
            if  let results = try context.fetch(accountFetch) as? [MailAccount] {
                return results.first
            }
            
        } catch  {
            print("Could not fetch ")
        }
        return nil
    }
    
    static func getAll(_ language: String = UDGet(kLanguage)!) -> [MailAccount]? {
        let context = DataManager.shared.managedObjectContext
        let accountFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_MAILACCOUNT)
        let langPredicate = NSPredicate(format: "lang = %@", language)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [langPredicate])
        accountFetch.predicate = compoundPredicate
        do {
            if  let results = try context.fetch(accountFetch) as? [MailAccount] {
                return results
            }
            
        } catch  {
            print("Could not fetch ")
        }
        return nil
    }
    
    static func getLatestUpdate(_ hasNewMail: Bool = false, key: String = UDGet(kLanguage)!) -> MailAccount? {
        let context = DataManager.shared.managedObjectContext
        let accountFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_MAILACCOUNT)
        let langPredicate = NSPredicate(format: "lang = %@", key)
        let defLangPredicate = NSPredicate(format: "lang != %@", key)
        let defaultPredicate = NSPredicate(format: "isDefault = %@", true as CVarArg)
        let defaultCodition = NSCompoundPredicate(andPredicateWithSubpredicates: [defaultPredicate, defLangPredicate])
        let languageAccountC = NSCompoundPredicate(orPredicateWithSubpredicates: [defaultCodition, langPredicate])
        var condition = Array<NSPredicate>()
        condition.append(languageAccountC)
        if hasNewMail == true {
            let hasNewMailPredicate = NSPredicate(format: "hasNewMail = %@", true as CVarArg)
            condition.append(hasNewMailPredicate)
        }
        accountFetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: condition)
        let sortDescriptor = NSSortDescriptor(key: "update_time", ascending: false)
        accountFetch.sortDescriptors = [sortDescriptor]
        do {
            if  let results = try context.fetch(accountFetch) as? [MailAccount] {
                return results.first
            }
            
        } catch  {
            print("Could not fetch ")
        }
        return nil
    }
    
    func getNumberMailUnRead() -> Int{
        if let maibox = self.mailbox {
            return maibox.allObjects.filter({ (mail) -> Bool in
                let isRead = (mail as! MailBox).is_read?.boolValue == false ?? false
                let isHidden = (mail as! MailBox).is_hidden?.boolValue ?? false
                return (isRead && !isHidden)
            }).count
        }
        return 0
    }
    //MARK: UPDATE
    func update(hasNewMail hasNew: Bool) {
        let context = DataManager.shared.managedObjectContext
        self.hasNewMail = hasNew as NSNumber
        self.update_time = Date()
        do {
            try context.save()
        }catch let error as NSError {
            print("Error: \(error) " + "description \(error.localizedDescription)")
        }
    }
    
    func update(topMailId id: Int?) {
        guard let id = id else {
            return
        }
        let context = DataManager.shared.managedObjectContext
        self.topMailId = id as NSNumber
        self.update_time = Date()
        do {
            try context.save()
        }catch let error as NSError {
            print("Error: \(error) " + "description \(error.localizedDescription)")
        }
        
    }
    
    func update(mailBox box: [MailInfo]) {
        guard box.count > 0 else {
            return
        }
        let context = DataManager.shared.managedObjectContext
        let mailBoxDB = self.mailbox?.mutableCopy() as! NSMutableSet
        self.update_time = Date()
        self.topMailId = Int(box.first?.mail_id ?? "") as! NSNumber
        for item in box {
            //Check item exist before insert
            if MailBox.checkMailExist(item) == false {
                let entity = NSEntityDescription.entity(forEntityName: ENTITY_MAIL, in: context)
                let mail = MailBox(entity: entity!, insertInto: context)
                mail.map(item)
                mailBoxDB.add(mail)
            }
        }
        self.mailbox = mailBoxDB.copy() as! NSSet
        do {
            try context.save()
        }catch let error as NSError {
            print("Error: \(error) " + "description \(error.localizedDescription)")
        }
        
    }
    
    func map(_ mail: MailXML) {
        self.isDefault = mail.isDefault as NSNumber
        self.lang = mail.lang
        self.name = mail.name
        self.server = mail.server
        self.encryption = mail.encryption
        self.port = mail.port
        self.idPrefix = mail.idPrefix
        self.idSuffix = mail.idSuffix
        self.passwd = mail.passwd
    }
    
    func toMailAccount() -> MailXML {
        let mail = MailXML()
        mail.lang = self.lang ?? kLanguageCodeDefault
        mail.name = self.name ?? ""
        mail.id = self.name ?? ""
        mail.server = self.server ?? ""
        mail.encryption = self.encryption
        mail.port = self.port
        mail.idPrefix = self.idPrefix
        mail.idSuffix = self.idSuffix
        mail.passwd = self.passwd
        return mail
    }
    
    func updateTime() {
        let context = DataManager.shared.managedObjectContext
        self.update_time = Date()
        do {
            try context.save()
        }catch let error as NSError {
            print("Error: \(error) " + "description \(error.localizedDescription)")
        }
    }
}
