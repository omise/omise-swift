import XCTest
import Omise

class ForexOperationFixtureTests: FixtureTestCase {
    
    func testUSDForex() {
        let expectation = self.expectation(description: "USD Forex Retrieve")
        
        let request = Forex.retrieve(using: testClient, exchangeFrom: .usd) { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(forex):
                XCTAssertEqual(forex.quote, .thb)
                XCTAssertEqual(forex.base, .usd)
                XCTAssertEqual(forex.rate, 32.846_667_05)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeUSDForex() throws {
        let defaultForex = try fixturesObjectFor(type: Forex.self, dataID: "USD")
        
        XCTAssertEqual(defaultForex.base, .usd)
        XCTAssertEqual(defaultForex.quote, .thb)
        XCTAssertEqual(defaultForex.rate, 32.846_667_05)
        XCTAssertEqual(defaultForex.location, "/forex/usd")
        XCTAssertEqual(defaultForex.object, "forex")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultForex)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedForex = try decoder.decode(Forex.self, from: encodedData)
        
        XCTAssertEqual(defaultForex.base, decodedForex.base)
        XCTAssertEqual(defaultForex.quote, decodedForex.quote)
        XCTAssertEqual(defaultForex.rate, decodedForex.rate)
        XCTAssertEqual(defaultForex.location, decodedForex.location)
        XCTAssertEqual(defaultForex.object, decodedForex.object)
    }
    
    func testJPYForex() {
        let expectation = self.expectation(description: "JPY Forex Retrieve")
        
        let request = Forex.retrieve(using: testClient, exchangeFrom: .jpy) { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(forex):
                XCTAssertEqual(forex.quote, .thb)
                XCTAssertEqual(forex.base, .jpy)
                XCTAssertEqual(forex.rate, 0.296_171_769_599_999_97)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeJYPForex() throws {
        let defaultForex = try fixturesObjectFor(type: Forex.self, dataID: "JPY")
        
        XCTAssertEqual(defaultForex.base, .jpy)
        XCTAssertEqual(defaultForex.quote, .thb)
        XCTAssertEqual(defaultForex.rate, 0.296_171_769_599_999_97)
        XCTAssertEqual(defaultForex.location, "/forex/jpy")
        XCTAssertEqual(defaultForex.object, "forex")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultForex)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedForex = try decoder.decode(Forex.self, from: encodedData)
        
        XCTAssertEqual(defaultForex.base, decodedForex.base)
        XCTAssertEqual(defaultForex.quote, decodedForex.quote)
        XCTAssertEqual(defaultForex.rate, decodedForex.rate)
        XCTAssertEqual(defaultForex.location, decodedForex.location)
        XCTAssertEqual(defaultForex.object, decodedForex.object)
    }
    
    func testSGDForex() {
        let expectation = self.expectation(description: "SGD Forex Retrieve")
        
        let request = Forex.retrieve(using: testClient, exchangeFrom: .sgd) { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(forex):
                XCTAssertEqual(forex.quote, .thb)
                XCTAssertEqual(forex.base, .sgd)
                XCTAssertEqual(forex.rate, 24.054_176_718_999_997)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeSGDForex() throws {
        let defaultForex = try fixturesObjectFor(type: Forex.self, dataID: "SGD")
        
        XCTAssertEqual(defaultForex.base, .sgd)
        XCTAssertEqual(defaultForex.quote, .thb)
        XCTAssertEqual(defaultForex.rate, 24.054_176_718_999_997)
        XCTAssertEqual(defaultForex.location, "/forex/sgd")
        XCTAssertEqual(defaultForex.object, "forex")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultForex)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedForex = try decoder.decode(Forex.self, from: encodedData)
        
        XCTAssertEqual(defaultForex.base, decodedForex.base)
        XCTAssertEqual(defaultForex.quote, decodedForex.quote)
        XCTAssertEqual(defaultForex.rate, decodedForex.rate)
        XCTAssertEqual(defaultForex.location, decodedForex.location)
        XCTAssertEqual(defaultForex.object, decodedForex.object)
    }
    
    func testEURForex() {
        let expectation = self.expectation(description: "EUR Forex Retrieve")
        
        let request = Forex.retrieve(using: testClient, exchangeFrom: .eur) { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(forex):
                XCTAssertEqual(forex.quote, .thb)
                XCTAssertEqual(forex.base, .eur)
                XCTAssertEqual(forex.rate, 36.784_682_468_599_996)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeEURForex() throws {
        let defaultForex = try fixturesObjectFor(type: Forex.self, dataID: "EUR")
        
        XCTAssertEqual(defaultForex.base, .eur)
        XCTAssertEqual(defaultForex.quote, .thb)
        XCTAssertEqual(defaultForex.rate, 36.784_682_468_599_996)
        XCTAssertEqual(defaultForex.location, "/forex/eur")
        XCTAssertEqual(defaultForex.object, "forex")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultForex)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedForex = try decoder.decode(Forex.self, from: encodedData)
        
        XCTAssertEqual(defaultForex.base, decodedForex.base)
        XCTAssertEqual(defaultForex.quote, decodedForex.quote)
        XCTAssertEqual(defaultForex.rate, decodedForex.rate)
        XCTAssertEqual(defaultForex.location, decodedForex.location)
        XCTAssertEqual(defaultForex.object, decodedForex.object)
    }
    
    func testGBPForex() {
        let expectation = self.expectation(description: "GBP Forex Retrieve")
        
        let request = Forex.retrieve(using: testClient, exchangeFrom: .gbp) { result in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(forex):
                XCTAssertEqual(forex.quote, .thb)
                XCTAssertEqual(forex.base, .gbp)
                XCTAssertEqual(forex.rate, 42.813_287_797_8)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeGBPForex() throws {
        let defaultForex = try fixturesObjectFor(type: Forex.self, dataID: "GBP")
        
        XCTAssertEqual(defaultForex.base, .gbp)
        XCTAssertEqual(defaultForex.quote, .thb)
        XCTAssertEqual(defaultForex.rate, 42.813_287_797_8)
        XCTAssertEqual(defaultForex.location, "/forex/gbp")
        XCTAssertEqual(defaultForex.object, "forex")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultForex)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedForex = try decoder.decode(Forex.self, from: encodedData)
        
        XCTAssertEqual(defaultForex.base, decodedForex.base)
        XCTAssertEqual(defaultForex.quote, decodedForex.quote)
        XCTAssertEqual(defaultForex.rate, decodedForex.rate)
        XCTAssertEqual(defaultForex.location, decodedForex.location)
        XCTAssertEqual(defaultForex.object, decodedForex.object)
    }
    
}
