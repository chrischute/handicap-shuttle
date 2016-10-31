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

    
    /**
     * Insert a rider with netId and password into the database.
     */
    class func riderInDatabase(from netId: String, with password: String, in moc: NSManagedObjectContext) -> Rider? {
        let request: NSFetchRequest<Rider> = Rider.fetchRequest()
        request.predicate = NSPredicate(format: "netId = %@", netId)
        var riders: [Rider]?

        // Perform the fetch request within the managed object context.
        moc.performAndWait {
            do {
                riders = try request.execute()
            } catch let error {
                print("Error fetching \(netId) from database.\nError was \(error)")
            }
        }

        // If rider already existed, return it. Else insert a new one in the database.
        if let fetchedRiders = riders {
            if let existingRider = fetchedRiders.first {
                // Rider already stored in database.
                Debug.log("Found existing rider with netId \(netId)")
                return existingRider
            } else {
                // Rider not in database yet. Insert the rider.
                Debug.log("Inserting new rider with netId \(netId)")
                // TODO: Password validation.
                let newRider = NSEntityDescription.insertNewObject(forEntityName: "Rider", into: moc) as? Rider
                newRider?.netId = netId
                newRider?.password = password
                try? moc.save()
                
                if let insertedRider = newRider {
                    Debug.log("Succeeded inserting new rider with netId \(insertedRider.netId)")
                } else {
                    Debug.log("Failed to insert new rider with netId \(netId)")
                }
                
                return newRider
            }
        } else {
            // Error in fetching from database. Return nil.
            return nil
        }
    }
}
