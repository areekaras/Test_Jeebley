//
//  CoreDataHelper.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 26/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//

import UIKit
import CoreData

open class CoreDataHelper: NSObject {
    
    open static var  managedObjectContext: NSManagedObjectContext? = CoreDataStack.sharedInstance.managedObjectContext
    open class func insertManagedObject(_ entityName:NSString)->AnyObject{
        let managedObject:NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: entityName as String , into: managedObjectContext!) 
        return managedObject
    }
    
   // open class func saveManagedObjectContext()->(status : Bool, message: String?){

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
    
    
    // open class func deleteManagedObjectContext(_ object :NSManagedObject)-> (status:Bool,message:String?)
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
    
   open class func getFetchedResultControllerFromEntity(_ entityName:String , sortDescriptors:NSArray? ,predicate:[NSPredicate] ,section:String!)->NSFetchedResultsController<NSFetchRequestResult> {
        return CoreDataHelper.fetchResultController(entityName as NSString, batchSize: 20, sortDescriptor: sortDescriptors,predicate: predicate , section:section)
    }

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
        
       // var error: NSError? = nil
        do {
            try _fetchedResultsController!.performFetch()
        } catch _ as NSError {
           // error = error1
            print("fetchResultController Error!")
            abort()
        }
        return _fetchedResultsController!
    }
    // remove persistent storage file - sql
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
    
    open class func clearStore() {
        let predicates = [NSPredicate]()
        deleteEntityFromDB(entityName: ["Category",
                                        "Store",
                                        "Item"], predicates: predicates)
        
        saveManagedObjectContext()
    }
    
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
