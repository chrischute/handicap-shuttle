//
//  StoryboardConstants.swift
//  Wheels
//
//  Created by Christopher Chute on 10/31/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import Foundation

class StoryboardConstants {
    /* Segues */
    static let loginSegueId = "loginSegue"
    static let newScheduledRideSegueId = "newScheduledRideSegue"
    static let embedTableViewControllerSegueId = "embedTableViewControllerSegue"
    static let embedEditRideTableViewSegueId = "embedEditRideTableViewSegue"
    static let editScheduledRideSegueId = "editScheduledRideSegue"
    static let unwindDoneNewScheduledRideSegueId = "unwindDoneNewScheduledRideSegue"
    static let unwindEditScheduledRideSegueId = "unwindEditScheduledRideSegue"

    /* View Controllers */
    static let onDemandViewControllerId = "onDemandViewController"
    static let queueViewControllerId = "queueViewController"
    static let planAheadViewControllerId = "planAheadViewController"

    /* Table View Prototype Cells */
    static let scheduledRideCellId = "scheduledRideCell"
    
    /* Date and Time Formatting */
    static let standardDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "h:mm a' on 'EEEE, MM/dd/yy"
        return df
    }()
    
    /* Map Coordinates */
    static let sterlingMemorialLibraryLatitude = 41.310842
    static let sterlingMemorialLibraryLongitude = -72.929603
    static let initialMapViewWidth = 0.014
    static let initialMapViewHeight = 0.010
}
