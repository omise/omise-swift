import XCTest
import Omise


private let tranferTestingID = "trsf_test_4yqacz8t3cbipcj766u"

class TransferOperationFixtureTests: FixtureTestCase {
    
    func testTransferRetrieve() {
        let expectation = self.expectation(description: "transfer result")
        
        let request = Transfer.retrieve(using: testClient, id: tranferTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfer):
                XCTAssertEqual(transfer.value.amount, 192188)
                XCTAssertEqual(transfer.sentDate, Date(timeIntervalSinceReferenceDate: 502010909.0))
                XCTAssertEqual(transfer.paidDate, Date(timeIntervalSinceReferenceDate: 502046909.0))
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testTransferList() {
        let expectation = self.expectation(description: "transfer list")
        
        let request = Transfer.list(using: testClient, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfersList):
                XCTAssertNotNil(transfersList.data)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    
    func testTransferCreate() {
        let expectation = self.expectation(description: "transfer create")
        
        let createParams = TransferParams(amount: 96094)
        
        let request = Transfer.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfer):
                XCTAssertNotNil(transfer)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testTransferUpdate() {
        let expectation = self.expectation(description: "transfer update")
        
        let updateParams = UpdateTransferParams(amount: 1_000_00)
        
        let request = Transfer.update(using: testClient, id: tranferTestingID, params: updateParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfer):
                XCTAssertEqual(transfer.value.amount, 192189)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testTransferDestroy() {
        let expectation = self.expectation(description: "transfer destroy")
        
        let request = Transfer.destroy(using: testClient, id: tranferTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfer):
                XCTAssertEqual(transfer.isDeleted, true)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}

