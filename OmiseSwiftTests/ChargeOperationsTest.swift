import Foundation
import XCTest
@testable import Omise

class ChargeOperationsTest: OmiseTestCase {
    var testClient: Client {
        let config = Config(
            publicKey: "pkey_test_54oojsyhv5uq1kzf4g4",
            secretKey: "skey_test_54oojsyhuzzr51wa5hc",
            apiVersion: nil,
            queue: (OperationQueue.current ?? OperationQueue.main)
        )
        
        return Client(config: config)
    }
    
    func testChargeList() {
        let expectation = self.expectation(description: "transfer list")
        
        let request = Charge.list(using: testClient, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfersList):
                XCTAssertNotNil(transfersList.data)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testChargeInfiniteListWithAfter() {
        let firstExpectation = self.expectation(description: "transfer list")
        let secondExpectation = self.expectation(description: "Load more of transfer list")
        
        Charge.list(using: testClient) { (result) in
            defer { firstExpectation.fulfill() }
            switch result {
            case let .success(transfersList):
                XCTAssertNotNil(transfersList.data)
                XCTAssertEqual(transfersList.loadedIndices, 0..<20)
                
                Charge.loadNextPage(list: transfersList, using: self.testClient, callback: { (afterResult) in
                    defer { secondExpectation.fulfill() }
                    
                    switch afterResult {
                    case let .success(loadedMoreList):
                        XCTAssertGreaterThan(loadedMoreList.count, 0)
                        XCTAssertEqual(transfersList.data.count, 25)
                        XCTAssertEqual(transfersList.data.count, Set(transfersList.data.flatMap({ $0.id })).count)
                        XCTAssertEqual(transfersList.loadedIndices, 0..<25)
                    case .fail(let error):
                        XCTFail("\(error)")
                    }
                })
            case let .fail(error):
                XCTFail("\(error)")
                secondExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testChargeInfiniteListWithBefore() -> Void {
        let expectation = self.expectation(description: "transfer list")
        let firstExpectation = self.expectation(description: "transfer list")
        let secondExpectation = self.expectation(description: "Load more of transfer list")
        
        let listParams = ListParams()
        
        listParams.limit = 20
        listParams.offset = 30
        
        let request = Charge.list(using: testClient, params: listParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfersList):
                XCTAssertNotNil(transfersList.data)
                let list = List<Charge>(endpoint: Endpoint.api, paths: [Charge.info.path], order: .chronological, list: transfersList)
                XCTAssertEqual(list.loadedIndices, 30..<30)

                list.loadPreviousPage(using: self.testClient, callback: { (firstLoadResult) in
                    defer { firstExpectation.fulfill() }
                    
                    switch firstLoadResult {
                    case let .success(loadedMoreList):
                        XCTAssertGreaterThan(loadedMoreList.count, 0)
                        XCTAssertEqual(list.data.count, 15)
                        XCTAssertEqual(list.loadedIndices, 10..<25)
                        
                        list.loadPreviousPage(using: self.testClient, callback: { (secondLoadResult) in
                            defer { secondExpectation.fulfill() }
                            
                            switch secondLoadResult {
                            case let .success(loadedMoreList):
                                XCTAssertGreaterThan(loadedMoreList.count, 0)
                                XCTAssertEqual(list.data.count, 25)
                                XCTAssertEqual(transfersList.data.count, Set(transfersList.data.flatMap({ $0.id })).count)
                                XCTAssertEqual(list.loadedIndices, 0..<25)
                            case .fail(let error):
                                XCTFail("\(error)")
                            }
                        })
                    case .fail(let error):
                        XCTFail("\(error)")
                        secondExpectation.fulfill()
                    }
                })
            case let .fail(error):
                XCTFail("\(error)")
                firstExpectation.fulfill()
                secondExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)

    }
}
