import XCTest
import Omise


private let disputeTestingID = "dspt_test_5089off452g5m5te7xs"

class DisputeOperationFixtureTests: FixtureTestCase {
    func testDisputeRetrieve() {
        let expectation = self.expectation(description: "Dispute result")
        
        let request = Dispute.retrieve(using: testClient, id: disputeTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(dispute):
                XCTAssertEqual(dispute.value.amount, 100000)
                XCTAssertEqual(dispute.responseMessage, "A dispute for testing purpose")
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeDisputeRetrieve() throws {
        let defaultDispute = try fixturesObjectFor(type: Dispute.self, dataID: disputeTestingID)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultDispute)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedDispute = try decoder.decode(Dispute.self, from: encodedData)
        XCTAssertEqual(defaultDispute.object, decodedDispute.object)
        XCTAssertEqual(defaultDispute.id, decodedDispute.id)
        XCTAssertEqual(defaultDispute.isLive, decodedDispute.isLive)
        XCTAssertEqual(defaultDispute.location, decodedDispute.location)
        XCTAssertEqual(defaultDispute.value.amount, decodedDispute.value.amount)
        XCTAssertEqual(defaultDispute.value.amountInUnit, decodedDispute.value.amountInUnit)
        XCTAssertEqual(defaultDispute.value.currency, decodedDispute.value.currency)
        XCTAssertEqual(defaultDispute.status, decodedDispute.status)
        XCTAssertEqual(defaultDispute.transaction.dataID, decodedDispute.transaction.dataID)
        XCTAssertEqual(defaultDispute.reasonCode, decodedDispute.reasonCode)
        XCTAssertEqual(defaultDispute.reasonMessage, decodedDispute.reasonMessage)
        XCTAssertEqual(defaultDispute.responseMessage, decodedDispute.responseMessage)
        XCTAssertEqual(defaultDispute.createdDate, decodedDispute.createdDate)
        XCTAssertEqual(defaultDispute.closedDate, decodedDispute.closedDate)
        
        guard let defaultDocument = defaultDispute.documents.first, let decodedDocument = decodedDispute.documents.first else {
            XCTFail("Cannot get the recent document")
            return
        }
        
        XCTAssertEqual(defaultDocument.object, decodedDocument.object)
        XCTAssertEqual(defaultDocument.id, decodedDocument.id)
        XCTAssertEqual(defaultDocument.isLive, decodedDocument.isLive)
        XCTAssertEqual(defaultDocument.location, decodedDocument.location)
        XCTAssertEqual(defaultDocument.filename, decodedDocument.filename)
        XCTAssertEqual(defaultDocument.createdDate, decodedDocument.createdDate)
    }
    
    func testDisputeWithDocumentsRetrieve() {
        let expectation = self.expectation(description: "Dispute result")
        
        let request = Dispute.retrieve(using: testClient, id: "dspt_test_58h9i2cdaswlyvv28m3") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(dispute):
                XCTAssertEqual(dispute.value.amount, 1200000)
                XCTAssertNil(dispute.responseMessage)
                XCTAssertEqual(dispute.reasonCode, Dispute.Reason.goodsOrServicesNotProvided)
                XCTAssertEqual(dispute.reasonMessage, "Services not provided or Merchandise not received")
                XCTAssertEqual(dispute.documents.total, 4)
                guard let recentDocument = dispute.documents.first else {
                    XCTFail("Cannot get the recent document")
                    return
                }
                
                XCTAssertEqual(recentDocument.filename, "ScreenShot.png")
                XCTAssertEqual(recentDocument.id, "docu_test_58m980pyztc5desmum8")
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeDisputeWithDocumentsRetrieve() throws {
        let defaultDispute = try fixturesObjectFor(type: Dispute.self, dataID: "dspt_test_58h9i2cdaswlyvv28m3")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultDispute)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedDispute = try decoder.decode(Dispute.self, from: encodedData)
        XCTAssertEqual(defaultDispute.object, decodedDispute.object)
        XCTAssertEqual(defaultDispute.id, decodedDispute.id)
        XCTAssertEqual(defaultDispute.isLive, decodedDispute.isLive)
        XCTAssertEqual(defaultDispute.location, decodedDispute.location)
        XCTAssertEqual(defaultDispute.value.amount, decodedDispute.value.amount)
        XCTAssertEqual(defaultDispute.value.amountInUnit, decodedDispute.value.amountInUnit)
        XCTAssertEqual(defaultDispute.value.currency, decodedDispute.value.currency)
        XCTAssertEqual(defaultDispute.status, decodedDispute.status)
        XCTAssertEqual(defaultDispute.transaction.dataID, decodedDispute.transaction.dataID)
        XCTAssertEqual(defaultDispute.reasonCode, decodedDispute.reasonCode)
        XCTAssertEqual(defaultDispute.reasonMessage, decodedDispute.reasonMessage)
        XCTAssertEqual(defaultDispute.responseMessage, decodedDispute.responseMessage)
        XCTAssertEqual(defaultDispute.createdDate, decodedDispute.createdDate)
        XCTAssertEqual(defaultDispute.closedDate, decodedDispute.closedDate)
        
        guard let defaultDocument = defaultDispute.documents.first, let decodedDocument = decodedDispute.documents.first else {
            XCTFail("Cannot get the recent document")
            return
        }
        
        XCTAssertEqual(defaultDocument.object, decodedDocument.object)
        XCTAssertEqual(defaultDocument.id, decodedDocument.id)
        XCTAssertEqual(defaultDocument.isLive, decodedDocument.isLive)
        XCTAssertEqual(defaultDocument.location, decodedDocument.location)
        XCTAssertEqual(defaultDocument.filename, decodedDocument.filename)
        XCTAssertEqual(defaultDocument.createdDate, decodedDocument.createdDate)
    }
    
    func testWonDisputeRetrieve() {
        let expectation = self.expectation(description: "Dispute result")
        
        let request = Dispute.retrieve(using: testClient, id: "dspt_test_58h9gj7ygndg2t5xs1n") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(dispute):
                XCTAssertEqual(dispute.value.amount, 3190000)
                XCTAssertEqual(dispute.responseMessage, "Test the document")
                XCTAssertEqual(dispute.reasonCode, Dispute.Reason.goodsOrServicesNotProvided)
                XCTAssertEqual(dispute.reasonMessage, "Services not provided or Merchandise not received")
                XCTAssertEqual(dispute.documents.total, 1)
                XCTAssertEqual(dispute.status, .won)
                XCTAssertEqual(dispute.transaction.dataID, "trxn_test_58h9gj859q3dpqdx94r")
                XCTAssertEqual(dispute.closedDate, dateFormatter.date(from: "2017-07-18T10:56:28Z"))
                guard let recentDocument = dispute.documents.first else {
                    XCTFail("Cannot get the recent document")
                    return
                }
                
                XCTAssertEqual(recentDocument.filename, "Screen Shot.png")
                XCTAssertEqual(recentDocument.id, "docu_test_58h9gloyz5iiug4k3xj")
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeWonDisputeRetrieve() throws {
        let defaultDispute = try fixturesObjectFor(type: Dispute.self, dataID: "dspt_test_58h9gj7ygndg2t5xs1n")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultDispute)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedDispute = try decoder.decode(Dispute.self, from: encodedData)
        XCTAssertEqual(defaultDispute.object, decodedDispute.object)
        XCTAssertEqual(defaultDispute.id, decodedDispute.id)
        XCTAssertEqual(defaultDispute.isLive, decodedDispute.isLive)
        XCTAssertEqual(defaultDispute.location, decodedDispute.location)
        XCTAssertEqual(defaultDispute.value.amount, decodedDispute.value.amount)
        XCTAssertEqual(defaultDispute.value.amountInUnit, decodedDispute.value.amountInUnit)
        XCTAssertEqual(defaultDispute.value.currency, decodedDispute.value.currency)
        XCTAssertEqual(defaultDispute.status, decodedDispute.status)
        XCTAssertEqual(defaultDispute.transaction.dataID, decodedDispute.transaction.dataID)
        XCTAssertEqual(defaultDispute.reasonCode, decodedDispute.reasonCode)
        XCTAssertEqual(defaultDispute.reasonMessage, decodedDispute.reasonMessage)
        XCTAssertEqual(defaultDispute.responseMessage, decodedDispute.responseMessage)
        XCTAssertEqual(defaultDispute.createdDate, decodedDispute.createdDate)
        XCTAssertEqual(defaultDispute.closedDate, decodedDispute.closedDate)
        
        guard let defaultDocument = defaultDispute.documents.first, let decodedDocument = decodedDispute.documents.first else {
            XCTFail("Cannot get the recent document")
            return
        }
        
        XCTAssertEqual(defaultDocument.object, decodedDocument.object)
        XCTAssertEqual(defaultDocument.id, decodedDocument.id)
        XCTAssertEqual(defaultDocument.isLive, decodedDocument.isLive)
        XCTAssertEqual(defaultDocument.location, decodedDocument.location)
        XCTAssertEqual(defaultDocument.filename, decodedDocument.filename)
        XCTAssertEqual(defaultDocument.createdDate, decodedDocument.createdDate)
    }
    
    func testDisputeList() {
        let expectation = self.expectation(description: "Dispute list")
        
        let request = Dispute.list(using: testClient, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(DisputesList):
                XCTAssertNotNil(DisputesList.data)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testDisputeUpdate() {
        let expectation = self.expectation(description: "Dispute update")
        
        let expectedMessage = "Your dispute message"
        let updateParams = DisputeParams(message: expectedMessage)
        
        let request = Dispute.update(using: testClient, id: disputeTestingID, params: updateParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(dispute):
                XCTAssertEqual(dispute.responseMessage, expectedMessage)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testDisputeListClosed() {
        let expectation = self.expectation(description: "Dispute list closed")
        
        let request = Dispute.list(using: testClient, state: .closed, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(disputesList):
                XCTAssertNotNil(disputesList.data)
                let disputeSampleData = disputesList.data.first
                XCTAssertNotNil(disputeSampleData)
                XCTAssertEqual(disputeSampleData?.status, .won)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testDisputeListOpen() {
        let expectation = self.expectation(description: "Dispute list open")
        
        let request = Dispute.list(using: testClient, state: .open, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(disputesList):
                XCTAssertNotNil(disputesList.data)
                let disputeSampleData = disputesList.data.first
                XCTAssertNotNil(disputeSampleData)
                XCTAssertEqual(disputeSampleData?.status, .open)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testDisputeListPending() {
        let expectation = self.expectation(description: "Dispute list pending")
        
        let request = Dispute.list(using: testClient, state: .pending, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(disputesList):
                XCTAssertNotNil(disputesList.data)
                let disputeSampleData = disputesList.data.first
                XCTAssertNotNil(disputeSampleData)
                XCTAssertEqual(disputeSampleData?.status, .pending)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
}
