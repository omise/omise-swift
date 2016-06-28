import Foundation
import XCTest
import Omise

class TransferOperationsTest: OmiseTestCase {
    var testClient: Client {
        let config = Config(
            publicKey: "pkey_test_54flsro0dmplsfg80vm",
            secretKey: "skey_test_54flpy4dc5jpkrmlpp6",
            apiVersion: nil,
            queue: (NSOperationQueue.currentQueue() ?? NSOperationQueue.mainQueue())
        )
        
        return Client(config: config)
    }
    
    func testTransferRetrieve() {
        let expectation = expectationWithDescription("transfer result")
        
        let request = Transfer.retrieve(using: testClient, id: "trsf_test_54h7uzmwu5v79mgri6d") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .Success(transfer):
                XCTAssertEqual(transfer.amount, 96094)
            case let .Fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectationsWithTimeout(15.0, handler: nil)
    }
    
    func testTransferList() {
        let expectation = expectationWithDescription("transfer list")
        
        let request = Transfer.list(using: testClient, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .Success(transfersList):
                XCTAssertNotNil(transfersList.data)
            case let .Fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectationsWithTimeout(15.0, handler: nil)
    }
    
    func testTransferCreate() {
        let expectation = expectationWithDescription("transfer create")
        
        let createParams = TransferParams()
        createParams.amount = 96094
        
        let request = Transfer.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .Success(transfer):
                XCTAssertNotNil(transfer)
            case let .Fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectationsWithTimeout(15.0, handler: nil)
    }
    
    func testTransferUpdate() {
        let expectation = expectationWithDescription("transfer update")
        
        let updateParams = TransferParams()
        updateParams.amount = 100000
        
        let request = Transfer.update(using: testClient, id: "trsf_test_54h7uzmwu5v79mgri6d", params: updateParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .Success(transfer):
                XCTAssertEqual(transfer.amount, 96094)
            case let .Fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectationsWithTimeout(15.0, handler: nil)
    }
    
    func testTransferDestroy() {
        let expectation = expectationWithDescription("transfer destroy")
        
        let request = Transfer.destroy(using: testClient, id: "trsf_test_54hktxphv9p7wv1tsed") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .Success(transfer):
                XCTAssertEqual(transfer.deleted, true)
            case let .Fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectationsWithTimeout(15.0, handler: nil)
    }
}