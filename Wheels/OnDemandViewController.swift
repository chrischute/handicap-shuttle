//
//  OnDemandViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 10/30/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import AWSDynamoDB
import UIKit
import MapKit

class OnDemandViewController: UIViewControllerWithRider, UIBarPositioningDelegate, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
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
            let initialMapRegion = MKCoordinateRegionMake(initialMapCenter, initialMapSpan)
            mapView.setRegion(initialMapRegion, animated: true)
        }
    }
    // MARK: Address Entry Outlets
    @IBOutlet weak var fromAddressTextField: UITextField!
    @IBOutlet weak var toAddressTextField: UITextField!
    @IBOutlet weak var fromAddressView: UIView!
    @IBOutlet weak var toAddressView: UIView!
    @IBOutlet weak var requestRideView: UIView!
    @IBOutlet weak var requestRideButton: UIButton!
    @IBOutlet weak var zoomToUserLocationView: UIView!
    @IBOutlet weak var userLocationButton: UIButton!
    @IBAction func zoomToUserLocation(_ sender: UIButton) {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            let alert = UIAlertController(title: "Location Not Enabled", message: "To use your GPS location, you must enable Location Services for Wheels.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else if let userCoordinate = mapView.userLocation.location?.coordinate {
            // Zoom to the user's location.
            let initialMapSpan = MKCoordinateSpanMake(StoryboardConstants.initialMapViewWidth,
                                                      StoryboardConstants.initialMapViewHeight)
            let centeredOnUser = MKCoordinateRegionMake(userCoordinate, initialMapSpan)
            mapView.setRegion(centeredOnUser, animated: true)
            // Set the pickup address to the user's location.
            editAddressDidBegin(fromAddressTextField)
            fromAddressTextField.text = "Current Location"
            editAddressDidChange(fromAddressTextField)
            editAddressDidEnd(fromAddressTextField)
        }
    }
    
    // MARK: Address Entry Actions
    @IBAction func requestRidePressed(_ sender: UIButton) {
        // TODO: Get accessibility using a switch instead of an alert?
        let alert = UIAlertController(title: "Wheelchair", message: "Do you need a wheelchair-accessible van?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .cancel, handler: { (action: UIAlertAction) in
            self.requestRideOnDemand(needsWheelchair: true)
        })
        let noAction = UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction) in
            self.requestRideOnDemand(needsWheelchair: false)
        })
        alert.addAction(noAction)
        alert.addAction(yesAction)
        present(alert, animated: true, completion: nil)
    }
    @IBAction func editAddressDidChange(_ sender: UITextField) {
        if sender == fromAddressTextField {
            Debug.log("From address: \(fromAddressTextField.text!)")
        } else if sender == toAddressTextField {
            Debug.log("To address: \(toAddressTextField.text!)")
        }

        // Enable ride request button if there's text in both address fields,
        // otherwise disable it. Fade in the effect of enabling or disabling.
        // Aqua color has (R = 41, G = 157, B = 242).
        if let fromAddressChars = fromAddressTextField.text?.characters,
            let toAddressChars = toAddressTextField.text?.characters {
            if fromAddressChars.count > 0 && toAddressChars.count > 0 {
                if !requestRideButton.isEnabled {
                    requestRideButton.isEnabled = true
                    UIView.animate(withDuration: 0.5,
                                   delay: 0,
                                   options: UIViewAnimationOptions.allowUserInteraction,
                                   animations: { self.requestRideView.backgroundColor = UIColor(hexValue: StoryboardConstants.aquaColorHexValue).withAlphaComponent(1.0) },
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
            if let fromAddress = fromAddressTextField.text {
                if fromAddress == "Current Location" {
                    fromAddressTextField.textColor = UIColor(hexValue: StoryboardConstants.aquaColorHexValue)
                } else {
                    fromAddressTextField.textColor = UIColor.black
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
        
        // Set up user location management.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        // Round the corners of address fields and button.
        fromAddressView.layer.cornerRadius = 5
        fromAddressView.layer.masksToBounds = true
        toAddressView.layer.cornerRadius = 5
        toAddressView.layer.masksToBounds = true
        requestRideView.layer.cornerRadius = 5
        requestRideView.layer.masksToBounds = true
        zoomToUserLocationView.layer.cornerRadius = 5
        zoomToUserLocationView.layer.masksToBounds = true
        
        // Make keyboard disappear when tapping outside its bounds.
        setKeyboardAutoHiding(true)
        
        // Color the user location button.
        let currentLocationImage = UIImage(named: "CurrentLocation");
        let tintedImage = currentLocationImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        userLocationButton.setImage(tintedImage, for: UIControlState.normal)
        userLocationButton.tintColor = UIColor(hexValue: StoryboardConstants.aquaColorHexValue)
    }
    
    private func requestRideOnDemand(needsWheelchair: Bool) {
        // Add the ride to t
        if var fromAddress = fromAddressTextField.text, let toAddress = toAddressTextField.text {
            // Check if request is based on user's current location.
            if fromAddress == "Current Location" {
                if let userCoordinate = mapView.userLocation.location?.coordinate {
                    fromAddress = "GPS(\(userCoordinate.latitude),\(userCoordinate.longitude))"
                }
            }
            // Insert ride in database, pickup time initializes to 5 min from now.
            if let onDemandRide = Ride.rideInDatabase(for: self.rider, from: fromAddress, to: toAddress, at: NSDate.init(timeIntervalSinceNow: StoryboardConstants.secondsUntilPickupForOnDemandRide), withWheelchair: needsWheelchair, guid: nil, in: self.moc) {
                // Ride created locally, now send it to the DynamoDB table.
                if let onDemandRideRow = DynamoDBTableRow.fromRideInfo(onDemandRide) {
                    dynamoInsertRow(onDemandRideRow)
                }
            }
        }
        // Clear the text fields.
        fromAddressTextField.text = ""
        editAddressDidChange(fromAddressTextField)
        editAddressDidEnd(fromAddressTextField)
        toAddressTextField.text = ""
        editAddressDidChange(toAddressTextField)
        editAddressDidEnd(toAddressTextField)
        toAddressTextField.resignFirstResponder()
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
    
    // MARK: Dynamo Insert a New Ride
    private func dynamoInsertRow(_ row: DynamoDBTableRow) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        // Try saving this row in the DynamoDB rides table.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        objectMapper.save(row).continue(with: AWSExecutor.mainThread(), with: { (task: AWSTask<AnyObject>!) -> AnyObject! in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let error = task.error {
                // Failed to insert row into Dynamo table. Display error.
                Debug.log("AWS Error: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Cannot Insert Ride", message: "Cannot reach central server to insert ride.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                // Successfully inserted row into Dynamo table.
                let alert = UIAlertController(title: "Success", message: "Your ride request has been submitted. You will be notified when your driver is en route.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            return nil
        })
    }
    
    // MARK: CLLocationManagerDelegate Implementation
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Show the user location if authorized.
        self.mapView.showsUserLocation = (status == .authorizedWhenInUse)
    }
}
