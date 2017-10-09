//
//  DataManager.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import CoreData

class DataManager: NSObject {
    // shared instance
    class var shared : DataManager {
        struct Static {
            static let instance : DataManager = DataManager()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
    }
    
    var modelName : String = "MailBeacon"
    var storeName : String = "MailBeaconCoreData"
    
    // MARK: - Core Data
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.adnet.MailBeacon" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let bundle = Bundle(for: DataManager.self)
        let modelURL = bundle.url(forResource: self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.storeName + ".sqlite")
        print("Applicaton Document: \(url)")
        var failureReason = "There was an error creating or loading the application's saved data."
        //FIX ERROR
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [NSMigratePersistentStoresAutomaticallyOption: true,NSInferMappingModelAutomaticallyOption: true])
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            print("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var mocPrivateQueue: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var mocPrivateQueue = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        mocPrivateQueue.persistentStoreCoordinator = coordinator
        return mocPrivateQueue
    }()
    
    
    // MARK: - Core Data Saving support
    func saveContext (_ context:NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                //                abort()
            }
            
            
        }
    }
    
    /*
     *  class or method name
     *
     *  Discussion:
     *    discussion
     *
     *   Created by LinhTH
     */
    func getEntity(_ entityName:String, context:NSManagedObjectContext)->NSManagedObject {
        
        // get entity info and insert to table Beacon
        let entity =  NSEntityDescription.entity(forEntityName: entityName,
                                                 in:context)
        
        let entityInfo = NSManagedObject(entity: entity!,
                                         insertInto:context)
        
        return entityInfo
    }
    
    
}
