//
//  Geofence.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation
import CoreData
import SwiftyXMLParser

class Geofence: NSManagedObject {
    //MARK: Update
    class func insert(_ geo: GeoFenceBean, withContext context: NSManagedObjectContext = DataManager.shared.managedObjectContext) {
        var geoDB: Geofence!
        geoDB = Geofence.fetch(geo).first
        if geoDB == nil {
            let beaconEntity = NSEntityDescription.entity(forEntityName: ENTITY_GEOFENCE, in: context)
            geoDB = Geofence(entity: beaconEntity!, insertInto: context)
        }
        
        geoDB.map(geoInfo: geo)
        let xmlDataEntity = NSEntityDescription.entity(forEntityName: ENTITY_XML, in: context)
        let xmlData = XMLFileData(entity: xmlDataEntity!, insertInto: context)
        let xmlInfor = XMLInfo(type: ENTITY_GEOFENCE)
        xmlInfor.dataRaw = geo.xmlData
        xmlData.map(xmlInfor)
        geoDB.xml_file = xmlData
        
        geoDB.notify_title = geo.notify_title
        geoDB.notify_message = geo.notify_message
        
        do {
            try context.save()
        }catch let error as NSError {
            print("Error: \(error) " + "description \(error.localizedDescription)")
        }
    }
    
    class func delete(geoFece geo: GeoFenceBean?){
        guard let geo = geo else {
            return
        }
        if let geoDB:Geofence = fetch(geo).first {
            let context = DataManager.shared.managedObjectContext
            context.delete(geoDB)
            DataManager.shared.saveContext(context)
        }
    }
    /*
     class func disable(geoFece geo: GeoFenceBean?){
     guard let geo = geo else {
     return
     }
     if let geoDB:Geofence = fetch(geo).first {
     let context = DataManager.shared.managedObjectContext
     geoDB.enable = false
     DataManager.shared.saveContext(context)
     }
     }*/
    
    class func updateGeofence(_ geo: GeoFenceBean, withContext context: NSManagedObjectContext = DataManager.shared.managedObjectContext) {
        var geoDB: Geofence!
        geoDB = Geofence.fetch(geo).first
        if geoDB == nil {
            return
        }
        var xmlData: XMLFileData!
        xmlData = geoDB.xml_file
        if geoDB.xml_file == nil {
            let xmlDataEntity = NSEntityDescription.entity(forEntityName: ENTITY_XML, in: context)
            xmlData = XMLFileData(entity: xmlDataEntity!, insertInto: context)
        }
        let xmlInfor = XMLInfo(type: ENTITY_GEOFENCE)
        xmlInfor.dataRaw = geo.xmlData
        xmlData.map(xmlInfor)
        geoDB.xml_file = xmlData
        
        if let mailAccountList = geo.mailGroup, mailAccountList.count > 0{
            let accountCurrently = geoDB.mailAccount?.mutableCopy() as! NSMutableSet
            for account in mailAccountList {
                var mailAccount:MailAccount!
                mailAccount = MailAccount.getMailAccoutBy(geo: geo, key: account.0)
                if mailAccount == nil {
                    let mailAccountEntity = NSEntityDescription.entity(forEntityName: ENTITY_MAILACCOUNT, in: context)
                    mailAccount = MailAccount(entity: mailAccountEntity!, insertInto: context)
                    mailAccount.map(account.1)
                    mailAccount.region_name = geo.identifier
                    mailAccount.update_time = Date()
                        
                    accountCurrently.add(mailAccount)
                }
            }
            geoDB.mailAccount = accountCurrently.copy() as! NSSet
        }
        DataManager.shared.saveContext(context)
        
    }
    
    class func enterRegion(_ geo: GeoFenceBean, isEnter: Bool) {
        if let geoDB = fetch(geo).first{
            let context = DataManager.shared.managedObjectContext
            geoDB.is_enter_geo = NSNumber(booleanLiteral: isEnter) //isEnter as NSNumber
            geoDB.update_date = Date()
            DataManager.shared.saveContext(context)
        }
    }
    
    //MARK: GET
    static func getGeoBy(id: String) -> GeoFenceBean? {
        print("getGeoByID: \(id)")
        let context = DataManager.shared.managedObjectContext
        let predicate = NSPredicate(format: "geofence_id = %@", id)
        let geoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_GEOFENCE)
        geoFetch.predicate = predicate
        
        do {
            if  let results = try context.fetch(geoFetch) as? [Geofence] {
                print("count results: \(results.count)")
                print("results: \(results)")
//                for geo in results {
//                    if geo.geofence_id == id {
//                        print("geofence_id = %@", geo.geofence_id)
//                        return geo.toGeoInfo()
//                    }
//
//                }
//
               return results.first?.toGeoInfo()
            }
            
        } catch  {
            print("Could not fetch ")
        }
        return nil
    }
    
    static func getGeoBy(xmlID id: String) -> GeoFenceBean? {
        let context = DataManager.shared.managedObjectContext
        let condition = NSPredicate(format: "xml_file_id = %@", id)
        let geoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_GEOFENCE)
        geoFetch.predicate = condition
        do {
            if  let results = try context.fetch(geoFetch) as? [Geofence] {
                return results.first?.toGeoInfo()
            }
            
        } catch  {
            print("Could not fetch ")
        }
        return nil
    }
    
    class func getGeoEnterRegion(isEnter enter: Bool = true) ->[Geofence] {
        let results = [Geofence]()
        let context = DataManager.shared.managedObjectContext
        let condition = NSPredicate(format: "is_enter_geo = %@", enter as CVarArg)
        let geoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_GEOFENCE)
        geoFetch.predicate = condition
        let sortDescriptor = NSSortDescriptor(key: "update_date", ascending: false)
        geoFetch.sortDescriptors = [sortDescriptor]
        do {
            if  let results = try context.fetch(geoFetch) as? [Geofence] {
                return results
            }
            
        } catch  {
            print("Could not fetch ")
        }
        return results
    }
    
    
    class func getAll(_ limit: Int = 0, context: NSManagedObjectContext = DataManager.shared.managedObjectContext) ->[GeoFenceBean]{
        let beaconBundle:[Geofence] = getAll(limit, context: context)
        let results = beaconBundle.map { (db) -> GeoFenceBean in
            return db.toGeoInfo()
        }
        return results;
    }
    
    fileprivate class func getAll(_ limit: Int, context: NSManagedObjectContext) ->[Geofence] {
        let results = [Geofence]()
        let geoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_GEOFENCE)
        let sortDescriptor = NSSortDescriptor(key: "update_date", ascending: false)
        geoFetch.sortDescriptors = [sortDescriptor]
        do {
            if  let results = try context.fetch(geoFetch) as? [Geofence] {
                return results
            }
            
        } catch  {
            print("Could not fetch ")
        }
        return results
    }
    
    class func fetch(geofence geo: GeoFenceBean, limit: Int = 0, context: NSManagedObjectContext = DataManager.shared.managedObjectContext) ->[GeoFenceBean] {
        let beaconBundle:[Geofence] = fetch(geo)
        let results = beaconBundle.map { (db) -> GeoFenceBean in
            return db.toGeoInfo()
        }
        return results;
    }
    
    class func isExists(_ geo: GeoFenceBean) -> Bool {
        let listGeoEnter = self.getGeoEnterRegion().map { g -> GeoFenceBean in
            return g.toGeoInfo()
        }
        
        for geoEnter in listGeoEnter {
            if geoEnter.identifier == geo.identifier {
                return true
            }
        }
        
        return false
        
//        let context = DataManager.shared.managedObjectContext
//        let geoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_GEOFENCE)
//        let geofence_latPredicate = NSPredicate(format: "geofence_lat = %f", geo.latitude!)
//        let geofence_lonPredicate = NSPredicate(format: "geofence_lon = %f", geo.longitude!)
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [geofence_latPredicate, geofence_lonPredicate])
//        geoFetch.predicate = compoundPredicate
//        geoFetch.resultType = .countResultType
//        do {
//            //var error:NSError? = nil
//            //let results = try context.count(for: geoFetch, error: &error)//fix error
//            let results = try context.count(for: geoFetch)
//            return results > 0
//        } catch  {
//            return false;
//            print("Could not fetch ")
//        }
    }
    
    fileprivate class func fetch(_ geo: GeoFenceBean, limit: Int = 0, all: Bool = false, context: NSManagedObjectContext = DataManager.shared.managedObjectContext) ->[Geofence]{
        let results = [Geofence]()
        let geoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_GEOFENCE)
        
        if let latitude = geo.latitude , let longitude = geo.longitude, let radius = geo.radius {
            let geofence_latPredicate = NSPredicate(format: "geofence_lat = %@", latitude)
            let geofence_lonPredicate = NSPredicate(format: "geofence_lon = %@", longitude)
            let geofence_radiusPredicate = NSPredicate(format: "geofence_radius = %@", radius)
            
            let conditionArray = [geofence_lonPredicate, geofence_latPredicate, geofence_radiusPredicate]
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: conditionArray)
            geoFetch.predicate = compoundPredicate
            
            let sortDescriptor = NSSortDescriptor(key: "update_date", ascending: false)
            geoFetch.sortDescriptors = [sortDescriptor]
            do {
                if  let results = try context.fetch(geoFetch) as? [Geofence] {
                    return results
                }
                
            } catch  {
                print("Could not fetch ")
            }
        }
        
        return results
    }
    
    func toGeoInfo() -> GeoFenceBean {
        let geo = GeoFenceBean()
        geo.identifier = self.geofence_id ?? ""
        geo.xml_file_id = self.xml_file_id
        geo.latitude = self.geofence_lat ?? ""
        geo.longitude = self.geofence_lon ?? ""
        geo.radius = self.geofence_radius ?? ""
        geo.create_date = self.create_date! as NSDate
        geo.update_date = self.update_date! as NSDate
        geo.xmlData = self.xml_file?.file
        if let accountList = self.mailAccount, accountList.allObjects.count > 0{
            
            if let allObjects = accountList.allObjects as? [Any], allObjects.count > 0 {
                geo.mailGroup = [:]
                var mailAccountAvalidate: MailAccount?
                for mailAccount in accountList.allObjects {
                    let account = mailAccount as! MailAccount
                    let infor = account.toMailAccount()
                    geo.mailGroup![infor.lang] = infor;
                    mailAccountAvalidate = (infor.lang == UDGet(kLanguage)) ? account: mailAccountAvalidate
                }
                if let accountDefault = mailAccountAvalidate {
                    geo.unread_cnt = accountDefault.getNumberMailUnRead()
                }else if let accountDefault = MailAccount.getMailAccoutBy(geo: geo, isDefault: true) {
                    geo.unread_cnt = accountDefault.getNumberMailUnRead()
                }
            }                        
        }
        
        geo.notify_title = self.notify_title
        geo.notify_message = self.notify_message
        
        return geo
    }
    
    func map(geoInfo geo: GeoFenceBean) {
        self.geofence_id = geo.identifier
        self.xml_file_id = geo.xmlID
        self.geofence_lat = geo.latitude
        self.geofence_lon = geo.longitude
        self.geofence_radius = geo.radius
        self.create_date = geo.create_date as Date? ?? Date()
        self.is_enter_geo = geo.isEnterGeo as NSNumber?
        self.update_date = geo.update_date as Date? ?? Date()
    }
}
