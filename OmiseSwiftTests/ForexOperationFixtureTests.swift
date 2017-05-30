import XCTest
import Omise

class ForexOperationFixtureTests: FixtureTestCase {
    
    func testUSDForex() {
        let expectation = self.expectation(description: "USD Forex Retrieve")
        
        let request = Forex.retrieve(using: testClient, exchangeFrom: .usd) { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(forex):
                XCTAssertEqual(forex.to, .thb)
                XCTAssertEqual(forex.from, .usd)
                XCTAssertEqual(forex.rate, 32.84666705)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testJPYForex() {
        let expectation = self.expectation(description: "JPY Forex Retrieve")
        
        let request = Forex.retrieve(using: testClient, exchangeFrom: .jpy) { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(forex):
                XCTAssertEqual(forex.to, .thb)
                XCTAssertEqual(forex.from, .jpy)
                XCTAssertEqual(forex.rate, 0.29617176959999997)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testSGDForex() {
        let expectation = self.expectation(description: "SGD Forex Retrieve")
        
        let request = Forex.retrieve(using: testClient, exchangeFrom: .sgd) { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(forex):
                XCTAssertEqual(forex.to, .thb)
                XCTAssertEqual(forex.from, .sgd)
                XCTAssertEqual(forex.rate, 24.054176718999997)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEURForex() {
        let expectation = self.expectation(description: "EUR Forex Retrieve")
        
        let request = Forex.retrieve(using: testClient, exchangeFrom: .eur) { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(forex):
                XCTAssertEqual(forex.to, .thb)
                XCTAssertEqual(forex.from, .eur)
                XCTAssertEqual(forex.rate, 36.784682468599996)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testGBPForex() {
        let expectation = self.expectation(description: "GBP Forex Retrieve")
        
        let request = Forex.retrieve(using: testClient, exchangeFrom: .gbp) { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(forex):
                XCTAssertEqual(forex.to, .thb)
                XCTAssertEqual(forex.from, .gbp)
                XCTAssertEqual(forex.rate, 42.8132877978)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
}
