//
//  ContactsProviderTests.swift
//  CoreModelDataTests
//
//  Created by Саша Восколович on 06.06.2024.
//

import XCTest
@testable import ElseCoreData

final class ContactsProviderTests: XCTestCase {

    private var provider: CoreDataProvider!
    
    
    override func setUp() {
        super.setUp()
        provider = ContactsProvider()
    }
    
    override func tearDown() {
        provider = nil
        super.tearDown()
    }
   

    func test_existsContact_shouldBeEqualToTestContact() throws {
        
        let contact: Contact = .init(context: provider.context,
                                             name: "Test",
                                             email: "Test",
                                             isFavourite: true,
                                             phoneNumber: "Test",
                                             dob: Date(),
                                             notes: "Test")
        XCTAssertEqual(provider.context.hasChanges, true)
        
        try provider.persist(in: provider.context)
        XCTAssertEqual(provider.context.hasChanges, false)
        
        XCTAssertEqual(provider.exists(contact, in: provider.context), contact)
    }
    
    
}
