//
//  NewScheduledRideReceiver.swift
//  Wheels
//
//  Created by Christopher Chute on 11/1/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import Foundation

/**
 * Protocol for controller that will receive data about a new scheduled ride.
 * E.g., PlanAheadViewController conforms to NewScheduledRideReceiver to get ride from a table view.
 */
protocol NewScheduledRideReceiving: class {
    func receiveRide(from src: String, to dest: String, at dateAndTime: NSDate, withWheelchair needsWheelchair: Bool)
}
