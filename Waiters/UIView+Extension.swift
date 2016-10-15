//
//  UIView+Extension.swift
//  Waiters
//
//  Created by Lucas Dilts on 2016-10-14.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

extension UIView {
    // This adds the corner radius attribute to 
    // the Attributes Inspector in Storyboards
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
}
