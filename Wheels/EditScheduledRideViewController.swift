//
//  EditScheduledRideViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 11/2/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit

class EditScheduledRideViewController: UIViewController, UIBarPositioningDelegate, RideCancellationReceiving {
    @IBOutlet weak var doneButton: UIBarButtonItem!

    // Ride state for passing edited ride data back and forth.
    var rideCancellationReceiver: RideCancellationReceiving!
    var fromAddress = ""
    var toAddress = ""
    var dateAndTime = NSDate.init(timeIntervalSinceNow: 0)
    var needsWheelchair = true
    
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        // Unwind to main schedule.
        performSegue(withIdentifier: StoryboardConstants.unwindEditScheduledRideSegueId, sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make fonts of 'Edit' and 'Done' match rest of app (Avenir).
        doneButton.setTitleTextAttributes(
            [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 17)!, NSForegroundColorAttributeName: UIColor.white],
            for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardConstants.embedEditRideTableViewSegueId {
            if let dest = segue.destination as? EditScheduledRideTableViewController {
                dest.fromAddress = self.fromAddress
                dest.toAddress = self.toAddress
                dest.dateString = StoryboardConstants.standardDateFormatter.string(from: self.dateAndTime as Date)
                dest.needsWheelchair = self.needsWheelchair
                
                dest.rideCancellationReceiver = self
            }
        }
    }
    
    func cancelRide() {
        rideCancellationReceiver.cancelRide()
        
        performSegue(withIdentifier: StoryboardConstants.unwindEditScheduledRideSegueId, sender: self)
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
