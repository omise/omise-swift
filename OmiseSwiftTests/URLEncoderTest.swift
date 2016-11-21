import Foundation
import Omise
import XCTest

class URLEncoderTest: OmiseTestCase {
    func testEncodeBasic() {
        let values: JSONAttributes = ["hello": "world"]
        let result = URLEncoder.encode(values)
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
        
        let result = URLEncoder.encode(values).map({ (query) in query.value ?? "(nil)" })
        XCTAssertEqual(result, [
            "world",
            "42",
            "64",
            "1234123412341234",
            "false",
            "true",
            "1970-01-01T07:00:00+07:00"
            ])
    }
    
    func testEncodeNested() {
        let values: JSONAttributes = [
            "0outer": "normal",
            "1nested": ["inside": "inner"] as JSONAttributes,
            "2deeper": ["nesting": ["also": "works"]  ] 
        ]
        
        let result = URLEncoder.encode(values)
        XCTAssertEqual("0outer", result[0].name)
        XCTAssertEqual("normal", result[0].value)
        XCTAssertEqual("1nested[inside]", result[1].name)
        XCTAssertEqual("inner", result[1].value)
        XCTAssertEqual("2deeper[nesting][also]", result[2].name)
        XCTAssertEqual("works", result[2].value)
    }
    
    func testConverter() {
        let searchFilterParams = ChargeFilterParams()
        searchFilterParams.amount = 1000
        searchFilterParams.cardLastDigits = "4242"
        searchFilterParams.capture = true
        searchFilterParams.created = DateComponents(year: 2016, month: 8, day: 1)
        
        let result = Set(URLEncoder.encode(searchFilterParams.normalizedAttributes).map({ (query) in query.value ?? "(nil)" }))
        XCTAssertEqual(result, [
            "1000",
            "4242",
            "true",
            "2016-8-1"
            ])
    }
}
