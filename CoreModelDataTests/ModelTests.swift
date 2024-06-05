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
        let contact = emptyContact
        XCTAssertEqual(contact.name, "", "Expected name to be empty")
        XCTAssertEqual(contact.phoneNumber, "", "Expected phone number to be empty")
        XCTAssertEqual(contact.email, "", "Expected email to be empty")
        XCTAssertFalse(contact.isFavourite, "Expected isFavourite to be false")
        XCTAssertTrue(Calendar.current.isDateInToday(contact.dob), "Expected dob to be today")
    }
    
    func test_isNotValidContactWithDefaultValues_shouldReturnFalse() {
        XCTAssertFalse(emptyContact.isValid)
    }

    func test_isValidContactWithFilledValues_shouldReturnTrue() {
        XCTAssertTrue(notEmptyContact.isValid)
    }
    
    func test_checkIsBirthdayPropertyWithTodayDateOfBirthday_shouldReturnTrue() {
        XCTAssertTrue(notEmptyContact.isBirthday)
    }
    
    func test_checkIsBirthdayPropertyWithNotTodayDateOfBirthday_shouldReturnFalse() throws {
        let contact = try XCTUnwrap(Contact.makePreview(count: 2, in: provider.context).last)
        XCTAssertFalse(contact.isBirthday)
    }
    
    func test_filterCorrectnessOfPredicateFormatWithFaveOption_shouldBeEqualIsFavouriteEqual1StringRepresentation() {
        let request = Contact.filter(with: .init(filter: .fave))
        XCTAssertEqual("isFavourite == 1", request.predicateFormat)
    }
    
    func test_filterCorrectnessOfPredicateFormatWithAllOption_shouldBeEqualTRUEPREDICATEStringRepresentation() {
        let request = Contact.filter(with: .init(filter: .all))
        XCTAssertEqual("TRUEPREDICATE", request.predicateFormat)
    }
    
    // MARK: - Helpers
    
    private var emptyContact: Contact {
        Contact.empty(context: provider.context)
    }
    private var notEmptyContact: Contact {
        Contact.preview(context: provider.context)
    }
 
    private var previewContacts: [Contact] {
        Contact.makePreview(count: 5, in: provider.context)
    }
}
