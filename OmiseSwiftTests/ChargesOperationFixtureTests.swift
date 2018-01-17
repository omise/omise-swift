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
    
    func testInternetBankingChargetRetrieve() {
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
        XCTAssertEqual(defaultCharge.value.amount, decodedCharge.value.amount)
        XCTAssertEqual(defaultCharge.value.currency, decodedCharge.value.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.isLive, decodedCharge.isLive)
        XCTAssertEqual(defaultCharge.transaction?.dataID, decodedCharge.transaction?.dataID)
        XCTAssertEqual(defaultCharge.createdDate, decodedCharge.createdDate)
        XCTAssertEqual(defaultCharge.source?.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.source?.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.source?.id, decodedCharge.source?.id)
        XCTAssertEqual(defaultCharge.source?.flow, decodedCharge.source?.flow)
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
        let source = PaymentSource(id: "src_test_12345", object: "source", currency: .thb, amount: 10_000_00, flow: .redirect, paymentInformation: .alipay)
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
        XCTAssertEqual(defaultCharge.value.amount, decodedCharge.value.amount)
        XCTAssertEqual(defaultCharge.value.currency, decodedCharge.value.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.isLive, decodedCharge.isLive)
        XCTAssertEqual(defaultCharge.transaction?.dataID, decodedCharge.transaction?.dataID)
        XCTAssertEqual(defaultCharge.createdDate, decodedCharge.createdDate)
        XCTAssertEqual(defaultCharge.dispute?.id, decodedCharge.dispute?.id)
    }
}


