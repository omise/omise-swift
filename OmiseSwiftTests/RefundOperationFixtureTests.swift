import XCTest
import Omise


private let refundTestingID = "rfnd_test_4yqmv79ahghsiz23y3c"
private let charge: Charge = {
    let bundle = Bundle(for: OmiseTestCase.self)
    guard let path = bundle.path(forResource: "Fixtures/api.omise.co/charges/chrg_test_4yq7duw15p9hdrjp8oq-get", ofType: "json") else {
        XCTFail("could not load fixtures.")
        preconditionFailure()
    }
    
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            XCTFail("could not load fixtures at path: \(path)")
            preconditionFailure()
    }
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try! decoder.decode(Charge.self, from: data)
}()

class RefundOperationFixtureTests: FixtureTestCase {
    func testRefundRetrieve() {
        let expectation = self.expectation(description: "Refund result")
        
        let request = Refund.retrieve(using: testClient, parent: charge, id: refundTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(refund):
                XCTAssertEqual(refund.value.amount, 10000)
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
        
        let createParams = RefundParams(amount: 100000)
        
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
