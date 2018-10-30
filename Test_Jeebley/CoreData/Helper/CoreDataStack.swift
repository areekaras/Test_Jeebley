//
//  CoreDataStack.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 26/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//

import UIKit
import CoreData


/// Set up Core Data Function
open class CoreDataStack: NSObject{
    
    
    /// create shared instance for this class
    public final  class var sharedInstance : CoreDataStack {
        struct Static {
            static var instance : CoreDataStack?
        }
        if !(Static.instance != nil) {
            Static.instance = CoreDataStack()
            
        }
        return Static.instance!
    }

    
    /// Initialising document directory
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    
    /// core data managedObjectModel
    lazy var managedObjectModel: NSManagedObjectModel = {
        let newPath = Bundle(for: type(of: self))
        let modelURL = newPath.url(forResource: "Test_Jeebley", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    
    /// core data persistentStoreCoordinator
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("Test_Jeebley.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        var options = [NSMigratePersistentStoresAutomaticallyOption:true,
                       NSInferMappingModelAutomaticallyOption:true]
        
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as? [AnyHashable: Any] as? [String : Any])
            NSLog("Unresolved error \(String(describing: error)), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()
    
    
    /// core data managedObjectContext
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    
    /// core data saving managedObjectContext
    func saveContext () {
        print("savecontext")
        if let moc = managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    NSLog("Unresolved error  \(error!.userInfo)")
                    abort()
                }
            }
        }
    }

}

