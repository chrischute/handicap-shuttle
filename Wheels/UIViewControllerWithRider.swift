//
//  RiderViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 11/1/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit
import CoreData


/**
 * Parent class of the three main pages for requesting rides.
 * Each needs information about the rider requesting rides,
 * as well as the NSManagedObjectContext for Core Data access.
 */
class UIViewControllerWithRider: UIViewController {
    var rider: Rider!
    var moc: NSManagedObjectContext!
}
