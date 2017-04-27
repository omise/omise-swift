import Foundation
import XCTest
import Omise

class LiveTest: OmiseTestCase {
    var testClient: APIClient {
        let testingApplicationKeyJSON = [
            "kind": "application",
            "name": "iOS Test Case",
            "object": "key",
            "key": "akey_test_57rqqo973wulbfhpqgq",
            "id": "key_test_57rqqo999mo107dacao",
            "livemode": false,
            "created": "2017-04-26T12:06:34Z"
            ] as [String : Any]
        let config = APIConfiguration(applicationKey: Key<ApplicationKey>(JSON: testingApplicationKeyJSON)!)
        return APIClient(config: config)
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
                XCTAssertEqual(balance.available.amount, 22118104)
            case let .fail(err):
                XCTFail("\(err)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
