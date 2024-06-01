//
//  EditContactViewModel.swift
//  ElseCoreData
//
//  Created by Саша Восколович on 31.05.2024.
//

import CoreData


final class EditContactViewModel: ObservableObject {
    
    @Published var contact: Contact
    
    private let context: NSManagedObjectContext
    private let provider: CoreDataProvider
    
    let isNew: Bool
    
    init(provider: CoreDataProvider, contact: Contact? = nil) {
        self.provider = provider
        self.context = provider.newContext
        if let contact,
           let existingContactCopy = provider.exists(contact, in: context) {
            self.contact = existingContactCopy
            self.isNew = false
        } else {
            self.contact = Contact(context: self.context)
            self.isNew = true 
        }
    }
    
    func save() throws {
        try provider.persist(in: context)
    }
}


