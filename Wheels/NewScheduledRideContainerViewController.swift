//
//  NewScheduledRideContainerViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 11/1/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit

class NewScheduledRideContainerView: UIViewController {
    var pickupLocationTextField: UITextField!
    var dropoffLocationTextField: UITextField!
    var dateAndTimePicker: UIDatePicker!
    var needsWheelchairSwitch: UISwitch!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardConstants.embedTableViewSegueId {
            if let dest = segue.destination as? NewScheduledRideTableViewController {
                self.pickupLocationTextField = dest.pickupLocationTextField
                self.dropoffLocationTextField = dest.dropoffLocationTextField
                self.dateAndTimePicker = dest.dateAndTimePicker
                self.needsWheelchairSwitch = dest.needsWheelchairSwitch
            }
            
        }
    }
}
