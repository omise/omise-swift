import Foundation
import XCTest
import Omise

class LiveTest: OmiseTestCase {
    var testClient: Client {
        let config = Config(
            publicKey: "pkey_test_52d6po3fvio2w6tefpb",
            secretKey: "skey_test_52d6ppdms4p1jhnkigq",
            apiVersion: nil,
            queue: (OperationQueue.current ?? OperationQueue.main)
        )
        
        return Client(config: config)
    }
    
    func testAccountRetrieve() throws {
        let expectation = self.expectation(description: "account result")
        let request = Account.retrieve(using: testClient) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(account):
                XCTAssertEqual(account.email, "omise@chakrit.net")
            case let .fail(err):
                XCTFail("\(err)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testBalanceRetrieve() {
        let expectation = self.expectation(description: "balance result")
        let request = Balance.retrieve(using: testClient) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(balance):
                XCTAssertEqual(balance.available, 22118104)
            case let .fail(err):
                XCTFail("\(err)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
