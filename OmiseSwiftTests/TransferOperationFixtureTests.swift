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
                XCTAssertEqual(transfer.amount, 192188)
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
        
        let createParams = TransferParams()
        createParams.amount = 96094
        
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
        
        let updateParams = TransferParams()
        updateParams.amount = 100000
        
        let request = Transfer.update(using: testClient, id: tranferTestingID, params: updateParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfer):
                XCTAssertEqual(transfer.amount, 192189)
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
                XCTAssertEqual(transfer.deleted, true)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}

