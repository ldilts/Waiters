//
//  WaiterDetailNameTableViewCell.swift
//  Waiters
//
//  Created by Lucas Dilts on 2016-10-14.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

class WaiterDetailNameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var detailLabel: UILabel!
    
    var waiter: Waiter! {
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
        if let uWaiter = self.waiter {
            self.nameLabel.text = uWaiter.name
            
//            if let birthday = uWaiter.birthday {
//                
//                let formatter = DateFormatter()
//                formatter.dateStyle = DateFormatter.Style.long
//                
//                let dateString = formatter.string(from: (birthday as Date))
//                
//                self.detailLabel.text = "Birthday: \(dateString)"
//            } else {
//                self.detailLabel.text = nil
//            }
        }
        
        
    }

}
