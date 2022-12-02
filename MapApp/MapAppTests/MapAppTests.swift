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
    
    func test_user_was_created_coredata() throws {
        CoreData.saveCoreData(id: "2398321090", lat: "-43.432343", lon: "-19.214235")
        
        XCTAssertTrue(CoreData.checkUserExistCoreData(id: "2398321090"))
    }
    
    func test_user_was_updated_coredata() throws {
        CoreData.updateCoreData(id: "2398321090", lat: "-47.432343", lon: "-23.214235")
        
        XCTAssertTrue(CoreData.checkUserExistCoreData(id: "2398321090"))
    }

}
