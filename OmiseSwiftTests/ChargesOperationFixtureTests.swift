import XCTest
import Omise


private let chargeTestingID = "chrg_test_4yq7duw15p9hdrjp8oq"

class ChargesOperationFixtureTests: FixtureTestCase {
    func testChargeRetrieve() {
        let expectation = self.expectation(description: "Charge result")
        
        let request = Charge.retrieve(using: testClient, id: chargeTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.amount, 100000)
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
                XCTAssertEqual(chargeSampleData?.amount, 100000)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testChargeCreate() {
        let expectation = self.expectation(description: "Charge create")
        
        let createParams = ChargeParams()
        createParams.amount = 100000
        
        let request = Charge.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertNotNil(charge)
                XCTAssertEqual(charge.amount, 100000)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testChargeUpdate() {
        let expectation = self.expectation(description: "Charge update")
        
        let updateParams = ChargeParams()
        updateParams.amount = 100000
        
        let request = Charge.update(using: testClient, id: chargeTestingID, params: updateParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.amount, 100000)
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
                XCTAssertEqual(charge.amount, 2025)
                XCTAssertEqual(charge.payment, Payment.offsite(.internetBanking(.scb)))
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)

    }
}
