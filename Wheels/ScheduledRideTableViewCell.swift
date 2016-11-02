//
//  ScheduledRideTableViewCell.swift
//  Wheels
//
//  Created by Christopher Chute on 11/1/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit

class ScheduledRideTableViewCell: UITableViewCell {
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
