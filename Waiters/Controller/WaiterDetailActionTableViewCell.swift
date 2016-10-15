//
//  WaiterDetailActionTableViewCell.swift
//  Waiters
//
//  Created by Lucas Dilts on 2016-10-14.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

class WaiterDetailActionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var actionTitleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var waiter: Waiter!
    
    var actionType: WaiterDetailCellType! {
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
    
    // MARK: - Actions
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        if let uWaiter = waiter {
            if let cellType = self.actionType {
                switch cellType {
                case .phone:
                    let phone = "tel://\(uWaiter.phone!)"
                    UIApplication.shared.open(URL(string: phone)!, options: [:], completionHandler: nil)
                    break
                case .email:
//                    UIApplication.shared.open(uBusiness.url, options: [:], completionHandler: nil)
                    break
                default: break
                }
            }
        }
    }
    
    // MARK: - Helper methods
    
    private func configureUI() {
        if let uWaiter = self.waiter {
            if let uActionType = self.actionType {
                
                switch uActionType {
                case .phone:
                    self.actionTitleLabel.text = uWaiter.phone ?? ""
                    if let image = UIImage(named: "Phone Button Icon") {
                        self.actionButton.setImage(image, for: .normal)
                    }
                    break
                case .email:
                    self.actionTitleLabel.text = uWaiter.email ?? ""
                    if let image = UIImage(named: "Email Button Icon") {
                        self.actionButton.setImage(image, for: .normal)
                    }
                    break
                default: break // Type not supported
                }
                
            }
        }
    }
}
