import XCTest
import Omise

class AccountAndBalanceOperationsTest: LiveTest {
    
    func testAccountRetrieve() throws {
        let expectation = self.expectation(description: "account result")
        let request = Account.retrieve(using: testClient) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(account):
                XCTAssertEqual(account.email, "john.doe@example.com")
            case let .failure(err):
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
                XCTAssertEqual(balance.transferable, 22118104)
            case let .failure(err):
                XCTFail("\(err)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
}
