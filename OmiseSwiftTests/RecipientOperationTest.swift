import Foundation
import XCTest
@testable import Omise

class RecipientOperationTest: OmiseTestCase {
    var testClient: APIClient = {
        let config = APIConfiguration(
            publicKey: "<#Public Key#>",
            secretKey: "<#Secret Key#>"
        )
        
        return APIClient(config: config)
    }()
    
    func testRecipientList() {
        let expectation = self.expectation(description: "recipient list")
        
        let request = Recipient.list(using: testClient, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(recipientList):
                XCTAssertNotNil(recipientList.data)
                XCTAssertGreaterThanOrEqual(recipientList.data.count, 1)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)

    }
}

