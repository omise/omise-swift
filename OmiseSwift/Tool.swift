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
    convenience init?(hexString: String) {
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


extension Dictionary {
    static func makeFlattenDictionaryFrom(_ values: ([Key: Value?])) -> Dictionary<Key, Value> {
        return Dictionary(uniqueKeysWithValues: values.flatMap({ element -> (Key, Value)? in
            if let value = element.value {
                return (element.key, value)
            } else {
                return nil
            }
        }))
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
    func decodeOmiseDateComponents(_ dateComponentsValue: String) throws -> DateComponents {
        return try parsingDateComponentsValue(dateComponentsValue, codingPath: codingPath)
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
}


extension Encoder {
    func encodeOmiseDateComponents(_ dateComponents: DateComponents) throws {
        var container = singleValueContainer()
        try container.encode(_encodeOmiseDateComponents(dateComponents, codingPath: codingPath))
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
