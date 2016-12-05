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
}

