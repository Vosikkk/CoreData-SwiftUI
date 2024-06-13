//
//  EditContactViewModel.swift
//  ElseCoreData
//
//  Created by Саша Восколович on 31.05.2024.
//

import CoreData
import Observation


@Observable
final class EditContactViewModel {
    
    var contact: Contact
    
    private let context: NSManagedObjectContext
    private let provider: CoreDataProvider
    
   
    private(set) var isNew: Bool
    
    init(provider: CoreDataProvider, contact: Contact? = nil) {
        self.provider = provider
        context = provider.newContext
        if let contact,
           let existingContactCopy = provider.exists(contact, in: context) {
            self.contact = existingContactCopy
            self.isNew = false
        } else {
            self.contact = Contact(context: context)
            self.isNew = true 
        }
    }
    
    func save() async throws {
        try await provider.persist(in: context)
    }
}

