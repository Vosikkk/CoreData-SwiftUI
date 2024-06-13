//
//  EditContactViewModelTests.swift
//  CoreModelDataTests
//
//  Created by Саша Восколович on 13.06.2024.
//
import CoreData
import XCTest
@testable import ElseCoreData


final class EditContactViewModelTests: XCTestCase {

    
    private var mockProvider: MockCoreDataProvider!
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        mockProvider = MockCoreDataProvider()
        context = mockProvider.context
    }
    
    
    override func tearDown() {
        mockProvider = nil
        context = nil
        super.tearDown()
    }
    
    func test_initWithoutContactModel_shouldCreateNewContactAndIsNewTrue() {
        let vm = EditContactViewModel(provider: mockProvider)
        XCTAssertNotNil(vm.contact)
        XCTAssertEqual(vm.isNew, true)
    }
    
   
    func test_initWithContactModel_shouldAddContactAndIsNewFalse() {
        let contact = Contact(context: context)
        mockProvider.contact = contact
        
        let vm = EditContactViewModel(provider: mockProvider, contact: contact)
        XCTAssertEqual(vm.isNew, false)
        XCTAssertEqual(vm.contact, contact)
    }
    
    
   
}

