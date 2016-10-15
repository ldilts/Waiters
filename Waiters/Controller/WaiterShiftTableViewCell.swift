//
//  WaiterShiftTableViewCell.swift
//  Waiters
//
//  Created by Lucas Dilts on 2016-10-15.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

class WaiterShiftTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    var shift: Shift! {
        didSet {
            configureUI()
        }
    }
    
    // MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Helper methods
    
    private func configureUI() {
        
        
        if let uShift = self.shift {
            
            if let waiter = uShift.owner {
                
                self.profileImageView.image = waiter.image
                self.nameLabel.text = waiter.name
                
                let shiftCount = waiter.shifts.count
                let shiftText = shiftCount == 1 ? "Shift" : "Shifts"
                
                self.detailLabel.text = "\(shiftCount) \(shiftText)"
            }
            
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.long
            formatter.timeStyle = DateFormatter.Style.short
            
            let startTimeString = formatter.string(from: uShift.startTime as Date)
            let endTimeString = formatter.string(from: uShift.endTime as Date)
            
            self.startTimeLabel.text = startTimeString
            self.endTimeLabel.text = endTimeString
        }
    }

}
