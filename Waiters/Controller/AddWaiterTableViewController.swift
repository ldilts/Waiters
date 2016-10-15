//
//  AddWaiterTableViewController.swift
//  Waiters
//
//  Created by Lucas Dilts on 2016-10-13.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import CoreData

protocol AddWaiterDelegate: class {
    func updateUI()
}

class AddWaiterTableViewController: UITableViewController, UITextFieldDelegate {
    
    var coreDataStack: CoreDataStack!
    
    weak var addWaiterDelegate: AddWaiterDelegate?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageLabel: UILabel!
    
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
    
    private let imagePicker = UIImagePickerController()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.birthdayDatePicker.isHidden = true
        
        self.imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            if let _ = self.profileImageView.image {
                return (UIScreen.main.bounds.width * 9.0) / 16.0
            }
            
            return 86.0
        }
        
        if indexPath.section == 1 && indexPath.row == 1 {
            // Birthday row height
            return self.birthdayCellHeight
        }

        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
            present(imagePicker, animated: true, completion: nil)
            
            break
        case 1:
            
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
            
        case 2:
            
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
        
        DispatchQueue.global(qos: .default).async {
            
            guard let waiterEntity = NSEntityDescription.entity(forEntityName: "Waiter", in: self.coreDataStack.managedObjectContext) else {
                fatalError("Could not find entity descriptions")
            }
            
            let waiter = Waiter(entity: waiterEntity, insertInto: self.coreDataStack.managedObjectContext)
            waiter.name = name
            waiter.birthday = birthday as NSDate
            
            if let phone = self.phoneTextField.text {
                if phone != "" {
                    waiter.phone = phone
                }
            }
            
            if let email = self.emailTextField.text {
                if email != "" {
                    waiter.email = email
                }
            }
            
            waiter.image = self.profileImageView.image
            
            self.coreDataStack.saveMainContext()
            
            
            DispatchQueue.main.async {
                self.addWaiterDelegate?.updateUI()
            }
        }
        
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

extension AddWaiterTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = pickedImage
            self.profileImageLabel.isHidden = true
            
            self.profileImageView.frame = CGRect(
                x: 0.0,
                y: 0.0,
                width: UIScreen.main.bounds.width,
                height: (UIScreen.main.bounds.width * 9.0) / 16.0)
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
