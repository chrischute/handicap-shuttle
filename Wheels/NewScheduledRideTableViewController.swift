//
//  NewScheduledRideTableViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 10/31/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit

class NewScheduledRideTableViewController: UITableViewController {
    @IBOutlet weak var pickupLocationTextField: UITextField!
    @IBOutlet weak var dropoffLocationTextField: UITextField!
    @IBOutlet weak var dateAndTimePicker: UIDatePicker!
    @IBOutlet weak var needsWheelchairSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
