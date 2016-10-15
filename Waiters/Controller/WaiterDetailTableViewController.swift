//
//  WaiterDetailTableViewController.swift
//  Waiters
//
//  Created by Lucas Dilts on 2016-10-13.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import MessageUI

/*
 0. Profile picture header
 1. Name + crumbs
 2. Phone
 3. E-mail
 */

typealias Tag = Int

enum WaiterDetailCellType: Tag {
    case header = 1
    case name = 2
    case phone = 3
    case email = 4
}

class WaiterDetailTableViewController: UITableViewController {
    
    var coreDataStack: CoreDataStack!
    var waiter: Waiter!
    
    var sortedShifts: [Shift] = [Shift]()
    
    var cellTypesForDisplay: [WaiterDetailCellType] = [WaiterDetailCellType]()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
//        self.title = self.waiter?.name ?? "Waiter"
        
        self.tableView.estimatedRowHeight = 110.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let uWaiter = self.waiter {
            self.sortShifts(forWaiter: uWaiter)
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.waiter.shifts.count > 0 {
            return 2
        }
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.calculateNumberOfRows() : self.waiter.shifts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let uWaiter = self.waiter {
            if indexPath.section == 0 {
                
                let cellType: WaiterDetailCellType = self.cellTypesForDisplay[indexPath.row]
                
                switch cellType {
                case .header:
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "waiterDetailHeaderCell",
                                                             for: indexPath) as! WaiterDetailHeaderImageTableViewCell
                    cell.waiter = uWaiter
                    return cell
                    
                case .name:
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "waiterDetailNameCell",
                                                             for: indexPath) as! WaiterDetailNameTableViewCell
                    cell.waiter = uWaiter
                    return cell
                    
                case .phone, .email:
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "waiterDetailActionCell",
                                                             for: indexPath) as! WaiterDetailActionTableViewCell
                    cell.waiter = uWaiter
                    cell.actionType = cellType
                    return cell
                    
                }
                
            } else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "shiftTableViewCell",
                                                         for: indexPath) as! ShiftTableViewCell
                
                let shift: Shift = self.sortedShifts[indexPath.row]
                
                cell.shift = shift
                
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == 1 {
            return true
        }
        
        return false
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
            
            let shift = sortedShifts[indexPath.row]
            
            coreDataStack.managedObjectContext.delete(shift)
            coreDataStack.saveMainContext()
            
            if let uWaiter = self.waiter {
                self.sortShifts(forWaiter: uWaiter)
            }
            
            self.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let cellType: WaiterDetailCellType = self.cellTypesForDisplay[indexPath.row]
            
            switch cellType {
            case .header: return (UIScreen.main.bounds.width * 9) / 16.0 // 16:9 ratio
            case .name: return UITableViewAutomaticDimension
            case .phone, .email: return 60.0
            }
        }
        
        return 86.0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Shifts"
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // TODO: Finish this
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "addShiftSegue", sender: self)
    }
    
    // MARK: - Helper methods
    
    private func calculateNumberOfRows() -> Int {
        var numberOfRows: Int = 0
        self.cellTypesForDisplay.removeAll(keepingCapacity: false)
        
        if let uWaiter = self.waiter {
            if let _ = uWaiter.image {
                numberOfRows += 1
                self.cellTypesForDisplay.append(.header)
            }
            
            numberOfRows += 1
            self.cellTypesForDisplay.append(.name)
            
            if let _ = uWaiter.phone {
                numberOfRows += 1
                self.cellTypesForDisplay.append(.phone)
            }
            
            if let _ = uWaiter.email {
                numberOfRows += 1
                self.cellTypesForDisplay.append(.email)
            }
        }
        
        return numberOfRows
    }

    private func sortShifts(forWaiter waiter: Waiter) {
        self.sortedShifts = waiter.shifts.sorted( by: {
            ($0 as! Shift).startTime.compare(($1 as! Shift).startTime as Date) == .orderedAscending
        } ) as! [Shift]
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            
            switch identifier {
            case "addShiftSegue":
                
                if let destinationViewController = segue.destination as? AddShiftTableViewController {
                    destinationViewController.coreDataStack = self.coreDataStack
                    destinationViewController.waiter = self.waiter
                }
                
                break
            default: break
            }
            
        }
    }
    
    @IBAction func unwindToWaiterDetailTableViewController(segue: UIStoryboardSegue) {
        // This is used in the storyboard file for unwind segues.
    }

}

extension WaiterDetailTableViewController: MFMailComposeViewControllerDelegate {
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self

        mailComposeViewController.setToRecipients(["someone@somewhere.com"])

        return mailComposeViewController
    }

    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Error Sending E-mail", message: "Your device was not able to send an e-mail.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
