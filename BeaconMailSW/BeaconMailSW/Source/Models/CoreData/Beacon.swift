//
//  Beacon.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation
import CoreData


class Beacon: NSManagedObject {
    class func insert(_ beacon: BeaconInfo, withContext context: NSManagedObjectContext = DataManager.shared.managedObjectContext) {
        var beaconDB: Beacon!
        beaconDB = Beacon.fetch(beacon.uuid, major: beacon.major, minor: beacon.minor, context: context).first
        if beaconDB == nil {
            let beaconEntity = NSEntityDescription.entity(forEntityName: "Beacon", in: context)
            beaconDB = Beacon(entity: beaconEntity!, insertInto: context)
        }
        beaconDB.beacon_id = beacon.beacon_id
        beaconDB.uuid = beacon.uuid
        beaconDB.major = beacon.major
        beaconDB.minor = beacon.minor
        beaconDB.rssi = beacon.rssi
        beaconDB.proximity = "\(beacon.proximity.intValue())"
        beaconDB.protected = beacon.protected as NSNumber
        beaconDB.create_date = Date()
        beaconDB.update_date = Date()
        
        let xmlDataEntity = NSEntityDescription.entity(forEntityName: ENTITY_XML, in: context)
        let xmlData = XMLFileData(entity: xmlDataEntity!, insertInto: context)
        let xmlInfor = XMLInfo(type: ENTITY_BEACON)
        xmlInfor.dataRaw = beacon.xmlData
        xmlData.map(xmlInfor)
        beaconDB.xml_file = xmlData
        
        if let mailAccountList = beacon.mailGroup, mailAccountList.count > 0{
            let accountCurrently = beaconDB.mailAccount?.mutableCopy() as! NSMutableSet
            for account in mailAccountList {
                var mailAccount:MailAccount!
                mailAccount = MailAccount.getMailAccoutBy(beacon, key: account.0)
                if mailAccount == nil {
                    let mailAccountEntity = NSEntityDescription.entity(forEntityName: ENTITY_MAILACCOUNT, in: context)
                    mailAccount = MailAccount(entity: mailAccountEntity!, insertInto: context)
                    mailAccount.map(account.1)
                    mailAccount.region_name = beacon.uuid + beacon.major + beacon.minor
                    
                    mailAccount.update_time = Date()
                    
                    accountCurrently.add(mailAccount)
                }
            }
            beaconDB.mailAccount = accountCurrently.copy() as! NSSet
        }
        
        do {
            try context.save()
        }catch let error as NSError {
            print("Error: \(error) " + "description \(error.localizedDescription)")
        }
    }
    
    class func delete(beacon beaconInfo: BeaconInfo?){
        guard let beacon = beaconInfo else {
            return
        }
        if let beaconDB:Beacon = fetch(beacon.uuid, major: beacon.major, minor: beacon.minor).first {
            let context = DataManager.shared.managedObjectContext
            context.delete(beaconDB)
            DataManager.shared.saveContext(context)
        }
    }
    /*
     class func disable(beacon beaconInfo: BeaconInfo?){
     guard let beacon = beaconInfo else {
     return
     }
     if let beaconDB:Beacon = fetch(beacon.uuid, major: beacon.major, minor: beacon.minor).first {
     let context = DataManager.shared.managedObjectContext
     DataManager.shared.saveContext(context)
     }
     }*/
    
    class func fetch(_ uuid: String, major: String, minor: String, limit: Int = 0, all: Bool = false) ->[BeaconInfo] {
        let context = DataManager.shared.managedObjectContext
        let beaconBundle:[Beacon] = Beacon.fetch(uuid, major: major, minor: minor, context: context)
        let results = beaconBundle.map { (db) -> BeaconInfo in
            return db.toBeaconInfo()
        }
        return results;
    }
    
    class func isExits(_ beacon: BeaconInfo) -> Bool {
        let context = DataManager.shared.managedObjectContext
        let beaconFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_BEACON)
        let majorPredicate = NSPredicate(format: "major = %@", beacon.major)
        let minorPredicate = NSPredicate(format: "minor = %@", beacon.minor)
        let uuidPredicate = NSPredicate(format: "uuid = %@", beacon.uuid)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [uuidPredicate, majorPredicate, minorPredicate])
        beaconFetch.predicate = compoundPredicate
        beaconFetch.resultType = .countResultType
        do {
            //var error:NSError? = nil
            //let results = try context.count(for: beaconFetch, error: &error)//fix error
            let results = try context.count(for: beaconFetch) //fix error
            return results > 0
        } catch  {
            print("Could not fetch ")
            return false //fix error
        }
    }
    
    fileprivate class func fetch(_ uuid: String, major: String, minor: String, limit: Int = 0, all: Bool = false, context: NSManagedObjectContext = DataManager.shared.managedObjectContext) ->[Beacon]{
        let results = [Beacon]()
        let beaconFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_BEACON)
        let majorPredicate = NSPredicate(format: "major = %@", major)
        let minorPredicate = NSPredicate(format: "minor = %@", minor)
        let uuidPredicate = NSPredicate(format: "uuid = %@", uuid)
        let conditionArray = [uuidPredicate, majorPredicate, minorPredicate]
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: conditionArray)
        beaconFetch.predicate = compoundPredicate
        let sortDescriptor = NSSortDescriptor(key: "update_date", ascending: false)
        beaconFetch.sortDescriptors = [sortDescriptor]
        do {
            if  let results = try context.fetch(beaconFetch) as? [Beacon] {
                return results
            }
            
        } catch  {
            print("Could not fetch ")
        }
        return results
    }
    
    class func getAll(_ limit: Int = 0, context: NSManagedObjectContext = DataManager.shared.managedObjectContext) ->[BeaconInfo]{
        let beaconBundle:[Beacon] = Beacon.getAll(limit, context: context)
        let results = beaconBundle.map { (db) -> BeaconInfo in
            return db.toBeaconInfo()
        }
        return results;
    }
    
    func toBeaconInfo() -> BeaconInfo {
        let beaconInfo = BeaconInfo()
        beaconInfo.beacon_id = self.beacon_id
        beaconInfo.uuid = self.uuid ?? ""
        beaconInfo.major = self.major ?? ""
        beaconInfo.minor = self.minor ?? ""
        beaconInfo.rssi = self.rssi ?? ""
        beaconInfo.proximity = (self.proximity?.toCLProximity())!
        beaconInfo.protected = self.protected?.boolValue ?? false
        beaconInfo.create_date = self.create_date
        beaconInfo.update_date = self.update_date
        beaconInfo.xmlData = self.xml_file?.file
        if let accountList = self.mailAccount, accountList.allObjects.count > 0{
            beaconInfo.mailGroup = [:]
            var mailAccountAvalidate: MailAccount?
            for mailAccount in accountList.allObjects {
                let account = mailAccount as! MailAccount
                let infor = account.toMailAccount()
                beaconInfo.mailGroup![infor.lang] = infor;
                mailAccountAvalidate = (infor.lang == UDGet(kLanguage)) ? account: mailAccountAvalidate
            }
            if let accountDefault = mailAccountAvalidate {
                beaconInfo.unread_cnt = accountDefault.getNumberMailUnRead()
            }else if let accountDefault = MailAccount.getMailAccoutBy(beaconInfo, isDefault: true) {
                beaconInfo.unread_cnt = accountDefault.getNumberMailUnRead()
            }
        }
        return beaconInfo
        
    }
    fileprivate class func getAll(_ limit: Int, context: NSManagedObjectContext) ->[Beacon] {
        let results = [Beacon]()
        let beaconFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_BEACON)
        let sortDescriptor = NSSortDescriptor(key: "update_date", ascending: false)
        beaconFetch.sortDescriptors = [sortDescriptor]
        do {
            if  let results = try context.fetch(beaconFetch) as? [Beacon] {
                return results
            }
            
        } catch  {
            print("Could not fetch ")
        }
        return results
    }
    
}
