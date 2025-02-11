//
//  iOSAppsSafetyTests.swift
//  iOSAppsSafetyTests
//
//  Created by Harish Garg on 2025-02-11.
//

import XCTest
@testable import iOSAppsSafety

final class iOSAppsSafetyTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSuccessCase() throws {
        let rest = RestManager<AppSafetyModel>()
        let parameters = ["limit":"\(AppConstants.limitPerPage)"]
        let expectation = self.expectation(description: "valid_searchQuery")
        
        rest.makeRequest(request : WebAPI().appsList(params : parameters, type: .appsList)!) { (result) in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                XCTAssertEqual(response.query_status, "ok")
            case .failure(let error):
                XCTFail("Error: \(error.description)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10.0)
    }
    
    func testFailureCase() throws {
        
        let rest = RestManager<AppSafetyModel>()
        let parameters = ["limit":"\(AppConstants.limitPerPage)"]
        let expectation = self.expectation(description: "valid_searchQuery")
        
        
        // Sending failureRequest api end point to create error in api response
        rest.makeRequest(request : WebAPI().appsList(params : parameters, type: .failureRequest)!) { (result) in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                XCTAssertEqual(response.query_status, "ok")
            case .failure(let error):
                XCTFail("Error: \(error.description)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10.0)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
