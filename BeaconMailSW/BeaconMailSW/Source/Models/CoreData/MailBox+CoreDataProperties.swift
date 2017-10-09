//
//  MailBox+CoreDataProperties.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation
import CoreData

extension MailBox {
    
    @NSManaged var create_date: Date?
    @NSManaged var is_favorite: NSNumber?
    @NSManaged var is_read: NSNumber?
    @NSManaged var mail_id: String?
    @NSManaged var message: String?
    @NSManaged var messageDescription: String?
    @NSManaged var subject: String?
    @NSManaged var update_date: Date?
    @NSManaged var is_hidden: NSNumber?
    @NSManaged var mailAccount: MailAccount?
    
}
