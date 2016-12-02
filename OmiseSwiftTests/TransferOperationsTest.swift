import Foundation
import XCTest
import Omise

class TransferOperationsTest: OmiseTestCase {
    var testClient: Client {
        let config = Config(
            publicKey: "pkey_test_54flsro0dmplsfg80vm",
            secretKey: "skey_test_54flpy4dc5jpkrmlpp6",
            apiVersion: nil,
            queue: (OperationQueue.current ?? OperationQueue.main)
        )
        
        return Client(config: config)
    }
    
    func testTransferRetrieve() {
        let expectation = self.expectation(description: "transfer result")
        
        let request = Transfer.retrieve(using: testClient, id: "trsf_test_565dzj6wol8aqzw8aya") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfer):
                XCTAssertEqual(transfer.amount, 1_000_00)
                XCTAssertEqual(transfer.sentDate, Date(timeIntervalSinceReferenceDate: 502010909.0))
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
        
        let request = Transfer.update(using: testClient, id: "trsf_test_54h7uzmwu5v79mgri6d", params: updateParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfer):
                XCTAssertEqual(transfer.amount, 96094)
            case let .fail(error):
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
                XCTAssertEqual(transfer.deleted, true)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
