//
//  EntityExtensions.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 27/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//

import Foundation

extension Store {
    
    /// Insert data into Store Entity object
    ///
    /// - Parameter storeData: data to insert
    func insertIntoDB(storeData:StoreInfo) {
        branchStatus = storeData.branchStatus
        cntrCurrency = storeData.cntrCurrency
        openingStatus = storeData.openingStatus
        rDeliveryCharge = storeData.rDeliveryCharge
        rDeliveryTime = storeData.rDeliveryTime
        rId = storeData.rId
        rMinOrderAmt = storeData.rMinOrderAmt
        rName = storeData.rName
        workingHour = storeData.workingHour
        rImage = storeData.rImage
    }
}

extension Category {
    /// Insert data into Category Entity object
    ///
    /// - Parameter categoryData: data to insert
    func insertIntoDB(categoryData:CategoryInfo) {
        mastMId = categoryData.mastMId
        menuCatId = categoryData.menuCatId
        menuName_eng = categoryData.menuName_eng
        
        guard let itemInfoObj = categoryData.menuArray else { return }
        var i = 0
        for item in  itemInfoObj {
            print("item \(i+1)")
            let newItem : Item = CoreDataHelper.insertManagedObject("Item") as! Item
            newItem.insertIntoDB(itemData: item, category: self)
            i += 1
        }
    }
}

extension Item {
    /// Insert data into Item Entity object
    ///
    /// - Parameter itemData: data to insert
    func insertIntoDB(itemData:ItemInfo,category: Category) {
        itemDesc_eng = itemData.itemDesc_eng
        itemFoodType = itemData.itemFoodType
        itemId = itemData.itemId
        itemImage = itemData.itemImage
        itemMinQty = itemData.itemMinQty
        itemName_eng = itemData.itemName_eng
        itemPrice = itemData.itemPrice
        logoImage = itemData.logoImage
        status = itemData.status
        self.category = category
    }
}


