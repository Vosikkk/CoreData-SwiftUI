//
//  EditContactViewModelTests.swift
//  CoreModelDataTests
//
//  Created by Саша Восколович on 13.06.2024.
//

import XCTest
@testable import ElseCoreData


final class EditContactViewModelTests: XCTestCase {

    private var mockProvider: MockCoreDataProvider!
  
    override func setUp() {
        super.setUp()
        mockProvider = MockCoreDataProvider()
    }
    
    
    override func tearDown() {
        mockProvider = nil
        super.tearDown()
    }
    
    func test_initWithoutContactModel_shouldCreateNewContactAndIsNewTrue() {
        let vm = EditContactViewModel(provider: mockProvider)
        XCTAssertNotNil(vm.contact)
        XCTAssertEqual(vm.isNew, true)
    }
    
   
    func test_initWithContactModel_shouldAddContactAndIsNewFalse() {
        let contact = Contact(context: mockProvider.mockContext)
        mockProvider.contact = contact
        
        let vm = EditContactViewModel(provider: mockProvider, contact: contact)
        XCTAssertEqual(vm.isNew, false)
        XCTAssertEqual(vm.contact, contact)
    }
    
    func test_save_persistCallEqualToOne() throws {
        let vm = EditContactViewModel(provider: mockProvider)
        XCTAssertEqual(mockProvider.persistCall, 0)
        try vm.save()
        XCTAssertEqual(mockProvider.persistCall, 1)
    }
}

