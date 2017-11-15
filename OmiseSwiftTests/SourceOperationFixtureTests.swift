import XCTest
@testable import Omise


class SourceOperationFixtureTests: FixtureTestCase {
    func testCreateInternetBankingSCBSource() {
        let expectation = self.expectation(description: "Creating Internet Banking SCB Source")
        
        let createParams = PaymentSourceParams(amount: 1_000_00, currency: .thb, type: SourceType.internetBanking(.scb))

        let request = PaymentSource.create(using: testClient, params: createParams, callback: { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(source):
                XCTAssertEqual(source.amount, 1000_00)
                XCTAssertEqual(source.currency, .thb)
                XCTAssertEqual(source.sourceType, SourceType.internetBanking(.scb))
                XCTAssertEqual(source.flow, Flow.redirect)
            case let .fail(error):
                XCTFail("\(error)")
            }
        })
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testCreateAlipaySource() {
        let expectation = self.expectation(description: "Creating Alipay Source")
        
        let createParams = PaymentSourceParams(amount: 1_000_00, currency: .thb, type: SourceType.alipay)
        
        let request = PaymentSource.create(using: testClient, params: createParams, callback: { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(source):
                XCTAssertEqual(source.amount, 1000_00)
                XCTAssertEqual(source.currency, .thb)
                XCTAssertEqual(source.sourceType, SourceType.alipay)
                XCTAssertEqual(source.flow, Flow.redirect)
            case let .fail(error):
                XCTFail("\(error)")
            }
        })
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testCreateTescoLotusBillPaymentSource() {
        let expectation = self.expectation(description: "Creating Tesco Lotus Bill Payment Source")
        
        let createParams = PaymentSourceParams(amount: 1_000_00, currency: .thb, type: SourceType.billPayment(.tescoLotus))
        
        let request = PaymentSource.create(using: testClient, params: createParams, callback: { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(source):
                XCTAssertEqual(source.amount, 1000_00)
                XCTAssertEqual(source.currency, .thb)
                XCTAssertEqual(source.sourceType, SourceType.billPayment(.tescoLotus))
                XCTAssertEqual(source.flow, Flow.offline)
            case let .fail(error):
                XCTFail("\(error)")
            }
        })
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testCreateVirtualAccountSinarmasSource() {
        let expectation = self.expectation(description: "Creating Virtual Account Sinarmas Source")
        
        let createParams = PaymentSourceParams(amount: 1_100_000, currency: .idr, type: SourceType.virtualAccount(.sinarmas))
        
        let request = PaymentSource.create(using: testClient, params: createParams, callback: { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(source):
                XCTAssertEqual(source.amount, 1_100_000)
                XCTAssertEqual(source.currency, .idr)
                XCTAssertEqual(source.sourceType, SourceType.virtualAccount(.sinarmas))
                XCTAssertEqual(source.flow, Flow.offline)
            case let .fail(error):
                XCTFail("\(error)")
            }
        })
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }

}


extension PaymentSourceParams: AdditionalFixtureData {
    var fixtureFileSuffix: String? {
        return type.value
    }
}

