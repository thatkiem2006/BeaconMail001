//
//  Geofence+CoreDataProperties.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation
import CoreData

extension Geofence {
    
    @NSManaged var create_date: Date?
    @NSManaged var geofence_distance: NSNumber?
    @NSManaged var geofence_id: String
    @NSManaged var geofence_lat: String?
    @NSManaged var geofence_lon: String?
    @NSManaged var geofence_radius: String?
    @NSManaged var is_enter_geo: NSNumber?
    @NSManaged var update_date: Date?
    @NSManaged var xml_file_id: String?
    @NSManaged var mailAccount: NSSet?
    @NSManaged var xml_file: XMLFileData?
    
    @NSManaged var notify_title: String?
    @NSManaged var notify_message: String?
}
