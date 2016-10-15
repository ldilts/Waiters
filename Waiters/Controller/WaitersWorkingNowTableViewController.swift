//
//  WaitersWorkingNowTableViewController.swift
//  Waiters
//
//  Created by Lucas Dilts on 2016-10-15.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import CoreData

class WaitersWorkingNowTableViewController: UITableViewController {
    
    var coreDataStack: CoreDataStack!
    var fetchedResultsController: NSFetchedResultsController<Shift>!
    
    private var selectedIndexPath: IndexPath?
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Fetched Results Controller
        
        let fetchRequest: NSFetchRequest<Shift> = Shift.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "startTime", ascending: true)
        ]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "waiterShiftTableViewCell",
                                                 for: indexPath) as! WaiterShiftTableViewCell

        // Configure the cell...
        cell.shift = fetchedResultsController.object(at: indexPath)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146.0
    }
    
    // MARK: - Helper methods
    
    private func reloadData() {
        fetchedResultsController.fetchRequest.predicate = NSPredicate(
            format: "(endTime >= %@) AND (startTime <= %@)", NSDate(), NSDate())
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("There was an error fetching the list of waiters")
        }
        
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
