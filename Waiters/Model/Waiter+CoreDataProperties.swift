//
//  Waiter+CoreDataProperties.swift
//  Waiters
//
//  Created by Lucas Dilts on 2016-10-13.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Waiter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Waiter> {
        return NSFetchRequest<Waiter>(entityName: "Waiter");
    }

    @NSManaged public var name: String
    @NSManaged public var birthday: NSDate?
    @NSManaged public var shifts: NSSet
    @NSManaged public var phone: String?
    @NSManaged public var email: String?
    @NSManaged public var image: UIImage?

}

// MARK: Generated accessors for shifts
extension Waiter {

    @objc(addShiftsObject:)
    @NSManaged public func addToShifts(_ value: Shift)

    @objc(removeShiftsObject:)
    @NSManaged public func removeFromShifts(_ value: Shift)

    @objc(addShifts:)
    @NSManaged public func addToShifts(_ values: NSSet)

    @objc(removeShifts:)
    @NSManaged public func removeFromShifts(_ values: NSSet)

}
