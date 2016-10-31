//
//  Ride+CoreDataProperties.swift
//  Wheels
//
//  Created by Christopher Chute on 10/31/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import Foundation
import CoreData


extension Ride {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ride> {
        return NSFetchRequest<Ride>(entityName: "Ride");
    }

    @NSManaged public var fromAddress: String?
    @NSManaged public var toAddress: String?
    @NSManaged public var dateAndTime: NSDate?
    @NSManaged public var rider: Rider?

}
