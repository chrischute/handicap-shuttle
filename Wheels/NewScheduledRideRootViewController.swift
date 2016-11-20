//
//  NewScheduledRideRootViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 10/31/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit

class NewScheduledRideRootViewController: UIViewController, UIBarPositioningDelegate, NewScheduledRideReceiving {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var fromAddress = ""
    var toAddress = ""
    var dateAndTime = NSDate.init(timeIntervalSinceNow: 0)
    var needsWheelchair = true
    
    /**
     * Pass data up when the done button is pressed. Then unwind the segue.
     */
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        rideDataReceiver?.receiveRide(from: fromAddress, to: toAddress, at: dateAndTime, withWheelchair: needsWheelchair)
        
        performSegue(withIdentifier: StoryboardConstants.unwindDoneNewScheduledRideSegueId, sender: self)
    }
    
    weak var rideDataReceiver: NewScheduledRideReceiving?

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
    
    /**
     * Passing data back through the view controllers.
     */
    // Set self as delegate to receive data from the contained static table view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set self as delegate to receive data about the new scheduled ride.
        if segue.identifier == StoryboardConstants.embedTableViewControllerSegueId {
            if let dest = segue.destination as? NewScheduledRideTableViewController {
                dest.rideDataReceiver = self
            }
        }
    }
    // When data is passed up from the contained table view, save it at this level.
    func receiveRide(from src: String, to dest: String, at dateAndTime: NSDate, withWheelchair needsWheelchair: Bool) {
        self.fromAddress = src
        self.toAddress = dest
        self.dateAndTime = dateAndTime
        self.needsWheelchair = needsWheelchair
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
