//
//  OnDemandViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 10/30/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit
import MapKit

class OnDemandViewController: UIViewControllerWithRider, UIBarPositioningDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
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
    // MARK: Address Field Outlets
    @IBOutlet weak var fromAddressTextField: UITextField!
    @IBOutlet weak var toAddressTextField: UITextField!
    @IBOutlet weak var fromAddressView: UIView!
    @IBOutlet weak var toAddressView: UIView!
    
    
    // MARK: Address Field Actions

    @IBAction func editAddressDidChange(_ sender: UITextField) {
        if sender == fromAddressTextField {
            Debug.log("From address: \(fromAddressTextField.text!)")
        } else if sender == toAddressTextField {
            Debug.log("To address: \(toAddressTextField.text!)")
        }
    }
    // Fade background from see-through to opaque white when editing.
    @IBAction func editAddressDidBegin(_ sender: UITextField) {
        if sender == fromAddressTextField {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: UIViewAnimationOptions.allowUserInteraction,
                           animations: { () -> Void in self.fromAddressView.backgroundColor = UIColor.white.withAlphaComponent(1.0) },
                           completion: nil);
        } else if sender == toAddressTextField {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: UIViewAnimationOptions.allowUserInteraction,
                           animations: { () -> Void in self.toAddressView.backgroundColor = UIColor.white.withAlphaComponent(1.0) },
                           completion: nil);
        }
    }
    // Fade background from opaque to see-through white when not editing.
    @IBAction func editAddressDidEnd(_ sender: UITextField) {
        if sender == fromAddressTextField {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: UIViewAnimationOptions.allowUserInteraction,
                           animations: { () -> Void in self.fromAddressView.backgroundColor = UIColor.white.withAlphaComponent(0.9) },
                           completion: nil);
        } else if sender == toAddressTextField {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: UIViewAnimationOptions.allowUserInteraction,
                           animations: { () -> Void in self.toAddressView.backgroundColor = UIColor.white.withAlphaComponent(0.9) },
                           completion: nil);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round the corners of address view displays.
        fromAddressView.layer.cornerRadius = 5
        fromAddressView.layer.masksToBounds = true
        toAddressView.layer.cornerRadius = 5
        toAddressView.layer.masksToBounds = true
    }
    
    /**
     * Set the navigation bar to extend under the status bar.
     */
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}
