//
//  PlanAheadViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 10/30/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit

class PlanAheadViewController: UIViewController, UIBarPositioningDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
     * Set the navigation bar to extend under the status bar.
     */
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    /**
     * Unwind to the PlanAheadViewController after pressing 'done'. Add a new scheduled ride.
     */
    @IBAction func unwindAddNewScheduledRide(from segue: UIStoryboardSegue) {
        // Done entering new ride. Save old
    }
    
    /**
     * Unwind to the PlanAheadViewController after pressing 'cancel'. Don't save anything.
     */
    @IBAction func unwindCancelNewScheduledRide(from segue: UIStoryboardSegue) {
        // Cancel was pressed. Do nothing.
    }
    
    
}
