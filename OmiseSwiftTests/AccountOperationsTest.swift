import Foundation
import XCTest
import Omise

class AccountOperationsTest: OmiseTestCase {
    var testClient: Client {
        let config = Config(
            publicKey: "pkey_test_52d6po3fvio2w6tefpb",
            secretKey: "skey_test_52d6ppdms4p1jhnkigq"
        )
        
        return Client(config: config)
    }
    
    func testRetrieve() {
        let expectation = expectationWithDescription("account result")
        let operation: Account.Retrieve = Account.Retrieve()
        
        let request = testClient.call(operation) { (result: Account?, error: ErrorType?) -> () in
            defer { expectation.fulfill() }
            XCTAssertNil(error)
            XCTAssertEqual(result?.email, "omise@chakrit.net")
        }
        
        XCTAssertNotNil(request)
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
}