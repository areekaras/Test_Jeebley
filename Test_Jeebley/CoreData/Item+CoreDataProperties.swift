//
//  Item+CoreDataProperties.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 27/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var itemDesc_eng: String?
    @NSManaged public var itemFoodType: String?
    @NSManaged public var itemId: String?
    @NSManaged public var itemImage: String?
    @NSManaged public var itemMinQty: String?
    @NSManaged public var itemName_eng: String?
    @NSManaged public var itemPrice: String?
    @NSManaged public var logoImage: String?
    @NSManaged public var status: String?
    @NSManaged public var category: Category?

}
