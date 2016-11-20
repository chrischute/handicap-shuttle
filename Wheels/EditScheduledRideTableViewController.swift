//
//  EditScheduledRideTableViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 11/2/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit

class EditScheduledRideTableViewController: UITableViewController {
    @IBOutlet weak var pickupLocationLabel: UILabel!
    @IBOutlet weak var dropoffLocationLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var needsWheelchairLabel: UILabel!
    

    var fromAddress = ""
    var toAddress = ""
    var dateString = ""
    var needsWheelchair = true
    
    var rideCancellationReceiver: RideCancellationReceiving!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickupLocationLabel.text = fromAddress
        dropoffLocationLabel.text = toAddress
        dateAndTimeLabel.text = dateString
        needsWheelchairLabel.text = (needsWheelchair ? "Needs Wheelchair-Accessible Van" : "No Requirements")
    }
}
