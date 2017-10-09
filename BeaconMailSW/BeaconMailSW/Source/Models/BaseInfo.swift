//
//  BaseInfo.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import CoreData

class BaseInfo: NSObject {
    static func getEntities(_ fetchLimit:Int,entityName:String)-> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:entityName)
        let sortDescriptor = NSSortDescriptor(key: "update_date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if fetchLimit > 0 {
            fetchRequest.fetchLimit = fetchLimit
        }
        
        do {
            if  let fetchedResults = try DataManager.shared.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            {
                return fetchedResults
            }
            
        } catch  {
            print("Could not fetch ")
        }
        
        return []
        
    }
    
    /*
     *  getEntitiesFromMajorMinor
     *
     *  Discussion:
     *    Get Entities from DB
     *
     *  KEY : major, minor
     *  SORT : update_date
     */
    static func getEntitiesFromMajorMinor(_ major:String, minor:String,entityName:String, context:NSManagedObjectContext)-> [NSManagedObject]
    {
        return  BaseInfo.getEntitiesFromMajorMinor(major, minor: minor, fetchLimit: 0, entityName: entityName,context: context)
    }
    
    /*
     *  getEntitiesFromMajorMinor
     *
     *  Discussion:
     *    Get Entities from DB
     *
     *  KEY : major, minor
     *  SORT : update_date
     *  Litmit : fetchLimit
     */
    static func getEntitiesFromMajorMinor(_ major:String, minor:String,fetchLimit:Int,entityName:String,context:NSManagedObjectContext)-> [NSManagedObject] {
        let majorPredicate = NSPredicate(format: "major = %@", major)
        let minorPredicate = NSPredicate(format: "minor = %@", minor)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [majorPredicate, minorPredicate])
        return  BaseInfo.getEntitiesWithPredicate(compoundPredicate, fetchLimit: fetchLimit, entityName: entityName,context: context)
    }
    
    
    /*
     *  getEntitiesWithPredicate
     *
     *  Discussion:
     *    Get Entities from DB
     *
     *  KEY : Predicate
     *  SORT : update_date
     *  Litmit : fetchLimit
     */
    static func getEntitiesWithPredicate(_ compoundPredicate:NSPredicate?, fetchLimit:Int,entityName:String, context:NSManagedObjectContext)-> [NSManagedObject]
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:entityName)
        fetchRequest.predicate = compoundPredicate
        let sortDescriptor = NSSortDescriptor(key: "update_date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if fetchLimit > 0
        {
            fetchRequest.fetchLimit = fetchLimit
        }
        
        do {
            if  let fetchedResults = try context.fetch(fetchRequest) as? [NSManagedObject]
            {
                return fetchedResults
            }
            
        } catch  {
            print("Could not fetch ")
        }
        
        return []
        
    }
    
    /*
     *  deleteEntities
     *
     *  Discussion:
     *    Delete Entities from DB
     *
     */
    static func deleteEntities(_ deleteEntities:[NSManagedObject])-> Void{
        // create MOC
        let mocContext = DataManager.shared.managedObjectContext
        
        // loop all entities
        for entity in deleteEntities
        {
            mocContext.delete(entity)
        }
        
        // save
        DataManager.shared.saveContext(mocContext)
    }
    
    static func deleteAllData(_ entity: String) {
        let mocContext = DataManager.shared.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try mocContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                mocContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
}
