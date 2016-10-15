//
//  TableSectionHeaderView.swift
//  Waiters
//
//  Created by Lucas Dilts on 2016-10-15.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

class TableSectionHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = ""
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
