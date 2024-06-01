//
//  ModelTests.swift
//  CoreModelDataTests
//
//  Created by Саша Восколович on 01.06.2024.
//

import XCTest
@testable import ElseCoreData

final class ModelTests: XCTestCase {

    private var provider: CoreDataProvider!
    
    override func setUp() {
        super.setUp()
        provider = ContactsProvider()
    }
    
    override func tearDown() {
        provider = nil
        super.tearDown()
    }
    
    func test_checkDefaultValuesInNewContact_valuesShouldBeEmptyAndIsFavouriteIsFalse() {
        let contact = Contact.empty(context: provider.context)
        XCTAssertEqual(contact.name, "", "Expected name to be empty")
        XCTAssertEqual(contact.phoneNumber, "", "Expected phone number to be empty")
        XCTAssertEqual(contact.email, "", "Expected email to be empty")
        XCTAssertFalse(contact.isFavourite, "Expected isFavourite to be false")
        XCTAssertTrue(Calendar.current.isDateInToday(contact.dob), "Expected dob to be today")
    }
    
    func test_isValidContactWithDefaultValue_shouldReturnFalse() {
        let contact = Contact.empty(context: provider.context)
        XCTAssertFalse(contact.isValid)
    }

}
