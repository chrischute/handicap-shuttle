//
//  DynamoRide.swift
//  Wheels
//
//  Created by Christopher Chute on 12/4/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import Foundation
import AWSDynamoDB

class DynamoDBManager : NSObject {
    class func describeTable() -> AWSTask<AWSDynamoDBDescribeTableOutput>? {
        let dynamoDB = AWSDynamoDB.default()
        
        // Check whether the rides table exists.
        let describeTableInput = AWSDynamoDBDescribeTableInput()
        describeTableInput?.tableName = DynamoDBConstants.ridesTableName
        if let describeTableInput = describeTableInput {
            return dynamoDB.describeTable(describeTableInput)
        }
        return nil
    }

    class func initializeRiderTable() -> AWSTask<AWSDynamoDBDescribeTableOutput> {
        let dynamoDB: AWSDynamoDB = AWSDynamoDB.default()
        
        // MARK: Construct the table of rides.
        // (1) Add the key attributes (netId and pickupTime).
        let hashKeyDefinition = AWSDynamoDBAttributeDefinition()
        hashKeyDefinition?.attributeName = DynamoDBConstants.netIdKeyName
        hashKeyDefinition?.attributeType = AWSDynamoDBScalarAttributeType.S
        
        let hashKeySchemaElement = AWSDynamoDBKeySchemaElement()
        hashKeySchemaElement?.attributeName = DynamoDBConstants.netIdKeyName
        hashKeySchemaElement?.keyType = AWSDynamoDBKeyType.hash
        
        let rangeKeyDefinition = AWSDynamoDBAttributeDefinition()
        rangeKeyDefinition?.attributeName = DynamoDBConstants.pickupTimeKeyName
        rangeKeyDefinition?.attributeType = AWSDynamoDBScalarAttributeType.S
        
        let rangeKeySchemaElement = AWSDynamoDBKeySchemaElement()
        rangeKeySchemaElement?.attributeName = DynamoDBConstants.pickupTimeKeyName
        rangeKeySchemaElement?.keyType = AWSDynamoDBKeyType.range
        
        // (2) Add the non-key attributes (fromAddress, toAddress, needsWheelchair).
        let fromAddressAttributeDefinition = AWSDynamoDBAttributeDefinition()
        fromAddressAttributeDefinition?.attributeName = DynamoDBConstants.fromAddressAttributeName
        fromAddressAttributeDefinition?.attributeType = AWSDynamoDBScalarAttributeType.S

        let toAddressAttributeDefinition = AWSDynamoDBAttributeDefinition()
        toAddressAttributeDefinition?.attributeName = DynamoDBConstants.fromAddressAttributeName
        toAddressAttributeDefinition?.attributeType = AWSDynamoDBScalarAttributeType.S
        
        let needsWheelchairAttributeDefinition = AWSDynamoDBAttributeDefinition()
        needsWheelchairAttributeDefinition?.attributeName = DynamoDBConstants.needsWheelchairAttributeName
        needsWheelchairAttributeDefinition?.attributeType = AWSDynamoDBScalarAttributeType.S
        
        let provisionedThroughput = AWSDynamoDBProvisionedThroughput()
        provisionedThroughput?.readCapacityUnits = 5
        provisionedThroughput?.writeCapacityUnits = 5
        
        // Create Global Secondary Index. None here.
        
        // Create Table Input.
        let createTableInput = AWSDynamoDBCreateTableInput()
        createTableInput?.tableName = DynamoDBConstants.ridesTableName
        if let hashKeyDefinition = hashKeyDefinition,
            let rangeKeyDefinition = rangeKeyDefinition,
            let fromAddressAttributeDefinition = fromAddressAttributeDefinition,
            let toAddressAttributeDefinition = toAddressAttributeDefinition {
            createTableInput?.attributeDefinitions = [
                hashKeyDefinition,
                rangeKeyDefinition,
                fromAddressAttributeDefinition,
                toAddressAttributeDefinition
            ]
        } else {
            Debug.log("One or more attribute definitions was undefined in DynamoDBManager.createTable.")
        }
        
        var createTableTask: AWSTask<AWSDynamoDBCreateTableOutput>? = nil
        if let createTableInput = createTableInput {
            createTableTask = dynamoDB.createTable(createTableInput)
        }
        
        return createTableTask?.continue(successBlock: { task -> AnyObject? in
            var localTask = task as! AWSTask<AnyObject>
            
            if ((localTask.result) != nil) {
                
                // Wait for up to 4 minutes until the table becomes ACTIVE.
                let describeTableInput = AWSDynamoDBDescribeTableInput()
                describeTableInput?.tableName = DynamoDBConstants.ridesTableName;
                if let describeTableInput = describeTableInput {
                    localTask = dynamoDB.describeTable(describeTableInput) as! AWSTask<AnyObject>
                }
                
                for _ in 0...15 {
                    localTask = localTask.continue(successBlock: { task -> AnyObject? in
                        let describeTableOutput:AWSDynamoDBDescribeTableOutput = task.result as! AWSDynamoDBDescribeTableOutput
                        let tableStatus = describeTableOutput.table!.tableStatus
                        if tableStatus == AWSDynamoDBTableStatus.active {
                            return task
                        }
                        
                        sleep(15)
                        return dynamoDB.describeTable(describeTableInput!)
                    })
                }
            }
            
            return localTask
        }) as! AWSTask<AWSDynamoDBDescribeTableOutput>
    }
}





































