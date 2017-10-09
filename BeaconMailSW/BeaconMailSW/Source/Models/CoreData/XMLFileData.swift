//
//  XMLFileData.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation
import CoreData


class XMLFileData: NSManagedObject {
    func map(_ xmlInfor: XMLInfo?) {
        guard let xmlInfo = xmlInfor else {
            return
        }
        self.is_loadMail = xmlInfo.is_loadMail as NSNumber
        self.create_date = xmlInfo.create_date
        self.update_date = xmlInfo.update_date
        self.file = xmlInfo.dataRaw
    }
    
    func toXMLInfo(forType type: String) -> XMLInfo {
        let xmlInfor = XMLInfo(type: type)
        xmlInfor.dataRaw = self.file
        xmlInfor.create_date = self.create_date
        xmlInfor.update_date = self.update_date
        xmlInfor.is_loadMail = self.is_loadMail?.boolValue ?? false
        return xmlInfor
    }
    
    class func fetch(_ beacon: BeaconInfo?, geofence: GeoFenceBean?, limit: Int = 0, context: NSManagedObjectContext = DataManager.shared.managedObjectContext) ->XMLInfo?{
        var results = [XMLFileData]()
        let beaconFetch = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_XML)
        var compoundPredicate: NSPredicate?
        var type:String!
        if let beacon = beacon {
            let majorPredicate = NSPredicate(format: "major = %@", beacon.major)
            let minorPredicate = NSPredicate(format: "minor = %@", beacon.minor)
            compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [majorPredicate, minorPredicate])
            type = ENTITY_BEACON
        }else {
            type = ENTITY_GEOFENCE
        }
        
        beaconFetch.predicate = compoundPredicate
        let sortDescriptor = NSSortDescriptor(key: "update_date", ascending: false)
        beaconFetch.sortDescriptors = [sortDescriptor]
        do {
            if  let results = try context.fetch(beaconFetch) as? [XMLFileData] {
                return results.first?.toXMLInfo(forType: type)
            }
            
        } catch  {
            print("Could not fetch ")
        }
        return nil
    }
    
}
