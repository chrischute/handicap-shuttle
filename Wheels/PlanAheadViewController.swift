//
//  PlanAheadViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 10/30/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit
import CoreData

class PlanAheadViewController: UIViewControllerWithRider, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIBarPositioningDelegate, NewScheduledRideReceiving {
    var fetchedResultsController: NSFetchedResultsController<Ride>!
    @IBOutlet weak var newScheduledRideButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        newScheduledRideButton.setTitleTextAttributes(
            [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 17)!, NSForegroundColorAttributeName: UIColor.white],
            for: UIControlState.normal)
        
        initializeFetchedResultsController()
        
        super.viewDidLoad()
    }
    
    /**
     * NSFetchedResultsController for managing rides on Core Data.
     */
    func initializeFetchedResultsController() {
        let ridesRequest: NSFetchRequest<Ride> = Ride.fetchRequest()
        
        // We request future rides associated with the rider that's logged in.
        let currentDateAndTime = NSDate.init(timeIntervalSinceNow: 0)
        ridesRequest.predicate = NSPredicate(format: "rider.netId == %@ and dateAndTime >= %@", rider.netId!, currentDateAndTime)
        ridesRequest.sortDescriptors = [NSSortDescriptor(key: "dateAndTime", ascending: true)]

        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: ridesRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: "rootCache")
        self.fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch let error {
            Debug.log("Error fetching in NSFetchedResultsController initialization: \(error)")
        }
    }
    
    /**
     * Receive the data for a new scheduled ride. Add it to the database.
     */
    func receiveRide(from src: String, to dest: String, at dateAndTime: NSDate, withWheelchair needsWheelchair: Bool) {
        if let ride = NSEntityDescription.insertNewObject(forEntityName: "Ride", into: moc) as? Ride {
            ride.fromAddress = src
            ride.toAddress = dest
            ride.dateAndTime = dateAndTime
            ride.needsWheelchair = needsWheelchair
            ride.rider = self.rider
            
            do {
                try moc.save()
            } catch let error {
                Debug.log("Error inserting new ride: \(error)")
            }
        }
    }
    
    /**
     * UITableViewDataSource implementation.
     */
    private func configureCell(cell: ScheduledRideTableViewCell, indexPath: IndexPath) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a' on 'EEEE, MM/dd/yy"
        
        let ride = fetchedResultsController.object(at: indexPath)
        cell.toAddressLabel.text = ride.toAddress
        cell.fromAddressLabel.text = ride.fromAddress
        cell.dateAndTimeLabel.text = formatter.string(from: ride.dateAndTime! as Date)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardConstants.scheduledRideCellId, for: indexPath)
        if let rideCell = cell as? ScheduledRideTableViewCell {
            configureCell(cell: rideCell, indexPath: indexPath)
            return rideCell
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        }
        Debug.log("Failed to read section \(section) from fetchedResultsController")
        return 0
    }
    
    /**
     * NSFetchedResultsControllerDelegate implementation.
     * Let the FRC tell us when to update the table view.
     */
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet([sectionIndex]), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet([sectionIndex]), with: .fade)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(cell: tableView.cellForRow(at: indexPath!) as! ScheduledRideTableViewCell, indexPath: indexPath!)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    /**
     * Set the navigation bar to extend under the status bar.
     */
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardConstants.newScheduledRideSegueId {
            if let dest = segue.destination as? NewScheduledRideRootViewController {
                dest.rideDataReceiver = self
            }
        }
    }

    /**
     * Unwind to the PlanAheadViewController after pressing 'done'. Nothing to do here.
     */
    @IBAction func unwindDoneNewScheduledRide(from segue: UIStoryboardSegue) { }
}
