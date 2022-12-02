//
//  RegisterTests.swift
//  MapAppTests
//
//  Created by Fernando Moreira on 02/12/22.
//

import XCTest
@testable import MapApp

class RegisterTests: XCTestCase {
    
    var validation: ValidationService!

    override func setUp() {
        super.setUp()
        validation = ValidationService()
    }
    
    override func tearDown() {
        validation = nil
        super.tearDown()
    }

    func test_name_is_invalid_with_slash() throws {
        let expectedError = ValidationError.invalidName
        var error: ValidationError?
        
        XCTAssertThrowsError(try validation.validateName("Teste/")) { thrownError in
            error = thrownError as? ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
    }
    
    func test_name_is_invalid_with_point() throws {
        let expectedError = ValidationError.invalidName
        var error: ValidationError?
        
        XCTAssertThrowsError(try validation.validateName("Tes.te")) { thrownError in
            error = thrownError as? ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
    }
    
    func test_name_is_valid() throws {
        XCTAssertNoThrow(try validation.validateName("Teste"))
    }

}
