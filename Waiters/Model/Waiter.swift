//
//  Waiter+CoreDataClass.swift
//  Waiters
//
//  Created by Lucas Dilts on 2016-10-13.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import Foundation
import CoreData


public class Waiter: NSManagedObject {
    
    // Used for section headers
    lazy var firstLetterOfFirstName: String = {
        let result = self.name.uppercased()
        return String(result[result.startIndex])
    }()

}
