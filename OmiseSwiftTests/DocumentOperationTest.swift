import XCTest
import Omise


class DocumentOperationTest: LiveTest {
    
    func testDocumentCreate() {
        let expectation = self.expectation(description: "link result")
        
        let request = Dispute.retrieve(using: testClient, id: "dspt_test_58h9i2cdaswlyvv28m3") { (result) in
            
            switch result {
            case let .success(dispute):
                
                let fileURL = Bundle(for: DocumentOperationTest.self)
                    .url(forResource: "ScreenShot", withExtension: "png")!
                
                guard let params = try? DocumentParams(url: fileURL) else {
                    return XCTFail("Failed to create document params from url: \(fileURL.absoluteString)")
                }
                
                let documentRequest = Document.create(
                    using: self.testClient, parent: dispute, params: params,
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
