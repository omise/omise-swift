import Foundation
@testable import Omise
import XCTest


extension AnyJSONType: Encodable {
    public func encode(to encoder: Encoder) throws {
        switch jsonValue {
        case Optional<Any>.none:
            var container = encoder.singleValueContainer()
            try container.encodeNil()
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
            try container.encode(contentsOf: value.map(AnyJSONType.init))
        case let value as Dictionary<String, Encodable>:
            var container = encoder.container(keyedBy: AnyJSONAttributeEncodingKey.self)
            let sortedValuesByKey = value.sorted(by: { (first, second) -> Bool in
                return first.key < second.key
            })
            for (key, value) in sortedValuesByKey {
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
            "6date": Date(timeIntervalSince1970: 0),
            "7nil": String?.none as Optional<String>,
            ] as [String: Optional<Any>])
        
        let encoder = URLQueryItemEncoder()
        let result = try encoder.encode(values).map({ (query) in query.value ?? "$*nil*$" })
        XCTAssertEqual(8, result.count)
        XCTAssertEqual(result, [
            "world",
            "42",
            "64",
            "1234123412341234",
            "false",
            "true",
            "1970-01-01T00:00:00Z",
            "$*nil*$",
            ])
    }

    func testEncodeNestedWithEmptyIndexStrategy() throws {
        let values = AnyJSONType([
            "0outer": "normal",
            "1nested": ["inside": "inner"] as [String: String],
            "2deeper": ["nesting": ["also": "works"]  ],
            "3array": [ "one", "two", "three", [ "deepest": "inside deepest" ] ],
            "4deeparray": [ "one", "two", "three", [ "deepest", "inside deepest" ] ],
            "5deepdictionary": ["anesting": ["also": "works"],
                                "another nesting": [ "deep": [ "deepest1" : "hello 1", "deepest2": "hello 2" ],
                                                     "deeparray": [ "rolling in", ["the" : 2, "deep": 1]]]],
            "6outer": "normal",
            "7nested": ["inside": "inner"] as [String: String],
            "8deeper": ["nesting": ["also": "works"]  ],
            
            ])
        
        let encoder = URLQueryItemEncoder()
        encoder.arrayIndexEncodingStrategy = .emptySquareBrackets
        let result = try encoder.encode(values)
        XCTAssertEqual(21, result.count)
        XCTAssertEqual("0outer", result[0].name)
        XCTAssertEqual("normal", result[0].value)
        XCTAssertEqual("1nested[inside]", result[1].name)
        XCTAssertEqual("inner", result[1].value)
        XCTAssertEqual("2deeper[nesting][also]", result[2].name)
        XCTAssertEqual("works", result[2].value)
        // 3array
        XCTAssertEqual("one", result[3].value)
        XCTAssertEqual("3array[]", result[3].name)
        XCTAssertEqual("two", result[4].value)
        XCTAssertEqual("3array[]", result[4].name)
        XCTAssertEqual("three", result[5].value)
        XCTAssertEqual("3array[]", result[5].name)
        XCTAssertEqual("inside deepest", result[6].value)
        XCTAssertEqual("3array[][deepest]", result[6].name)
        // 4deeparray
        XCTAssertEqual("one", result[7].value)
        XCTAssertEqual("4deeparray[]", result[7].name)
        XCTAssertEqual("two", result[8].value)
        XCTAssertEqual("4deeparray[]", result[8].name)
        XCTAssertEqual("three", result[9].value)
        XCTAssertEqual("4deeparray[]", result[9].name)
        XCTAssertEqual("deepest", result[10].value)
        XCTAssertEqual("4deeparray[][]", result[10].name)
        XCTAssertEqual("inside deepest", result[11].value)
        XCTAssertEqual("4deeparray[][]", result[11].name)
        
        // 5deepdictionary
        XCTAssertEqual("works", result[12].value)
        XCTAssertEqual("5deepdictionary[anesting][also]", result[12].name)
        XCTAssertEqual("hello 1", result[13].value)
        XCTAssertEqual("5deepdictionary[another nesting][deep][deepest1]", result[13].name)
        XCTAssertEqual("hello 2", result[14].value)
        XCTAssertEqual("5deepdictionary[another nesting][deep][deepest2]", result[14].name)
        // 5deepdictionary -> deeparray
        XCTAssertEqual("rolling in", result[15].value)
        XCTAssertEqual("5deepdictionary[another nesting][deeparray][]", result[15].name)
        XCTAssertEqual("2", result[17].value)
        XCTAssertEqual("5deepdictionary[another nesting][deeparray][][the]", result[17].name)
        XCTAssertEqual("1", result[16].value)
        XCTAssertEqual("5deepdictionary[another nesting][deeparray][][deep]", result[16].name)
        
        // resting
        XCTAssertEqual("6outer", result[18].name)
        XCTAssertEqual("normal", result[18].value)
        XCTAssertEqual("7nested[inside]", result[19].name)
        XCTAssertEqual("inner", result[19].value)
        XCTAssertEqual("8deeper[nesting][also]", result[20].name)
        XCTAssertEqual("works", result[20].value)
    }
    
    func testEncodeNestedWithIndexStrategy() throws {
        let values = AnyJSONType([
            "0outer": "normal",
            "1nested": ["inside": "inner"] as [String: String],
            "2deeper": ["nesting": ["also": "works"]  ],
            "3array": [ "one", "two", "three", [ "deepest": "inside deepest" ] ],
            "4deeparray": [ "one", "two", "three", [ "deepest", "inside deepest" ] ],
            "5deepdictionary": ["anesting": ["also": "works"],
                                "another nesting": [ "deep": [ "deepest1" : "hello 1", "deepest2": "hello 2" ],
                                                     "deeparray": [ "rolling in", ["the" : 2, "deep": 1]]]],
            "6outer": "normal",
            "7nested": ["inside": "inner"] as [String: String],
            "8deeper": ["nesting": ["also": "works"]  ],

            ])
        
        let encoder = URLQueryItemEncoder()
        encoder.arrayIndexEncodingStrategy = .index
        let result = try encoder.encode(values)
        XCTAssertEqual(21, result.count)
        XCTAssertEqual("0outer", result[0].name)
        XCTAssertEqual("normal", result[0].value)
        XCTAssertEqual("1nested[inside]", result[1].name)
        XCTAssertEqual("inner", result[1].value)
        XCTAssertEqual("2deeper[nesting][also]", result[2].name)
        XCTAssertEqual("works", result[2].value)
        // 3array
        XCTAssertEqual("one", result[3].value)
        XCTAssertEqual("3array[0]", result[3].name)
        XCTAssertEqual("two", result[4].value)
        XCTAssertEqual("3array[1]", result[4].name)
        XCTAssertEqual("three", result[5].value)
        XCTAssertEqual("3array[2]", result[5].name)
        XCTAssertEqual("inside deepest", result[6].value)
        XCTAssertEqual("3array[3][deepest]", result[6].name)
        // 4deeparray
        XCTAssertEqual("one", result[7].value)
        XCTAssertEqual("4deeparray[0]", result[7].name)
        XCTAssertEqual("two", result[8].value)
        XCTAssertEqual("4deeparray[1]", result[8].name)
        XCTAssertEqual("three", result[9].value)
        XCTAssertEqual("4deeparray[2]", result[9].name)
        XCTAssertEqual("deepest", result[10].value)
        XCTAssertEqual("4deeparray[3][0]", result[10].name)
        XCTAssertEqual("inside deepest", result[11].value)
        XCTAssertEqual("4deeparray[3][1]", result[11].name)
        
        // 5deepdictionary
        XCTAssertEqual("works", result[12].value)
        XCTAssertEqual("5deepdictionary[anesting][also]", result[12].name)
        XCTAssertEqual("hello 1", result[13].value)
        XCTAssertEqual("5deepdictionary[another nesting][deep][deepest1]", result[13].name)
        XCTAssertEqual("hello 2", result[14].value)
        XCTAssertEqual("5deepdictionary[another nesting][deep][deepest2]", result[14].name)
        // 5deepdictionary -> deeparray
        XCTAssertEqual("rolling in", result[15].value)
        XCTAssertEqual("5deepdictionary[another nesting][deeparray][0]", result[15].name)
        XCTAssertEqual("2", result[17].value)
        XCTAssertEqual("5deepdictionary[another nesting][deeparray][1][the]", result[17].name)
        XCTAssertEqual("1", result[16].value)
        XCTAssertEqual("5deepdictionary[another nesting][deeparray][1][deep]", result[16].name)
        
        // resting
        XCTAssertEqual("6outer", result[18].name)
        XCTAssertEqual("normal", result[18].value)
        XCTAssertEqual("7nested[inside]", result[19].name)
        XCTAssertEqual("inner", result[19].value)
        XCTAssertEqual("8deeper[nesting][also]", result[20].name)
        XCTAssertEqual("works", result[20].value)
    }

    func testConvertChargeFilterParams() throws {
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
            "2016-8-1",
            ])
    }
    
    func testConvertListParams() throws {
        let from = Date()
        let to = from.addingTimeInterval(3600)
        let listParams = ListParams(from: from, to: to, offset: nil, limit: nil, order: Ordering.chronological)
        
        let encoder = URLQueryItemEncoder()
        let items = try encoder.encode(listParams)
        
        let formatter = ISO8601DateFormatter()
        let expectedFromDateString = formatter.string(from: from)
        let expectedToDateString = formatter.string(from: to)
        XCTAssertEqual(3, items.count)
        let result = items.map({ (query) in query.value ?? "(nil)" })
        XCTAssertEqual(result, [
            expectedFromDateString,
            expectedToDateString,
            "chronological",
            ])
    }
    
    func testCreateChargeParams() throws {
        let createChargeParams = ChargeParams(value: Value(amount: 10_000_00, currency: .thb), chargeDescription: "A charge description", customerID: nil, cardID: nil, isAutoCapture: true, returnURL: URL(string: "https://omise.co"), metadata: ["customer-id": "1", "stock-count": 66473])
        
        let encoder = URLQueryItemEncoder()
        encoder.arrayIndexEncodingStrategy = .emptySquareBrackets
        let result = try encoder.encode(createChargeParams)
        XCTAssertEqual(result.count, 7)
        
        XCTAssertEqual("amount", result[0].name)
        XCTAssertEqual("1000000", result[0].value)
        XCTAssertEqual("currency", result[1].name)
        XCTAssertEqual("THB", result[1].value)
        XCTAssertEqual("description", result[2].name)
        XCTAssertEqual("A charge description", result[2].value)
        XCTAssertEqual("capture", result[3].name)
        XCTAssertEqual("true", result[3].value)
        XCTAssertEqual("return_uri", result[4].name)
        XCTAssertEqual("https://omise.co", result[4].value)
        XCTAssertEqual("metadata[customer-id]", result[5].name)
        XCTAssertEqual("1", result[5].value)
        XCTAssertEqual("metadata[stock-count]", result[6].name)
        XCTAssertEqual("66473", result[6].value)
    }
}
