//
//  MailAccount+CoreDataProperties.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation
import CoreData

extension MailAccount {
    
    @NSManaged var encryption: String?
    @NSManaged var hasNewMail: NSNumber?
    @NSManaged var region_name: String?
    @NSManaged var idPrefix: String?
    @NSManaged var idSuffix: String?
    @NSManaged var lang: String?
    @NSManaged var name: String?
    @NSManaged var passwd: String?
    @NSManaged var port: String?
    @NSManaged var server: String?
    @NSManaged var topMailId: NSNumber?
    @NSManaged var update_time: Date?
    @NSManaged var isDefault: NSNumber?
    @NSManaged var beacon: Beacon?
    @NSManaged var geofence: Geofence?
    @NSManaged var mailbox: NSSet?
    
}
