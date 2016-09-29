import XCTest
import Omise


private let refundTestingID = "rfnd_test_4yqmv79ahghsiz23y3c"
private let charge = Charge(id: "chrg_test_4yq7duw15p9hdrjp8oq")

class RefundOperationFixtureTests: FixtureTestCase {
    func testRefundRetrieve() {
        let expectation = self.expectation(description: "Refund result")
        
        let request = Refund.retrieve(using: testClient, parent: charge, id: refundTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(refund):
                XCTAssertEqual(refund.amount, 10000)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testRefundList() {
        let expectation = self.expectation(description: "Refund list")
        
        let request = Refund.list(using: testClient, parent: charge, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(refundsList):
                XCTAssertNotNil(refundsList.data)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    
    func testRefundCreate() {
        let expectation = self.expectation(description: "Refund create")
        
        let createParams = RefundParams()
        createParams.amount = 100000
        
        let request = Refund.create(using: testClient, parent: charge, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(refund):
                XCTAssertNotNil(refund)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
}
