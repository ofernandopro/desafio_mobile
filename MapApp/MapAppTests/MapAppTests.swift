//
//  MapAppTests.swift
//  MapAppTests
//
//  Created by Fernando Moreira on 25/11/22.
//

import XCTest
@testable import MapApp

class MapAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    /*
    func test_login_with_username_but_no_password() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! LoginViewController
        let _ = vc.view

        vc.emailTextField!.text = "fernando@gmail.com"
        vc.passwordTextField!.text = "fernando123"

        vc.didTapLoginButton()

        XCTAssertFalse(vc.errorLabel!.isHidden)
        XCTAssertEqual("Please enter a password", vc.errorLabel!.text!)
    }
    
    func test_register_new_user() {
        let authManager = AuthManager()

        authManager.registerNewUser(name: "Teste4", email: "teste4@gmail.com", password: "teste123", completion: nil)


        XCTAssertFalse(vc.errorLabel!.isHidden)
        XCTAssertEqual("Please enter a password", vc.errorLabel!.text!)
    }*/

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
