import XCTest
@testable import Omise


private let chargeTestingID = "chrg_test_4yq7duw15p9hdrjp8oq"

class ChargesOperationFixtureTests: FixtureTestCase {
    func testChargeRetrieve() {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: chargeTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 100000)
                XCTAssertEqual(charge.value.currency.code, "THB")
                XCTAssertEqual(charge.chargeDescription, "Charge for order 3947")
                XCTAssertEqual(charge.id, chargeTestingID)
                XCTAssertEqual(charge.location, "/charges/chrg_test_4yq7duw15p9hdrjp8oq")
                XCTAssertEqual(charge.isLive, false)
                XCTAssertEqual(charge.refunded, 10000)
                XCTAssertEqual(charge.transaction?.dataID, "trxn_test_4yq7duwb9jts1vxgqua")
                XCTAssertEqual(charge.customer?.dataID, "cust_test_4yq6txdpfadhbaqnwp3")
                XCTAssertEqual(charge.createdDate, dateFormatter.date(from: "2015-01-15T05:00:29Z"))
                XCTAssertEqual(charge.card?.id, "card_test_4yq6tuucl9h4erukfl0")
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
                XCTAssertEqual(charge.chargeDescription, "Test API Version 2014-07-27")
                XCTAssertEqual(charge.id, "chrg_test_57v787rzs4vr0dj1xc0")
                XCTAssertEqual(charge.location, "/charges/chrg_test_57v787rzs4vr0dj1xc0")
                XCTAssertEqual(charge.isLive, false)
                XCTAssertEqual(charge.isPaid, true)
                XCTAssertEqual(charge.refunded, 0)
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
                XCTAssertEqual(chargeSampleData?.value.amount, 3190000)
                let expiredCharges = chargesList.data.filter({ .expired ~= $0.status })
                XCTAssertEqual(expiredCharges.count, 1)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testChargeCreate() {
        let expectation = self.expectation(description: "Charge create")
        
        let createParams = ChargeParams(value: Value(amount: 1_000_00, currency: .thb), cardID: "")
        
        let request = Charge.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertNotNil(charge)
                XCTAssertEqual(charge.value.amount, 100000)
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
        
        let request = Charge.update(using: testClient, id: chargeTestingID, params: updateParams) { (result) in
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
        
        let request = Charge.retrieve(using: testClient, id: "chrg_5668k0kp0a9v2mr7myq") { (result) in
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
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_5668k0kp0a9v2mr7myq")
        
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
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_57003cpwde7oww4x3o0") { (result) in
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
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_57003cpwde7oww4x3o0")
        
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
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5929fjoo8hwgakspj7y") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 100000)
                XCTAssertEqual(charge.source?.amount, charge.amount)
                XCTAssertEqual(charge.source?.id, "src_test_5929eggu29qfzi5vcfs")
                XCTAssertEqual(charge.source?.flow, .offline)
                switch charge.source?.paymentInformation {
                case EnrolledSource.EnrolledPaymentInformation.billPayment(.tescoLotus(let bill))?:
                    XCTAssertEqual(bill.omiseTaxID, "0105556091152")
                    XCTAssertEqual(bill.referenceNumber1, "025821267592373884")
                    XCTAssertEqual(bill.referenceNumber2, "237000400584228075")
                    XCTAssertEqual(bill.barcodeURL, URL(string: "https://api.omise.co/charges/chrg_test_5929fjoo8hwgakspj7y/documents/docu_test_5929fjznrj5nsr0fqhu/download")!)
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
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5929fjoo8hwgakspj7y")
        
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
        default:
            XCTFail("Wrong source information on Testco Lotus Bill Payment charge")
        }
    }
    
    func testSinarmasVirtualAccountChargeRetrieve() {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_592kd97reyadw42v247") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.amount, 1100000)
                XCTAssertEqual(charge.currency, .idr)
                XCTAssertEqual(charge.source?.amount, charge.amount)
                XCTAssertEqual(charge.source?.currency, charge.currency)
                XCTAssertEqual(charge.source?.id, "src_test_592kd3dkxre5h91e5cf")
                XCTAssertEqual(charge.source?.flow, .offline)
                switch charge.source?.paymentInformation {
                case EnrolledSource.EnrolledPaymentInformation.virtualAccount(EnrolledSource.PaymentInformation.VirtualAccount.sinarmas(vaCode: let vaCode))?:
                    XCTAssertEqual(vaCode, "2128932047849310")
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
    
    func testEncodeChargeWithSinarmasVirtualAccountSource() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_592kd97reyadw42v247")
        
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
    
    func testWalletAlipayChargeRetrieve() throws {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5au1dtnsoc7noi31yab") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.amount, 22_25)
                XCTAssertEqual(charge.currency, .thb)
                XCTAssertEqual(charge.source?.amount, charge.amount)
                XCTAssertEqual(charge.source?.currency, charge.currency)
                XCTAssertEqual(charge.source?.id, "src_test_5atzxwlghyr2jydh33h")
                XCTAssertEqual(charge.source?.flow, .offline)
                XCTAssertEqual(charge.metadata["invoice_id"] as? String, "inv-1234567890")
                switch charge.source?.paymentInformation {
                case .wallet(.alipay(let alipayWallet))?:
                    XCTAssertEqual(alipayWallet.expired, dateFormatter.date(from: "2018-02-03T11:53:15Z"))
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
    
    func testEncodeWalletAlipayCharge() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5au1dtnsoc7noi31yab")
        
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
        let source = PaymentSource(id: "src_test_12345", object: "source", location: "/sources/src_test_12345", currency: .thb, amount: 10_000_00, flow: .redirect, paymentInformation: .alipay)
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
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_59f0shjjikr16e93vfq") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 99900)
                
                XCTAssertEqual(charge.transaction?.dataID, "trxn_test_59f0shn44u2jnh9x2vv")
                
                if case .loaded(let customer)? = charge.customer {
                    XCTAssertNil(customer.customerDescription)
                    XCTAssertEqual(customer.id, "cust_test_53ip53r3m4jjy3c28n4")
                    XCTAssertEqual(customer.email, "robin@omise.co")
                } else {
                    XCTFail("Cannot parse transaction data")
                }
                if case .loaded(let transaction)? = charge.transaction {
                    XCTAssertEqual(transaction.amount, 95999)
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
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_59f0shjjikr16e93vfq")
        
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
                XCTAssertEqual(charge.source?.id, "src_test_5929eggu29qfzi5vcfs")
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
    
    func testResilientVirtualAccountChargeRetrieve() {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_resilient_with_virtual_account_cinimas_source") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.amount, 1100000)
                XCTAssertEqual(charge.currency, .idr)
                XCTAssertEqual(charge.source?.amount, charge.amount)
                XCTAssertEqual(charge.source?.currency, charge.currency)
                XCTAssertEqual(charge.source?.id, "src_test_592kd3dkxre5h91e5cf")
                XCTAssertEqual(charge.source?.flow, .offline)
                switch charge.source?.paymentInformation {
                case EnrolledSource.EnrolledPaymentInformation.virtualAccount(EnrolledSource.PaymentInformation.VirtualAccount.unknown(name: let name, references: let references))?:
                    XCTAssertEqual(name, "cinimas")
                    XCTAssertEqual((references as? [String: String]) ?? [:], [
                        "cinimas_code": "2128932047849310"
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
    
    func testEncodeChargeWithResilientVirtualAccountSource() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_resilient_with_virtual_account_cinimas_source")
        
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
        case (EnrolledSource.EnrolledPaymentInformation.virtualAccount(.unknown(name: let virtualAccountName, references: let virtualAccountReferences))?,
              EnrolledSource.EnrolledPaymentInformation.virtualAccount(.unknown(name: let decodedVirtualAccountName, references: let decodedVirtualAccountReferences))?):
            XCTAssertEqual(virtualAccountName, decodedVirtualAccountName)
            XCTAssertNotNil(decodedVirtualAccountReferences as? [String: String])
            XCTAssertEqual(virtualAccountReferences as? [String: String] ?? [:], decodedVirtualAccountReferences as? [String: String] ?? [:])
        default:
            XCTFail("Wrong source information on Testco Lotus Bill Payment charge")
        }
    }
    
}


