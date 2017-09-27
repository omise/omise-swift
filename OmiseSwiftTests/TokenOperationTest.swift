import Foundation
import XCTest
import Omise

class TokenOperationTest: LiveTest {
    
    func testTokenCreate() {
        let expectation = self.expectation(description: "token create")
        
        let createParams = TokenParams(number: "4242424242424242", name: "John Appleseed", expiration: (month: 1, year: 2021), securityCode: "123")
        
        let request = Token.create(using: testClient, usingKey: AnyAccessKey(""), params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(token):
                XCTAssertNotNil(token)
                XCTAssertEqual(token.card.lastDigits.lastDigits, "4242")
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}

