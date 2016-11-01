//
//  NewScheduledRideTableViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 10/31/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit

class NewScheduledRideTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var pickupLocationTextField: UITextField!
    @IBOutlet weak var dropoffLocationTextField: UITextField!
    @IBOutlet weak var dateAndTimePicker: UIDatePicker!
    @IBOutlet weak var needsWheelchairSwitch: UISwitch!
    
    // Notify the parent controller whenever a value changes.
    @IBAction func rideLocationChanged(_ sender: UITextField) {
        notifyParentViewController()
    }
    @IBAction func rideTimeChanged(_ sender: UIDatePicker) {
        notifyParentViewController()
    }
    @IBAction func rideAccessibilityChanged(_ sender: UISwitch) {
        notifyParentViewController()
    }
    
    weak var rideDataReceiver: NewScheduledRideReceiving?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dismiss the keyboard when tapping outside its bounds.
        setKeyboardAutoHiding(true)
    }

    private func notifyParentViewController() {
        rideDataReceiver?.receiveRide(from: pickupLocationTextField.text!,
                                      to: dropoffLocationTextField.text!,
                                      at: dateAndTimePicker.date as NSDate,
                                      withWheelchair: needsWheelchairSwitch.isOn)
    }
    
    /**
     * Move to next text field on return from netId field.
     * Move to segue on return from password field.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.pickupLocationTextField {
            self.dropoffLocationTextField.becomeFirstResponder()
        }
        
        return true
    }
}
