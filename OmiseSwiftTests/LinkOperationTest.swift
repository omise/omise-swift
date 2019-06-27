import XCTest
import Omise


class LinkOperationTest: LiveTest {
    
    func testLinkRetrieve() {
        let expectation = self.expectation(description: "link result")
        
        let request = Link.retrieve(using: testClient, id: "link_test_565dgexs3bvcsjyvmpm") { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(link):
                XCTAssertEqual(link.value.amount, 1490000)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testLinkList() {
        let expectation = self.expectation(description: "link list")
        
        let request = Link.list(using: testClient, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(linkList):
                XCTAssertNotNil(linkList.data)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testCreateLink() {
        let expectation = self.expectation(description: "link update")
        
        let createParams = LinkParams(
            value: Value(amount: 1_000_00, currency: .thb),
            title: "Link for testing",
            linkDescription: "Testing create link from Omise Swift SDK")
        
        let request = Link.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(link):
                XCTAssertNotNil(link)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)

    }
}
