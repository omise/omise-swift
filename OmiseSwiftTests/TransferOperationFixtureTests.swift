import XCTest
import Omise


private let transferTestingID = "trsf_test_4yqacz8t3cbipcj766u"

class TransferOperationFixtureTests: FixtureTestCase {
    
    func testTransferRetrieve() {
        let expectation = self.expectation(description: "transfer result")
        
        let request = Transfer.retrieve(using: testClient, id: transferTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfer):
                XCTAssertEqual(transfer.value.amount, 192188)
                XCTAssertEqual(transfer.sentDate, Date(timeIntervalSinceReferenceDate: 502010909.0))
                XCTAssertEqual(transfer.paidDate, Date(timeIntervalSinceReferenceDate: 502046909.0))
                XCTAssertFalse(transfer.shouldFailFast)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeTransferRetrieve() throws {
        let defaultTransfer = try fixturesObjectFor(type: Transfer.self, dataID: transferTestingID)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultTransfer)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedTransfer = try decoder.decode(Transfer.self, from: encodedData)
        XCTAssertEqual(defaultTransfer.value.amount, decodedTransfer.value.amount)
        XCTAssertEqual(defaultTransfer.sentDate, decodedTransfer.sentDate)
        XCTAssertEqual(defaultTransfer.paidDate, decodedTransfer.paidDate)
        XCTAssertFalse(defaultTransfer.shouldFailFast)
        XCTAssertFalse(decodedTransfer.shouldFailFast)
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
        
        let createParams = TransferParams(amount: 96094, failFast: true)
        
        let request = Transfer.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfer):
                XCTAssertNotNil(transfer)
                XCTAssertTrue(transfer.shouldFailFast)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testTransferUpdate() {
        let expectation = self.expectation(description: "transfer update")
        
        let updateParams = UpdateTransferParams(amount: 1_000_00)
        
        let request = Transfer.update(using: testClient, id: transferTestingID, params: updateParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfer):
                XCTAssertEqual(transfer.value.amount, 192189)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testTransferDestroy() {
        let expectation = self.expectation(description: "transfer destroy")
        
        let request = Transfer.destroy(using: testClient, id: transferTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfer):
                XCTAssertEqual(transfer.id, transferTestingID)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    
    func testTransferOtherFailureCode() {
        let expectation = self.expectation(description: "transfer result")
        
        let request = Transfer.retrieve(using: testClient, id: "trsf_test_4yqacz8t3cbipcj272c") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfer):
                XCTAssertEqual(transfer.value.amount, 300)
                XCTAssertNotNil(transfer.sentDate)
                XCTAssertNil(transfer.paidDate)
                if case TransferStatus.failed(.other(let code)) = transfer.status {
                    XCTAssertEqual(code, "other")
                } else {
                    XCTFail()
                }
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeTransferOtherFailureCode() throws {
        let defaultTransfer = try fixturesObjectFor(type: Transfer.self, dataID: "trsf_test_4yqacz8t3cbipcj272c")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultTransfer)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedTransfer = try decoder.decode(Transfer.self, from: encodedData)
        XCTAssertEqual(defaultTransfer.value.amount, decodedTransfer.value.amount)
        XCTAssertEqual(defaultTransfer.sentDate, decodedTransfer.sentDate)
        XCTAssertEqual(defaultTransfer.paidDate, decodedTransfer.paidDate)
        if case TransferStatus.failed(.other(let transferFailedCode)) = defaultTransfer.status, case TransferStatus.failed(.other(let decodedTransferFailedCode)) = decodedTransfer.status {
            XCTAssertEqual(transferFailedCode, decodedTransferFailedCode)
        } else {
            XCTFail()
        }
    }
}

