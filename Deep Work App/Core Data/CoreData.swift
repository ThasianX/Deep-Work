//
//  CoreData.swift
//  Deep Work App
//
//  Created by Kevin Li on 1/20/20.
//  Copyright © 2020 Kevin Li. All rights reserved.
//

import CoreData

class CoreData: NSObject {
    
    static let stack = CoreData()   // Singleton
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Deep_Work_App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let nserror = error as NSError? {
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        })
        return container
    }()
    
    public var context: NSManagedObjectContext {
        get {
            return self.persistentContainer.viewContext
        }
    }
    
    // MARK: - Core Data Saving support
    
    public func save() {
        if self.context.hasChanges {
            do {
                try self.context.save()
                print("In CoreData.stack.save()")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Database setup
    
    public class func initialDbSetup() -> Void {
        
    }
    
    // MARK: - Managed Object Helpers
    
    class func executeBlockAndCommit(_ block: @escaping () -> Void) {
        
        block()
        CoreData.stack.save()
    }
    
}
