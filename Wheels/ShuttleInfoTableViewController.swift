//
//  ShuttleInfoTableViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 11/9/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit

// Aligned with NSCalendar.components representation of weekdays.
enum Weekday: Int {
    case Saturday = 0
    case Sunday = 1
    case Monday = 2
    case Tuesday = 3
    case Wednesday = 4
    case Thursday = 5
    case Friday = 6
}

class ShuttleInfoTableViewController: UITableViewController {
    @IBOutlet weak var serviceHoursTodayLabel: UILabel!
    @IBAction func callDispatcherButtonPressed(_ sender: UIButton) {
        // Call the Special Services Van Dispatcher hotline.
        if let dispatchPhoneNumberURL = URL(string: "tel://\(StoryboardConstants.dispatchPhoneNumber)"),
            UIApplication.shared.canOpenURL(dispatchPhoneNumberURL) {
            UIApplication.shared.open(dispatchPhoneNumberURL, options: [:], completionHandler: nil)
        }
    }
    @IBAction func studentRequestFormButtonPressed(_ sender: UIButton) {
        if let studentRequestFormURL = URL(string: StoryboardConstants.studentRequestFormURL),
            UIApplication.shared.canOpenURL(studentRequestFormURL) {
            UIApplication.shared.open(studentRequestFormURL, options: [:], completionHandler: nil)
        }
    }
    @IBAction func employeeRequestFormButtonPressed(_ sender: UIButton) {
        if let employeeRequestFormURL = URL(string: StoryboardConstants.employeeRequestFormURL),
            UIApplication.shared.canOpenURL(employeeRequestFormURL) {
            UIApplication.shared.open(employeeRequestFormURL, options: [:], completionHandler: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Display today's service hours.
        if isSpecialServicesHoliday(Date()) {
            serviceHoursTodayLabel.text = "Holiday (No Service)"
        } else if let weekday = dayOfWeek() {
            switch weekday {
            case .Saturday, .Sunday:
                serviceHoursTodayLabel.text = "6:00PM - 7:30 AM"
            default:
                serviceHoursTodayLabel.text = "24-Hour Service"
            }
        }
    }

    // TODO: Parse holidays.
    private func isSpecialServicesHoliday(_ date: Date) -> Bool {
        return false
    }
 
    private func dayOfWeek() -> Weekday? {
        let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let dateComponents = gregorianCalendar.components(.weekday, from: Date())
        if let dayOfWeek = dateComponents.weekday {
            return Weekday(rawValue: dayOfWeek)
        } else {
            return nil
        }
    }
}
