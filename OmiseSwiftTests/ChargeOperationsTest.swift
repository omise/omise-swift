import Foundation
import XCTest
@testable import Omise

class ChargeOperationsTest: LiveTest {
    
    func testChargeList() {
        let expectation = self.expectation(description: "charge list")
        
        let request = Charge.list(using: testClient, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfersList):
                XCTAssertNotNil(transfersList.data)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
     
    
    func testChargeRetrieve() {
        let expectation = self.expectation(description: "charge retrieve")
        
        let request = Charge.retrieve(using: testClient, id: "chrg_test_54phpsikwx0q7sv8h4g", callback: { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charge):
                XCTAssertEqual(charge.id, "chrg_test_54phpsikwx0q7sv8h4g")
                switch charge.transaction {
                case .loaded(let transaction)?:
                    XCTAssertEqual(transaction.id, "trxn_test_54phpsjg3xlhyapzlyp")
                default:
                    XCTFail("Could not load charge's transaction data")
                }
            case let .failure(error):
                XCTFail("\(error)")
            }
        })
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testChargeInfiniteListWithAfter() {
        let firstExpectation = self.expectation(description: "charge list")
        let secondExpectation = self.expectation(description: "Load more of charge list")
        
        Charge.list(using: testClient) { (result) in
            defer { firstExpectation.fulfill() }
            switch result {
            case let .success(transfersList):
                XCTAssertNotNil(transfersList.data)
                XCTAssertEqual(transfersList.loadedIndices, 0..<20)
                
                transfersList.loadNextPage(using: self.testClient, callback: { (afterResult) in
                    defer { secondExpectation.fulfill() }
                    
                    switch afterResult {
                    case let .success(loadedMoreList):
                        XCTAssertGreaterThan(loadedMoreList.count, 0)
                        XCTAssertEqual(transfersList.data.count, 25)
                        XCTAssertEqual(transfersList.data.count, Set(transfersList.data.map({ $0.id })).count)
                        XCTAssertEqual(transfersList.loadedIndices, 0..<25)
                    case .failure(let error):
                        XCTFail("\(error)")
                    }
                })
            case let .failure(error):
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
        
        var listParams = ListParams()
        
        listParams.limit = 20
        listParams.offset = 30
        
        let request = Charge.list(using: testClient, params: listParams) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(transfersList):
                XCTAssertNotNil(transfersList.data)
                let list = List<Charge>(listEndpoint: APIEndpoint<ListProperty<Charge>>(endpoint: .api, pathComponents: [Charge.resourcePath], parameter: .get(listParams)), list: transfersList)
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
                                XCTAssertEqual(transfersList.data.count, Set(transfersList.data.map({ $0.id })).count)
                                XCTAssertEqual(list.loadedIndices, 0..<25)
                            case .failure(let error):
                                XCTFail("\(error)")
                            }
                        })
                    case .failure(let error):
                        XCTFail("\(error)")
                        secondExpectation.fulfill()
                    }
                })
            case let .failure(error):
                XCTFail("\(error)")
                firstExpectation.fulfill()
                secondExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)

    }
}
