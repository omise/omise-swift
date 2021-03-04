import XCTest
import Omise


class DocumentOperationTest: LiveTest {
    
    func testDocumentCreate() throws {
        let expectation = self.expectation(description: "link result")
        
        let bundle = Bundle(for: DocumentOperationTest.self)
        let fileURL = try XCTUnwrap(bundle.url(forResource: "ScreenShot", withExtension: "png"))
        let documentParams = try DocumentParams(url: fileURL)
        
        let request = Dispute.retrieve(using: testClient, id: "dspt_test_58h9i2cdaswlyvv28m3") { (result) in
            
            switch result {
            case let .success(dispute):
                
                let documentRequest = Document.create(
                    using: self.testClient, parent: dispute, params: documentParams,
                    callback: { (documentResult) in
                        defer { expectation.fulfill() }
                        
                        switch documentResult {
                        case .success(let document):
                            print(document.filename)
                        case let .failure(error):
                            XCTFail("\(error)")
                        }
                    })
                
                XCTAssertNotNil(documentRequest)
            case let .failure(error):
                XCTFail("\(error)")
                expectation.fulfill()
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 30.0, handler: nil)
    }
    
}
