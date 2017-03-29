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
                XCTAssertEqual(charge.createdDate, DateConverter.convert(fromAttribute: "2015-01-15T05:00:29Z"))
                XCTAssertEqual(charge.card?.id, "card_test_4yq6tuucl9h4erukfl0")
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
                let chargeSampleData = chargesList.data.first
                XCTAssertNotNil(chargeSampleData)
                XCTAssertEqual(chargeSampleData?.value.amount, 100000)
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
        
        let updateParams = UpdateChargeParams(chargeDescription: "Hello")
        
        let request = Charge.update(using: testClient, id: chargeTestingID, params: updateParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.chargeDescription, "Hello")
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
}
