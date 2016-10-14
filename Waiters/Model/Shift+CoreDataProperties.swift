//
//  Shift+CoreDataProperties.swift
//  Waiters
//
//  Created by Lucas Dilts on 2016-10-13.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import Foundation
import CoreData

extension Shift {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shift> {
        return NSFetchRequest<Shift>(entityName: "Shift");
    }

    @NSManaged public var endTime: NSDate
    @NSManaged public var startTime: NSDate
    @NSManaged public var owner: Waiter?

}
