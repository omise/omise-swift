import XCTest
import Omise

class RecipientOperationFixtureTests: FixtureTestCase {

    func testRecipientList() {
        let expectation = self.expectation(description: "recipient list")
        
        let request = Recipient.list(using: testClient, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(recipientList):
                XCTAssertEqual(recipientList.data.count, 2)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

}
