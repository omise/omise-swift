import XCTest
import Omise


private let disputeTestingID = "dspt_test_5089off452g5m5te7xs"

class DisputeOperationFixtureTests: FixtureTestCase {
    func testDisputeRetrieve() {
        let expectation = self.expectation(description: "Dispute result")
        
        let request = Dispute.retrieve(using: testClient, id: disputeTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(Dispute):
                XCTAssertEqual(Dispute.amount, 100000)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
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
        let updateParams = DisputeParams()
        updateParams.message = expectedMessage
        
        let request = Dispute.update(using: testClient, id: disputeTestingID, params: updateParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(dispute):
                XCTAssertEqual(dispute.message, expectedMessage)
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
