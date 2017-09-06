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
                XCTAssertEqual(chargesList.data.count, 40)
                let chargeSampleData = chargesList.data.first
                XCTAssertNotNil(chargeSampleData)
                XCTAssertEqual(chargeSampleData?.value.amount, 8990000)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testChargeCreate() {
        let expectation = self.expectation(description: "Charge create")
        
        let createParams = ChargeParams(value: Value(amount: 1_000_00, currency: .thb))
        
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
                XCTAssertEqual(charge.value.amount, 2025)
                XCTAssertEqual(charge.payment, Payment.offsite(.internetBanking(.scb)))
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
                XCTAssertEqual(charge.payment, Payment.offsite(.alipay))
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodingCreateChargeParams() throws {
        let params = ChargeParams(value: Value(amount: 10_000_00, currency: .thb), chargeDescription: "Hello", customerID: nil, cardID: nil, isAutoCapture: nil, returnURL: nil, metadata: ["customer id": "1"])
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(params)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decodedParams = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        
        XCTAssertEqual(params.chargeDescription, decodedParams["description"] as? String)
        XCTAssertEqual(params.value.amount, decodedParams["amount"] as? Int64)
        XCTAssertEqual(params.value.currency.code, decodedParams["currency"] as? String)
        XCTAssertEqual(
            params.metadata?["customer id"] as? String,
            (decodedParams["metadata"] as? [String: Any])?["customer id"] as? String
        )
    }
}


