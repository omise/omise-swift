import Foundation
@testable import Omise
import XCTest


extension AnyJSONType: Encodable {
    public func encode(to encoder: Encoder) throws {
        switch jsonValue {
        case let value as Int:
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case let value as Bool:
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case let value as Double:
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case let value as String:
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case let value as Date:
            var container = encoder.singleValueContainer()
            let formatter = ISO8601DateFormatter()
            try container.encode(formatter.string(from: value))
        case let value as [Encodable]:
            var container = encoder.unkeyedContainer()
            try container.encode(value.map(AnyJSONType.init))
        case let value as Dictionary<String, Encodable>:
            var container = encoder.container(keyedBy: AnyJSONAttributeEncodingKey.self)
            for (key, value) in value {
                let value = AnyJSONType(value)
                try container.encode(value, forKey: AnyJSONAttributeEncodingKey(stringValue: key))
            }
        default: fatalError()
        }
    }
}

fileprivate struct AnyJSONAttributeEncodingKey: CodingKey {
    let stringValue: String
    init?(intValue: Int) { return nil }
    var intValue: Int? { return nil }
    init(stringValue: String) { self.stringValue = stringValue }
}

class URLEncoderTest: OmiseTestCase {
    func testEncodeBasic() throws {
        let values = AnyJSONType(["hello": "world"])
        let encoder = URLQueryItemEncoder()
        let result = try encoder.encode(values)
        
        XCTAssertEqual(1, result.count)
        XCTAssertEqual("hello", result[0].name)
        XCTAssertEqual("world", result[0].value)
    }

    func testEncodeMultipleTypes() throws {
        let values = AnyJSONType([
            "0hello": "world",
            "1num": 42,
            "2number": 64,
            "3long": 1234123412341234,
            "4bool": false,
            "5boolean": true,
            "6date": Date(timeIntervalSince1970: 0)
        ])
        
        let encoder = URLQueryItemEncoder()
        let result = try encoder.encode(values).map({ (query) in query.value ?? "(nil)" })
        XCTAssertEqual(7, result.count)
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

    func testEncodeNested() throws {
        let values = AnyJSONType([
            "0outer": "normal",
            "1nested": ["inside": "inner"] as [String: String],
            "2deeper": ["nesting": ["also": "works"]  ],
            "3array": [ "one", "two", "three", [ "deepest": "inside deepest" ] ],
        ])

        let encoder = URLQueryItemEncoder()
        let result = try encoder.encode(values)
        XCTAssertEqual(7, result.count)
        XCTAssertEqual("0outer", result[0].name)
        XCTAssertEqual("normal", result[0].value)
        XCTAssertEqual("1nested[inside]", result[1].name)
        XCTAssertEqual("inner", result[1].value)
        XCTAssertEqual("2deeper[nesting][also]", result[2].name)
        XCTAssertEqual("works", result[2].value)
        XCTAssertEqual("one", result[3].value)
        XCTAssertEqual("3array[]", result[3].name)
        XCTAssertEqual("two", result[4].value)
        XCTAssertEqual("3array[]", result[4].name)
        XCTAssertEqual("three", result[5].value)
        XCTAssertEqual("3array[]", result[5].name)
        XCTAssertEqual("inside deepest", result[6].value)
        XCTAssertEqual("3array[][deepest]", result[6].name)
    }

    func testConverter() throws {
        var searchFilterParams = ChargeFilterParams()
        searchFilterParams.amount = 1000
        searchFilterParams.cardLastDigits = LastDigits(lastDigitsString: "4242")!
        searchFilterParams.isCaptured = true
        searchFilterParams.created = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2016, month: 8, day: 1)
        
        let encoder = URLQueryItemEncoder()
        let items = try encoder.encode(searchFilterParams)
        
        XCTAssertEqual(4, items.count)
        let result = Set(items.map({ (query) in query.value ?? "(nil)" }))
        XCTAssertEqual(result, [
            "1000.0",
            "4242",
            "true",
            "2016-8-1"
            ])
    }
}
