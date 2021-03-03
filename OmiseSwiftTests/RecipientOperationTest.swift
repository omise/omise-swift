import Foundation
import XCTest
@testable import Omise

class RecipientOperationTest: LiveTest {
    
    func testRecipientList() {
        let expectation = self.expectation(description: "recipient list")
        
        let request = Recipient.list(using: testClient, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(recipientList):
                XCTAssertNotNil(recipientList.data)
                XCTAssertGreaterThanOrEqual(recipientList.data.count, 1)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)

    }
}
