import Foundation
import XCTest
import Omise

class TransferOperationsTest: LiveTest {
    func testTransferRetrieve() {
        let expectation = self.expectation(description: "transfer result")
        
        let request = Transfer.retrieve(using: testClient, id: "trsf_test_565dzj6wol8aqzw8aya") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfer):
                XCTAssertEqual(transfer.value.amount, 100_000)
                XCTAssertEqual(transfer.sentDate, Date(timeIntervalSinceReferenceDate: 502_010_909.0))
            case let .failure(error):
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
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testTransferCreate() {
        let expectation = self.expectation(description: "transfer create")
        
        let createParams = TransferParams(amount: 96_094)
        
        let request = Transfer.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfer):
                XCTAssertNotNil(transfer)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testTransferUpdate() {
        let expectation = self.expectation(description: "transfer update")
        
        let updateParams = UpdateTransferParams(amount: 96_094)
        
        let request = Transfer
            .update(using: testClient, id: "trsf_test_54h7uzmwu5v79mgri6d", params: updateParams) { (result) in
                defer { expectation.fulfill() }
                
                switch result {
                case let .success(transfer):
                    XCTAssertEqual(transfer.value.amount, 96_094)
                case let .failure(error):
                    XCTFail("\(error)")
                }
            }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testTransferDestroy() {
        let expectation = self.expectation(description: "transfer destroy")
        
        let request = Transfer.destroy(using: testClient, id: "trsf_test_54hktxphv9p7wv1tsed") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfer):
                XCTAssertEqual(transfer.id.idString, "trsf_test_54hktxphv9p7wv1tsed")
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testCreateAndDestroy() {
        let expectation = self.expectation(description: "transfer create")
        
        let createParams = TransferParams(amount: 96_094)
        let deleteExpectaion = self.expectation(description: "transfer delete")
        
        let request = Transfer.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfer):
                let destroyRequest = Transfer.destroy(using: self.testClient, id: transfer.id) { (result) in
                    defer { deleteExpectaion.fulfill() }
                    
                    switch result {
                    case let .success(deletedTransfer):
                        XCTAssertEqual(transfer.id, deletedTransfer.id)
                    case let .failure(error):
                        XCTFail("\(error)")
                    }
                }
            case let .failure(error):
                XCTFail("\(error)")
                deleteExpectaion.fulfill()
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
