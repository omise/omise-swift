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
    
    func testAccountRetrieve() throws {
        let expectation = expectationWithDescription("account result")
        let request = Account.retrieve(using: testClient) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .Success(account):
                XCTAssertEqual(account.email, "omise@chakrit.net")
            case let .Fail(err):
                XCTFail("\(err)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func testBalanceRetrieve() {
        let expectation = expectationWithDescription("balance result")
        let request = Balance.retrieve(using: testClient) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .Success(balance):
                XCTAssertEqual(balance.available, 22118104)
            case let .Fail(err):
                XCTFail("\(err)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
}
