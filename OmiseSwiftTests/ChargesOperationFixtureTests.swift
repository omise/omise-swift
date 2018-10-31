import XCTest
@testable import Omise


private let defaultReturnURL = URL(string: "https://omise.co")!

class ChargesOperationFixtureTests: FixtureTestCase {
    func testChargeRetrieve() {
        let chargeTestingID = "chrg_test_5dxvbupj5e337skzplh"
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: chargeTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 100000)
                XCTAssertEqual(charge.value.currency, .usd)
                XCTAssertEqual(charge.chargeDescription, "Charge for order 3947")
                XCTAssertEqual(charge.id, chargeTestingID)
                XCTAssertEqual(charge.location, "/charges/chrg_test_5dxvbupj5e337skzplh")
                XCTAssertEqual(charge.isLive, false)
                XCTAssertEqual(charge.fundingAmount, 3174194)
                XCTAssertEqual(charge.fundingCurrency, .thb)
                XCTAssertEqual(charge.refunded, 10000)
                XCTAssertEqual(charge.transaction?.dataID, "trxn_test_5dxvbusat651hoatw00")
                XCTAssertEqual(charge.customer?.dataID, "cust_test_4yq6txdpfadhbaqnwp3")
                XCTAssertEqual(charge.createdDate, dateFormatter.date(from: "2018-11-15T09:55:31Z"))
                XCTAssertEqual(charge.card?.id, "card_test_5dxvbuja3f2n02o4wlg")
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeChargeRetrieve() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_57v787rzs4vr0dj1xc0")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLive, decodedCharge.isLive)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.dataID, decodedCharge.transaction?.dataID)
        XCTAssertEqual(defaultCharge.source?.id, decodedCharge.source?.id)
        XCTAssertEqual(defaultCharge.refunded, decodedCharge.refunded)
        
        XCTAssertEqual(defaultCharge.refunds?.object, defaultCharge.refunds?.object)
        XCTAssertEqual(defaultCharge.refunds?.from, decodedCharge.refunds?.from)
        XCTAssertEqual(defaultCharge.refunds?.to, decodedCharge.refunds?.to)
        XCTAssertEqual(defaultCharge.refunds?.offset, decodedCharge.refunds?.offset)
        XCTAssertEqual(defaultCharge.refunds?.limit, decodedCharge.refunds?.limit)
        XCTAssertEqual(defaultCharge.refunds?.total, decodedCharge.refunds?.total)

        XCTAssertEqual(defaultCharge.returnURL, decodedCharge.returnURL)
        XCTAssertEqual(defaultCharge.authorizedURL, decodedCharge.authorizedURL)
        
        XCTAssertEqual(defaultCharge.card?.object, decodedCharge.card?.object)
        XCTAssertEqual(defaultCharge.card?.id, decodedCharge.card?.id)
        XCTAssertEqual(defaultCharge.card?.isLive, decodedCharge.card?.isLive)
        XCTAssertEqual(defaultCharge.card?.countryCode, decodedCharge.card?.countryCode)
        XCTAssertEqual(defaultCharge.card?.city, decodedCharge.card?.city)
        XCTAssertEqual(defaultCharge.card?.postalCode, decodedCharge.card?.postalCode)
        XCTAssertEqual(defaultCharge.card?.financing, decodedCharge.card?.financing)
        XCTAssertEqual(defaultCharge.card?.bankName, decodedCharge.card?.bankName)
        XCTAssertEqual(defaultCharge.card?.lastDigits, decodedCharge.card?.lastDigits)
        XCTAssertEqual(defaultCharge.card?.brand, decodedCharge.card?.brand)
        XCTAssertEqual(defaultCharge.card?.expiration?.month, decodedCharge.card?.expiration?.month)
        XCTAssertEqual(defaultCharge.card?.expiration?.year, decodedCharge.card?.expiration?.year)
        XCTAssertEqual(defaultCharge.card?.fingerPrint, decodedCharge.card?.fingerPrint)
        XCTAssertEqual(defaultCharge.card?.name, decodedCharge.card?.name)
        XCTAssertEqual(defaultCharge.card?.createdDate, decodedCharge.card?.createdDate)
        
        XCTAssertEqual(defaultCharge.customer?.dataID, decodedCharge.customer?.dataID)
        XCTAssertEqual(defaultCharge.ipAddress, decodedCharge.ipAddress)
        XCTAssertEqual(defaultCharge.dispute?.amount, decodedCharge.dispute?.amount)
        XCTAssertEqual(defaultCharge.createdDate, decodedCharge.createdDate)
        
        XCTAssertEqual(defaultCharge.value.amount, decodedCharge.value.amount)
        XCTAssertEqual(defaultCharge.value.amountInUnit, decodedCharge.value.amountInUnit)
        XCTAssertEqual(defaultCharge.value.currency, defaultCharge.value.currency)
    }
    
    func testCharge2014APIRetrieve() {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_57v787rzs4vr0dj1xc0") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 100000)
                XCTAssertEqual(charge.value.currency.code, "THB")
                XCTAssertEqual(charge.chargeDescription, "Test API Version 2014-07-27.")
                XCTAssertEqual(charge.id, "chrg_test_57v787rzs4vr0dj1xc0")
                XCTAssertEqual(charge.location, "/charges/chrg_test_57v787rzs4vr0dj1xc0")
                XCTAssertEqual(charge.isLive, false)
                XCTAssertEqual(charge.isPaid, true)
                XCTAssertEqual(charge.refunded, 10000)
                XCTAssertEqual(charge.transaction?.dataID, "trxn_test_57v787szdbe4b2ala5p")
                XCTAssertEqual(charge.createdDate, dateFormatter.date(from: "2017-05-05T08:17:33Z"))
                XCTAssertEqual(charge.card?.id, "card_test_57v7856t6viu321t7h4")
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeCharge2014APIRetrieve() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_57v787rzs4vr0dj1xc0")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLive, decodedCharge.isLive)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.dataID, decodedCharge.transaction?.dataID)
        XCTAssertEqual(defaultCharge.source?.id, decodedCharge.source?.id)
        XCTAssertEqual(defaultCharge.refunded, decodedCharge.refunded)
        
        XCTAssertEqual(defaultCharge.refunds?.object, defaultCharge.refunds?.object)
        XCTAssertEqual(defaultCharge.refunds?.from, decodedCharge.refunds?.from)
        XCTAssertEqual(defaultCharge.refunds?.to, decodedCharge.refunds?.to)
        XCTAssertEqual(defaultCharge.refunds?.offset, decodedCharge.refunds?.offset)
        XCTAssertEqual(defaultCharge.refunds?.limit, decodedCharge.refunds?.limit)
        XCTAssertEqual(defaultCharge.refunds?.total, decodedCharge.refunds?.total)
        
        XCTAssertEqual(defaultCharge.returnURL, decodedCharge.returnURL)
        XCTAssertEqual(defaultCharge.authorizedURL, decodedCharge.authorizedURL)
        
        XCTAssertEqual(defaultCharge.card?.object, decodedCharge.card?.object)
        XCTAssertEqual(defaultCharge.card?.id, decodedCharge.card?.id)
        XCTAssertEqual(defaultCharge.card?.isLive, decodedCharge.card?.isLive)
        XCTAssertEqual(defaultCharge.card?.countryCode, decodedCharge.card?.countryCode)
        XCTAssertEqual(defaultCharge.card?.city, decodedCharge.card?.city)
        XCTAssertEqual(defaultCharge.card?.postalCode, decodedCharge.card?.postalCode)
        XCTAssertEqual(defaultCharge.card?.financing, decodedCharge.card?.financing)
        XCTAssertEqual(defaultCharge.card?.bankName, decodedCharge.card?.bankName)
        XCTAssertEqual(defaultCharge.card?.lastDigits, decodedCharge.card?.lastDigits)
        XCTAssertEqual(defaultCharge.card?.brand, decodedCharge.card?.brand)
        XCTAssertEqual(defaultCharge.card?.expiration?.month, decodedCharge.card?.expiration?.month)
        XCTAssertEqual(defaultCharge.card?.expiration?.year, decodedCharge.card?.expiration?.year)
        XCTAssertEqual(defaultCharge.card?.fingerPrint, decodedCharge.card?.fingerPrint)
        XCTAssertEqual(defaultCharge.card?.name, decodedCharge.card?.name)
        XCTAssertEqual(defaultCharge.card?.createdDate, decodedCharge.card?.createdDate)
        
        XCTAssertEqual(defaultCharge.customer?.dataID, decodedCharge.customer?.dataID)
        XCTAssertEqual(defaultCharge.ipAddress, decodedCharge.ipAddress)
        XCTAssertEqual(defaultCharge.dispute?.amount, decodedCharge.dispute?.amount)
        XCTAssertEqual(defaultCharge.createdDate, decodedCharge.createdDate)
        
        XCTAssertEqual(defaultCharge.value.amount, decodedCharge.value.amount)
        XCTAssertEqual(defaultCharge.value.amountInUnit, decodedCharge.value.amountInUnit)
        XCTAssertEqual(defaultCharge.value.currency, defaultCharge.value.currency)
    }
    
    func testDisputedCharge() {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_58qdpc54lq6a5enm88m") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 31_900_00)
                XCTAssertEqual(charge.value.currency.code, "THB")
                XCTAssertNil(charge.chargeDescription)
                XCTAssertEqual(charge.id, "chrg_test_58qdpc54lq6a5enm88m")
                XCTAssertEqual(charge.location, "/charges/chrg_test_58qdpc54lq6a5enm88m")
                XCTAssertEqual(charge.isLive, false)
                XCTAssertEqual(charge.transaction?.dataID, "trxn_test_58qdpcrr81jsqpoks6l")
                XCTAssertEqual(charge.createdDate, dateFormatter.date(from: "2017-07-24T01:30:01Z"))
                XCTAssertNotNil(charge.dispute)
                
                XCTAssertEqual(charge.dispute?.id, "dspt_test_58qhpee050f4qo36rnp")
                XCTAssertEqual(charge.dispute?.value.amount, 3190000)
                XCTAssertEqual(charge.dispute?.status, .pending)
                XCTAssertEqual(charge.dispute?.reasonCode, .goodsOrServicesNotProvided)
                XCTAssertEqual(charge.dispute?.reasonMessage, "Services not provided or Merchandise not received")
                XCTAssertEqual(charge.dispute?.responseMessage, "This is a response message")
                XCTAssertEqual(charge.dispute?.charge.dataID, "chrg_test_58qdpc54lq6a5enm88m")
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeDisputedCharge() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_58qdpc54lq6a5enm88m")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLive, decodedCharge.isLive)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.dataID, decodedCharge.transaction?.dataID)
        XCTAssertEqual(defaultCharge.source?.id, decodedCharge.source?.id)
        XCTAssertEqual(defaultCharge.refunded, decodedCharge.refunded)
        
        XCTAssertEqual(defaultCharge.refunds?.object, defaultCharge.refunds?.object)
        XCTAssertEqual(defaultCharge.refunds?.from, decodedCharge.refunds?.from)
        XCTAssertEqual(defaultCharge.refunds?.to, decodedCharge.refunds?.to)
        XCTAssertEqual(defaultCharge.refunds?.offset, decodedCharge.refunds?.offset)
        XCTAssertEqual(defaultCharge.refunds?.limit, decodedCharge.refunds?.limit)
        XCTAssertEqual(defaultCharge.refunds?.total, decodedCharge.refunds?.total)
        
        XCTAssertEqual(defaultCharge.returnURL, decodedCharge.returnURL)
        XCTAssertEqual(defaultCharge.authorizedURL, decodedCharge.authorizedURL)
        
        XCTAssertEqual(defaultCharge.card?.object, decodedCharge.card?.object)
        XCTAssertEqual(defaultCharge.card?.id, decodedCharge.card?.id)
        XCTAssertEqual(defaultCharge.card?.isLive, decodedCharge.card?.isLive)
        XCTAssertEqual(defaultCharge.card?.countryCode, decodedCharge.card?.countryCode)
        XCTAssertEqual(defaultCharge.card?.city, decodedCharge.card?.city)
        XCTAssertEqual(defaultCharge.card?.postalCode, decodedCharge.card?.postalCode)
        XCTAssertEqual(defaultCharge.card?.financing, decodedCharge.card?.financing)
        XCTAssertEqual(defaultCharge.card?.bankName, decodedCharge.card?.bankName)
        XCTAssertEqual(defaultCharge.card?.lastDigits, decodedCharge.card?.lastDigits)
        XCTAssertEqual(defaultCharge.card?.brand, decodedCharge.card?.brand)
        XCTAssertEqual(defaultCharge.card?.expiration?.month, decodedCharge.card?.expiration?.month)
        XCTAssertEqual(defaultCharge.card?.expiration?.year, decodedCharge.card?.expiration?.year)
        XCTAssertEqual(defaultCharge.card?.fingerPrint, decodedCharge.card?.fingerPrint)
        XCTAssertEqual(defaultCharge.card?.name, decodedCharge.card?.name)
        XCTAssertEqual(defaultCharge.card?.createdDate, decodedCharge.card?.createdDate)
        
        XCTAssertEqual(defaultCharge.customer?.dataID, decodedCharge.customer?.dataID)
        XCTAssertEqual(defaultCharge.ipAddress, decodedCharge.ipAddress)
        XCTAssertEqual(defaultCharge.createdDate, decodedCharge.createdDate)
        
        XCTAssertEqual(defaultCharge.value.amount, decodedCharge.value.amount)
        XCTAssertEqual(defaultCharge.value.amountInUnit, decodedCharge.value.amountInUnit)
        XCTAssertEqual(defaultCharge.value.currency, defaultCharge.value.currency)
        
        XCTAssertNotNil(defaultCharge.dispute)
        XCTAssertNotNil(decodedCharge.dispute)
        XCTAssertEqual(defaultCharge.dispute?.object, decodedCharge.dispute?.object)
        XCTAssertEqual(defaultCharge.dispute?.id, decodedCharge.dispute?.id)
        XCTAssertEqual(defaultCharge.dispute?.isLive, decodedCharge.dispute?.isLive)
        XCTAssertEqual(defaultCharge.dispute?.location, decodedCharge.dispute?.location)
        XCTAssertEqual(defaultCharge.dispute?.value.amount, decodedCharge.dispute?.value.amount)
        XCTAssertEqual(defaultCharge.dispute?.value.amountInUnit, decodedCharge.dispute?.value.amountInUnit)
        XCTAssertEqual(defaultCharge.dispute?.value.currency, decodedCharge.dispute?.value.currency)
        XCTAssertEqual(defaultCharge.dispute?.status, decodedCharge.dispute?.status)
        XCTAssertEqual(defaultCharge.dispute?.transaction.dataID, decodedCharge.dispute?.transaction.dataID)
        XCTAssertEqual(defaultCharge.dispute?.reasonCode, decodedCharge.dispute?.reasonCode)
        XCTAssertEqual(defaultCharge.dispute?.reasonMessage, decodedCharge.dispute?.reasonMessage)
        XCTAssertEqual(defaultCharge.dispute?.responseMessage, decodedCharge.dispute?.responseMessage)
        XCTAssertEqual(defaultCharge.dispute?.charge.dataID, decodedCharge.dispute?.charge.dataID)
        XCTAssertEqual(defaultCharge.dispute?.documents.total, decodedCharge.dispute?.documents.total)
        XCTAssertEqual(defaultCharge.dispute?.createdDate, decodedCharge.dispute?.createdDate)
        
        guard let defaultDocument = defaultCharge.dispute?.documents.first, let decodedDocument = decodedCharge.dispute?.documents.first else {
            XCTFail("Cannot get the recent document")
            return
        }
        
        XCTAssertEqual(defaultDocument.object, decodedDocument.object)
        XCTAssertEqual(defaultDocument.id, decodedDocument.id)
        XCTAssertEqual(defaultDocument.isLive, decodedDocument.isLive)
        XCTAssertEqual(defaultDocument.location, decodedDocument.location)
        XCTAssertEqual(defaultDocument.filename, decodedDocument.filename)
        XCTAssertEqual(defaultDocument.createdDate, decodedDocument.createdDate)
    }
    
    func testChargeList() {
        let expectation = self.expectation(description: "Charge list")
        
        let request = Charge.list(using: testClient, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(chargesList):
                XCTAssertNotNil(chargesList.data)
                XCTAssertEqual(chargesList.data.count, 60)
                let chargeSampleData = chargesList.data.first
                XCTAssertNotNil(chargeSampleData)
                XCTAssertEqual(chargeSampleData?.value.amount, 2000)
                XCTAssertEqual(chargeSampleData?.value.currency, .usd)
                XCTAssertEqual(chargeSampleData?.fundingValue.amount, 63754)
                XCTAssertEqual(chargeSampleData?.fundingValue.currency, .thb)
                
                
                let expiredCharges = chargesList.data.filter({ .expired ~= $0.status })
                XCTAssertEqual(expiredCharges.count, 6)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testCustomerChargeCreate() {
        let expectation = self.expectation(description: "Charge create")
        
        let createParams = ChargeParams(value: Value(amount: 1_000_00, currency: .thb), customerID: "cust_test_5dzgpes169hkk7n1b4n")
        
        let request = Charge.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertNotNil(charge)
                XCTAssertEqual(charge.value.amount, 100000)
                XCTAssertEqual(charge.value.currency, .usd)
                
                XCTAssertEqual(charge.fundingValue.amount, 3165630)
                XCTAssertEqual(charge.fundingValue.currency, .thb)
                
                
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testAlipayChargeCreate() {
        let expectation = self.expectation(description: "Alipay Charge create")
        
        let createParams = ChargeParams(value: Value(amount: 1_000_00, currency: .thb), sourceType: .alipay, returnURL: defaultReturnURL)
        
        let request = Charge.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertNotNil(charge)
                XCTAssertEqual(charge.value.amount, 100000)
                XCTAssertEqual(charge.source?.paymentInformation, .alipay)
                XCTAssertEqual(charge.returnURL, defaultReturnURL)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testBillPaymentChargeCreate() {
        let expectation = self.expectation(description: "Bill Payment Charge create")
        
        let createParams = ChargeParams(value: Value(amount: 1_000_00, currency: .thb), sourceType: .billPayment(.tescoLotus), returnURL: defaultReturnURL)
        
        let request = Charge.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            let billInformation = EnrolledSource.EnrolledPaymentInformation.BillPayment.BillInformation(omiseTaxID: "0105556091152", referenceNumber1: "128971730818814014", referenceNumber2: "464538863396896659", barcodeURL: URL(string: "https://api.omise.co/charges/chrg_test_5dzgra4ne1hzlxxvkuf/documents/docu_test_5dzgra5sq6w6myznkv8/downloads/5CD761E748448EEA")!, expired: dateFormatter.date(from: "2018-11-20T11:48:35Z")!)
            
            switch result {
            case let .success(charge):
                XCTAssertNotNil(charge)
                XCTAssertEqual(charge.value.amount, 100000)
                XCTAssertEqual(charge.source?.paymentInformation, .billPayment(.tescoLotus(billInformation)))
                XCTAssertEqual(charge.returnURL, defaultReturnURL)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testInternetBankingChargeCreate() {
        let expectation = self.expectation(description: "Internet Banking SCB Charge create")
        
        let createParams = ChargeParams(value: Value(amount: 1_000_00, currency: .thb), sourceType: .internetBanking(.scb), returnURL: defaultReturnURL)
        
        let request = Charge.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertNotNil(charge)
                XCTAssertEqual(charge.value.amount, 100000)
                XCTAssertEqual(charge.source?.paymentInformation, .internetBanking(.scb))
                XCTAssertEqual(charge.returnURL, defaultReturnURL)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testBarcodeAlipayChargeCreate() {
        let expectation = self.expectation(description: "Barcode Alipay Charge create")
        
        let alipayBarcode = AlipayBarcodeParams(storeID: "1", storeName: "Main Store", terminalID: nil, barcode: "1234567890123456")
        let createParams = ChargeParams(value: Value(amount: 1_000_00, currency: .thb), sourceType: .barcode(.alipay(alipayBarcode)))
        
        let request = Charge.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertNotNil(charge)
                XCTAssertEqual(charge.value.amount, 1_000_00)
                XCTAssertEqual(charge.source?.paymentInformation, .barcode(.alipay(EnrolledSource.EnrolledPaymentInformation.Barcode.AlipayBarcode(expired: dateFormatter.date(from: "2018-11-20T11:48:22Z")!))))
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testChargeUpdate() {
        let expectation = self.expectation(description: "Charge update")
        
        let metadata: [String: Any] = [
            "user-id": "a-user-id",
            "user": [
                "name": "John Appleseed",
                "tel": "08-xxxx-xxxx",
            ]
        ]
        
        let updateParams = UpdateChargeParams(chargeDescription: "Charge for order 3947 (XXL)", metadata: metadata)
        
        let request = Charge.update(using: testClient, id: "chrg_test_5dxvbupj5e337skzplh", params: updateParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.chargeDescription, "Charge for order 3947 (XXL)")
                XCTAssertEqual(charge.metadata["user-id"] as? String, "a-user-id")
                XCTAssertEqual((charge.metadata["user"] as? [String: Any])?["name"] as? String, "John Appleseed")
                XCTAssertEqual((charge.metadata["user"] as? [String: Any])?["tel"] as? String, "08-xxxx-xxxx")
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testInternetBankingChargeRetrieve() {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5dzgrh693mzqifqi7hn") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 100000)
                XCTAssertEqual(charge.source?.paymentInformation.sourceType, EnrolledSource.EnrolledPaymentInformation.internetBanking(.scb).sourceType)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeInternetBankingChargeRetrieve() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5dzgrh693mzqifqi7hn")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLive, decodedCharge.isLive)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.dataID, decodedCharge.transaction?.dataID)
        XCTAssertEqual(defaultCharge.refunded, decodedCharge.refunded)
        
        XCTAssertEqual(defaultCharge.refunds?.object, defaultCharge.refunds?.object)
        XCTAssertEqual(defaultCharge.refunds?.from, decodedCharge.refunds?.from)
        XCTAssertEqual(defaultCharge.refunds?.to, decodedCharge.refunds?.to)
        XCTAssertEqual(defaultCharge.refunds?.offset, decodedCharge.refunds?.offset)
        XCTAssertEqual(defaultCharge.refunds?.limit, decodedCharge.refunds?.limit)
        XCTAssertEqual(defaultCharge.refunds?.total, decodedCharge.refunds?.total)
        
        XCTAssertEqual(defaultCharge.returnURL, decodedCharge.returnURL)
        XCTAssertEqual(defaultCharge.authorizedURL, decodedCharge.authorizedURL)
        XCTAssertEqual(defaultCharge.createdDate, decodedCharge.createdDate)
        
        XCTAssertEqual(defaultCharge.source?.object, decodedCharge.source?.object)
        XCTAssertEqual(defaultCharge.source?.id, decodedCharge.source?.id)
        XCTAssertEqual(defaultCharge.source?.sourceType.value, decodedCharge.source?.sourceType.value)
        XCTAssertEqual(defaultCharge.source?.flow, decodedCharge.source?.flow)
        XCTAssertEqual(defaultCharge.source?.amount, decodedCharge.source?.amount)
        XCTAssertEqual(defaultCharge.source?.currency, decodedCharge.source?.currency)
        XCTAssertEqual(defaultCharge.source?.paymentInformation.sourceType, decodedCharge.source?.paymentInformation.sourceType)
        
    }
    
    func testAlipayChargeRetrieve() {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5dzgr2er2lfpks4fzwq") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 100000)
                XCTAssertEqual(charge.source?.paymentInformation.sourceType, EnrolledSource.EnrolledPaymentInformation.alipay.sourceType)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeAlipayChargeRetrieve() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5dzgr2er2lfpks4fzwq")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLive, decodedCharge.isLive)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.dataID, decodedCharge.transaction?.dataID)
        XCTAssertEqual(defaultCharge.refunded, decodedCharge.refunded)
        
        XCTAssertEqual(defaultCharge.refunds?.object, defaultCharge.refunds?.object)
        XCTAssertEqual(defaultCharge.refunds?.from, decodedCharge.refunds?.from)
        XCTAssertEqual(defaultCharge.refunds?.to, decodedCharge.refunds?.to)
        XCTAssertEqual(defaultCharge.refunds?.offset, decodedCharge.refunds?.offset)
        XCTAssertEqual(defaultCharge.refunds?.limit, decodedCharge.refunds?.limit)
        XCTAssertEqual(defaultCharge.refunds?.total, decodedCharge.refunds?.total)
        
        XCTAssertEqual(defaultCharge.returnURL, decodedCharge.returnURL)
        XCTAssertEqual(defaultCharge.authorizedURL, decodedCharge.authorizedURL)
        XCTAssertEqual(defaultCharge.createdDate, decodedCharge.createdDate)
        
        XCTAssertEqual(defaultCharge.source?.object, decodedCharge.source?.object)
        XCTAssertEqual(defaultCharge.source?.id, decodedCharge.source?.id)
        XCTAssertEqual(defaultCharge.source?.sourceType.value, decodedCharge.source?.sourceType.value)
        XCTAssertEqual(defaultCharge.source?.flow, decodedCharge.source?.flow)
        XCTAssertEqual(defaultCharge.source?.amount, decodedCharge.source?.amount)
        XCTAssertEqual(defaultCharge.source?.currency, decodedCharge.source?.currency)
        XCTAssertEqual(defaultCharge.source?.paymentInformation.sourceType, decodedCharge.source?.paymentInformation.sourceType)
    }
    
    func testTestcoLotusBillPaymentChargeRetrieve() {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5dzgra4ne1hzlxxvkuf") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 100000)
                XCTAssertEqual(charge.source?.amount, charge.amount)
                XCTAssertEqual(charge.source?.id, "src_test_5dzgra1hjrajmcvawuc")
                XCTAssertEqual(charge.source?.flow, .offline)
                switch charge.source?.paymentInformation {
                case EnrolledSource.EnrolledPaymentInformation.billPayment(.tescoLotus(let bill))?:
                    XCTAssertEqual(bill.omiseTaxID, "0105556091152")
                    XCTAssertEqual(bill.referenceNumber1, "128971730818814014")
                    XCTAssertEqual(bill.referenceNumber2, "464538863396896659")
                    XCTAssertEqual(bill.barcodeURL, URL(string: "https://api.omise.co/charges/chrg_test_5dzgra4ne1hzlxxvkuf/documents/docu_test_5dzgra5sq6w6myznkv8/downloads/5CD761E748448EEA")!)
                default:
                    XCTFail("Wrong source information on Testco Lotus Bill Payment charge")
                }
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeTestcoLotusBillPaymentChargeRetrieve() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5dzgra4ne1hzlxxvkuf")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLive, decodedCharge.isLive)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.dataID, decodedCharge.transaction?.dataID)
        XCTAssertEqual(defaultCharge.refunded, decodedCharge.refunded)
        
        XCTAssertEqual(defaultCharge.refunds?.object, defaultCharge.refunds?.object)
        XCTAssertEqual(defaultCharge.refunds?.from, decodedCharge.refunds?.from)
        XCTAssertEqual(defaultCharge.refunds?.to, decodedCharge.refunds?.to)
        XCTAssertEqual(defaultCharge.refunds?.offset, decodedCharge.refunds?.offset)
        XCTAssertEqual(defaultCharge.refunds?.limit, decodedCharge.refunds?.limit)
        XCTAssertEqual(defaultCharge.refunds?.total, decodedCharge.refunds?.total)
        
        XCTAssertEqual(defaultCharge.source?.object, decodedCharge.source?.object)
        XCTAssertEqual(defaultCharge.source?.id, decodedCharge.source?.id)
        XCTAssertEqual(defaultCharge.source?.sourceType.value, decodedCharge.source?.sourceType.value)
        XCTAssertEqual(defaultCharge.source?.flow, decodedCharge.source?.flow)
        XCTAssertEqual(defaultCharge.source?.amount, decodedCharge.source?.amount)
        XCTAssertEqual(defaultCharge.source?.currency, decodedCharge.source?.currency)
        XCTAssertEqual(defaultCharge.source?.paymentInformation.sourceType, decodedCharge.source?.paymentInformation.sourceType)
        switch (defaultCharge.source?.paymentInformation, decodedCharge.source?.paymentInformation) {
        case (EnrolledSource.EnrolledPaymentInformation.billPayment(.tescoLotus(let bill))?, EnrolledSource.EnrolledPaymentInformation.billPayment(.tescoLotus(let decodedBill))?):

            XCTAssertEqual(bill.omiseTaxID, decodedBill.omiseTaxID)
            XCTAssertEqual(bill.referenceNumber1, decodedBill.referenceNumber1)
            XCTAssertEqual(bill.referenceNumber2, decodedBill.referenceNumber2)
            XCTAssertEqual(bill.barcodeURL, decodedBill.barcodeURL)
            XCTAssertEqual(bill.expired, decodedBill.expired)
        default:
            XCTFail("Wrong source information on Testco Lotus Bill Payment charge")
        }
    }
    
    func testInstallmentKBankChargeRetrieve() {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5czuxmgzinn6qq1tz5u") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.amount, 5_000_00)
                XCTAssertEqual(charge.currency, .thb)
                XCTAssertEqual(charge.source?.amount, charge.amount)
                XCTAssertEqual(charge.source?.currency, charge.currency)
                XCTAssertEqual(charge.source?.id, "src_test_5cs0totfv87k1i6y45l")
                XCTAssertEqual(charge.source?.flow, .redirect)
                XCTAssertEqual(charge.source?.paymentInformation, EnrolledSource.EnrolledPaymentInformation.installment(.kBank))
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testBarcodeAlipayChargeRetrieve() throws {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5dzgr7e4ydljy6sgiyr") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.amount, 100000)
                XCTAssertEqual(charge.currency, .thb)
                XCTAssertEqual(charge.source?.amount, charge.amount)
                XCTAssertEqual(charge.source?.currency, charge.currency)
                XCTAssertEqual(charge.source?.id, "src_test_5dzgr7axod948i6c9uz")
                XCTAssertEqual(charge.source?.flow, .offline)
                XCTAssertEqual(charge.metadata["invoice_id"] as? String, "inv-1234567890")
                switch charge.source?.paymentInformation {
                case .barcode(.alipay(let alipayBarcode))?:
                    XCTAssertEqual(alipayBarcode.expired, dateFormatter.date(from: "2018-11-20T11:48:22Z"))
                default:
                    XCTFail("Wrong source information on Testco Lotus Bill Payment charge")
                }
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeBarcodeAlipayCharge() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5dzgr7e4ydljy6sgiyr")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLive, decodedCharge.isLive)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.dataID, decodedCharge.transaction?.dataID)
        XCTAssertEqual(defaultCharge.refunded, decodedCharge.refunded)
        
        XCTAssertEqual(defaultCharge.refunds?.object, defaultCharge.refunds?.object)
        XCTAssertEqual(defaultCharge.refunds?.from, decodedCharge.refunds?.from)
        XCTAssertEqual(defaultCharge.refunds?.to, decodedCharge.refunds?.to)
        XCTAssertEqual(defaultCharge.refunds?.offset, decodedCharge.refunds?.offset)
        XCTAssertEqual(defaultCharge.refunds?.limit, decodedCharge.refunds?.limit)
        XCTAssertEqual(defaultCharge.refunds?.total, decodedCharge.refunds?.total)
        
        XCTAssertEqual(defaultCharge.returnURL, decodedCharge.returnURL)
        XCTAssertEqual(defaultCharge.authorizedURL, decodedCharge.authorizedURL)
        XCTAssertEqual(defaultCharge.createdDate, decodedCharge.createdDate)
        
        XCTAssertEqual(defaultCharge.source?.object, decodedCharge.source?.object)
        XCTAssertEqual(defaultCharge.source?.id, decodedCharge.source?.id)
        XCTAssertEqual(defaultCharge.source?.sourceType.value, decodedCharge.source?.sourceType.value)
        XCTAssertEqual(defaultCharge.source?.flow, decodedCharge.source?.flow)
        XCTAssertEqual(defaultCharge.source?.amount, decodedCharge.source?.amount)
        XCTAssertEqual(defaultCharge.source?.currency, decodedCharge.source?.currency)
        XCTAssertEqual(defaultCharge.source?.paymentInformation, decodedCharge.source?.paymentInformation)

    }
    
    func testEncodingCreateChargeParams() throws {
        let params = ChargeParams(value: Value(amount: 10_000_00, currency: .thb), cardID: "crd_test_12345", chargeDescription: "Hello", isAutoCapture: nil, returnURL: nil, metadata: ["customer id": "1"])
        
        let encoder = URLQueryItemEncoder()
        encoder.arrayIndexEncodingStrategy = .emptySquareBrackets
        
        let items = try encoder.encode(params)
        
        XCTAssertEqual(items.count, 5)
        XCTAssertEqual(items[0].name, "amount")
        XCTAssertEqual(items[0].value, "1000000")
        XCTAssertEqual(items[1].name, "currency")
        XCTAssertEqual(items[1].value, "THB")
        XCTAssertEqual(items[2].name, "card")
        XCTAssertEqual(items[2].value, "crd_test_12345")
        XCTAssertEqual(items[3].name, "description")
        XCTAssertEqual(items[3].value, "Hello")
        XCTAssertEqual(items[4].name, "metadata[customer id]")
        XCTAssertEqual(items[4].value, "1")
    }
    
    func testEncodingCreateCardChargeParams() throws {
        let params = ChargeParams(value: Value(amount: 10_000_00, currency: .thb), cardID: "card_test_12345", chargeDescription: "Hello", isAutoCapture: nil, returnURL: nil, metadata: ["customer id": "1"])
        
        let encoder = URLQueryItemEncoder()
        encoder.arrayIndexEncodingStrategy = .emptySquareBrackets
        
        let items = try encoder.encode(params)
        
        XCTAssertEqual(items.count, 5)
        XCTAssertEqual(items[0].name, "amount")
        XCTAssertEqual(items[0].value, "1000000")
        XCTAssertEqual(items[1].name, "currency")
        XCTAssertEqual(items[1].value, "THB")
        XCTAssertEqual(items[2].name, "card")
        XCTAssertEqual(items[2].value, "card_test_12345")
        XCTAssertEqual(items[3].name, "description")
        XCTAssertEqual(items[3].value, "Hello")
        XCTAssertEqual(items[4].name, "metadata[customer id]")
        XCTAssertEqual(items[4].value, "1")
    }
    
    func testEncodingCreateCustomerCardChargeParams() throws {
        let params = ChargeParams(value: Value(amount: 10_000_00, currency: .thb), customerID: "cust_test_12345", cardID: "card_test_12345", chargeDescription: "Hello", isAutoCapture: nil, returnURL: nil, metadata: ["customer id": "1"])
        
        let encoder = URLQueryItemEncoder()
        encoder.arrayIndexEncodingStrategy = .emptySquareBrackets
        
        let items = try encoder.encode(params)
        
        XCTAssertEqual(items.count, 6)
        XCTAssertEqual(items[0].name, "amount")
        XCTAssertEqual(items[0].value, "1000000")
        XCTAssertEqual(items[1].name, "currency")
        XCTAssertEqual(items[1].value, "THB")
        XCTAssertEqual(items[2].name, "customer")
        XCTAssertEqual(items[2].value, "cust_test_12345")
        XCTAssertEqual(items[3].name, "card")
        XCTAssertEqual(items[3].value, "card_test_12345")
        XCTAssertEqual(items[4].name, "description")
        XCTAssertEqual(items[4].value, "Hello")
        XCTAssertEqual(items[5].name, "metadata[customer id]")
        XCTAssertEqual(items[5].value, "1")
    }
    
    func testEncodingCreateSourceChargeParams() throws {
        let source = PaymentSource(id: "src_test_12345", object: "source", isLive: false, location: "/sources/src_test_12345", currency: .thb, amount: 10_000_00, flow: .redirect, paymentInformation: .alipay)
        let params = ChargeParams(value: Value(amount: 10_000_00, currency: .thb), source: source, chargeDescription: "Hello", isAutoCapture: nil, returnURL: nil, metadata: ["customer id": "1"])
        
        let encoder = URLQueryItemEncoder()
        encoder.arrayIndexEncodingStrategy = .emptySquareBrackets
        
        let items = try encoder.encode(params)
        
        XCTAssertEqual(items.count, 5)
        XCTAssertEqual(items[0].name, "amount")
        XCTAssertEqual(items[0].value, "1000000")
        XCTAssertEqual(items[1].name, "currency")
        XCTAssertEqual(items[1].value, "THB")
        XCTAssertEqual(items[2].name, "source")
        XCTAssertEqual(items[2].value, "src_test_12345")
        XCTAssertEqual(items[3].name, "description")
        XCTAssertEqual(items[3].value, "Hello")
        XCTAssertEqual(items[4].name, "metadata[customer id]")
        XCTAssertEqual(items[4].value, "1")
    }
    
    func testEncodingCreateFastTrackTescoLotusBillPaymentChargeParams() throws {
        let params = ChargeParams(value: Value(amount: 10_000_00, currency: .thb), sourceType: .billPayment(.tescoLotus), chargeDescription: "Hello", isAutoCapture: nil, returnURL: nil, metadata: ["customer id": "1"])
        
        let encoder = URLQueryItemEncoder()
        encoder.arrayIndexEncodingStrategy = .emptySquareBrackets
        
        let items = try encoder.encode(params)
        
        XCTAssertEqual(items.count, 5)
        XCTAssertEqual(items[0].name, "amount")
        XCTAssertEqual(items[0].value, "1000000")
        XCTAssertEqual(items[1].name, "currency")
        XCTAssertEqual(items[1].value, "THB")
        XCTAssertEqual(items[2].name, "source[type]")
        XCTAssertEqual(items[2].value, billPaymentPrefix + SourceType.BillPayment.tescoLotus.rawValue)
        XCTAssertEqual(items[3].name, "description")
        XCTAssertEqual(items[3].value, "Hello")
        XCTAssertEqual(items[4].name, "metadata[customer id]")
        XCTAssertEqual(items[4].value, "1")
    }
    
    func testChargeWithLoadedCustomer() throws {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5dzgq88ehh6gavj0h59") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 100000)
                
                XCTAssertEqual(charge.transaction?.dataID, "trxn_test_5dzgq8b5uhhh89j8sxf")
                
                if case .loaded(let customer)? = charge.customer {
                    XCTAssertNotNil(customer.customerDescription)
                    XCTAssertEqual(customer.id, "cust_test_5dzgpes169hkk7n1b4n")
                    XCTAssertEqual(customer.email, "john.doe@example.com")
                } else {
                    XCTFail("Cannot parse transaction data")
                }
                if case .loaded(let transaction)? = charge.transaction {
                    XCTAssertEqual(transaction.amount, 3041997)
                } else {
                    XCTFail("Cannot parse transaction data")
                }
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeChargeWithLoadedCustomer() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5dzgq88ehh6gavj0h59")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLive, decodedCharge.isLive)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.dataID, decodedCharge.transaction?.dataID)
        XCTAssertEqual(defaultCharge.source?.id, decodedCharge.source?.id)
        XCTAssertEqual(defaultCharge.refunded, decodedCharge.refunded)
        
        XCTAssertEqual(defaultCharge.refunds?.object, defaultCharge.refunds?.object)
        XCTAssertEqual(defaultCharge.refunds?.from, decodedCharge.refunds?.from)
        XCTAssertEqual(defaultCharge.refunds?.to, decodedCharge.refunds?.to)
        XCTAssertEqual(defaultCharge.refunds?.offset, decodedCharge.refunds?.offset)
        XCTAssertEqual(defaultCharge.refunds?.limit, decodedCharge.refunds?.limit)
        XCTAssertEqual(defaultCharge.refunds?.total, decodedCharge.refunds?.total)
        
        XCTAssertEqual(defaultCharge.returnURL, decodedCharge.returnURL)
        XCTAssertEqual(defaultCharge.authorizedURL, decodedCharge.authorizedURL)
        
        XCTAssertEqual(defaultCharge.card?.object, decodedCharge.card?.object)
        XCTAssertEqual(defaultCharge.card?.id, decodedCharge.card?.id)
        XCTAssertEqual(defaultCharge.card?.isLive, decodedCharge.card?.isLive)
        XCTAssertEqual(defaultCharge.card?.countryCode, decodedCharge.card?.countryCode)
        XCTAssertEqual(defaultCharge.card?.city, decodedCharge.card?.city)
        XCTAssertEqual(defaultCharge.card?.postalCode, decodedCharge.card?.postalCode)
        XCTAssertEqual(defaultCharge.card?.financing, decodedCharge.card?.financing)
        XCTAssertEqual(defaultCharge.card?.bankName, decodedCharge.card?.bankName)
        XCTAssertEqual(defaultCharge.card?.lastDigits, decodedCharge.card?.lastDigits)
        XCTAssertEqual(defaultCharge.card?.brand, decodedCharge.card?.brand)
        XCTAssertEqual(defaultCharge.card?.expiration?.month, decodedCharge.card?.expiration?.month)
        XCTAssertEqual(defaultCharge.card?.expiration?.year, decodedCharge.card?.expiration?.year)
        XCTAssertEqual(defaultCharge.card?.fingerPrint, decodedCharge.card?.fingerPrint)
        XCTAssertEqual(defaultCharge.card?.name, decodedCharge.card?.name)
        XCTAssertEqual(defaultCharge.card?.createdDate, decodedCharge.card?.createdDate)
        
        XCTAssertEqual(defaultCharge.customer?.dataID, decodedCharge.customer?.dataID)
        
        XCTAssertEqual(defaultCharge.ipAddress, decodedCharge.ipAddress)
        XCTAssertEqual(defaultCharge.dispute?.amount, decodedCharge.dispute?.amount)
        XCTAssertEqual(defaultCharge.createdDate, decodedCharge.createdDate)
    }
    
    
    // MARK: - Resilient Cases
    
    func testResilientInternetBankingChargeRetrieve() {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_resilient_with_internet_banking_oms_source") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 100000)
                XCTAssertEqual(charge.source?.paymentInformation.sourceType, EnrolledSource.EnrolledPaymentInformation.internetBanking(.unknown("oms")).sourceType)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeResilientInternetBankingChargeRetrieve() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_resilient_with_internet_banking_oms_source")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLive, decodedCharge.isLive)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.dataID, decodedCharge.transaction?.dataID)
        XCTAssertEqual(defaultCharge.refunded, decodedCharge.refunded)
        
        XCTAssertEqual(defaultCharge.refunds?.object, defaultCharge.refunds?.object)
        XCTAssertEqual(defaultCharge.refunds?.from, decodedCharge.refunds?.from)
        XCTAssertEqual(defaultCharge.refunds?.to, decodedCharge.refunds?.to)
        XCTAssertEqual(defaultCharge.refunds?.offset, decodedCharge.refunds?.offset)
        XCTAssertEqual(defaultCharge.refunds?.limit, decodedCharge.refunds?.limit)
        XCTAssertEqual(defaultCharge.refunds?.total, decodedCharge.refunds?.total)
        
        XCTAssertEqual(defaultCharge.returnURL, decodedCharge.returnURL)
        XCTAssertEqual(defaultCharge.authorizedURL, decodedCharge.authorizedURL)
        XCTAssertEqual(defaultCharge.createdDate, decodedCharge.createdDate)
        
        XCTAssertEqual(defaultCharge.source?.object, decodedCharge.source?.object)
        XCTAssertEqual(defaultCharge.source?.id, decodedCharge.source?.id)
        XCTAssertEqual(defaultCharge.source?.sourceType.value, decodedCharge.source?.sourceType.value)
        XCTAssertEqual(defaultCharge.source?.flow, decodedCharge.source?.flow)
        XCTAssertEqual(defaultCharge.source?.amount, decodedCharge.source?.amount)
        XCTAssertEqual(defaultCharge.source?.currency, decodedCharge.source?.currency)
        XCTAssertEqual(defaultCharge.source?.paymentInformation.sourceType, decodedCharge.source?.paymentInformation.sourceType)
        
    }
    
    func testResilientSourceChargeRetrieve() {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_resilient_with_omise_source") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 100000)
                
                if case let .unknown(name: name, references: references)? = charge.source?.paymentInformation {
                    XCTAssertEqual(name, "omise")
                    XCTAssertEqual((references as? [String: String]) ?? [:], [
                        "account_id": "0105556091152",
                        "reference": "025821267592373884",
                        "key": "237000400584228075",
                        "barcode": "https://api.omise.co/charges/chrg_test_resilient_with_omise_source/documents/docu_test_5929fjznrj5nsr0fqhu/download"
                        ] as [String: String])
                }
                
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeResilientSourceChargeRetrieve() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_resilient_with_omise_source")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLive, decodedCharge.isLive)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.dataID, decodedCharge.transaction?.dataID)
        XCTAssertEqual(defaultCharge.refunded, decodedCharge.refunded)
        
        XCTAssertEqual(defaultCharge.refunds?.object, defaultCharge.refunds?.object)
        XCTAssertEqual(defaultCharge.refunds?.from, decodedCharge.refunds?.from)
        XCTAssertEqual(defaultCharge.refunds?.to, decodedCharge.refunds?.to)
        XCTAssertEqual(defaultCharge.refunds?.offset, decodedCharge.refunds?.offset)
        XCTAssertEqual(defaultCharge.refunds?.limit, decodedCharge.refunds?.limit)
        XCTAssertEqual(defaultCharge.refunds?.total, decodedCharge.refunds?.total)
        
        XCTAssertEqual(defaultCharge.returnURL, decodedCharge.returnURL)
        XCTAssertEqual(defaultCharge.authorizedURL, decodedCharge.authorizedURL)
        XCTAssertEqual(defaultCharge.createdDate, decodedCharge.createdDate)
        
        XCTAssertEqual(defaultCharge.source?.object, decodedCharge.source?.object)
        XCTAssertEqual(defaultCharge.source?.id, decodedCharge.source?.id)
        XCTAssertEqual(defaultCharge.source?.sourceType.value, decodedCharge.source?.sourceType.value)
        XCTAssertEqual(defaultCharge.source?.flow, decodedCharge.source?.flow)
        XCTAssertEqual(defaultCharge.source?.amount, decodedCharge.source?.amount)
        XCTAssertEqual(defaultCharge.source?.currency, decodedCharge.source?.currency)

        switch (defaultCharge.source?.paymentInformation, decodedCharge.source?.paymentInformation) {
        case (EnrolledSource.EnrolledPaymentInformation.unknown(name: let name, references: let references)?,
              EnrolledSource.EnrolledPaymentInformation.unknown(name: let decodedName, references: let decodedReferences)?):
            XCTAssertEqual(name, decodedName)
            XCTAssertNotNil(decodedReferences as? [String: String])
            XCTAssertEqual(references as? [String: String] ?? [:], decodedReferences as? [String: String] ?? [:])
        default:
            XCTFail("Wrong source information on Testco Lotus Bill Payment charge")
        }
    }
    
    func testResilientBillPaymentChargeRetrieve() {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_resilient_with_bill_payment_papaya_source") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 100000)
                XCTAssertEqual(charge.source?.amount, charge.amount)
                XCTAssertEqual(charge.source?.id, "src_test_5dzgra1hjrajmcvawuc")
                XCTAssertEqual(charge.source?.flow, .offline)
                switch charge.source?.paymentInformation {
                case EnrolledSource.EnrolledPaymentInformation.billPayment(.unknown(name: let name, references: let references))?:
                    XCTAssertEqual(name, "papaya")
                    XCTAssertEqual((references as? [String: String]) ?? [:], [
                        "omise_id": "0105556091152",
                        "reference_1": "025821267592373884",
                        "key": "237000400584228075",
                        "barcode": "https://api.omise.co/charges/chrg_test_resilient_with_bill_payment_papaya_source/documents/docu_test_5929fjznrj5nsr0fqhu/download"
                        ] as [String: String])
                default:
                    XCTFail("Wrong source information on Testco Lotus Bill Payment charge")
                }
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeResilientBillPaymentChargeRetrieve() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_resilient_with_bill_payment_papaya_source")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLive, decodedCharge.isLive)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.dataID, decodedCharge.transaction?.dataID)
        XCTAssertEqual(defaultCharge.refunded, decodedCharge.refunded)
        
        XCTAssertEqual(defaultCharge.refunds?.object, defaultCharge.refunds?.object)
        XCTAssertEqual(defaultCharge.refunds?.from, decodedCharge.refunds?.from)
        XCTAssertEqual(defaultCharge.refunds?.to, decodedCharge.refunds?.to)
        XCTAssertEqual(defaultCharge.refunds?.offset, decodedCharge.refunds?.offset)
        XCTAssertEqual(defaultCharge.refunds?.limit, decodedCharge.refunds?.limit)
        XCTAssertEqual(defaultCharge.refunds?.total, decodedCharge.refunds?.total)
        
        XCTAssertEqual(defaultCharge.source?.object, decodedCharge.source?.object)
        XCTAssertEqual(defaultCharge.source?.id, decodedCharge.source?.id)
        XCTAssertEqual(defaultCharge.source?.sourceType.value, decodedCharge.source?.sourceType.value)
        XCTAssertEqual(defaultCharge.source?.flow, decodedCharge.source?.flow)
        XCTAssertEqual(defaultCharge.source?.amount, decodedCharge.source?.amount)
        XCTAssertEqual(defaultCharge.source?.currency, decodedCharge.source?.currency)
        XCTAssertEqual(defaultCharge.source?.paymentInformation.sourceType, decodedCharge.source?.paymentInformation.sourceType)
        switch (defaultCharge.source?.paymentInformation, decodedCharge.source?.paymentInformation) {
        case (EnrolledSource.EnrolledPaymentInformation.billPayment(.unknown(name: let billName, references: let billReferences))?,
              EnrolledSource.EnrolledPaymentInformation.billPayment(.unknown(name: let decodedBillName, references: let decodedBillReferences))?):
            XCTAssertEqual(billName, decodedBillName)
            XCTAssertNotNil(decodedBillReferences as? [String: String])
            XCTAssertEqual(billReferences as? [String: String] ?? [:], decodedBillReferences as? [String: String] ?? [:])
        default:
            XCTFail("Wrong source information on Testco Lotus Bill Payment charge")
        }
    }
    
}


extension ChargeParams: AdditionalFixtureData {
    var fixtureFileSuffix: String? {
        switch payment {
        case .card(let id), .customer(customerID: let id, cardID: _):
            return id
        case .source(let source):
            return source.id
        case .sourceType(let sourceType):
            return sourceType.sourceType.value
        }
    }
}

