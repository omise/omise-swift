import Foundation
import XCTest
import Omise

class TokenOperationTest: OmiseTestCase {
    
    var testClient: APIClient {
        let config = APIConfiguration(
            publicKey: "pkey_test_54oojsyhv5uq1kzf4g4",
            secretKey: "skey_test_54oojsyhuzzr51wa5hc"
        )
        
        return APIClient(config: config)
    }
    
    
    func testTransferCreate() {
        let expectation = self.expectation(description: "token create")
        
        let createParams = TokenParams(number: "4242424242424242", name: "John Appleseed", expiration: (month: 1, year: 2021), securityCode: "123")
        
        let request = Token.create(using: testClient, params: createParams) { (result) in
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
