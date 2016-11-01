//
//  NewScheduledRideRootViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 10/31/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit

class NewScheduledRideRootViewController: UIViewController, UIBarPositioningDelegate {
    @IBOutlet weak var containedSubview: UIView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Make fonts of 'Cancel' and 'Done' match rest of app (Avenir).
        doneButton.setTitleTextAttributes(
            [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 17)!, NSForegroundColorAttributeName: UIColor.white],
            for: UIControlState.normal)
        cancelButton.setTitleTextAttributes(
            [NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 17)!, NSForegroundColorAttributeName: UIColor.white],
            for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * Set the navigation bar to extend under the status bar.
     */
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
