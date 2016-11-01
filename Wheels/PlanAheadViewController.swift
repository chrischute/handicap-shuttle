//
//  PlanAheadViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 10/30/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit
import CoreData

class PlanAheadViewController: UIViewControllerWithRider, NSFetchedResultsControllerDelegate, UIBarPositioningDelegate, NewScheduledRideReceiving {
    var fetchedResultsController: NSFetchedResultsController<Ride>!
    @IBOutlet weak var newScheduledRideButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        newScheduledRideButton.setTitleTextAttributes(
            [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 17)!, NSForegroundColorAttributeName: UIColor.white],
            for: UIControlState.normal)
        
        super.viewDidLoad()
    }
    
    /**
     * NSFetchedResultsController for managing rides on Core Data.
     */
    func initializeFetchedResultsController() {
        let ridesRequest: NSFetchRequest<Ride> = Ride.fetchRequest()
        
        // We request future rides associated with the rider that's logged in.
        let currentDateAndTime = NSDate.init(timeIntervalSinceNow: 0)
        ridesRequest.predicate = NSPredicate(format: "rider.netId == %@ and dateAndTime >= %@", rider.netId!, currentDateAndTime)
        ridesRequest.sortDescriptors = [NSSortDescriptor(key: "dateAndTime", ascending: true)]

        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: ridesRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: "rootCache")
        self.fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch let error {
            Debug.log("Error fetching in NSFetchedResultsController initialization: \(error)")
        }
    }
    
    /**
     * Receive the data for a new scheduled ride. Add it to the database.
     */
    func receiveRide(from src: String, to dest: String, at dateAndTime: NSDate, withWheelchair needsWheelchair: Bool) {
        // Save the new ride in the database.
    }

    /**
     * Set the navigation bar to extend under the status bar.
     */
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardConstants.newScheduledRideSegueId {
            if let dest = segue.destination as? NewScheduledRideRootViewController {
                dest.rideDataReceiver = self
            }
        }
    }

    /**
     * Unwind to the PlanAheadViewController after pressing 'done'. Nothing to do here.
     */
    @IBAction func unwindDoneNewScheduledRide(from segue: UIStoryboardSegue) { }
}
