import XCTest
@testable import Omise


private let defaultReturnURL = URL(string: "https://omise.co")!

class ChargesOperationFixtureTests: FixtureTestCase {
    func testChargeRetrieve() {
        let chargeTestingID: DataID<Charge>  = "chrg_test_5fzbppsjk5q9cxqjz0o"
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: chargeTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 10_000_00)
                XCTAssertEqual(charge.value.currency, .thb)
                XCTAssertNil(charge.chargeDescription)
                XCTAssertEqual(charge.id, chargeTestingID)
                XCTAssertEqual(charge.location, "/charges/chrg_test_5fzbppsjk5q9cxqjz0o")
                XCTAssertEqual(charge.isLiveMode, false)
                XCTAssertEqual(charge.fundingAmount, 10_000_00)
                XCTAssertEqual(charge.fundingCurrency, .thb)
                XCTAssertEqual(charge.refundedAmount, 0)
                XCTAssertEqual(charge.transaction?.id, "trxn_test_5fzbppuzeobh8evajc2")
                XCTAssertNil(charge.customer?.id)
                XCTAssertEqual(charge.createdDate, dateFormatter.date(from: "2019-05-22T05:09:28Z"))
                XCTAssertEqual(charge.card?.id, "card_test_5fzbppot4s4ozksb0f9")
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeChargeRetrieve() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5fzbppsjk5q9cxqjz0o")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLiveMode, decodedCharge.isLiveMode)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.id, decodedCharge.transaction?.id)
        XCTAssertEqual(defaultCharge.source?.id, decodedCharge.source?.id)
        XCTAssertEqual(defaultCharge.refundedAmount, decodedCharge.refundedAmount)
        
        XCTAssertEqual(defaultCharge.refunds.object, defaultCharge.refunds.object)
        XCTAssertEqual(defaultCharge.refunds.from, decodedCharge.refunds.from)
        XCTAssertEqual(defaultCharge.refunds.to, decodedCharge.refunds.to)
        XCTAssertEqual(defaultCharge.refunds.offset, decodedCharge.refunds.offset)
        XCTAssertEqual(defaultCharge.refunds.limit, decodedCharge.refunds.limit)
        XCTAssertEqual(defaultCharge.refunds.total, decodedCharge.refunds.total)

        XCTAssertEqual(defaultCharge.returnURL, decodedCharge.returnURL)
        XCTAssertEqual(defaultCharge.authorizedURL, decodedCharge.authorizedURL)
        
        XCTAssertEqual(defaultCharge.card?.object, decodedCharge.card?.object)
        XCTAssertEqual(defaultCharge.card?.id, decodedCharge.card?.id)
        XCTAssertEqual(defaultCharge.card?.isLiveMode, decodedCharge.card?.isLiveMode)
        XCTAssertEqual(defaultCharge.card?.billingAddress.countryCode, decodedCharge.card?.billingAddress.countryCode)
        XCTAssertEqual(defaultCharge.card?.billingAddress.city, decodedCharge.card?.billingAddress.city)
        XCTAssertEqual(defaultCharge.card?.billingAddress.postalCode, decodedCharge.card?.billingAddress.postalCode)
        XCTAssertEqual(defaultCharge.card?.financing, decodedCharge.card?.financing)
        XCTAssertEqual(defaultCharge.card?.bankName, decodedCharge.card?.bankName)
        XCTAssertEqual(defaultCharge.card?.lastDigits, decodedCharge.card?.lastDigits)
        XCTAssertEqual(defaultCharge.card?.brand, decodedCharge.card?.brand)
        XCTAssertEqual(defaultCharge.card?.expiration?.month, decodedCharge.card?.expiration?.month)
        XCTAssertEqual(defaultCharge.card?.expiration?.year, decodedCharge.card?.expiration?.year)
        XCTAssertEqual(defaultCharge.card?.fingerPrint, decodedCharge.card?.fingerPrint)
        XCTAssertEqual(defaultCharge.card?.name, decodedCharge.card?.name)
        XCTAssertEqual(defaultCharge.card?.createdDate, decodedCharge.card?.createdDate)
        
        XCTAssertEqual(defaultCharge.customer?.id, decodedCharge.customer?.id)
        XCTAssertEqual(defaultCharge.ipAddress, decodedCharge.ipAddress)
        XCTAssertEqual(defaultCharge.dispute?.amount, decodedCharge.dispute?.amount)
        XCTAssertEqual(defaultCharge.createdDate, decodedCharge.createdDate)
        
        XCTAssertEqual(defaultCharge.value.amount, decodedCharge.value.amount)
        XCTAssertEqual(defaultCharge.value.amountInUnit, decodedCharge.value.amountInUnit)
        XCTAssertEqual(defaultCharge.value.currency, defaultCharge.value.currency)
    }
    
    func testDisputedChargeRetrieve() {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5flpmtdmcibefxk7bxc") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 2_00_00)
                XCTAssertEqual(charge.value.currency.code, "THB")
                XCTAssertEqual(charge.chargeDescription, "John Doe")
                XCTAssertEqual(charge.id, "chrg_test_5flpmtdmcibefxk7bxc")
                XCTAssertEqual(charge.location, "/charges/chrg_test_5flpmtdmcibefxk7bxc")
                XCTAssertEqual(charge.isLiveMode, false)
                XCTAssertEqual(charge.transaction?.id, "trxn_test_5flpmtfvna92r53pzuh")
                XCTAssertEqual(charge.createdDate, dateFormatter.date(from: "2019-04-17T09:50:17Z"))
                XCTAssertNotNil(charge.dispute)
                
                XCTAssertEqual(charge.dispute?.id, "dspt_test_5fqcgl9si4xqs3fi4hp")
                XCTAssertEqual(charge.dispute?.value.amount, 200_00)
                XCTAssertEqual(charge.dispute?.status, .pending)
                XCTAssertEqual(charge.dispute?.reasonCode, .goodsOrServicesNotProvided)
                XCTAssertEqual(charge.dispute?.reasonMessage, "Services not provided or Merchandise not received")
                XCTAssertEqual(charge.dispute?.responseMessage, "This is a response message")
                XCTAssertEqual(charge.dispute?.charge.id, "chrg_test_5flpmtdmcibefxk7bxc")
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeDisputedCharge() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5flpmtdmcibefxk7bxc")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLiveMode, decodedCharge.isLiveMode)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.id, decodedCharge.transaction?.id)
        XCTAssertEqual(defaultCharge.source?.id, decodedCharge.source?.id)
        XCTAssertEqual(defaultCharge.refundedAmount, decodedCharge.refundedAmount)
        
        XCTAssertEqual(defaultCharge.refunds.object, defaultCharge.refunds.object)
        XCTAssertEqual(defaultCharge.refunds.from, decodedCharge.refunds.from)
        XCTAssertEqual(defaultCharge.refunds.to, decodedCharge.refunds.to)
        XCTAssertEqual(defaultCharge.refunds.offset, decodedCharge.refunds.offset)
        XCTAssertEqual(defaultCharge.refunds.limit, decodedCharge.refunds.limit)
        XCTAssertEqual(defaultCharge.refunds.total, decodedCharge.refunds.total)
        
        XCTAssertEqual(defaultCharge.returnURL, decodedCharge.returnURL)
        XCTAssertEqual(defaultCharge.authorizedURL, decodedCharge.authorizedURL)
        
        XCTAssertEqual(defaultCharge.card?.object, decodedCharge.card?.object)
        XCTAssertEqual(defaultCharge.card?.id, decodedCharge.card?.id)
        XCTAssertEqual(defaultCharge.card?.isLiveMode, decodedCharge.card?.isLiveMode)
        XCTAssertEqual(defaultCharge.card?.billingAddress.countryCode, decodedCharge.card?.billingAddress.countryCode)
        XCTAssertEqual(defaultCharge.card?.billingAddress.city, decodedCharge.card?.billingAddress.city)
        XCTAssertEqual(defaultCharge.card?.billingAddress.postalCode, decodedCharge.card?.billingAddress.postalCode)
        XCTAssertEqual(defaultCharge.card?.financing, decodedCharge.card?.financing)
        XCTAssertEqual(defaultCharge.card?.bankName, decodedCharge.card?.bankName)
        XCTAssertEqual(defaultCharge.card?.lastDigits, decodedCharge.card?.lastDigits)
        XCTAssertEqual(defaultCharge.card?.brand, decodedCharge.card?.brand)
        XCTAssertEqual(defaultCharge.card?.expiration?.month, decodedCharge.card?.expiration?.month)
        XCTAssertEqual(defaultCharge.card?.expiration?.year, decodedCharge.card?.expiration?.year)
        XCTAssertEqual(defaultCharge.card?.fingerPrint, decodedCharge.card?.fingerPrint)
        XCTAssertEqual(defaultCharge.card?.name, decodedCharge.card?.name)
        XCTAssertEqual(defaultCharge.card?.createdDate, decodedCharge.card?.createdDate)
        
        XCTAssertEqual(defaultCharge.customer?.id, decodedCharge.customer?.id)
        XCTAssertEqual(defaultCharge.ipAddress, decodedCharge.ipAddress)
        XCTAssertEqual(defaultCharge.createdDate, decodedCharge.createdDate)
        
        XCTAssertEqual(defaultCharge.value.amount, decodedCharge.value.amount)
        XCTAssertEqual(defaultCharge.value.amountInUnit, decodedCharge.value.amountInUnit)
        XCTAssertEqual(defaultCharge.value.currency, defaultCharge.value.currency)
        
        XCTAssertNotNil(defaultCharge.dispute)
        XCTAssertNotNil(decodedCharge.dispute)
        XCTAssertEqual(defaultCharge.dispute?.object, decodedCharge.dispute?.object)
        XCTAssertEqual(defaultCharge.dispute?.id, decodedCharge.dispute?.id)
        XCTAssertEqual(defaultCharge.dispute?.isLiveMode, decodedCharge.dispute?.isLiveMode)
        XCTAssertEqual(defaultCharge.dispute?.location, decodedCharge.dispute?.location)
        XCTAssertEqual(defaultCharge.dispute?.value.amount, decodedCharge.dispute?.value.amount)
        XCTAssertEqual(defaultCharge.dispute?.value.amountInUnit, decodedCharge.dispute?.value.amountInUnit)
        XCTAssertEqual(defaultCharge.dispute?.value.currency, decodedCharge.dispute?.value.currency)
        XCTAssertEqual(defaultCharge.dispute?.status, decodedCharge.dispute?.status)
        XCTAssertEqual(defaultCharge.dispute?.transactions.first?.id, decodedCharge.dispute?.transactions.first?.id)
        XCTAssertEqual(defaultCharge.dispute?.reasonCode, decodedCharge.dispute?.reasonCode)
        XCTAssertEqual(defaultCharge.dispute?.reasonMessage, decodedCharge.dispute?.reasonMessage)
        XCTAssertEqual(defaultCharge.dispute?.responseMessage, decodedCharge.dispute?.responseMessage)
        XCTAssertEqual(defaultCharge.dispute?.charge.id, decodedCharge.dispute?.charge.id)
        XCTAssertEqual(defaultCharge.dispute?.documents.total, decodedCharge.dispute?.documents.total)
        XCTAssertEqual(defaultCharge.dispute?.createdDate, decodedCharge.dispute?.createdDate)
        
        guard let defaultDocument = defaultCharge.dispute?.documents.first, let decodedDocument = decodedCharge.dispute?.documents.first else {
            XCTFail("Cannot get the recent document")
            return
        }
        
        XCTAssertEqual(defaultDocument.object, decodedDocument.object)
        XCTAssertEqual(defaultDocument.id, decodedDocument.id)
        XCTAssertEqual(defaultDocument.isLiveMode, decodedDocument.isLiveMode)
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
                XCTAssertEqual(chargesList.data.count, 20)
                let chargeSampleData = chargesList.data.first
                XCTAssertNotNil(chargeSampleData)
                XCTAssertEqual(chargeSampleData?.value.amount, 1000000)
                XCTAssertEqual(chargeSampleData?.value.currency, .thb)
                XCTAssertEqual(chargeSampleData?.fundingValue.amount, 1000000)
                XCTAssertEqual(chargeSampleData?.fundingValue.currency, .thb)
                
                let pendingCharges = chargesList.data.filter({ .pending ~= $0.status })
                XCTAssertEqual(pendingCharges.count, 14)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testCustomerChargeCreate() {
        let expectation = self.expectation(description: "Charge create")
        
        let createParams = ChargeParams(value: Value(amount: 10_000_00, currency: .thb), customerID: "cust_test_customer")
        
        let request = Charge.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertNotNil(charge)
                XCTAssertEqual(charge.fundingValue.amount, 10_000_00)
                XCTAssertEqual(charge.fundingValue.currency, .thb)
                
                
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testAlipayChargeCreate() {
        let expectation = self.expectation(description: "Alipay Charge create")
        
        let createParams = ChargeParams(value: Value(amount: 10_000_00, currency: .thb), sourceType: .alipay, returnURL: defaultReturnURL)
        
        let request = Charge.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertNotNil(charge)
                XCTAssertEqual(charge.value.amount, 10_000_00)
                XCTAssertEqual(charge.source?.paymentInformation, .alipay)
                XCTAssertEqual(charge.returnURL, defaultReturnURL)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testBillPaymentChargeCreate() {
        let expectation = self.expectation(description: "Bill Payment Charge create")
        
        let createParams = ChargeParams(value: Value(amount: 10_000_00, currency: .thb), sourceType: .billPayment(.tescoLotus), returnURL: defaultReturnURL)
        
        let request = Charge.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            let billInformation = EnrolledSource.EnrolledPaymentInformation.BillPayment.BillInformation(
                omiseTaxID: "0105556091152",
                referenceNumber1: "072069591314674529",
                referenceNumber2: "973863183337739418",
                barcodeURL: URL(string: "https://api.omise.co/charges/chrg_test_5fz0fjxkigm3hytmr0s/documents/docu_test_5fz0fjysdfl69m8on9k/downloads/A20EAA1FA45FAFEC")!,
                expiredDate: dateFormatter.date(from: "2019-05-22T09:55:39Z")!)
            
            switch result {
            case let .success(charge):
                XCTAssertNotNil(charge)
                XCTAssertEqual(charge.value.amount, 1_000_00)
                XCTAssertEqual(charge.source?.paymentInformation, .billPayment(.tescoLotus(billInformation)))
                XCTAssertEqual(charge.returnURL, defaultReturnURL)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testInternetBankingChargeCreate() {
        let expectation = self.expectation(description: "Internet Banking SCB Charge create")
        
        let createParams = ChargeParams(value: Value(amount: 100_00, currency: .thb), sourceType: .internetBanking(.scb), returnURL: defaultReturnURL)
        
        let request = Charge.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertNotNil(charge)
                XCTAssertEqual(charge.value.amount, 10_000_00)
                XCTAssertEqual(charge.source?.paymentInformation, .internetBanking(.scb))
                XCTAssertEqual(charge.returnURL, defaultReturnURL)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testBarcodeAlipayChargeCreate() {
        let expectation = self.expectation(description: "Barcode Alipay Charge create")
        
        let alipayBarcode = AlipayBarcodeParams(storeID: "1", storeName: "Main Store", terminalID: nil, barcode: "1234567890123456")
        let createParams = ChargeParams(value: Value(amount: 10_000_00, currency: .thb), sourceType: .barcode(.alipay(alipayBarcode)))
        
        let request = Charge.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertNotNil(charge)
                XCTAssertEqual(charge.value.amount, 10_000_00)
                XCTAssertEqual(charge.source?.paymentInformation, .barcode(.alipay(EnrolledSource.EnrolledPaymentInformation.Barcode.AlipayBarcode(expiredDate: dateFormatter.date(from: "2018-11-20T11:48:22Z")!))))
            case let .failure(error):
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
        
        let request = Charge.update(using: testClient, id: "chrg_test_5fzbppsjk5q9cxqjz0o", params: updateParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.chargeDescription, "Charge for order 3947 (XXL)")
                XCTAssertEqual(charge.metadata["user-id"] as? String, "a-user-id")
                XCTAssertEqual((charge.metadata["user"] as? [String: Any])?["name"] as? String, "John Appleseed")
                XCTAssertEqual((charge.metadata["user"] as? [String: Any])?["tel"] as? String, "08-xxxx-xxxx")
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testDeletedCardChargeRetrieve() {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5fzc99n9gvnqvlmcior") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 10_000_00)
                XCTAssertEqual(charge.value.currency.code, "THB")
                XCTAssertEqual(charge.id, "chrg_test_5fzc99n9gvnqvlmcior")
                XCTAssertEqual(charge.location, "/charges/chrg_test_5fzc99n9gvnqvlmcior")
                XCTAssertEqual(charge.isLiveMode, false)
                XCTAssertEqual(charge.refundedAmount, 0)
                XCTAssertEqual(charge.transaction?.id, "trxn_test_5fzc99osk6yqddb4msq")
                XCTAssertEqual(charge.createdDate, dateFormatter.date(from: "2019-05-22T06:05:00Z"))
                XCTAssertNil(charge.chargeDescription)
                XCTAssertNil(charge.customer?.id)
                if case .tokenized(let deletedCard)? = charge.card {
                    XCTAssertEqual(deletedCard.id, "card_test_5fz0od4o3fn29wp14t4")
                } else {
                    XCTFail("This charge should have the deleted card value")
                }
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testInternetBankingChargeRetrieve() {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5fzc7xbzon56ydkdl5k") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 1000000)
                XCTAssertEqual(charge.source?.paymentInformation.sourceType, EnrolledSource.EnrolledPaymentInformation.internetBanking(.scb).sourceType)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeInternetBankingChargeRetrieve() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5fzc7xbzon56ydkdl5k")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLiveMode, decodedCharge.isLiveMode)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.id, decodedCharge.transaction?.id)
        XCTAssertEqual(defaultCharge.refundedAmount, decodedCharge.refundedAmount)
        
        XCTAssertEqual(defaultCharge.refunds.object, defaultCharge.refunds.object)
        XCTAssertEqual(defaultCharge.refunds.from, decodedCharge.refunds.from)
        XCTAssertEqual(defaultCharge.refunds.to, decodedCharge.refunds.to)
        XCTAssertEqual(defaultCharge.refunds.offset, decodedCharge.refunds.offset)
        XCTAssertEqual(defaultCharge.refunds.limit, decodedCharge.refunds.limit)
        XCTAssertEqual(defaultCharge.refunds.total, decodedCharge.refunds.total)
        
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
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5fzc7k07d6oifxi1vl7") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 10_000_00)
                XCTAssertEqual(charge.source?.paymentInformation.sourceType, EnrolledSource.EnrolledPaymentInformation.alipay.sourceType)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeAlipayChargeRetrieve() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5fzc7k07d6oifxi1vl7")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLiveMode, decodedCharge.isLiveMode)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.id, decodedCharge.transaction?.id)
        XCTAssertEqual(defaultCharge.refundedAmount, decodedCharge.refundedAmount)
        
        XCTAssertEqual(defaultCharge.refunds.object, defaultCharge.refunds.object)
        XCTAssertEqual(defaultCharge.refunds.from, decodedCharge.refunds.from)
        XCTAssertEqual(defaultCharge.refunds.to, decodedCharge.refunds.to)
        XCTAssertEqual(defaultCharge.refunds.offset, decodedCharge.refunds.offset)
        XCTAssertEqual(defaultCharge.refunds.limit, decodedCharge.refunds.limit)
        XCTAssertEqual(defaultCharge.refunds.total, decodedCharge.refunds.total)
        
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
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5fzc7srreh7yj3oh6k0") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 10_000_00)
                XCTAssertEqual(charge.source?.amount, charge.amount)
                XCTAssertEqual(charge.source?.id, "src_test_5fzc7socrzb7an79lj9")
                XCTAssertEqual(charge.source?.flow, .offline)
                switch charge.source?.paymentInformation {
                case EnrolledSource.EnrolledPaymentInformation.billPayment(.tescoLotus(let bill))?:
                    XCTAssertEqual(bill.omiseTaxID, "0105556091152")
                    XCTAssertEqual(bill.referenceNumber1, "068263727885787840")
                    XCTAssertEqual(bill.referenceNumber2, "060028266962275319")
                    XCTAssertEqual(bill.barcodeURL, URL(string: "https://api.omise.co/charges/chrg_test_5fzc7srreh7yj3oh6k0/documents/docu_test_5fzc7stfx9z2u3ohh4a/downloads/B6958F0720700012")!)
                default:
                    XCTFail("Wrong source information on Testco Lotus Bill Payment charge")
                }
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeTestcoLotusBillPaymentChargeRetrieve() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5fzc7srreh7yj3oh6k0")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLiveMode, decodedCharge.isLiveMode)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.id, decodedCharge.transaction?.id)
        XCTAssertEqual(defaultCharge.refundedAmount, decodedCharge.refundedAmount)
        
        XCTAssertEqual(defaultCharge.refunds.object, defaultCharge.refunds.object)
        XCTAssertEqual(defaultCharge.refunds.from, decodedCharge.refunds.from)
        XCTAssertEqual(defaultCharge.refunds.to, decodedCharge.refunds.to)
        XCTAssertEqual(defaultCharge.refunds.offset, decodedCharge.refunds.offset)
        XCTAssertEqual(defaultCharge.refunds.limit, decodedCharge.refunds.limit)
        XCTAssertEqual(defaultCharge.refunds.total, decodedCharge.refunds.total)
        
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
            XCTAssertEqual(bill.expiredDate, decodedBill.expiredDate)
        default:
            XCTFail("Wrong source information on Testco Lotus Bill Payment charge")
        }
    }
    
    func testInstallmentKBankChargeRetrieve() {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5fzc7v0ce9ukmm02al2") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.amount, 1000000)
                XCTAssertEqual(charge.currency, .thb)
                XCTAssertEqual(charge.source?.amount, charge.amount)
                XCTAssertEqual(charge.source?.currency, charge.currency)
                XCTAssertEqual(charge.source?.id, "src_test_5fzc7uxck19j90stcj8")
                XCTAssertEqual(charge.source?.flow, .redirect)
                XCTAssertEqual(charge.source?.paymentInformation, EnrolledSource.EnrolledPaymentInformation.installment(.bay))
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testBarcodeAlipayChargeRetrieve() throws {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5fzc7olqr3su9mscg9i") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.amount, 10_000_00)
                XCTAssertEqual(charge.currency, .thb)
                XCTAssertEqual(charge.source?.amount, charge.amount)
                XCTAssertEqual(charge.source?.currency, charge.currency)
                XCTAssertEqual(charge.source?.id, "src_test_5fzc7ogbj2wkx75kq1o")
                XCTAssertEqual(charge.source?.flow, .offline)
                switch charge.source?.paymentInformation {
                case .barcode(.alipay(let alipayBarcode))?:
                    XCTAssertEqual(alipayBarcode.expiredDate, dateFormatter.date(from: "2019-05-23T06:00:30Z"))
                default:
                    XCTFail("Wrong source information on Testco Lotus Bill Payment charge")
                }
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeBarcodeAlipayCharge() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5fzc7olqr3su9mscg9i")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLiveMode, decodedCharge.isLiveMode)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.id, decodedCharge.transaction?.id)
        XCTAssertEqual(defaultCharge.refundedAmount, decodedCharge.refundedAmount)
        
        XCTAssertEqual(defaultCharge.refunds.object, defaultCharge.refunds.object)
        XCTAssertEqual(defaultCharge.refunds.from, decodedCharge.refunds.from)
        XCTAssertEqual(defaultCharge.refunds.to, decodedCharge.refunds.to)
        XCTAssertEqual(defaultCharge.refunds.offset, decodedCharge.refunds.offset)
        XCTAssertEqual(defaultCharge.refunds.limit, decodedCharge.refunds.limit)
        XCTAssertEqual(defaultCharge.refunds.total, decodedCharge.refunds.total)
        
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
        let source = PaymentSource(id: "src_test_12345", object: "source", isLiveMode: false, location: "/sources/src_test_12345", createdDate: dateFormatter.date(from: "2019-05-23T06:00:30Z")!, currency: .thb, amount: 10_000_00, flow: .redirect, paymentInformation: .alipay)
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
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5fzbqf68stewg2nkzil") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 10_000_00)
                
                XCTAssertEqual(charge.transaction?.id, "trxn_test_5fzbqf7um91u0xrb5k7")
                
                if case .loaded(let customer)? = charge.customer {
                    XCTAssertNotNil(customer.customerDescription)
                    XCTAssertEqual(customer.id, "cust_test_5fz0olfpy32zadv96ek")
                    XCTAssertEqual(customer.email, "john.doe@example.com")
                } else {
                    XCTFail("Cannot parse transaction data")
                }
                if case .loaded(let transaction)? = charge.transaction {
                    XCTAssertEqual(transaction.amount, 960945)
                } else {
                    XCTFail("Cannot parse transaction data")
                }
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeChargeWithLoadedCustomer() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5fzbqf68stewg2nkzil")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLiveMode, decodedCharge.isLiveMode)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.id, decodedCharge.transaction?.id)
        XCTAssertEqual(defaultCharge.source?.id, decodedCharge.source?.id)
        XCTAssertEqual(defaultCharge.refundedAmount, decodedCharge.refundedAmount)
        
        XCTAssertEqual(defaultCharge.refunds.object, defaultCharge.refunds.object)
        XCTAssertEqual(defaultCharge.refunds.from, decodedCharge.refunds.from)
        XCTAssertEqual(defaultCharge.refunds.to, decodedCharge.refunds.to)
        XCTAssertEqual(defaultCharge.refunds.offset, decodedCharge.refunds.offset)
        XCTAssertEqual(defaultCharge.refunds.limit, decodedCharge.refunds.limit)
        XCTAssertEqual(defaultCharge.refunds.total, decodedCharge.refunds.total)
        
        XCTAssertEqual(defaultCharge.returnURL, decodedCharge.returnURL)
        XCTAssertEqual(defaultCharge.authorizedURL, decodedCharge.authorizedURL)
        
        XCTAssertEqual(defaultCharge.card?.object, decodedCharge.card?.object)
        XCTAssertEqual(defaultCharge.card?.id, decodedCharge.card?.id)
        XCTAssertEqual(defaultCharge.card?.isLiveMode, decodedCharge.card?.isLiveMode)
        XCTAssertEqual(defaultCharge.card?.billingAddress.countryCode, decodedCharge.card?.billingAddress.countryCode)
        XCTAssertEqual(defaultCharge.card?.billingAddress.city, decodedCharge.card?.billingAddress.city)
        XCTAssertEqual(defaultCharge.card?.billingAddress.postalCode, decodedCharge.card?.billingAddress.postalCode)
        XCTAssertEqual(defaultCharge.card?.financing, decodedCharge.card?.financing)
        XCTAssertEqual(defaultCharge.card?.bankName, decodedCharge.card?.bankName)
        XCTAssertEqual(defaultCharge.card?.lastDigits, decodedCharge.card?.lastDigits)
        XCTAssertEqual(defaultCharge.card?.brand, decodedCharge.card?.brand)
        XCTAssertEqual(defaultCharge.card?.expiration?.month, decodedCharge.card?.expiration?.month)
        XCTAssertEqual(defaultCharge.card?.expiration?.year, decodedCharge.card?.expiration?.year)
        XCTAssertEqual(defaultCharge.card?.fingerPrint, decodedCharge.card?.fingerPrint)
        XCTAssertEqual(defaultCharge.card?.name, decodedCharge.card?.name)
        XCTAssertEqual(defaultCharge.card?.createdDate, decodedCharge.card?.createdDate)
        
        XCTAssertEqual(defaultCharge.customer?.id, decodedCharge.customer?.id)
        
        XCTAssertEqual(defaultCharge.ipAddress, decodedCharge.ipAddress)
        XCTAssertEqual(defaultCharge.dispute?.amount, decodedCharge.dispute?.amount)
        XCTAssertEqual(defaultCharge.createdDate, decodedCharge.createdDate)
    }
    
    
    // MARK: - Resilient Cases
    
    func testResilientInternetBankingChargeRetrieve() {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5fzcfhae1s2u9qcoqew") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 10_000_00)
                XCTAssertEqual(charge.source?.paymentInformation.sourceType, EnrolledSource.EnrolledPaymentInformation.internetBanking(.unknown("oms")).sourceType)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeResilientInternetBankingChargeRetrieve() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5fzcfhae1s2u9qcoqew")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLiveMode, decodedCharge.isLiveMode)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.id, decodedCharge.transaction?.id)
        XCTAssertEqual(defaultCharge.refundedAmount, decodedCharge.refundedAmount)
        
        XCTAssertEqual(defaultCharge.refunds.object, defaultCharge.refunds.object)
        XCTAssertEqual(defaultCharge.refunds.from, decodedCharge.refunds.from)
        XCTAssertEqual(defaultCharge.refunds.to, decodedCharge.refunds.to)
        XCTAssertEqual(defaultCharge.refunds.offset, decodedCharge.refunds.offset)
        XCTAssertEqual(defaultCharge.refunds.limit, decodedCharge.refunds.limit)
        XCTAssertEqual(defaultCharge.refunds.total, decodedCharge.refunds.total)
        
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
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5fzbagmkeikty9pdkgh") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 10_000_00)
                
                if case let .unknown(name: name, references: references)? = charge.source?.paymentInformation {
                    XCTAssertEqual(name, "omise")
                    XCTAssertEqual((references as? [String: String]) ?? [:], [
                        "account_id": "0105556091152",
                        "expires_at": "2019-05-23T06:00:50Z",
                        "reference": "025821267592373884",
                        "key": "237000400584228075",
                        "barcode": "https://api.omise.co/charges/chrg_test_5fzbagmkeikty9pdkgh/documents/docu_test_5fzc7stfx9z2u3ohh4a/downloads/B6958F0720700012"
                        ] as [String: String])
                }
                
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeResilientSourceChargeRetrieve() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5fzbagmkeikty9pdkgh")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLiveMode, decodedCharge.isLiveMode)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.id, decodedCharge.transaction?.id)
        XCTAssertEqual(defaultCharge.refundedAmount, decodedCharge.refundedAmount)
        
        XCTAssertEqual(defaultCharge.refunds.object, defaultCharge.refunds.object)
        XCTAssertEqual(defaultCharge.refunds.from, decodedCharge.refunds.from)
        XCTAssertEqual(defaultCharge.refunds.to, decodedCharge.refunds.to)
        XCTAssertEqual(defaultCharge.refunds.offset, decodedCharge.refunds.offset)
        XCTAssertEqual(defaultCharge.refunds.limit, decodedCharge.refunds.limit)
        XCTAssertEqual(defaultCharge.refunds.total, decodedCharge.refunds.total)
        
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
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_5fzcfas8shggyzje7gw") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.value.amount, 10_000_00)
                XCTAssertEqual(charge.source?.amount, charge.amount)
                XCTAssertEqual(charge.source?.id, "src_test_5fzc7socrzb7an79lj9")
                XCTAssertEqual(charge.source?.flow, .offline)
                switch charge.source?.paymentInformation {
                case EnrolledSource.EnrolledPaymentInformation.billPayment(.unknown(name: let name, references: let references))?:
                    XCTAssertEqual(name, "papaya")
                    XCTAssertEqual((references as? [String: String]) ?? [:], [
                        "omise_tax_id": "0105556091152",
                        "expires_at": "2019-05-23T06:00:50Z",
                        "reference_1": "025821267592373884",
                        "key": "237000400584228075",
                        "barcode": "https://api.omise.co/charges/chrg_test_5fzcfas8shggyzje7gw/documents/docu_test_5fzc7stfx9z2u3ohh4a/downloads/B6958F0720700012"
                        ] as [String: String])
                default:
                    XCTFail("Wrong source information on Testco Lotus Bill Payment charge")
                }
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeResilientBillPaymentChargeRetrieve() throws {
        let defaultCharge = try fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5fzcfas8shggyzje7gw")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCharge)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCharge = try decoder.decode(Charge.self, from: encodedData)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLiveMode, decodedCharge.isLiveMode)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.transaction?.id, decodedCharge.transaction?.id)
        XCTAssertEqual(defaultCharge.refundedAmount, decodedCharge.refundedAmount)
        
        XCTAssertEqual(defaultCharge.refunds.object, defaultCharge.refunds.object)
        XCTAssertEqual(defaultCharge.refunds.from, decodedCharge.refunds.from)
        XCTAssertEqual(defaultCharge.refunds.to, decodedCharge.refunds.to)
        XCTAssertEqual(defaultCharge.refunds.offset, decodedCharge.refunds.offset)
        XCTAssertEqual(defaultCharge.refunds.limit, decodedCharge.refunds.limit)
        XCTAssertEqual(defaultCharge.refunds.total, decodedCharge.refunds.total)
        
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
        case .card(let id):
            return id.idString
        case .customer(customerID: let id, cardID: _):
            return id.idString
        case .source(let source):
            return source.id.idString
        case .sourceType(let sourceType):
            return sourceType.sourceType.value
        }
    }
}

