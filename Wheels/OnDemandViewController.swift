//
//  OnDemandViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 10/30/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit
import MapKit

class OnDemandViewController: UIViewControllerWithRider, UIBarPositioningDelegate, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    var locationManager: CLLocationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            // Initialize to standard view with VC as delegate.
            mapView.mapType = .standard
            mapView.delegate = self
            // Set the initial map frames to Yale's campus. Show user's location.
            let initialMapCenter = CLLocationCoordinate2DMake(StoryboardConstants.sterlingMemorialLibraryLatitude,
                                                              StoryboardConstants.sterlingMemorialLibraryLongitude)
            let initialMapSpan = MKCoordinateSpanMake(StoryboardConstants.initialMapViewWidth,
                                                      StoryboardConstants.initialMapViewHeight)
            mapView.setRegion(MKCoordinateRegionMake(initialMapCenter, initialMapSpan), animated: true)
            mapView.showsUserLocation = true
            mapView.showsCompass = true
        }
    }
    // MARK: Address Entry Outlets
    @IBOutlet weak var fromAddressTextField: UITextField!
    @IBOutlet weak var toAddressTextField: UITextField!
    @IBOutlet weak var fromAddressView: UIView!
    @IBOutlet weak var toAddressView: UIView!
    @IBOutlet weak var requestRideView: UIView!
    @IBOutlet weak var requestRideButton: UIButton!
    
    
    // MARK: Address Entry Actions
    @IBAction func requestRidePressed(_ sender: UIButton) {
        // TODO: Get accessibility for on-demand rides.
        let needsWheelchair = true
        
        if let fromAddress = fromAddressTextField.text, let toAddress = toAddressTextField.text {
            // Insert ride in database.
            _ = Ride.rideInDatabase(for: self.rider, from: fromAddress, to: toAddress, at: NSDate.init(timeIntervalSinceNow: 0), withWheelchair: needsWheelchair, in: self.moc)
            // TODO: Send ride to dispatcher.
            
            // Display an alert notifying that ride will be picked up.
            let requestRideAlert = UIAlertController(title: "Request Pending", message: "Your request is being reviewed.", preferredStyle: .alert)
            requestRideAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(requestRideAlert, animated: true, completion: nil)
        }
    }
    @IBAction func editAddressDidChange(_ sender: UITextField) {
        if sender == fromAddressTextField {
            Debug.log("From address: \(fromAddressTextField.text!)")
        } else if sender == toAddressTextField {
            Debug.log("To address: \(toAddressTextField.text!)")
        }
        
        // Enable ride request button if there's text in both address fields,
        // otherwise disable it. Fade in the effect of enabling or disabling.
        // Aqua color has (R = 0, G = 128, B = 255).
        if let fromAddressChars = fromAddressTextField.text?.characters,
            let toAddressChars = toAddressTextField.text?.characters {
            if fromAddressChars.count > 0 && toAddressChars.count > 0 {
                if !requestRideButton.isEnabled {
                    requestRideButton.isEnabled = true
                    UIView.animate(withDuration: 0.5,
                                   delay: 0,
                                   options: UIViewAnimationOptions.allowUserInteraction,
                                   animations: { self.requestRideView.backgroundColor = UIColor.init(red: (41 / 255.0), green: (157 / 255.0), blue: (242 / 255.0), alpha: 1.0) },
                                   completion: nil)
                }
            } else {
                if requestRideButton.isEnabled {
                    requestRideButton.isEnabled = false
                    UIView.animate(withDuration: 0.5,
                                   delay: 0,
                                   options: UIViewAnimationOptions.allowUserInteraction,
                                   animations: { self.requestRideView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8) },
                                   completion: nil)
                }
            }
        }
    }
    // Fade background from see-through to opaque white when editing.
    @IBAction func editAddressDidBegin(_ sender: UITextField) {
        if sender == fromAddressTextField {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: UIViewAnimationOptions.allowUserInteraction,
                           animations: { self.fromAddressView.backgroundColor = UIColor.white.withAlphaComponent(1.0) },
                           completion: nil)
        } else if sender == toAddressTextField {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: UIViewAnimationOptions.allowUserInteraction,
                           animations: { self.toAddressView.backgroundColor = UIColor.white.withAlphaComponent(1.0) },
                           completion: nil)
        }
    }
    // Fade background from opaque to see-through white when not editing.
    @IBAction func editAddressDidEnd(_ sender: UITextField) {
        if sender == fromAddressTextField {
            if let fromAddressChars = fromAddressTextField.text?.characters {
                if fromAddressChars.count == 0 {
                    UIView.animate(withDuration: 0.5,
                                   delay: 0,
                                   options: UIViewAnimationOptions.allowUserInteraction,
                                   animations: { self.fromAddressView.backgroundColor = UIColor.white.withAlphaComponent(0.8) },
                                   completion: nil)
                }
            }
        } else if sender == toAddressTextField {
            if let toAddressChars = toAddressTextField.text?.characters {
                if toAddressChars.count == 0 {
                    UIView.animate(withDuration: 0.5,
                                   delay: 0,
                                   options: UIViewAnimationOptions.allowUserInteraction,
                                   animations: { self.toAddressView.backgroundColor = UIColor.white.withAlphaComponent(0.8) },
                                   completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round the corners of address fields and button.
        fromAddressView.layer.cornerRadius = 5
        fromAddressView.layer.masksToBounds = true
        toAddressView.layer.cornerRadius = 5
        toAddressView.layer.masksToBounds = true
        requestRideView.layer.cornerRadius = 5
        requestRideView.layer.masksToBounds = true
        
        // Make keyboard disappear when tapping outside its bounds.
        setKeyboardAutoHiding(true)
    }
    
    // MARK: UIBarPositioningDelegate
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.fromAddressTextField {
            self.toAddressTextField.becomeFirstResponder()
        }
        
        return true
    }
}
