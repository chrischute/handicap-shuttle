//
//  OnDemandViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 10/30/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit
import MapKit

class OnDemandViewController: UIViewControllerWithRider, UIBarPositioningDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .standard
            mapView.delegate = self
            
            let initialMapCenter = CLLocationCoordinate2DMake(StoryboardConstants.sterlingMemorialLibraryLatitude,
                                                              StoryboardConstants.sterlingMemorialLibraryLongitude)
            let initialMapSpan = MKCoordinateSpanMake(StoryboardConstants.initialMapViewWidth,
                                                      StoryboardConstants.initialMapViewHeight)
            
            mapView.setRegion(MKCoordinateRegionMake(initialMapCenter, initialMapSpan), animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /**
     * Set the navigation bar to extend under the status bar.
     */
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}
