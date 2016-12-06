//
//  PlanAheadViewController.swift
//  Wheels
//
//  Created by Christopher Chute on 10/30/16.
//  Copyright © 2016 Christopher Chute. All rights reserved.
//

import UIKit
import CoreData
import AWSDynamoDB

class PlanAheadViewController: UIViewControllerWithRider, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIBarPositioningDelegate, NewScheduledRideReceiving, RideCancellationReceiving {
    var fetchedResultsController: NSFetchedResultsController<Ride>!
    @IBOutlet weak var newScheduledRideButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        newScheduledRideButton.setTitleTextAttributes(
            [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 17)!, NSForegroundColorAttributeName: UIColor.white],
            for: UIControlState.normal)
        
        initializeFetchedResultsController()
        // Make sure we connect to Dynamo.
        setupTable()
        // Get all the rides for the current rider's netID.
        dynamoSearch(for: self.rider)

        super.viewDidLoad()
    }
    
    // MARK: Synchronize with AWS DynamoDB.
    private func setupTable() {
        // See if the test table exists.
        DynamoDBManager.describeTable()?.continue(with: AWSExecutor.mainThread(), with: { (task: AWSTask!) -> AnyObject! in
            // Display an alert if cannot connect to DynamoDB table.
            if let error = task.error {
                Debug.log("AWS Error: \(error.localizedDescription)")
                
                let alertController = UIAlertController(title: "Cannot Connect to Database", message: "The central server cannot be reached.", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                // TODO: Scan the DynamoDB table for rides. Insert into the local table.
                Debug.log("AWS: Successfully found dynamo table.")
            }
            return nil
        })
    }
    
    // MARK: NSFetchedResultsController for managing rides on Core Data.
    func initializeFetchedResultsController() {
        let ridesRequest: NSFetchRequest<Ride> = Ride.fetchRequest()
        
        // We request future rides associated with the rider that's logged in.
        ridesRequest.predicate = NSPredicate(format: "rider.netId == %@ && dateAndTime > now()", rider.netId!)
        ridesRequest.sortDescriptors = [NSSortDescriptor(key: "dateAndTime", ascending: true)]

        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: ridesRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch let error {
            Debug.log("Error fetching in NSFetchedResultsController initialization: \(error)")
        }
    }
    
    // MARK: Receive the data for a new scheduled ride. Add it to the database.
    func receiveRide(from src: String, to dest: String, at dateAndTime: NSDate, withWheelchair needsWheelchair: Bool) {
        if let ride = NSEntityDescription.insertNewObject(forEntityName: "Ride", into: moc) as? Ride {
            ride.fromAddress = src
            ride.toAddress = dest
            ride.dateAndTime = dateAndTime
            ride.needsWheelchair = needsWheelchair
            ride.rider = self.rider
            ride.guid = NSUUID().uuidString
            
            do {
                try moc.save()
            } catch let error {
                Debug.log("Error inserting new ride: \(error)")
            }
            
            // Send the ride to AWS Dynamo table.
            if let dynamoRide = DynamoDBTableRow.fromRideInfo(ride) {
                dynamoInsertRow(dynamoRide)
            }
        }
    }
    
    // MARK: UITableViewDataSource implementation.
    private func configureCell(cell: ScheduledRideTableViewCell, indexPath: IndexPath) {
        // Fill the cell with ride information.
        let ride = fetchedResultsController.object(at: indexPath)
        cell.toAddressLabel.text = ride.toAddress
        cell.fromAddressLabel.text = ride.fromAddress
        cell.dateAndTimeLabel.text = StoryboardConstants.standardDateFormatter.string(from: ride.dateAndTime! as Date)
        
        // Style the cell.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardConstants.scheduledRideCellId, for: indexPath)
        if let rideCell = cell as? ScheduledRideTableViewCell {
            configureCell(cell: rideCell, indexPath: indexPath)
            return rideCell
        }
        return cell
    }
    
    // MARK: Selecting rows pulls up edit view.
    // View ride details when a row is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Debug.log("Row selected in table view.")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: StoryboardConstants.editScheduledRideSegueId, sender: self)
        }
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
    
    func cancelRide() {
        // Delete the ride that was just selected.
        if let indexPath = tableView.indexPathForSelectedRow {
            moc.delete(fetchedResultsController.object(at: indexPath))
        } else {
            Debug.log("No selected row when trying to delete a ride.")
        }
    }
    
    // MARK: NSFetchedResultsControllerDelegate implementation.
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

    // Set the navigation bar to extend under the status bar.
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryboardConstants.newScheduledRideSegueId {
            if let dest = segue.destination as? NewScheduledRideRootViewController {
                // Tell editing view controller to pass any changes back here.
                dest.rideDataReceiver = self
            }
        } else if segue.identifier == StoryboardConstants.editScheduledRideSegueId {
            if let dest = segue.destination as? EditScheduledRideViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    // Pass ride information to editing view controller.
                    let selectedRide = fetchedResultsController.object(at: indexPath)
                    dest.fromAddress = selectedRide.fromAddress!
                    dest.toAddress = selectedRide.toAddress!
                    dest.dateAndTime = selectedRide.dateAndTime!
                    dest.needsWheelchair = selectedRide.needsWheelchair
                    
                    // Tell editing view controller to pass any changes back here.
                    dest.rideCancellationReceiver = self
                }
            }
        }
    }
    
    // MARK: Dynamo Insert a New Ride
    private func dynamoInsertRow(_ row: DynamoDBTableRow) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        objectMapper.save(row).continue(with: AWSExecutor.mainThread(), with: { (task: AWSTask<AnyObject>!) -> AnyObject! in
            if let error = task.error {
                // Failed to insert row into Dynamo table. Display error.
                Debug.log("AWS Error: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Cannot Insert Ride", message: "Cannot reach central server to insert ride.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                // Successfully inserted row into Dynamo table.
                let alert = UIAlertController(title: "Success", message: "Your ride request has been submitted.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            return nil
        })
    }
    
    // MARK: Dynamo - Search for Rides under this netId.
    private func dynamoSearch(for rider: Rider) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        // Set up the query for all rides with the current user's netID.
        let queryForNetId = AWSDynamoDBQueryExpression()
        queryForNetId.scanIndexForward = true
        queryForNetId.indexName = DynamoDBConstants.netIdIndexName
        queryForNetId.keyConditionExpression = "\(DynamoDBConstants.netIdKeyName) = :riderNetId" // TODO: AND ride didn't already happen?
        queryForNetId.expressionAttributeValues = [
            ":riderNetId" : rider.netId!
        ]
        
        // Execute the query for all rides with the current user's netID.
        objectMapper.query(DynamoDBTableRow.self, expression: queryForNetId).continue({ (task: AWSTask<AWSDynamoDBPaginatedOutput>!) -> AnyObject! in
            if let error = task.error {
                Debug.log("Query Error: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Cannot Connect to Server", message: "Cannot connect to central server.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                if let result = task.result {
                    // Insert all fetched rows into our table.
                    for fetchedRow in result.items {
                        if let row = fetchedRow as? DynamoDBTableRow {
                            if let fromAddress = row.fromAddress,
                                let toAddress = row.toAddress,
                                let pickupTime = row.pickupTime,
                                let needsWheelchairNSNumber = row.needsWheelchair,
                                let guid = row.guid {
                                if let epoch = Double(pickupTime) {
                                    let dateAndTime = NSDate(timeIntervalSince1970: TimeInterval(epoch))
                                    _ = Ride.rideInDatabase(for: self.rider, from: fromAddress, to: toAddress, at: dateAndTime, withWheelchair: Bool(needsWheelchairNSNumber), guid: guid, in: self.moc)
                                }
                            }
                        }
                    }
                }
            }
            // We don't use the return value from this task.
            return nil
        })
    }

    // Unwind to the PlanAheadViewController after pressing 'done'.
    @IBAction func unwindDoneNewScheduledRide(from segue: UIStoryboardSegue) {
        // Do nothing.
    }
}
