//
//  Category+CoreDataProperties.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 27/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var mastMId: String?
    @NSManaged public var menuCatId: String?
    @NSManaged public var menuName_eng: String?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension Category {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
