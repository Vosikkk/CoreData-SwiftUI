//
//  EditContactViewModelTests.swift
//  CoreModelDataTests
//
//  Created by Саша Восколович on 13.06.2024.
//

import XCTest
@testable import ElseCoreData


final class EditContactViewModelTests: XCTestCase {

    
    private var mockProvider: CoreDataProvider!
    
    override func setUp() {
        super.setUp()
        mockProvider = MockCoreDataProvider()
    }
    
    
    override func tearDown() {
        mockProvider = nil
        super.tearDown()
    }
    
    func test_initWithoutContactModel_shouldCreateNewContactAndisNewTrue() {
        let vm = EditContactViewModel(provider: mockProvider)
        XCTAssertNotNil(vm.contact)
        XCTAssertEqual(vm.isNew, true)
    }
    
   
    
    
   
}

