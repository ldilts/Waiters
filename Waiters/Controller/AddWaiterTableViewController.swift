//
//  AddWaiterTableViewController.swift
//  Waiters
//
//  Created by Lucas Dilts on 2016-10-13.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import CoreData

class AddWaiterTableViewController: UITableViewController, UITextFieldDelegate {
    
    var coreDataStack: CoreDataStack!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    
    private let birthdayCellHeightOpen: CGFloat = 260.0
    private let birthdayCellHeightClosed: CGFloat = 44.0
    
    private var birthdayCellHeight: CGFloat = 44.0
    private var isBirthdayCellExpanded: Bool = false
    
    private var selectedBirthday: Date!
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.birthdayDatePicker.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

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
        
        if indexPath.section == 0 && indexPath.row == 1 {
            // Birthday row height
            return self.birthdayCellHeight
        }

        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            
            switch indexPath.row {
            case 0:
                self.nameTextField.becomeFirstResponder()
                break
            case 1:
                self.toggleBirthdayRowHeight()
                break
            default: break
            }
            
            break
            
        case 1:
            
            switch indexPath.row {
            case 0:
                self.phoneTextField.becomeFirstResponder()
                break
            case 1:
                self.emailTextField.becomeFirstResponder()
                break
            default: break
            }
            
            break
            
        default: break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Text field delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        self.toggleBirthdayRowHeight(true)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.nameTextField: self.phoneTextField.becomeFirstResponder()
        case self.phoneTextField: self.emailTextField.becomeFirstResponder()
        case self.emailTextField: self.hideKeyboard()
        default: self.hideKeyboard()
        }
        
        return true
    }
    
    // MARK: - Actions
    
    @IBAction func birthdayDatePickerValueChanged(_ sender: UIDatePicker) {
        
        self.birthdayLabel.textColor = UIColor.black
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        
        let dateString = formatter.string(from: sender.date)
        
        self.birthdayLabel.text = dateString
        self.selectedBirthday = sender.date
        
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = self.nameTextField.text, self.nameTextField.text != "" else {
            let alert = UIAlertController(
                title: "Invalid Name",
                message: "A name is required to register a new waiter.",
                preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let birthday = self.selectedBirthday else {
            let alert = UIAlertController(
                title: "Invalid Birthday",
                message: "A birthday is required to register a new waiter.",
                preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let waiterEntity = NSEntityDescription.entity(forEntityName: "Waiter", in: coreDataStack.managedObjectContext) else {
            fatalError("Could not find entity descriptions")
        }
        
        let waiter = Waiter(entity: waiterEntity, insertInto: coreDataStack.managedObjectContext)
        waiter.name = name
        waiter.birthday = birthday as NSDate
        
        coreDataStack.saveMainContext()
        
        self.performSegue(withIdentifier: "unwindToWaitersTableViewController", sender: self)
    }
    
    // MARK: - Helper methods
    
    private func hideKeyboard() {
        self.nameTextField.resignFirstResponder()
        self.phoneTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
    }
    
    private func toggleBirthdayRowHeight(_ hidden: Bool = false) {
        self.hideKeyboard()
        
        // update cell height
        self.birthdayCellHeight = self.isBirthdayCellExpanded ? self.birthdayCellHeightClosed : self.birthdayCellHeightOpen
        
        // toggle bool
        self.isBirthdayCellExpanded = !self.isBirthdayCellExpanded
        
        // Animate tableView
        self.tableView.beginUpdates()
        
        // hide datepicker?
        self.birthdayDatePicker.isHidden = !self.isBirthdayCellExpanded
        
        self.tableView.endUpdates()
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
