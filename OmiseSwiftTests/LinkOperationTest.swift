import XCTest
import Omise


class LinkOperationTest: OmiseTestCase {
    var testClient: Client {
        let config = Config(
            publicKey: "pkey_test_5570z4yt4wybjb03ag8",
            secretKey: "skey_test_5570z4yvwcr22l3rjnm",
            apiVersion: nil,
            queue: (OperationQueue.current ?? OperationQueue.main)
        )
        
        return Client(config: config)
    }
    
    func testLinkRetrieve() {
        let expectation = self.expectation(description: "link result")
        
        let request = Link.retrieve(using: testClient, id: "link_test_565dgexs3bvcsjyvmpm") { (result) in
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
        let expectation = self.expectation(description: "link list")
        
        let request = Link.list(using: testClient, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(linkList):
                XCTAssertNotNil(linkList.data)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testCreateLink() {
        let expectation = self.expectation(description: "link update")
        
        let createParams = LinkParams()
        createParams.amount = 100000
        createParams.currency = .thb
        createParams.title = "Link for testing"
        createParams.linkDescription = "Testing create link from Omise Swift SDK"
        
        let request = Link.create(using: testClient, params: createParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(link):
                XCTAssertNotNil(link)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)

    }
}
