//
//  ContactsProvider.swift
//  ElseCoreData
//
//  Created by Саша Восколович on 30.05.2024.
//

import SwiftUI
import CoreData


public protocol CoreDataProvider {

    var context: NSManagedObjectContext { get }
    var newContext: NSManagedObjectContext { get }
    func exists<T: NSManagedObject>(_ contact: T, in context: NSManagedObjectContext) -> T?
    func delete<T: NSManagedObject>(_ contact: T, in context: NSManagedObjectContext) throws
    func persist(in context: NSManagedObjectContext) throws
}


final class ContactsProvider: CoreDataProvider {
    
    typealias Context = NSManagedObjectContext
    
    let persistentContainer: NSPersistentContainer
    
    static var name: String = "ContactsDataModel"
    
    var context: Context {
        persistentContainer.viewContext
    }
    
    var newContext: Context {
        persistentContainer.newBackgroundContext()
    }

    
    init(container: NSPersistentContainer = NSPersistentContainer(name: name)) {
        persistentContainer = container
        
        if EnvironmentValues.isPreview || Thread.current.isRunningXCTest {
            persistentContainer.persistentStoreDescriptions.first?.url = .init(fileURLWithPath: "/dev/null")
        }
        
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("unable to load storage \(error)")
            }
        }
    }
    
    
    func persist(in context: Context) throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    func exists<T: NSManagedObject>(_ contact: T, in context: Context) -> T? {
        try? context.existingObject(with: contact.objectID) as? T
    }
    
    func delete<T: NSManagedObject>(_ contact: T, in context: Context) throws {
        if let existingContact = exists(contact, in: context) {
            context.delete(existingContact)
            Task(priority: .background) {
                try await context.perform {
                    try context.save()
                }
            }
        }
    }
}


