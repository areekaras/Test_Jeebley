//
//  DBEntityHelpers.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 30/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//

import Foundation
import CoreData

/// DBEntityHelpers to easy access db values
public class DBEntityHelpers {
    public init(){
    
    }
        
    /// get store entities array
    ///
    /// - Returns: store entity array
    public func fetchStoreEntity() -> [Store] {
        let storeList = CoreDataHelper.fetchEntities("Store", withPredicate: [] ,sortkey: nil ,order:nil , limit : nil) as! [Store]
        return storeList
    }
    
    
    /// get Category entity array
    ///
    /// - Returns: Category entity array
    public func fetchCategoryEntity() -> [Category] {
        let categoryList = CoreDataHelper.fetchEntities("Category", withPredicate: [] ,sortkey: nil ,order:nil , limit : nil) as! [Category]
        return categoryList
    }
    
    
    /// inset new Store Entity into DB
    ///
    /// - Parameter storeInfoObj: Store info
    public func saveToDB(storeInfoObj: StoreInfo) {
        let newStore : Store = CoreDataHelper.insertManagedObject("Store") as! Store
        newStore.insertIntoDB(storeData: storeInfoObj)
        CoreDataHelper.saveManagedObjectContext()
    }
    
    
    /// insert Category Entity into DB
    ///
    /// - Parameter categoryInfoObj: Category Info
    public func saveToDB(categoryInfoObj: [CategoryInfo]) {
        var i = 0
        for _category in categoryInfoObj {
            print("category \(i+1)")
            let newCategory : Category = CoreDataHelper.insertManagedObject("Category") as! Category
            newCategory.insertIntoDB(categoryData: _category)
            CoreDataHelper.saveManagedObjectContext()
            i += 1
        }
    }

}
