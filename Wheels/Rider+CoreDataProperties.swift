//
//  Rider+CoreDataProperties.swift
//  Wheels
//
//  Created by Christopher Chute on 10/31/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import Foundation
import CoreData


extension Rider {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rider> {
        return NSFetchRequest<Rider>(entityName: "Rider");
    }
    
    @NSManaged public var netId: String?
    @NSManaged public var password: String?
    @NSManaged public var scheduledRides: NSSet?
    
}

// MARK: Generated accessors for scheduledRides
extension Rider {
    
    @objc(addScheduledRidesObject:)
    @NSManaged public func addToScheduledRides(_ value: Ride)
    
    @objc(removeScheduledRidesObject:)
    @NSManaged public func removeFromScheduledRides(_ value: Ride)
    
    @objc(addScheduledRides:)
    @NSManaged public func addToScheduledRides(_ values: NSSet)
    
    @objc(removeScheduledRides:)
    @NSManaged public func removeFromScheduledRides(_ values: NSSet)
    
}
