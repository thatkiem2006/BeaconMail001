//
//  Beacon+CoreDataProperties.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation
import CoreData

extension Beacon {
    
    @NSManaged var beacon_id: String?
    @NSManaged var create_date: Date?
    @NSManaged var major: String?
    @NSManaged var minor: String?
    @NSManaged var protected: NSNumber?
    @NSManaged var proximity: String?
    @NSManaged var rssi: String?
    @NSManaged var update_date: Date?
    @NSManaged var uuid: String?
    @NSManaged var mailAccount: NSSet?
    @NSManaged var xml_file: XMLFileData?
    
}

