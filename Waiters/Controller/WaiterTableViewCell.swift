//
//  WaiterTableViewCell.swift
//  Waiters
//
//  Created by Lucas Dilts on 2016-10-14.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

class WaiterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var waiter: Waiter! {
        didSet {
            self.configureUI()
        }
    }
    
    // MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.profileImageView.image = nil
        self.nameLabel.text = ""
        self.detailLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Helper methods
    
    private func configureUI() {
        if let uWaiter = waiter {
            
            self.profileImageView.image = uWaiter.image
            self.nameLabel.text = uWaiter.name
            
            let shiftCount = uWaiter.shifts.count
            let shiftText = shiftCount == 1 ? "Shift" : "Shifts"
            
            self.detailLabel.text = "\(shiftCount) \(shiftText)"
        }
    }

}
