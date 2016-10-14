//
//  WaitersTableViewController.swift
//  Waiters
//
//  Created by Lucas Dilts on 2016-10-13.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import CoreData

class WaitersTableViewController: UITableViewController {
    
    var coreDataStack: CoreDataStack!
    var fetchedResultsController: NSFetchedResultsController<Waiter>!
    
    private var selectedIndexPath: IndexPath?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let fetchRequest: NSFetchRequest<Waiter> = Waiter.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.managedObjectContext,
            sectionNameKeyPath: "firstLetterOfFirstName",
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
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name ?? ""
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "waiterCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = fetchedResultsController.object(at: indexPath).name

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Delete the row from the data source
            let waiter = fetchedResultsController.object(at: indexPath)
            coreDataStack.managedObjectContext.delete(waiter)
            coreDataStack.saveMainContext()
            
            reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "waiterDetailSegue", sender: self)
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "addWaiterSegue", sender: self)
    }
    
    // MARK: - Helper methods
    
    private func reloadData(predicate: NSPredicate? = nil) {
        fetchedResultsController.fetchRequest.predicate = predicate
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("There was an error fetching the list of waiters")
        }
        
        tableView.reloadData()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            switch identifier {
            case "waiterDetailSegue":
                guard let uSelectedIndexPath = self.selectedIndexPath else {
                    return
                }
                
                if let destinationViewController = segue.destination as? WaiterDetailTableViewController {
                    
                    destinationViewController.coreDataStack = self.coreDataStack
                    destinationViewController.waiter = fetchedResultsController.object(at: uSelectedIndexPath)
                }
                
            case "addWaiterSegue":
                if let destinationViewController = segue.destination as? AddWaiterTableViewController {
                    
                    destinationViewController.coreDataStack = self.coreDataStack
                }
                
            default: break
            }
        }
    }
    
    @IBAction func unwindToWaitersTableViewController(segue: UIStoryboardSegue) {
        // This is used in the storyboard file for unwind segues.  
    }

}
