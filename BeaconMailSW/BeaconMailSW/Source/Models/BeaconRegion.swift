//
//  BeaconRegion.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import CoreData

class BeaconRegion: BaseInfo {
    
    var url:String = ""
    var uuid: String = ""
    
    var create_date: Date?
    var update_date: Date?
    
    override init() {
        super.init()
    }
    
    static func insertBeaconRegionToDb(_ beaconRegion: BeaconRegion) {
        
        let mocContext = DataManager.shared.managedObjectContext
        
        // get beacon info and insert to table Beacon
        let beaconRegionEntity = DataManager.shared.getEntity(ENTITY_BEACONREGION, context: mocContext)
        beaconRegionEntity.setValue(beaconRegion.uuid, forKey: "uuid")
        beaconRegionEntity.setValue(beaconRegion.url, forKey: "url")
        beaconRegionEntity.setValue(Date(), forKey: "create_date")
        beaconRegionEntity.setValue(Date(), forKey: "update_create")
        
        DataManager.shared.saveContext(mocContext)
    }
    
    
    static func getListBeaconRegions()-> [BeaconRegion] {
        
        var listBeaconRegion: [BeaconRegion] = []
        let listRegion = BeaconRegion.getListBeaconRegionEntities()
        for region in listRegion {
            
            let beaconRegion = BeaconRegion()
            beaconRegion.uuid = (region.value(forKey: "uuid") as? String)!
            beaconRegion.url = (region.value(forKey: "url") as? String)!
            listBeaconRegion.append(beaconRegion)
        }
        
        return listBeaconRegion
    }
    
    static func getListBeaconRegionEntities()-> [NSManagedObject] {
        return BaseInfo.getEntities(0, entityName: ENTITY_BEACONREGION)
    }
    
    static func deleteAllBeaconRegions() -> Bool {
        
        var listBeaconRegionEntities: [NSManagedObject] = []
        listBeaconRegionEntities = BeaconRegion.getListBeaconRegionEntities()
        
        if listBeaconRegionEntities.count > 0 {
            BaseInfo.deleteEntities(listBeaconRegionEntities)
            return true
        }
        return false
    }
}
