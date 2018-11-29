import Foundation
#if os(iOS)
    import UIKit
    public typealias Color = UIColor
 #elseif os(macOS)
    import AppKit
    public typealias Color = NSColor
#endif


func omiseWarn(_ message: String) {
    print("[omise-swift] WARN: \(message)")
}

public typealias JSONDictionary = [String: Any]

public extension Color {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        guard hexString.hasPrefix("#") else {
            return nil
        }
        
        let start = hexString.index(hexString.startIndex, offsetBy: 1)
        let hexColor = String(hexString[start...])
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        
        guard scanner.scanHexInt64(&hexNumber) else {
            return nil
        }
        
        switch hexColor.count {
        case 8:
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
            
            self.init(red: r, green: g, blue: b, alpha: a)
        case 6:
            r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            b = CGFloat((hexNumber & 0x0000ff)) / 255
            
            self.init(red: r, green: g, blue: b, alpha: 1.0)

        default:
            return nil
        }
    }
}


func deserializeData<TObject: OmiseObject>(_ data: Data) throws -> TObject {
    let jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = .iso8601
    return try jsonDecoder.decode(TObject.self, from: data)
}

private func makeScanner(forString string: String) -> Scanner {
    let scanner = Scanner(string: string)
    let validCharacterSet = CharacterSet(charactersIn: "0123456789-")
    scanner.charactersToBeSkipped = validCharacterSet.inverted
    return scanner
}

private func parsingDateComponentsValue(_ value: String, codingPath: [CodingKey]) throws -> DateComponents {
    let scanner = makeScanner(forString: value)
    let year: Int
    let month: Int
    let day: Int
    
    var firstInt: Int = 0
    var secondInt: Int = 0
    var lastInt: Int = 0
    guard scanner.scanInt(&firstInt) &&
        scanner.scanString("-", into: nil) &&
        scanner.scanInt(&secondInt) &&
        scanner.scanString("-", into: nil) &&
        scanner.scanInt(&lastInt)
        else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Invalid Date Components value"))
    }
    
    month = secondInt
    let isYearFirst = firstInt > 12
    if isYearFirst {
        year = firstInt
        day = lastInt
    } else {
        day = firstInt
        year = lastInt
    }
    
    var components = DateComponents()
    components.calendar = Calendar(identifier: .gregorian)
    
    components.year = year
    components.month = month
    components.day = day
    
    return components
}

func _encodeOmiseDateComponents(_ dateComponents: DateComponents, codingPath: [CodingKey]) throws -> String {
    guard (dateComponents.calendar?.identifier ?? Calendar.current.identifier) == .gregorian else {
        throw EncodingError.invalidValue(
            dateComponents,
            EncodingError.Context(codingPath: codingPath, debugDescription: "Date Components' calendar must be Gregorian calendar")
        )
    }
    
    guard let year = dateComponents.year, let month = dateComponents.month, let day = dateComponents.day else {
        throw EncodingError.invalidValue(dateComponents, EncodingError.Context(codingPath: codingPath, debugDescription: "Invalid Date Components value"))
    }
    
    return "\(year)-\(month)-\(day)"
}


extension Decoder {
    private func decodeOmiseDateComponents(_ dateComponentsValue: String) throws -> DateComponents {
        return try parsingDateComponentsValue(dateComponentsValue, codingPath: codingPath)
    }
    
    func decodeJSONDictionary() throws -> Dictionary<String, Any> {
        let container = try self.container(keyedBy: JSONCodingKeys.self)
        return try container.decodeJSONDictionary()
    }
}

private struct ArrayIndexKey: CodingKey {
    let index: Int
    
    var stringValue: String {
        return "[\(index)]"
    }
    
    var intValue: Int? {
        return index
    }
    
    init(index: Int) {
        self.index = index
    }
    
    init?(stringValue: String) {
        guard let parsedValue = Int(stringValue) else {
            return nil
        }
        self.init(intValue: parsedValue)
    }
    
    init?(intValue: Int) {
        self.index = intValue
    }
}

struct JSONCodingKeys: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
        self.init(key: stringValue)
    }
    
    init(key: String) {
        self.stringValue = key
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}


extension KeyedDecodingContainerProtocol {
    func decodeOmiseDateComponents(forKey key: Key) throws -> DateComponents {
        let dateComponentsValue = try decode(String.self, forKey: key)
        return try parsingDateComponentsValue(dateComponentsValue, codingPath: codingPath)
    }
    
    func decodeOmiseDateComponentsIfPresent(forKey key: Key) throws -> DateComponents? {
        guard let dateComponentsValue = try decodeIfPresent(String.self, forKey: key) else {
            return nil
        }
        
        return try parsingDateComponentsValue(dateComponentsValue, codingPath: codingPath)
    }
    
    func decodeOmiseDateComponentsArray(forKey key: Key) throws -> [DateComponents] {
        let dateComponentsValues = try decode(Array<String>.self, forKey: key)
        
        return try dateComponentsValues.enumerated().map({ (index, element) in
            try parsingDateComponentsValue(element, codingPath: codingPath + [key, ArrayIndexKey(index: index)])
        })
    }
    
    func decodeOmiseAPIValueIfPresent(_ type: Bool.Type, forKey key: Key) throws -> Bool? {
        do {
            return try decodeIfPresent(type, forKey: key)
        } catch DecodingError.typeMismatch {
            let stringValue = try decodeIfPresent(String.self, forKey: key)
            guard let value = stringValue else {
                return nil
            }
            
            guard let boolValue = Bool(value) else {
                throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Invalid Omise API Value for a boolean")
            }
            
            return boolValue
        }
    }
    
    func decodeOmiseAPIValueIfPresent(_ type: Double.Type, forKey key: Key) throws -> Double? {
        do {
            return try decodeIfPresent(type, forKey: key)
        } catch DecodingError.typeMismatch {
            let stringValue = try decodeIfPresent(String.self, forKey: key)
            guard let value = stringValue else {
                return nil
            }
            
            guard let doubleValue = Double(value) else {
                throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Invalid Omise API Value for a double")
            }
            
            return doubleValue
        }
    }

}

extension KeyedDecodingContainerProtocol {
    func decode(_ type: Dictionary<String, Any>.Type, forKey key: Key) throws -> Dictionary<String, Any> {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decodeJSONDictionary()
    }
    
    func decodeIfPresent(_ type: Dictionary<String, Any>.Type, forKey key: Key) throws -> Dictionary<String, Any>? {
        guard contains(key) else {
            return nil
        }
        return try decode(type, forKey: key)
    }
    
    func decode(_ type: Array<Any>.Type, forKey key: Key) throws -> Array<Any> {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decodeJSONArray()
    }
    
    func decodeIfPresent(_ type: Array<Any>.Type, forKey key: Key) throws -> Array<Any>? {
        guard contains(key) else {
            return nil
        }
        return try decode(type, forKey: key)
    }
    
    func decodeJSONDictionary() throws -> Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()
        
        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            } else if try decodeNil(forKey: key) {
                dictionary[key.stringValue] = String?.none as Any
            }
        }
        return dictionary
    }
}

extension UnkeyedDecodingContainer {
    mutating func decodeJSONArray() throws -> Array<Any> {
        var array: [Any] = []
        while isAtEnd == false {
            if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decodeArrayElement() {
                array.append(nestedArray)
            }
        }
        return array
    }
    
    private mutating func decodeArrayElement() throws -> Array<Any> {
        var nestedContainer = try self.nestedUnkeyedContainer()
        return try nestedContainer.decodeJSONArray()
    }
    
    mutating func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decodeJSONDictionary()
    }
}

extension SingleValueDecodingContainer {
//    mutating func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
//        let nestedContainer = try  .nestedContainer(keyedBy: JSONCodingKeys.self)
//        return try nestedContainer.decodeJSONDictionary()
//    }
}

extension Encoder {
    func encodeOmiseDateComponents(_ dateComponents: DateComponents) throws {
        var container = singleValueContainer()
        try container.encode(_encodeOmiseDateComponents(dateComponents, codingPath: codingPath))
    }
    
    func encodeJSONDictionary(_ jsonDictionary: Dictionary<String, Any>) throws {
        var container = self.container(keyedBy: JSONCodingKeys.self)
        try container.encodeJSONDictionary(jsonDictionary)
    }
}

extension KeyedEncodingContainerProtocol {
    mutating func encodeOmiseDateComponents(_ dateComponents: DateComponents, forKey key: Key) throws {
        let dateComponentsValue = try _encodeOmiseDateComponents(dateComponents, codingPath: codingPath)
        try encode(dateComponentsValue, forKey: key)
    }
    
    mutating func encodeOmiseDateComponentsIfPresent(_ dateComponents: DateComponents?, forKey key: Key) throws {
        if let dateComponents = dateComponents {
            try encodeOmiseDateComponents(dateComponents, forKey: key)
        }
    }
    
    mutating func encodeOmiseDateComponentsArray(_ dateComponents: [DateComponents], forKey key: Key) throws {
        let dateComponentsValue = try dateComponents.enumerated().map({ (index, element) in
            try _encodeOmiseDateComponents(element, codingPath: codingPath + [key, ArrayIndexKey(index: index)])
        })
        try encode(dateComponentsValue, forKey: key)
    }
}

extension KeyedEncodingContainerProtocol where Key == JSONCodingKeys {
    mutating func encodeJSONDictionary(_ value: Dictionary<String, Any>) throws {
        try value.forEach({ (key, value) in
            let key = JSONCodingKeys(key: key)
            switch value {
            case let value as Bool:
                try encode(value, forKey: key)
            case let value as Int:
                try encode(value, forKey: key)
            case let value as String:
                try encode(value, forKey: key)
            case let value as Double:
                try encode(value, forKey: key)
            case let value as Dictionary<String, Any>:
                try encode(value, forKey: key)
            case let value as Array<Any>:
                try encode(value, forKey: key)
            case Optional<Any>.none:
                try encodeNil(forKey: key)
            default:
                throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: codingPath + [key], debugDescription: "Invalid JSON value"))
            }
        })
    }
}

extension KeyedEncodingContainerProtocol {
    mutating func encode(_ value: Dictionary<String, Any>, forKey key: Key) throws {
        var container = self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        try container.encodeJSONDictionary(value)
    }
    
    mutating func encodeIfPresent(_ value: Dictionary<String, Any>?, forKey key: Key) throws {
        if let value = value {
            try encode(value, forKey: key)
        }
    }
    
    mutating func encode(_ value: Array<Any>, forKey key: Key) throws {
        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encodeJSONArray(value)
    }
    
    mutating func encodeIfPresent(_ value: Array<Any>?, forKey key: Key) throws {
        if let value = value {
            try encode(value, forKey: key)
        }
    }
}

extension UnkeyedEncodingContainer {
    mutating func encodeJSONArray(_ value: Array<Any>) throws {
        try value.enumerated().forEach({ (index, value) in
            switch value {
            case let value as Bool:
                try encode(value)
            case let value as Int:
                try encode(value)
            case let value as String:
                try encode(value)
            case let value as Double:
                try encode(value)
            case let value as Dictionary<String, Any>:
                try encodeJSONDictionary(value)
            case let value as Array<Any>:
                try encodeArrayElement(value)
            case Optional<Any>.none:
                try encodeNil()
            default:
                let keys = JSONCodingKeys(intValue: index).map({ [ $0 ] }) ?? []
                throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: codingPath + keys, debugDescription: "Invalid JSON value"))
            }
        })
    }
    
    private mutating func encodeArrayElement(_ value: Array<Any>) throws {
        var nestedContainer = self.nestedUnkeyedContainer()
        try nestedContainer.encodeJSONArray(value)
    }
    
    mutating func encodeJSONDictionary(_ value: Dictionary<String, Any>) throws {
        var nestedContainer = self.nestedContainer(keyedBy: JSONCodingKeys.self)
        try nestedContainer.encodeJSONDictionary(value)
    }
}

