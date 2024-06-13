//
//  ContactsProviderTests.swift
//  CoreModelDataTests
//
//  Created by Саша Восколович on 06.06.2024.
//

import XCTest
@testable import ElseCoreData

final class ContactsProviderTests: XCTestCase {

    private var provider: ContactsProvider!
    
    
    override func setUp() {
        super.setUp()
        provider = ContactsProvider()
    }
    
    override func tearDown() {
        provider = nil
        super.tearDown()
    }
   

    func test_existsContact_shouldBeEqualToTestContact() async throws {
        let contact: Contact = .init(
            context: provider.context,
            name: "Test",
            email: "Test",
            isFavourite: true,
            phoneNumber: "Test",
            dob: Date(),
            notes: "Test"
        )
        
        // Here we check, is our func persist doesn't let save context without changes
        XCTAssertEqual(provider.context.hasChanges, true)
        try await provider.persist(in: provider.context)
        XCTAssertEqual(provider.context.hasChanges, false)
        
        XCTAssertEqual(provider.exists(contact, in: provider.context), contact)
    }
    
    
    func test_delete_shouldDeleteContactAndhasChangesTrue() async throws {
        
        let contact: Contact = .init(
            context: provider.context,
            name: "Test",
            email: "Test",
            isFavourite: true,
            phoneNumber: "Test",
            dob: Date(),
            notes: "Test"
        )
        XCTAssertEqual(provider.context.hasChanges, true)
        
        try provider.delete(contact, in: provider.context)
        
        try provider.delete(contact, in: provider.context)
        await provider.context.perform {
            XCTAssertEqual(self.provider.exists(contact, in: self.provider.context), nil)
            XCTAssertEqual(self.provider.context.hasChanges, true)
        }
    }
}
