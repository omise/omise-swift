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
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeUSDForex() throws {
        let defaultForex = try fixturesObjectFor(type: Forex.self, dataID: "USD")
        
        XCTAssertEqual(defaultForex.from, .usd)
        XCTAssertEqual(defaultForex.to, .thb)
        XCTAssertEqual(defaultForex.rate, 32.84666705)
        XCTAssertEqual(defaultForex.location, "/forex/usd")
        XCTAssertEqual(defaultForex.object, "forex")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultForex)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedForex = try decoder.decode(Forex.self, from: encodedData)
        
        XCTAssertEqual(defaultForex.from, decodedForex.from)
        XCTAssertEqual(defaultForex.to, decodedForex.to)
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
                XCTAssertEqual(forex.to, .thb)
                XCTAssertEqual(forex.from, .jpy)
                XCTAssertEqual(forex.rate, 0.29617176959999997)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeJYPForex() throws {
        let defaultForex = try fixturesObjectFor(type: Forex.self, dataID: "JPY")
        
        XCTAssertEqual(defaultForex.from, .jpy)
        XCTAssertEqual(defaultForex.to, .thb)
        XCTAssertEqual(defaultForex.rate, 0.29617176959999997)
        XCTAssertEqual(defaultForex.location, "/forex/jpy")
        XCTAssertEqual(defaultForex.object, "forex")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultForex)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedForex = try decoder.decode(Forex.self, from: encodedData)
        
        XCTAssertEqual(defaultForex.from, decodedForex.from)
        XCTAssertEqual(defaultForex.to, decodedForex.to)
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
                XCTAssertEqual(forex.to, .thb)
                XCTAssertEqual(forex.from, .sgd)
                XCTAssertEqual(forex.rate, 24.054176718999997)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeSGDForex() throws {
        let defaultForex = try fixturesObjectFor(type: Forex.self, dataID: "SGD")
        
        XCTAssertEqual(defaultForex.from, .sgd)
        XCTAssertEqual(defaultForex.to, .thb)
        XCTAssertEqual(defaultForex.rate, 24.054176718999997)
        XCTAssertEqual(defaultForex.location, "/forex/sgd")
        XCTAssertEqual(defaultForex.object, "forex")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultForex)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedForex = try decoder.decode(Forex.self, from: encodedData)
        
        XCTAssertEqual(defaultForex.from, decodedForex.from)
        XCTAssertEqual(defaultForex.to, decodedForex.to)
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
                XCTAssertEqual(forex.to, .thb)
                XCTAssertEqual(forex.from, .eur)
                XCTAssertEqual(forex.rate, 36.784682468599996)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeEURForex() throws {
        let defaultForex = try fixturesObjectFor(type: Forex.self, dataID: "EUR")
        
        XCTAssertEqual(defaultForex.from, .eur)
        XCTAssertEqual(defaultForex.to, .thb)
        XCTAssertEqual(defaultForex.rate, 36.784682468599996)
        XCTAssertEqual(defaultForex.location, "/forex/eur")
        XCTAssertEqual(defaultForex.object, "forex")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultForex)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedForex = try decoder.decode(Forex.self, from: encodedData)
        
        XCTAssertEqual(defaultForex.from, decodedForex.from)
        XCTAssertEqual(defaultForex.to, decodedForex.to)
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
                XCTAssertEqual(forex.to, .thb)
                XCTAssertEqual(forex.from, .gbp)
                XCTAssertEqual(forex.rate, 42.8132877978)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeGBPForex() throws {
        let defaultForex = try fixturesObjectFor(type: Forex.self, dataID: "GBP")
        
        XCTAssertEqual(defaultForex.from, .gbp)
        XCTAssertEqual(defaultForex.to, .thb)
        XCTAssertEqual(defaultForex.rate, 42.8132877978)
        XCTAssertEqual(defaultForex.location, "/forex/gbp")
        XCTAssertEqual(defaultForex.object, "forex")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultForex)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedForex = try decoder.decode(Forex.self, from: encodedData)
        
        XCTAssertEqual(defaultForex.from, decodedForex.from)
        XCTAssertEqual(defaultForex.to, decodedForex.to)
        XCTAssertEqual(defaultForex.rate, decodedForex.rate)
        XCTAssertEqual(defaultForex.location, decodedForex.location)
        XCTAssertEqual(defaultForex.object, decodedForex.object)
    }
    
}
