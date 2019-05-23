import XCTest
import Omise


private let disputeTestingID = "dspt_test_58utmxp85fm4x9mwde6"

class DisputeOperationFixtureTests: FixtureTestCase {
    func testDisputeRetrieve() {
        let expectation = self.expectation(description: "Dispute result")
        
        let request = Dispute.retrieve(using: testClient, id: disputeTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(dispute):
                XCTAssertEqual(dispute.value.amount, 3190000)
                XCTAssertEqual(dispute.responseMessage, "A dispute for testing purpose")
            case let .failure(error):
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
        XCTAssertEqual(defaultDispute.isLiveMode, decodedDispute.isLiveMode)
        XCTAssertEqual(defaultDispute.location, decodedDispute.location)
        XCTAssertEqual(defaultDispute.value.amount, decodedDispute.value.amount)
        XCTAssertEqual(defaultDispute.value.amountInUnit, decodedDispute.value.amountInUnit)
        XCTAssertEqual(defaultDispute.value.currency, decodedDispute.value.currency)
        XCTAssertEqual(defaultDispute.status, decodedDispute.status)
        XCTAssertEqual(defaultDispute.transactions.first?.id, decodedDispute.transactions.first?.id)
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
        XCTAssertEqual(defaultDocument.isLiveMode, decodedDocument.isLiveMode)
        XCTAssertEqual(defaultDocument.location, decodedDocument.location)
        XCTAssertEqual(defaultDocument.filename, decodedDocument.filename)
        XCTAssertEqual(defaultDocument.createdDate, decodedDocument.createdDate)
    }
    
    func testDisputeWithDocumentsRetrieve() {
        let expectation = self.expectation(description: "Dispute result")
        
        let request = Dispute.retrieve(using: testClient, id: "dspt_test_5dzhbyswtur9eu7cgzz") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(dispute):
                XCTAssertEqual(dispute.value.amount, 2000)
                XCTAssertNotNil(dispute.responseMessage)
                XCTAssertEqual(dispute.reasonCode, Dispute.Reason.goodsOrServicesNotProvided)
                XCTAssertEqual(dispute.reasonMessage, "Services not provided or Merchandise not received")
                XCTAssertEqual(dispute.documents.total, 2)
                guard let recentDocument = dispute.documents.first else {
                    XCTFail("Cannot get the recent document")
                    return
                }
                
                XCTAssertEqual(recentDocument.filename, "Screen Shot.png")
                XCTAssertEqual(recentDocument.id, "docu_test_5dzhc60jm40sg1umiyg")
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeDisputeWithDocumentsRetrieve() throws {
        let defaultDispute = try fixturesObjectFor(type: Dispute.self, dataID: "dspt_test_5dzhbyswtur9eu7cgzz")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultDispute)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedDispute = try decoder.decode(Dispute.self, from: encodedData)
        XCTAssertEqual(defaultDispute.object, decodedDispute.object)
        XCTAssertEqual(defaultDispute.id, decodedDispute.id)
        XCTAssertEqual(defaultDispute.isLiveMode, decodedDispute.isLiveMode)
        XCTAssertEqual(defaultDispute.location, decodedDispute.location)
        XCTAssertEqual(defaultDispute.value.amount, decodedDispute.value.amount)
        XCTAssertEqual(defaultDispute.value.amountInUnit, decodedDispute.value.amountInUnit)
        XCTAssertEqual(defaultDispute.value.currency, decodedDispute.value.currency)
        XCTAssertEqual(defaultDispute.status, decodedDispute.status)
        XCTAssertEqual(defaultDispute.transactions.first?.id, decodedDispute.transactions.first?.id)
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
        XCTAssertEqual(defaultDocument.isLiveMode, decodedDocument.isLiveMode)
        XCTAssertEqual(defaultDocument.location, decodedDocument.location)
        XCTAssertEqual(defaultDocument.filename, decodedDocument.filename)
        XCTAssertEqual(defaultDocument.createdDate, decodedDocument.createdDate)
    }
    
    func testWonDisputeRetrieve() {
        let expectation = self.expectation(description: "Dispute result")
        
        let request = Dispute.retrieve(using: testClient, id: "dspt_test_5dzhbclwha52lkgt6p4") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(dispute):
                XCTAssertEqual(dispute.value.amount, 2000)
                XCTAssertEqual(dispute.responseMessage, "Here's an evidence")
                XCTAssertEqual(dispute.reasonCode, Dispute.Reason.goodsOrServicesNotProvided)
                XCTAssertEqual(dispute.reasonMessage, "Services not provided or Merchandise not received")
                XCTAssertEqual(dispute.documents.total, 1)
                XCTAssertEqual(dispute.status, .won)
                XCTAssertEqual(dispute.transactions.first?.id, "trxn_test_5dzhbcm7gkyg3hnexee")
                XCTAssertEqual(dispute.closedDate, dateFormatter.date(from: "2018-11-19T12:45:57Z"))
                guard let recentDocument = dispute.documents.first else {
                    XCTFail("Cannot get the recent document")
                    return
                }
                
                XCTAssertEqual(recentDocument.filename, "Screenshot.png")
                XCTAssertEqual(recentDocument.id, "docu_test_5dzhbe7mf4sg0eq1bzk")
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeWonDisputeRetrieve() throws {
        let defaultDispute = try fixturesObjectFor(type: Dispute.self, dataID: "dspt_test_5dzhbclwha52lkgt6p4")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultDispute)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedDispute = try decoder.decode(Dispute.self, from: encodedData)
        XCTAssertEqual(defaultDispute.object, decodedDispute.object)
        XCTAssertEqual(defaultDispute.id, decodedDispute.id)
        XCTAssertEqual(defaultDispute.isLiveMode, decodedDispute.isLiveMode)
        XCTAssertEqual(defaultDispute.location, decodedDispute.location)
        XCTAssertEqual(defaultDispute.value.amount, decodedDispute.value.amount)
        XCTAssertEqual(defaultDispute.value.amountInUnit, decodedDispute.value.amountInUnit)
        XCTAssertEqual(defaultDispute.value.currency, decodedDispute.value.currency)
        XCTAssertEqual(defaultDispute.status, decodedDispute.status)
        XCTAssertEqual(defaultDispute.transactions.first?.id, decodedDispute.transactions.first?.id)
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
        XCTAssertEqual(defaultDocument.isLiveMode, decodedDocument.isLiveMode)
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
            case let .failure(error):
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
            case let .failure(error):
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
            case let .failure(error):
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
            case let .failure(error):
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
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
}
