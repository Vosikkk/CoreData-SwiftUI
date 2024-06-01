//
//  Contact.swift
//  ElseCoreData
//
//  Created by Саша Восколович on 30.05.2024.
//

import Foundation
import CoreData

final class Contact: NSManagedObject, Identifiable {
    
    @NSManaged var dob: Date
    @NSManaged var email: String
    @NSManaged var isFavourite: Bool
    @NSManaged var name: String
    @NSManaged var notes: String
    @NSManaged var phoneNumber: String
    
    
    var isBirthday: Bool {
        Calendar.current.isDateInToday(dob)
    }
    
    var formattedName: String {
        "\(isBirthday ? "🎈" : "")\(name)"
    }
    
    var isValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !phoneNumber.isEmpty
    }
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(Date.now, forKey: "dob")
        setPrimitiveValue(false, forKey: "isFavourite")
    }
}

extension Contact {
    
    private static var contactsFetchRequest: NSFetchRequest<Contact> {
        NSFetchRequest(entityName: "Contact")
    }
    
    static func all() -> NSFetchRequest<Contact> {
        let request: NSFetchRequest<Contact> = contactsFetchRequest
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Contact.name, ascending: true)
        ]
        return request
    }
    
    convenience init(context: NSManagedObjectContext,
                     name: String,
                     email: String,
                     isFavourite: Bool,
                     phoneNumber: String,
                     dob: Date,
                     notes: String
    ) {
        self.init(context: context)
        self.name = name
        self.email = email
        self.isFavourite = isFavourite
        self.phoneNumber = phoneNumber
        self.dob = dob
        self.notes = notes
    }
}

extension Contact {
    
    @discardableResult
    static func makePreview(count: Int, in context: NSManagedObjectContext) -> [Contact] {
        var contacts: [Contact] = []
        for i in 0..<count {
            contacts.append(Contact(
                context: context,
                name: "item \(i)",
                email: "test_\(i)@email.com",
                isFavourite: Bool.random(),
                phoneNumber: "087377333\(i)",
                dob: Calendar.current.date(byAdding: .day, value: -i, to: .now) ?? .now,
                notes: "This is a preview for item \(i)")
            )
        }
        
        return contacts
    }
    
    static func filter(with config: SearchConfig) -> NSPredicate {
        switch config.filter {
        case .all:
            config.query.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "name CONTAINS[cd] %@", config.query)
        case .fave:
            config.query.isEmpty ? NSPredicate(format: "isFavourite == %@", NSNumber(value: true)) :
            NSPredicate(format: "name CONTAINS[cd] %@ AND isFavourite == %@", config.query, NSNumber(value: true))
        }
    }
    
    static func sort(order: Sort) -> [NSSortDescriptor] {
        [NSSortDescriptor(keyPath: \Contact.name, ascending: order == .asc)]
    }
    
    static let previewProvider = ContactsProvider()
    
    static func preview(context: NSManagedObjectContext = previewProvider.context) -> Contact {
        makePreview(count: 1, in: context)[0]
    }
    
    static func empty(context: NSManagedObjectContext = previewProvider.context) -> Contact {
         Contact(context: context)
    }
}
