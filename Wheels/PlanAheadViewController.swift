//
//  PlanAheadViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 10/30/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit

class PlanAheadViewController: UIViewControllerWithRider, UIBarPositioningDelegate, NewScheduledRideReceiving {
    @IBOutlet weak var newScheduledRideButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        newScheduledRideButton.setTitleTextAttributes(
            [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 17)!, NSForegroundColorAttributeName: UIColor.white],
            for: UIControlState.normal)
        
        super.viewDidLoad()
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
                Debug.log("New Scheduled Ride segue to root view controller was called.")
                dest.rideDataReceiver = self
            }
        }
    }
    
    /**
     * Unwind to the PlanAheadViewController after pressing 'done'. Add a new scheduled ride.
     */
    @IBAction func unwindDoneNewScheduledRide(from segue: UIStoryboardSegue) {
        // TODO: Combine with the cancel segue.
    }

    /**
     * Unwind to the PlanAheadViewController after pressing 'cancel'.
     */
    @IBAction func unwindCancelNewScheduledRide(from segue: UIStoryboardSegue) {
        // Do nothing.
    }
    
    
    func receiveRide(from src: String, to dest: String, at dateAndTime: NSDate, withWheelchair needsWheelchair: Bool) {
        Debug.log("->receiveRide in PAVC")
        // Save the new ride in the database.
        
    }
}
