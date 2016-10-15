//
//  ShiftTableViewCell.swift
//  Waiters
//
//  Created by Lucas Dilts on 2016-10-15.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

class ShiftTableViewCell: UITableViewCell {
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.startTimeLabel.text = ""
        self.endTimeLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Helper Methods
    
    private func configureUI() {
        if let uShift = self.shift {
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
