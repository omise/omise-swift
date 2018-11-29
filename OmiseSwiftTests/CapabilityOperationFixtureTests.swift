import XCTest
@testable import Omise


class CapabilityOperationFixtureTests: FixtureTestCase {
    func testCapabilityRetrieve() {
        let expectation = self.expectation(description: "Capability result")

        let request = Capability.retrieve(using: testClient) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(capability):
                XCTAssertEqual(capability.chargeLimit, Capability.Limit(max: 100000000, min: 2000))
                XCTAssertEqual(capability.supportedBackends.count, 6)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}

