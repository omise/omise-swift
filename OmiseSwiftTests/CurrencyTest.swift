import XCTest
import Omise


class CurrencyTest: XCTestCase {
    
    func testSupportedCurrencies() {
        do {
            let currency = Currency(code: "THB")
            XCTAssertEqual(currency?.code, "THB")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "JPY")
            XCTAssertEqual(currency?.code, "JPY")
            XCTAssertEqual(currency?.factor, 1)
        }
        
        do {
            let currency = Currency(code: "IDR")
            XCTAssertEqual(currency?.code, "IDR")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "SGD")
            XCTAssertEqual(currency?.code, "SGD")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "USD")
            XCTAssertEqual(currency?.code, "USD")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "GBP")
            XCTAssertEqual(currency?.code, "GBP")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "EUR")
            XCTAssertEqual(currency?.code, "EUR")
            XCTAssertEqual(currency?.factor, 100)
        }
    }
    
    func testUnsupportedCurrencies() {
        do {
            let currency = Currency(code: "KRW")
            XCTAssertEqual(currency?.code, "KRW")
            XCTAssertEqual(currency?.factor, 1)
        }
        
        do {
            let currency = Currency(code: "MYR")
            XCTAssertEqual(currency?.code, "MYR")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "CNY")
            XCTAssertEqual(currency?.code, "CNY")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "AUD")
            XCTAssertEqual(currency?.code, "AUD")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "CAD")
            XCTAssertEqual(currency?.code, "CAD")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "HKD")
            XCTAssertEqual(currency?.code, "HKD")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "RUB")
            XCTAssertEqual(currency?.code, "RUB")
            XCTAssertEqual(currency?.factor, 100)
        }
    }
}
