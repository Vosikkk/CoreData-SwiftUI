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
    
    func test_defaultValuesInNewContact_shouldBeEmptyAndIsFavouriteShouldBeFalse() {
        let contact = emptyContact
        XCTAssertEqual(contact.name, "", "Expected name to be empty")
        XCTAssertEqual(contact.phoneNumber, "", "Expected phone number to be empty")
        XCTAssertEqual(contact.email, "", "Expected email to be empty")
        XCTAssertFalse(contact.isFavourite, "Expected isFavourite to be false")
        XCTAssertTrue(Calendar.current.isDateInToday(contact.dob), "Expected dob to be today")
    }
    
    func test_defaultContactValidity_shouldReturnFalse() {
        XCTAssertFalse(emptyContact.isValid)
    }

    func test_filledContactValidity_shouldReturnTrue() {
        XCTAssertTrue(notEmptyContact.isValid)
    }
    
    func test_isBirthdayPropertyWithTodayDOB_shouldReturnTrue() {
        XCTAssertTrue(notEmptyContact.isBirthday)
    }
    
    func test_isBirthdayPropertyWithNonTodayDOB_shouldReturnFalse() throws {
        let contact = try XCTUnwrap(Contact.makePreview(count: 2, in: provider.context).last)
        XCTAssertFalse(contact.isBirthday)
    }
    
    func test_filterWithFaveOption_shouldReturnFavPredicate() {
        let request = Contact.filter(with: .init(filter: .fave))
        XCTAssertEqual(favPredicate, request.predicateFormat)
    }
    
    func test_filterWithAllOption_shouldReturnTruePredicate() {
        let request = Contact.filter(with: .init(filter: .all))
        XCTAssertEqual(truePredicate, request.predicateFormat)
    }
    
    func test_filterWithQuery_shouldReturnNameContainsQueryPredicate() {
        let request = Contact.filter(with: .init(query: query))
        XCTAssertEqual("name CONTAINS[cd] \"\(query)\"", request.predicateFormat)
    }
    
    func test_filterWithQueryAndFaveOption_shouldReturnNameContainsQueryAndFavPredicate() {
        let request = Contact.filter(with: .init(query: query, filter: .fave))
        XCTAssertEqual("name CONTAINS[cd] \"\(query)\" AND \(favPredicate)", request.predicateFormat)
    }
    
    // MARK: - Helpers
    
    private let favPredicate: String = "isFavourite == 1"
    
    private let truePredicate: String = "TRUEPREDICATE"
    
    private let query: String = "Test"
    
    private var emptyContact: Contact {
        Contact.empty(context: provider.context)
    }
    private var notEmptyContact: Contact {
        Contact.preview(context: provider.context)
    }

}
