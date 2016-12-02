import XCTest
import Omise

private let linkTestingID = "link_test_565dgexs3bvcsjyvmpm"

class LinkOperationFixtureTest: FixtureTestCase {
    func testLinkeRetrieve() {
        let expectation = self.expectation(description: "Link result")
        
        let request = Link.retrieve(using: testClient, id: linkTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(link):
                XCTAssertEqual(link.amount, 1490000)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testLinkList() {
        let expectation = self.expectation(description: "Link list")
        
        let request = Link.list(using: testClient, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(linksList):
                XCTAssertNotNil(linksList.data)
                XCTAssertEqual(linksList.data.count, 2)
                let linkSampleData = linksList.data.first
                XCTAssertNotNil(linkSampleData)
                XCTAssertEqual(linkSampleData?.amount, 1490000)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
