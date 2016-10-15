//
//  WaiterDetailHeaderImageTableViewCell.swift
//  Waiters
//
//  Created by Lucas Dilts on 2016-10-14.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

class WaiterDetailHeaderImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerImageView: UIImageView!
    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Helper methods
    
    private func configureUI() {
        if let uWaiter = self.waiter {
            if let image = uWaiter.image {
                self.headerImageView.image = image
            }
        }
    }
}
