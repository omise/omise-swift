import XCTest
import Omise

class CurrencyTest: XCTestCase {
    
    // swiftlint:disable function_body_length
    func testSupportedCurrencies() {
        do {
            let currency = Currency(code: "THB")
            XCTAssertEqual(currency, Currency.thb)
            XCTAssertEqual(currency?.code, "THB")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "JPY")
            XCTAssertEqual(currency, Currency.jpy)
            XCTAssertEqual(currency?.code, "JPY")
            XCTAssertEqual(currency?.factor, 1)
        }
        
        do {
            let currency = Currency(code: "IDR")
            XCTAssertEqual(currency, Currency.idr)
            XCTAssertEqual(currency?.code, "IDR")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "SGD")
            XCTAssertEqual(currency, Currency.sgd)
            XCTAssertEqual(currency?.code, "SGD")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "USD")
            XCTAssertEqual(currency, Currency.usd)
            XCTAssertEqual(currency?.code, "USD")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "GBP")
            XCTAssertEqual(currency, Currency.gbp)
            XCTAssertEqual(currency?.code, "GBP")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "EUR")
            XCTAssertEqual(currency, Currency.eur)
            XCTAssertEqual(currency?.code, "EUR")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "MYR")
            XCTAssertEqual(currency, Currency.myr)
            XCTAssertEqual(currency?.code, "MYR")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "AUD")
            XCTAssertEqual(currency, Currency.aud)
            XCTAssertEqual(currency?.code, "AUD")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "CAD")
            XCTAssertEqual(currency, Currency.cad)
            XCTAssertEqual(currency?.code, "CAD")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "CHF")
            XCTAssertEqual(currency, Currency.chf)
            XCTAssertEqual(currency?.code, "CHF")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "CNY")
            XCTAssertEqual(currency, Currency.cny)
            XCTAssertEqual(currency?.code, "CNY")
            XCTAssertEqual(currency?.factor, 100)
        }
        
        do {
            let currency = Currency(code: "DKK")
            XCTAssertEqual(currency, Currency.dkk)
            XCTAssertEqual(currency?.code, "DKK")
            XCTAssertEqual(currency?.factor, 100)
        }

        do {
            let currency = Currency(code: "HKD")
            XCTAssertEqual(currency?.code, "HKD")
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
            let currency = Currency(code: "RUB")
            XCTAssertEqual(currency?.code, "RUB")
            XCTAssertEqual(currency?.factor, 100)
        }
    }
}
