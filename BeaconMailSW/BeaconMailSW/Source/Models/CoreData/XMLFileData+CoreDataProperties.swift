//
//  XMLFileData+CoreDataProperties.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation
import CoreData

extension XMLFileData {
    
    @NSManaged var create_date: Date?
    @NSManaged var file: Data?
    @NSManaged var update_date: Date?
    @NSManaged var is_loadMail: NSNumber?
    @NSManaged var beacon: Beacon?
    @NSManaged var geofence: Geofence?
    
}
