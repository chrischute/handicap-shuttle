//
//  Ride+rideInDatabase.swift
//  Wheels
//
//  Created by Christopher Chute on 11/1/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import Foundation
import CoreData

extension Ride {
    /**
     * Insert a ride with given properties in the database.
     */
    class func rideInDatabase(for rider: Rider, from src: String, to dest: String, at dateAndTime: NSDate, withWheelchair needsWheelchair: Bool, guid: String?, in moc: NSManagedObjectContext) -> Ride? {

        // Check whether this ride already exists in CoreData.
        if let rideId = guid {
            let fetchRequest: NSFetchRequest<Ride> = Ride.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "guid == %@", rideId)
            var oldRide: Ride? = nil
            
            // Try and fetch the ride with the specified GUID.
            moc.performAndWait {
                do {
                    oldRide = try fetchRequest.execute().first
                } catch {
                    Debug.log("rideInDatabase: Error executing fetch request for ride.")
                }
            }
            // If ride was present, just return it.
            if oldRide != nil {
                Debug.log("Already had ride from \(src) to \(dest) for rider with netId \(rider.netId)")
                return oldRide
            } else {
                Debug.log("Did not find ride with GUID \(guid)")
            }
        }

        // Ride does not exist in CoreData yet. Insert new ride in the database.
        Debug.log("Inserting new ride from \(src) to \(dest) for rider with netId \(rider.netId)")
        if let newRide = NSEntityDescription.insertNewObject(forEntityName: "Ride", into: moc) as? Ride {
            newRide.rider = rider
            newRide.fromAddress = src
            newRide.toAddress = dest
            newRide.dateAndTime = dateAndTime
            newRide.needsWheelchair = needsWheelchair
            if let oldGuid = guid {
                newRide.guid = oldGuid
            } else {
                newRide.guid = NSUUID().uuidString
            }
            
            do {
                try moc.save()
                return newRide
            } catch let error {
                print("Error saving context after putting new ride in database: \(error)")
                return nil
            }
        }
        
        print("Error inserting new ride in database.")
        return nil
    }
}
