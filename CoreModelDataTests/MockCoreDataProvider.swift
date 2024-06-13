//
//  MockCoreDataProvider.swift
//  CoreModelDataTests
//
//  Created by Саша Восколович on 13.06.2024.
//

import Foundation
import ElseCoreData
import CoreData


class MockCoreDataProvider: CoreDataProvider {
    
    var mockContext: NSManagedObjectContext!
    
    var context: NSManagedObjectContext {
        mockContext
    }
    
    var newContext: NSManagedObjectContext {
        mockContext
    }
    
    init() {
        let persistentContainer = NSPersistentContainer(name: "ContactsDataModel")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        mockContext = persistentContainer.newBackgroundContext()
    }
    
    func exists<T>(_ contact: T, in context: NSManagedObjectContext) -> T? where T : NSManagedObject {
        return nil
    }
    
    func delete<T>(_ contact: T, in context: NSManagedObjectContext) throws where T : NSManagedObject {
        
    }
    
    func persist(in context: NSManagedObjectContext) throws {
        
    }
    
    
}

