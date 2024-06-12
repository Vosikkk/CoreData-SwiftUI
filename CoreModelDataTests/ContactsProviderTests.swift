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
   

    func test_existsContact_shouldBeEqualToTestContact() throws {
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
        try provider.persist(in: provider.context)
        XCTAssertEqual(provider.context.hasChanges, false)
        
        XCTAssertEqual(provider.exists(contact, in: provider.context), contact)
    }
    
    
    func test_delete_shouldDeleteContactAndhasChangesTrue() throws {
        
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
        let expectation = self.expectation(description: "Contact should be deleted")
       
        Task {
            try provider.delete(contact, in: provider.context)
            await provider.context.perform {
                XCTAssertEqual(self.provider.exists(contact, in: self.provider.context), nil)
                expectation.fulfill()
            }
        }
        XCTAssertEqual(provider.context.hasChanges, true)
               
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
