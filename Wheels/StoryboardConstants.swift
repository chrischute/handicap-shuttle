//
//  StoryboardConstants.swift
//  Wheels
//
//  Created by Christopher Chute on 10/31/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import Foundation
import UIKit

class StoryboardConstants {
    /* Segues */
    static let loginSegueId = "loginSegue"
    static let newScheduledRideSegueId = "newScheduledRideSegue"
    static let embedTableViewControllerSegueId = "embedTableViewControllerSegue"
    static let embedEditRideTableViewSegueId = "embedEditRideTableViewSegue"
    static let editScheduledRideSegueId = "editScheduledRideSegue"
    static let unwindDoneNewScheduledRideSegueId = "unwindDoneNewScheduledRideSegue"
    static let unwindEditScheduledRideSegueId = "unwindEditScheduledRideSegue"
    static let waitForRideSegueId = "waitForRideSegue"

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
    
    /* Special Services Van Constants */
    static let dispatchPhoneNumber = "2034322788"
    static let studentRequestFormURL = "http://your.yale.edu/sites/default/files/files/StudentRequestformforSpecialServicesVanTransportation.pdf"
    static let employeeRequestFormURL = "http://your.yale.edu/sites/default/files/files/Special%20Service%20Van%20Form%20updated%2003_27_12.pdf"
    static let secondsUntilPickupForOnDemandRide = 300.0
}

// Credit: @Sulthan on Stack Overflow
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(hexValue: Int) {
        self.init(red: (hexValue >> 16) & 0xff, green: (hexValue >> 8) & 0xff, blue: hexValue & 0xff)
    }
}
