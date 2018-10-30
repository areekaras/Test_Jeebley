//
//  CoreDataHelper.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 26/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//

import UIKit
import CoreData


/// An NSObject Class to Handle CoreData for developer
open class CoreDataHelper: NSObject {
    
    open static var  managedObjectContext: NSManagedObjectContext? = CoreDataStack.sharedInstance.managedObjectContext
    open class func insertManagedObject(_ entityName:NSString)->AnyObject{
        let managedObject:NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: entityName as String , into: managedObjectContext!) 
        return managedObject
    }
    
    
    /// Function To Save managedObjectContext
    open class func saveManagedObjectContext(){
        var error: NSError?
        do {
            try managedObjectContext!.save()
            print(error?.localizedDescription as Any)
        } catch let error1 as NSError {
            error = error1
            print(error?.localizedDescription as Any)
        }
    }
    
    
    /// Function to delete Managed Object Context
    ///
    /// - Parameter object: object to Delete
    open class func deleteManagedObjectContext(_ object :NSManagedObject) {
       managedObjectContext?.delete(object)
        var error: NSError?
        do {
            try managedObjectContext!.save()
        } catch let error1 as NSError {
            error = error1
            print(error?.localizedDescription as Any)
        }
    }
    
    
   /// Function to get fetchedResultController for required predicates and sort descriptor
   ///
   /// - Parameters:
   ///   - entityName: The name of the entity to fetch
   ///   - sortDescriptors: Sorting Conditions
   ///   - predicate: Predicates array
   ///   - section: section
   /// - Returns: return fetchResultController with entity array
   open class func getFetchedResultControllerFromEntity(_ entityName:String , sortDescriptors:NSArray? ,predicate:[NSPredicate] ,section:String!)->NSFetchedResultsController<NSFetchRequestResult> {
        return CoreDataHelper.fetchResultController(entityName as NSString, batchSize: 20, sortDescriptor: sortDescriptors,predicate: predicate , section:section)
    }

    
    /// Function to entities array from DB
    ///
    /// - Parameters:
    ///   - entityName: name of entity
    ///   - predicate: predicates array
    ///   - sortkey: sort condition`
    ///   - order: ascending or descending
    ///   - limit: set limit to fetch
    /// - Returns: returns entity array
    open class func fetchEntities(_ entityName:NSString, withPredicate predicate:[NSPredicate],sortkey:String!,order:Bool!, limit:Int!)->NSArray{
        let fetchRequest:NSFetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entetyDescription:NSEntityDescription = NSEntityDescription.entity(forEntityName: entityName as String, in: managedObjectContext!)!
        
        fetchRequest.entity = entetyDescription
        if (predicate.count != 0){
            let compound = NSCompoundPredicate(andPredicateWithSubpredicates:predicate)
            fetchRequest.predicate = compound
        }
        if((sortkey) != nil)
        {
            let sortDescriptor = NSSortDescriptor(key: sortkey, ascending: order)
            let sortDescriptors = [sortDescriptor]
            fetchRequest.sortDescriptors = sortDescriptors
        }
        if((limit) != nil)
        {
            fetchRequest.fetchLimit = limit
        }
        fetchRequest.returnsObjectsAsFaults = false
        
        let items:NSArray = try! managedObjectContext! .fetch(fetchRequest) as NSArray
        return items
    }
    
    
   /// Function to entities array from DB
   ///
   /// - Parameters:
   ///   - entityName: name of entity
   ///   - sortDescriptor: Sorting Conditions
   /// - Returns: returns entity array
   open  class func fetchEntities(_ entityName:NSString, withSortDescriptors sortDescriptor:NSArray?)->NSArray {
    
    let fetchRequest  = NSFetchRequest<NSFetchRequestResult>()
        let entetyDescription:NSEntityDescription = NSEntityDescription.entity(forEntityName: entityName as String, in: managedObjectContext!)!
    
        fetchRequest.entity = entetyDescription
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = sortDescriptor as? [NSSortDescriptor]
        }else {
            fetchRequest.sortDescriptors = []
        }
        fetchRequest.returnsObjectsAsFaults = false
        let items:NSArray = try! managedObjectContext! .fetch(fetchRequest) as NSArray
        
        return items  
    }
    
    
    /// Function to get fetchedResultController for required predicates and sort descriptor with batch size
    ///
    /// - Parameters:
    ///   - entityName: name of entity
    ///   - batchSize: batch size of entity
    ///   - sortDescriptor: Sorting Conditions
    ///   - predicate: predicates array
    ///   - section: section
    /// - Returns: return fetchResultController with entity array
    open class func fetchResultController(_ entityName:NSString,batchSize:Int8,sortDescriptor:NSArray?,predicate:[NSPredicate],section:String!) -> NSFetchedResultsController<NSFetchRequestResult> {
        var _fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult>?
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription:NSEntityDescription = NSEntityDescription.entity(forEntityName: entityName as String, in: managedObjectContext!)!
        fetchRequest.entity = entityDescription
        fetchRequest.fetchBatchSize = Int(batchSize)
        if (predicate.count != 0){
            let compound = NSCompoundPredicate(andPredicateWithSubpredicates: predicate)
            fetchRequest.predicate = compound
        }
        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = sortDescriptor as? [NSSortDescriptor]
        }else {
            fetchRequest.sortDescriptors = []
        }
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext!,
            sectionNameKeyPath: section,
            cacheName: nil)
        _fetchedResultsController = frc
        do {
            try _fetchedResultsController!.performFetch()
        } catch _ as NSError {
            print("fetchResultController Error!")
            abort()
        }
        return _fetchedResultsController!
    }

    
    /// Function to reset data store
    ///
    /// - Parameter storeCordinator: store cordinator
    open class func clearDataStore(_ storeCordinator:NSPersistentStoreCoordinator?) {
       let storeCordinator:NSPersistentStoreCoordinator = storeCordinator!
        let store:NSPersistentStore = storeCordinator.persistentStores[0] 
        let storeUrl:URL = store.url!
        print(storeUrl.path)
        do {
            try storeCordinator.remove(store)
        } catch _ {
        }
        do {
            try FileManager.default.removeItem(atPath: storeUrl.path)
        } catch _ {
        } 
    }
    
    
    /// Clear All Entities
    open class func clearStore() {
        let predicates = [NSPredicate]()
        deleteEntityFromDB(entityName: [Entities.STORE.rawValue,
                                        Entities.CATEGORY.rawValue,
                                        Entities.ITEM.rawValue], predicates: predicates)
        saveManagedObjectContext()
    }
    
    
    /// Delete function to delete an with predicates specification
    ///
    /// - Parameters:
    ///   - entityName: entity to delete
    ///   - predicates: redicates specification
    open class func deleteEntityFromDB(entityName:[String],predicates:[NSPredicate]) {
        for name in entityName {
            let result = fetchEntities(name as NSString, withPredicate: predicates , sortkey: nil , order : nil , limit : nil)
            if result.count>0 {
                for result: AnyObject in result as [AnyObject]
                {
                    deleteManagedObjectContext(result as! NSManagedObject)
                }
            }
        }
    }
    
}
