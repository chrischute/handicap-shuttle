//
//  Ride+CoreDataProperties.swift
//  
//
//  Created by Christopher Chute on 12/6/16.
//
//

import Foundation
import CoreData


extension Ride {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ride> {
        return NSFetchRequest<Ride>(entityName: "Ride");
    }

    @NSManaged public var dateAndTime: NSDate?
    @NSManaged public var fromAddress: String?
    @NSManaged public var needsWheelchair: Bool
    @NSManaged public var toAddress: String?
    @NSManaged public var guid: String?
    @NSManaged public var rider: Rider?

}
