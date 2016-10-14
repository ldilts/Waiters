//
//  AddShiftTableViewController.swift
//  Waiters
//
//  Created by Lucas Dilts on 2016-10-14.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import CoreData

class AddShiftTableViewController: UITableViewController {
    
    var coreDataStack: CoreDataStack!
    var waiter: Waiter!
    
    @IBOutlet weak var startTimeDatePicker: UIDatePicker!
    @IBOutlet weak var endTimeDatePicker: UIDatePicker!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    private let datePickerCellHeightOpen: CGFloat = 260.0
    private let datePickerCellHeightClosed: CGFloat = 44.0
    
    private var startTimeCellHeight: CGFloat = 44.0
    private var endTimeCellHeight: CGFloat = 44.0
    
    private var isStartTimeCellExpanded: Bool = false
    private var isEndTimeCellExpanded: Bool = false
    
    private var selectedStartTime: Date?
    private var selectedEndTime: Date?
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.startTimeDatePicker.isHidden = true
        self.endTimeDatePicker.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0  {
            return self.startTimeCellHeight
        } else if indexPath.row == 1 {
            return self.endTimeCellHeight
        }
        
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            self.toggleStartDateRowHeight()
        } else if indexPath.row == 1 {
            self.toggleEndDateRowHeight()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        if sender == startTimeDatePicker {
            self.startTimeLabel.textColor = UIColor.black
        } else if sender == endTimeDatePicker {
            self.endTimeLabel.textColor = UIColor.black
        }
        
        // Format the date and time
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = DateFormatter.Style.short
        
        let dateString = formatter.string(from: sender.date)
        
        if sender == startTimeDatePicker {
            self.startTimeLabel.text = dateString
            self.selectedStartTime = sender.date
        } else if sender == endTimeDatePicker {
            self.endTimeLabel.text = dateString
            self.selectedEndTime = sender.date
        }

    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        
        // Is there a selected start time?
        guard let startTime = self.selectedStartTime else {
            let alert = UIAlertController(
                title: "Invalid Start Time",
                message: "A start time is required to register a shift.",
                preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Is there a selected end time?
        guard let endTime = self.selectedEndTime else {
            let alert = UIAlertController(
                title: "Invalid End Time",
                message: "An end time is required to register a shift.",
                preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Is the end time after the start time?
        guard endTime > startTime else {
            let alert = UIAlertController(
                title: "Invalid End Time",
                message: "The shift end time must be after the start time.",
                preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let shiftEntity = NSEntityDescription.entity(forEntityName: "Shift", in: coreDataStack.managedObjectContext) else {
            fatalError("Could not find entity descriptions")
        }
        
        if let uWaiter = self.waiter {
        
            let shift = Shift(entity: shiftEntity, insertInto: coreDataStack.managedObjectContext)
            shift.owner = uWaiter
            shift.startTime = startTime as NSDate
            shift.endTime = endTime as NSDate
            
            coreDataStack.saveMainContext()
        }
        
        self.performSegue(withIdentifier: "unwindToWaiterDetailTableViewController", sender: self)
    }
    
    // MARK: - Helper methods
    
    private func toggleStartDateRowHeight() {
        
        if isEndTimeCellExpanded {
            self.toggleEndDateRowHeight()
        }
        
        // update cell height
        self.startTimeCellHeight = self.isStartTimeCellExpanded ? self.datePickerCellHeightClosed : self.datePickerCellHeightOpen
        
        // toggle bool
        self.isStartTimeCellExpanded = !self.isStartTimeCellExpanded
        
        // Animate tableView
        self.tableView.beginUpdates()
        
        // hide datepicker?
        self.startTimeDatePicker.isHidden = !self.isStartTimeCellExpanded
        
        self.tableView.endUpdates()
    }
    
    private func toggleEndDateRowHeight() {
        
        if isStartTimeCellExpanded {
            self.toggleStartDateRowHeight()
        }
        
        // update cell height
        self.endTimeCellHeight = self.isEndTimeCellExpanded ? self.datePickerCellHeightClosed : self.datePickerCellHeightOpen
        
        // toggle bool
        self.isEndTimeCellExpanded = !self.isEndTimeCellExpanded
        
        // Animate tableView
        self.tableView.beginUpdates()
        
        // hide datepicker?
        self.endTimeDatePicker.isHidden = !self.isEndTimeCellExpanded
        
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
