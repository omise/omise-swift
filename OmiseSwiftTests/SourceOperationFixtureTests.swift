import XCTest
@testable import Omise


class SourceOperationFixtureTests: FixtureTestCase {
    
    func testAlipaySourceRetrieve() throws {
        let expectation = self.expectation(description: "Alipay Source result")
        
        let request = PaymentSource.retrieve(using: testClient, id: "src_test_5avnfnqxzzj2yu7a34e") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(source):
                XCTAssertEqual(source.amount, 1_000_00)
                XCTAssertEqual(source.currency, .thb)
                XCTAssertEqual(source.sourceType, .alipay)
                XCTAssertEqual(source.flow, Flow.redirect)
                XCTAssertEqual(source.paymentInformation, .alipay)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeAlipaySourceRetrieve() throws {
        let defaultSource = try fixturesObjectFor(type: PaymentSource.self, dataID: "src_test_5avnfnqxzzj2yu7a34e")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultSource)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(PaymentSource.self, from: encodedData)
        XCTAssertEqual(defaultSource.id, decodedCharge.id)
        XCTAssertEqual(defaultSource.location, decodedCharge.location)
        XCTAssertEqual(defaultSource.amount, decodedCharge.amount)
        XCTAssertEqual(defaultSource.currency, decodedCharge.currency)
        XCTAssertEqual(defaultSource.sourceType, decodedCharge.sourceType)
        XCTAssertEqual(defaultSource.flow, decodedCharge.flow)
        XCTAssertEqual(defaultSource.paymentInformation, decodedCharge.paymentInformation)
    }
    
    func testBillPaymentSourceRetrieve() throws {
        let expectation = self.expectation(description: "Alipay Source result")
        
        let request = PaymentSource.retrieve(using: testClient, id: "src_test_5avnbl5i9xi30o9dk82") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(source):
                XCTAssertEqual(source.amount, 1_000_00)
                XCTAssertEqual(source.currency, .thb)
                XCTAssertEqual(source.sourceType, .billPayment(.tescoLotus))
                XCTAssertEqual(source.flow, Flow.offline)
                XCTAssertEqual(source.paymentInformation, .billPayment(.tescoLotus))
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeBillPaymentSourceRetrieve() throws {
        let defaultSource = try fixturesObjectFor(type: PaymentSource.self, dataID: "src_test_5avnbl5i9xi30o9dk82")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultSource)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(PaymentSource.self, from: encodedData)
        XCTAssertEqual(defaultSource.id, decodedCharge.id)
        XCTAssertEqual(defaultSource.location, decodedCharge.location)
        XCTAssertEqual(defaultSource.amount, decodedCharge.amount)
        XCTAssertEqual(defaultSource.currency, decodedCharge.currency)
        XCTAssertEqual(defaultSource.sourceType, decodedCharge.sourceType)
        XCTAssertEqual(defaultSource.flow, decodedCharge.flow)
        XCTAssertEqual(defaultSource.paymentInformation, decodedCharge.paymentInformation)
    }
    
    func testInternetBankingSourceRetrieve() throws {
        let expectation = self.expectation(description: "Alipay Source result")
        
        let request = PaymentSource.retrieve(using: testClient, id: "src_test_5avnh1p1dt3hkh161ac") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(source):
                XCTAssertEqual(source.amount, 1_000_00)
                XCTAssertEqual(source.currency, .thb)
                XCTAssertEqual(source.sourceType, .internetBanking(.scb))
                XCTAssertEqual(source.flow, Flow.redirect)
                XCTAssertEqual(source.paymentInformation, .internetBanking(.scb))
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeInternetBankingSourceRetrieve() throws {
        let defaultSource = try fixturesObjectFor(type: PaymentSource.self, dataID: "src_test_5avnh1p1dt3hkh161ac")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultSource)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(PaymentSource.self, from: encodedData)
        XCTAssertEqual(defaultSource.id, decodedCharge.id)
        XCTAssertEqual(defaultSource.location, decodedCharge.location)
        XCTAssertEqual(defaultSource.amount, decodedCharge.amount)
        XCTAssertEqual(defaultSource.currency, decodedCharge.currency)
        XCTAssertEqual(defaultSource.sourceType, decodedCharge.sourceType)
        XCTAssertEqual(defaultSource.flow, decodedCharge.flow)
        XCTAssertEqual(defaultSource.paymentInformation, decodedCharge.paymentInformation)
    }
    
    func testVirtualAccountSourceRetrieve() throws {
        let expectation = self.expectation(description: "Alipay Source result")
        
        let request = PaymentSource.retrieve(using: testClient, id: "src_test_5avnfrstr7ubsy8py3k") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(source):
                XCTAssertEqual(source.amount, 1_000_00)
                XCTAssertEqual(source.currency, .thb)
                XCTAssertEqual(source.sourceType, .virtualAccount(.sinarmas))
                XCTAssertEqual(source.flow, Flow.offline)
                XCTAssertEqual(source.paymentInformation, .virtualAccount(.sinarmas))
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeVirtualAccountSourceRetrieve() throws {
        let defaultSource = try fixturesObjectFor(type: PaymentSource.self, dataID: "src_test_5avnfrstr7ubsy8py3k")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultSource)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(PaymentSource.self, from: encodedData)
        XCTAssertEqual(defaultSource.id, decodedCharge.id)
        XCTAssertEqual(defaultSource.location, decodedCharge.location)
        XCTAssertEqual(defaultSource.amount, decodedCharge.amount)
        XCTAssertEqual(defaultSource.currency, decodedCharge.currency)
        XCTAssertEqual(defaultSource.sourceType, decodedCharge.sourceType)
        XCTAssertEqual(defaultSource.flow, decodedCharge.flow)
        XCTAssertEqual(defaultSource.paymentInformation, decodedCharge.paymentInformation)
    }
    
    func testWalletAlipaySourceRetrieve() throws {
        let expectation = self.expectation(description: "Wallet Alipay Source result")
        
        let request = PaymentSource.retrieve(using: testClient, id: "src_test_5avle5cxg430bi579f1") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(source):
                XCTAssertEqual(source.amount, 1_000_00)
                XCTAssertEqual(source.currency, .thb)
                XCTAssertEqual(source.sourceType, .wallet(SourceType.Wallet.alipay))
                XCTAssertEqual(source.flow, Flow.offline)
                if case .wallet(.alipay(let alipayWalletResult)) = source.paymentInformation {
                    XCTAssertEqual(alipayWalletResult.barcode, "1234567890123456")
                    XCTAssertEqual(alipayWalletResult.storeID, "1")
                    XCTAssertEqual(alipayWalletResult.storeName, "Main Store")
                    XCTAssertNil(alipayWalletResult.terminalID)
                } else {
                    XCTFail("Wrong payment information")
                }
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeWalletAlipaySourceRetrieve() throws {
        let defaultSource = try fixturesObjectFor(type: PaymentSource.self, dataID: "src_test_5avle5cxg430bi579f1")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultSource)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(PaymentSource.self, from: encodedData)
        XCTAssertEqual(defaultSource.id, decodedCharge.id)
        XCTAssertEqual(defaultSource.location, decodedCharge.location)
        XCTAssertEqual(defaultSource.amount, decodedCharge.amount)
        XCTAssertEqual(defaultSource.currency, decodedCharge.currency)
        XCTAssertEqual(defaultSource.sourceType, decodedCharge.sourceType)
        XCTAssertEqual(defaultSource.flow, decodedCharge.flow)
        XCTAssertEqual(defaultSource.paymentInformation, decodedCharge.paymentInformation)
    }
    
    func testCreateInternetBankingSCBSource() {
        let expectation = self.expectation(description: "Creating Internet Banking SCB Source")
        
        let createParams = PaymentSourceParams(amount: 1_000_00, currency: .thb, type: PaymentSourceInformation.internetBanking(.scb))

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
        
        let createParams = PaymentSourceParams(amount: 1_000_00, currency: .thb, type: PaymentSourceInformation.alipay)
        
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
        
        let createParams = PaymentSourceParams(amount: 1_000_00, currency: .thb, type: PaymentSourceInformation.billPayment(.tescoLotus))
        
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
        
        let createParams = PaymentSourceParams(amount: 1_000_00, currency: .thb, type: PaymentSourceInformation.billPayment(SourceType.BillPayment.unknown("papaya")))
        
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
        
        let createParams = PaymentSourceParams(amount: 1_100_000, currency: .idr, type: PaymentSourceInformation.virtualAccount(.unknown("cinimas")))
        
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
        
        let createParams = PaymentSourceParams(amount: 1_000_00, currency: .thb, type: PaymentSourceInformation.internetBanking(.unknown("oms")))
        
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
    
    func testResilientWalletSource() {
        let expectation = self.expectation(description: "Creating Resilient Internet Banking Source")
        
        let omiseWallet = Wallet.unknown(name: "omise", parameters: [
            "barcode": "1234567890",
            "store_id": "store_1",
            "store_name": "store 1",
            "terminal_id": String?.none as Any,
            ])
        
        let createParams = PaymentSourceParams(amount: 1_000_00, currency: .thb, type: PaymentSourceInformation.wallet(omiseWallet))
        
        let request = PaymentSource.create(using: testClient, params: createParams, callback: { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(source):
                XCTAssertEqual(source.amount, 22_25)
                XCTAssertEqual(source.currency, .thb)
                XCTAssertEqual(source.sourceType, SourceType.wallet(SourceType.Wallet.unknown("omise")))
                XCTAssertEqual(source.flow, Flow.offline)
                
                if case .wallet(.unknown(let name, let parameters)) = source.paymentInformation {
                    XCTAssertEqual(name, "omise")
                    XCTAssertEqual(parameters.count, 4)
                    XCTAssertEqual(parameters["barcode"] as? String, "1234567890")
                    XCTAssertEqual(parameters["store_id"] as? String, "store_1")
                    XCTAssertEqual(parameters["store_name"] as? String, "store 1")
                    XCTAssertNil(parameters["terminal_id"] as? String)
                } else {
                    XCTFail("Wrong payment information")
                }

                
            case let .fail(error):
                XCTFail("\(error)")
            }
        })
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testResilientSource() {
        let expectation = self.expectation(description: "Creating Resilient Source")
        
        let createParams = PaymentSourceParams(amount: 1_000_00, currency: .thb, type: PaymentSourceInformation.unknown("omise"))
        
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
    
    func testCreateWalletAlipaySource() throws {
        let expectation = self.expectation(description: "Creating Virtual Account Sinarmas Source")
        
        let alipayWallet = AlipayWalletParams(barcode: "1234567890", storeID: "store_1", storeName: "store 1", terminalID: nil)
        let createParams = PaymentSourceParams(amount: 22_25, currency: .thb, type: .wallet(Wallet.alipay(alipayWallet)))
        
        let request = PaymentSource.create(using: testClient, params: createParams, callback: { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(source):
                XCTAssertEqual(source.amount, 22_25)
                XCTAssertEqual(source.currency, .thb)
                XCTAssertEqual(source.sourceType, .wallet(SourceType.Wallet.alipay))
                XCTAssertEqual(source.flow, Flow.offline)
                if case .wallet(.alipay(let alipayWalletResult)) = source.paymentInformation {
                    XCTAssertEqual(alipayWalletResult.barcode, "1234567890")
                    XCTAssertEqual(alipayWalletResult.storeID, "store_1")
                    XCTAssertEqual(alipayWalletResult.storeName, "store 1")
                    XCTAssertNil(alipayWalletResult.terminalID)
                } else {
                    XCTFail("Wrong payment information")
                }
            case let .fail(error):
                XCTFail("\(error)")
            }
        })
        
        waitForExpectations(timeout: 15.0, handler: nil)

    }
    
    func testEncodeAlipayWalletSource() throws {
        let alipayWallet = AlipayWalletParams(barcode: "1234567890123456", storeID: "1", storeName: "Main Store", terminalID: nil)
        let createSourceParams = PaymentSourceParams(amount: 1_000, currency: .thb, type: PaymentSourceInformation.wallet(.alipay(alipayWallet)))
        
        let encoder = URLQueryItemEncoder()
        encoder.arrayIndexEncodingStrategy = .emptySquareBrackets
        
        let createSourceEncodedString = String(data: URLQueryItemEncoder.encodeToFormURLEncodedData(queryItems: try encoder.encode(createSourceParams)), encoding: .utf8)
        XCTAssertEqual(createSourceEncodedString, "amount=1000&currency=THB&type=wallet_alipay&barcode=1234567890123456&store_id=1&store_name=Main%20Store")
        
        let createChargeParams = ChargeParams.init(value: Value.init(amount: 10_000_00, currency: .thb), sourceType: PaymentSourceInformation.wallet(Wallet.alipay(alipayWallet)))
        let createChargeEncodedString = String(data: URLQueryItemEncoder.encodeToFormURLEncodedData(queryItems: try encoder.encode(createChargeParams)), encoding: .utf8)
        XCTAssertEqual(createChargeEncodedString, "amount=1000000&currency=THB&source%5Btype%5D=wallet_alipay&source%5Bbarcode%5D=1234567890123456&source%5Bstore_id%5D=1&source%5Bstore_name%5D=Main%20Store")
    }
}


extension PaymentSourceParams: AdditionalFixtureData {
    var fixtureFileSuffix: String? {
        return type.value
    }
}

