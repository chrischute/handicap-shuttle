//
//  DynamoDBTableRow.swift
//  Wheels
//
//  Created by Christopher Chute on 12/5/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import Foundation
import AWSDynamoDB

class DynamoDBTableRow : AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    var netId: String?
    var pickupTime: String?
    var fromAddress: String?
    var toAddress: String?
    var needsWheelchair: NSNumber? = 0
    
    class func dynamoDBTableName() -> String {
        return DynamoDBConstants.ridesTableName
    }
    
    class func hashKeyAttribute() -> String {
        return DynamoDBConstants.netIdKeyName
    }
    
    class func rangeKeyAttribute() -> String {
        return DynamoDBConstants.pickupTimeKeyName
    }
    
    class func ignoreAttributes() -> [String] {
        return []
    }

    // Construct a DBTableRow from the information we have on riders.
    class func fromRideInfo(_ ride: Ride) -> DynamoDBTableRow? {
        if let netId = ride.rider?.netId,
            let fromAddress = ride.fromAddress,
            let toAddress = ride.toAddress,
            let date = ride.dateAndTime {
            return DynamoDBTableRow.fromRideInfo(for: netId, at: date, from: fromAddress, to: toAddress, needsWheelchair: ride.needsWheelchair)
        }
        return nil
    }
    
    private class func fromRideInfo(for rider: String, at dateAndTime: NSDate, from fromAddress: String, to toAddress: String, needsWheelchair: Bool) -> DynamoDBTableRow? {
        let row = DynamoDBTableRow()
        row?.netId = rider
        row?.fromAddress = fromAddress
        row?.toAddress = toAddress
        row?.needsWheelchair = needsWheelchair ? 1 : 0
        
        row?.pickupTime = String(dateAndTime.timeIntervalSince1970)
        Debug.log("Set pickup time to \(row?.pickupTime)")
        
        return row
    }
}

