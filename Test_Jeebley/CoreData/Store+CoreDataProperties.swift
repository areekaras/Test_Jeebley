//
//  Store+CoreDataProperties.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 27/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//
//

import Foundation
import CoreData


extension Store {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Store> {
        return NSFetchRequest<Store>(entityName: "Store")
    }

    @NSManaged public var branchStatus: String?
    @NSManaged public var cntrCurrency: String?
    @NSManaged public var openingStatus: String?
    @NSManaged public var rDeliveryCharge: String?
    @NSManaged public var rDeliveryTime: String?
    @NSManaged public var rId: String?
    @NSManaged public var rMinOrderAmt: String?
    @NSManaged public var rName: String?
    @NSManaged public var workingHour: String?
    @NSManaged public var rImage: String?

}


