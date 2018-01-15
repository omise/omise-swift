import XCTest
@testable import Omise


class SourceOperationFixtureTests: FixtureTestCase {
    func testCreateInternetBankingSCBSource() {
        let expectation = self.expectation(description: "Creating Internet Banking SCB Source")
        
        let createParams = PaymentSourceParams(amount: 1_000_00, currency: .thb, type: PaymentSourceParams.SourceType.internetBanking(.scb))

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
        
        let createParams = PaymentSourceParams(amount: 1_000_00, currency: .thb, type: PaymentSourceParams.SourceType.alipay)
        
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
        
        let createParams = PaymentSourceParams(amount: 1_000_00, currency: .thb, type: PaymentSourceParams.SourceType.billPayment(.tescoLotus))
        
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
        
        let createParams = PaymentSourceParams(amount: 1_100_000, currency: .idr, type: .virtualAccount(.sinarmas))
        
        let request = PaymentSource.create(using: testClient, params: createParams, callback: { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(source):
                XCTAssertEqual(source.amount, 1_100_000)
                XCTAssertEqual(source.currency, .idr)
                XCTAssertEqual(source.sourceType, .virtualAccount(.sinarmas))
                XCTAssertEqual(source.flow, Flow.offline)
            case let .fail(error):
                XCTFail("\(error)")
            }
        })
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testResilientBillPaymentSource() {
        let expectation = self.expectation(description: "Creating Resilient Bill Payment Source")
        
        let createParams = PaymentSourceParams(amount: 1_000_00, currency: .thb, type: PaymentSourceParams.SourceType.billPayment(SourceType.BillPayment.unknown("papaya")))
        
        let request = PaymentSource.create(using: testClient, params: createParams, callback: { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(source):
                XCTAssertEqual(source.amount, 1000_00)
                XCTAssertEqual(source.currency, .thb)
                XCTAssertEqual(source.sourceType, SourceType.billPayment(.unknown("papaya")))
                XCTAssertEqual(source.flow, Flow.offline)
            case let .fail(error):
                XCTFail("\(error)")
            }
        })
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testResilientVirtualAccountSource() {
        let expectation = self.expectation(description: "Creating Resilient Virtual Account Source")
        
        let createParams = PaymentSourceParams(amount: 1_100_000, currency: .idr, type: PaymentSourceParams.SourceType.virtualAccount(.unknown("cinimas")))
        
        let request = PaymentSource.create(using: testClient, params: createParams, callback: { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(source):
                XCTAssertEqual(source.amount, 1_100_000)
                XCTAssertEqual(source.currency, .idr)
                XCTAssertEqual(source.sourceType, SourceType.virtualAccount(.unknown("cinimas")))
                XCTAssertEqual(source.flow, Flow.offline)
            case let .fail(error):
                XCTFail("\(error)")
            }
        })
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testResilientInternetBankingSource() {
        let expectation = self.expectation(description: "Creating Resilient Internet Banking Source")
        
        let createParams = PaymentSourceParams(amount: 1_000_00, currency: .thb, type: PaymentSourceParams.SourceType.internetBanking(.unknown("oms")))
        
        let request = PaymentSource.create(using: testClient, params: createParams, callback: { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(source):
                XCTAssertEqual(source.amount, 1000_00)
                XCTAssertEqual(source.currency, .thb)
                XCTAssertEqual(source.sourceType, SourceType.internetBanking(.unknown("oms")))
                XCTAssertEqual(source.flow, Flow.redirect)
            case let .fail(error):
                XCTFail("\(error)")
            }
        })
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testResilientSource() {
        let expectation = self.expectation(description: "Creating Resilient Source")
        
        let createParams = PaymentSourceParams(amount: 1_000_00, currency: .thb, type: PaymentSourceParams.SourceType.unknown("omise"))
        
        let request = PaymentSource.create(using: testClient, params: createParams, callback: { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(source):
                XCTAssertEqual(source.amount, 1000_00)
                XCTAssertEqual(source.currency, .thb)
                XCTAssertEqual(source.sourceType, SourceType.unknown("omise"))
                XCTAssertEqual(source.flow, Flow.redirect)
            case let .fail(error):
                XCTFail("\(error)")
            }
        })
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeAlipayWalletSource() throws {
        let alipayWallet = AlipayWalletParams(barcode: "1234567890123456", storeID: "1", storeName: "Main Store", terminalID: nil)
        let createSourceParams = PaymentSourceParams(amount: 1_000, currency: .thb, type: PaymentSourceParams.SourceType.wallet(.alipay(alipayWallet)))
        
        let encoder = URLQueryItemEncoder()
        encoder.arrayIndexEncodingStrategy = .emptySquareBrackets
        
        let createSourceEncodedString = String(data: URLQueryItemEncoder.encodeToFormURLEncodedData(queryItems: try encoder.encode(createSourceParams)), encoding: .utf8)
        XCTAssertEqual(createSourceEncodedString, "amount=1000&currency=THB&type=wallet_alipay&barcode=1234567890123456&store_id=1&store_name=Main%20Store")
        
        let createChargeParams = ChargeParams.init(value: Value.init(amount: 10_000_00, currency: .thb), sourceType: PaymentSourceParams.SourceType.wallet(Wallet.alipay(alipayWallet)))
        let createChargeEncodedString = String(data: URLQueryItemEncoder.encodeToFormURLEncodedData(queryItems: try encoder.encode(createChargeParams)), encoding: .utf8)
        XCTAssertEqual(createChargeEncodedString, "amount=1000000&currency=THB&source%5Btype%5D=wallet_alipay&source%5Bbarcode%5D=1234567890123456&source%5Bstore_id%5D=1&source%5Bstore_name%5D=Main%20Store")
    }
}


extension PaymentSourceParams: AdditionalFixtureData {
    var fixtureFileSuffix: String? {
        return type.value
    }
}

