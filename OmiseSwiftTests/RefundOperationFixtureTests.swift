import XCTest
import Omise


private let refundTestingID = DataID<Refund>(idString: "rfnd_test_5frz1pdm34u27646j5p")!

private let charge: Charge = {
    let bundle = Bundle(for: OmiseTestCase.self)
    guard let path = bundle.path(forResource: "Fixtures/api.omise.co/charges/chrg_test_5frvn3hgya3qemayzrt-get", ofType: "json") else {
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
                XCTAssertEqual(refund.value.amount, 100000)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeRefundRetrieve() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5frvn3hgya3qemayzrt")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        guard let defaultRefund = defaultCharge.refunds.first, let decodedRefund = decodedCharge.refunds.first else {
            XCTFail("Cannot get the recent refund")
            return
        }
        XCTAssertEqual(defaultRefund.object, decodedRefund.object)
        XCTAssertEqual(defaultRefund.id, decodedRefund.id)
        XCTAssertEqual(defaultRefund.location, decodedRefund.location)
        XCTAssertEqual(defaultRefund.amount, decodedRefund.amount)
        XCTAssertEqual(defaultRefund.currency, decodedRefund.currency)
        XCTAssertEqual(defaultRefund.charge.id, decodedRefund.charge.id)
        XCTAssertEqual(defaultRefund.transaction.id, decodedRefund.transaction.id)
        XCTAssertEqual(defaultRefund.createdDate, decodedRefund.createdDate)
    }
    
    func testRefundList() {
        let expectation = self.expectation(description: "Refund list")
        
        let request = Refund.list(using: testClient, parent: charge, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(refundsList):
                XCTAssertNotNil(refundsList.data)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    
    func testRefundCreate() {
        let expectation = self.expectation(description: "Refund create")
        
        let createParams = RefundParams(amount: 10000)
        
        let request = Refund.create(using: testClient, parent: charge, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(refund):
                XCTAssertNotNil(refund)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
}
