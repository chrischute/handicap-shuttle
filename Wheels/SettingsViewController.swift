//
//  SettingsViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 12/14/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIBarPositioningDelegate {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make font 'Done' button match rest of app (Avenir).
        doneButton.setTitleTextAttributes(
            [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 17)!, NSForegroundColorAttributeName: UIColor.white],
            for: UIControlState.normal)
    }
    
    /**
     * Set the navigation bar to extend under the status bar.
     */
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}
