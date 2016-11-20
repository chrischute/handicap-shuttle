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
    class func rideInDatabase(for rider: Rider, from src: String, to dest: String, at dateAndTime: NSDate, withWheelchair needsWheelchair: Bool, in moc: NSManagedObjectContext) -> Ride? {

        // Insert a new ride in the database.
        Debug.log("Inserting new ride from \(src) to \(dest) for rider with netId \(rider.netId)")
        
        if let newRide = NSEntityDescription.insertNewObject(forEntityName: "Ride", into: moc) as? Ride {
            newRide.rider = rider
            newRide.fromAddress = src
            newRide.toAddress = dest
            newRide.dateAndTime = dateAndTime
            newRide.needsWheelchair = needsWheelchair
            
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
