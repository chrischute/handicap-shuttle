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
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: StoryboardConstants.unwindEditScheduledRideSegueId, sender: self)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        // Display action sheet asking user to confirm the ride cancellation.
        let cancelController = UIAlertController(title: nil, message: "Are you sure?", preferredStyle: .actionSheet)
        let confirmCancelAction = UIAlertAction(title: "Yes, Cancel Ride", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in self.cancelRide()
        })
        let denyCancelAction = UIAlertAction(title: "No, Don't Cancel Ride", style: .cancel, handler: nil)
        
        cancelController.addAction(confirmCancelAction)
        cancelController.addAction(denyCancelAction)
        
        self.present(cancelController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make font of 'Done' button match rest of app (Avenir).
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
        // Pass information to the embedded table view for display.
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
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: StoryboardConstants.unwindEditScheduledRideSegueId, sender: self)
        }
    }
}
