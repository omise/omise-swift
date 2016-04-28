import Foundation
import XCTest
import Omise

class LiveTest: OmiseTestCase {
    var testClient: Client {
        let config = Config(
            publicKey: "pkey_test_52d6po3fvio2w6tefpb",
            secretKey: "skey_test_52d6ppdms4p1jhnkigq",
            apiVersion: nil,
            queue: (NSOperationQueue.currentQueue() ?? NSOperationQueue.mainQueue())
        )
        
        return Client(config: config)
    }
    
    func testAccountRetrieve() {
        let expectation = expectationWithDescription("account result")
        let operation = Account.Retrieve()
        
        let request = testClient.call(operation) { (result: Account?, error: ErrorType?) -> () in
            defer { expectation.fulfill() }
            XCTAssertNil(error)
            XCTAssertEqual(result?.email, "omise@chakrit.net")
        }
        
        XCTAssertNotNil(request)
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func testBalanceRetrieve() {
        let expectation = expectationWithDescription("balance result")
        let operation = Balance.Retrieve()
        
        let request = testClient.call(operation) { (result: Balance?, error: ErrorType?) -> () in
            defer { expectation.fulfill() }
            XCTAssertNil(error)
            XCTAssertEqual(result?.available, 20485902)
        }
        
        XCTAssertNotNil(request)
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
}
