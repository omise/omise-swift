import Foundation
@testable import Omise
import XCTest


struct AnyJSONAttributes: APIDataSerializable {
    let json: JSONAttributes
}

class URLEncoderTest: OmiseTestCase {
    func testEncodeBasic() {
        let values: JSONAttributes = ["hello": "world"]
        let result = encode(AnyJSONAttributes(json: values))
        XCTAssertEqual("hello", result[0].name)
        XCTAssertEqual("world", result[0].value)
    }
    
    func testEncodeMultipleTypes() {
        let values: JSONAttributes = [
            "0hello": "world",
            "1num": 42,
            "2number": 64,
            "3long": 1234123412341234,
            "4bool": false,
            "5boolean": true,
            "6date": Date(timeIntervalSince1970: 0)
        ]
        
        let result = encode(AnyJSONAttributes(json: values)).map({ (query) in query.value ?? "(nil)" })
        XCTAssertEqual(result, [
            "world",
            "42",
            "64",
            "1234123412341234",
            "false",
            "true",
            "1970-01-01T00:00:00Z"
            ])
    }
    
    func testEncodeNested() {
        let values: JSONAttributes = [
            "0outer": "normal",
            "1nested": ["inside": "inner"] as JSONAttributes,
            "2deeper": ["nesting": ["also": "works"]  ] 
        ]
        
        let result = encode(AnyJSONAttributes(json: values))
        XCTAssertEqual("0outer", result[0].name)
        XCTAssertEqual("normal", result[0].value)
        XCTAssertEqual("1nested[inside]", result[1].name)
        XCTAssertEqual("inner", result[1].value)
        XCTAssertEqual("2deeper[nesting][also]", result[2].name)
        XCTAssertEqual("works", result[2].value)
    }
    
    func testConverter() {
        var searchFilterParams = ChargeFilterParams()
        searchFilterParams.amount = 1000
        searchFilterParams.cardLastDigits = LastDigits(lastDigitsString: "4242")!
        searchFilterParams.isCaptured = true
        searchFilterParams.created = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2016, month: 8, day: 1)
        
        let result = Set(encode(searchFilterParams).map({ (query) in query.value ?? "(nil)" }))
        XCTAssertEqual(result, [
            "1000.0",
            "4242",
            "true",
            "2016-8-1"
            ])
    }
}
