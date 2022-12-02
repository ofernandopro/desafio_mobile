//
//  LoginTests.swift
//  MapAppTests
//
//  Created by Fernando Moreira on 27/11/22.
//

import XCTest
@testable import MapApp

class LoginTests: XCTestCase {

    var validation: ValidationService!
    
    override func setUp() {
        super.setUp()
        validation = ValidationService()
    }
    
    override func tearDown() {
        validation = nil
        super.tearDown()
    }
    
    func test_is_valid_email() throws {
        XCTAssertNoThrow(try validation.validateEmail("teste@gmail.com"))
    }
    
    func test_email_is_nil() throws {
        let expectedError = ValidationError.invalidEmail
        var error: ValidationError?
        
        XCTAssertThrowsError(try validation.validateEmail("")) { thrownError in
            error = thrownError as? ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        
    }
    
    func test_email_is_invalid_without_at() throws {
        let expectedError = ValidationError.invalidEmail
        var error: ValidationError?
        
        XCTAssertThrowsError(try validation.validateEmail("testGmail.com")) { thrownError in
            error = thrownError as? ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        
    }
    
    func test_email_is_invalid_without_point() throws {
        let expectedError = ValidationError.invalidEmail
        var error: ValidationError?
        
        XCTAssertThrowsError(try validation.validateEmail("test@Gmailcom")) { thrownError in
            error = thrownError as? ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        
    }

    func test_password_too_short() throws {
        let expectedError = ValidationError.passwordTooShort
        var error: ValidationError?
        
        XCTAssertThrowsError(try validation.validatePassword("Test")) { thrownError in
            error = thrownError as? ValidationError
        }
        
        XCTAssertEqual(expectedError, error)
        
    }
    
}
