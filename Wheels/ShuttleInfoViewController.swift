//
//  QueueViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 10/30/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit

class ShuttleInfoViewController: UIViewControllerWithRider, UIBarPositioningDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
     * Set the navigation bar to extend under the status bar.
     */
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    // Unwind from the settings page back to shuttle info.
    @IBAction func unwindFromSettingsToShuttleInfoView(segue: UIStoryboardSegue) {
        // Do nothing.
    }
}
