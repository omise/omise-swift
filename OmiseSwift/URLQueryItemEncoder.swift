import Foundation


public protocol URLQueryItemEncodable: Encodable {
    func queryEncode(to encoder: URLQueryItemEncoder) throws
}

public extension URLQueryItemEncodable {
    public func queryEncode(to encoder: URLQueryItemEncoder) throws {
        try encode(to: encoder)
    }
}

extension DateComponents: URLQueryItemEncodable {
    public func queryEncode(to encoder: URLQueryItemEncoder) throws {
        var container = encoder.singleValueContainer()
        guard (calendar?.identifier ?? Calendar.current.identifier) == .gregorian,
            let year = year, let month = month, let day = day else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: encoder.codingPath, debugDescription: "Invalid date components"))
        }
        try container.encode("\(year)-\(month)-\(day)")
    }
}

let iso8601Formatter: Formatter = ISO8601DateFormatter()
extension Date: URLQueryItemEncodable {
    public func queryEncode(to encoder: URLQueryItemEncoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(iso8601Formatter.string(for: self))
    }
}

public class URLQueryItemEncoder {
    public var codingPath: [CodingKey] = []
    private var items: [URLQueryItem] = []
    public init() {}
    
    public func encode(_ value: Encodable) throws -> [URLQueryItem] {
        try value.encode(to: self)
        return items
            .sorted(by: { (item1, item2) in item1.name < item2.name })
    }
}

extension Array where Element == CodingKey {
    func queryItemKeyForKey(_ key: CodingKey) -> String {
        var keysPath = self + [key]
        let firstKey = keysPath.removeFirst()
        let tailCodingKeyString = keysPath.reduce(into: "", {
            $0 += "[\($1.stringValue)]"
        })
        
        return firstKey.stringValue + tailCodingKeyString
    }
    
    var queryItemKey: String {
        guard !isEmpty else { return "" }
        var keysPath = self
        let firstKey = keysPath.removeFirst()
        let tailCodingKeyString = keysPath.reduce(into: "", {
            $0 += "[\($1.stringValue)]"
        })
        
        return firstKey.stringValue + tailCodingKeyString
    }
}

private struct URLQueryItemArrayElementKey: CodingKey {
    var stringValue: String {
        return ""
    }
    
    init() {}
    init?(stringValue: String) {}
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
}

extension URLQueryItemEncoder: Encoder {
    public var userInfo: [CodingUserInfoKey : Any] { return [:] }
    
    public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        return KeyedEncodingContainer(KeyedContainer<Key>(encoder: self, codingPath: codingPath))
    }
    
    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        return UnkeyedContanier(encoder: self, codingPath: codingPath)
    }
    
    public func singleValueContainer() -> SingleValueEncodingContainer {
        return SingleValueContanier(encoder: self, codingPath: codingPath)
    }
    
    fileprivate struct KeyedContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
        let encoder: URLQueryItemEncoder
        let codingPath: [CodingKey]
        
        func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
            encoder.codingPath = codingPath + [key]
            defer { encoder.codingPath.removeAll() }
            if let value = value as? URLQueryItemEncodable {
                try value.queryEncode(to: encoder)
            } else {
                try value.encode(to: encoder)
            }
        }
        
        func encodeNil(forKey key: Key) throws {}
        
        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            return KeyedEncodingContainer(KeyedContainer<NestedKey>(encoder: encoder, codingPath: codingPath + [key]))
        }
        
        func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
            return UnkeyedContanier(encoder: encoder, codingPath: codingPath + [key])
        }
        
        func superEncoder() -> Encoder {
            return encoder
        }
        
        func superEncoder(forKey key: Key) -> Encoder {
            return encoder
        }
    }
    
    fileprivate struct UnkeyedContanier: UnkeyedEncodingContainer {
        var encoder: URLQueryItemEncoder
        
        var codingPath: [CodingKey]
        
        var count: Int = 0
        
        fileprivate init(encoder: URLQueryItemEncoder, codingPath: [CodingKey]) {
            self.encoder = encoder
            self.codingPath = codingPath + [URLQueryItemArrayElementKey()]
        }
        
        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            return KeyedEncodingContainer(KeyedContainer<NestedKey>(encoder: encoder, codingPath: codingPath))
        }
        
        func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
            return self
        }
        
        func superEncoder() -> Encoder {
            return encoder
        }
        
        func encodeNil() throws {}
        
        mutating func encode<T>(_ value: T) throws where T : URLQueryItemEncodable {
            encoder.codingPath = codingPath
            defer { encoder.codingPath.removeAll() }
            try value.queryEncode(to: encoder)
        }
        
        mutating func encode<T>(_ value: T) throws where T : Encodable {
            encoder.codingPath = codingPath
            defer { encoder.codingPath.removeAll() }
            try value.encode(to: encoder)
        }
    }
    
    fileprivate struct SingleValueContanier: SingleValueEncodingContainer {
        let encoder: URLQueryItemEncoder
        var codingPath: [CodingKey]
        var queryItem: URLQueryItem?
        
        fileprivate init(encoder: URLQueryItemEncoder, codingPath: [CodingKey]) {
            self.encoder = encoder
            self.codingPath = codingPath
            self.queryItem = nil
        }
        
        mutating func encodeNil() throws {
            encoder.items.append(URLQueryItem(name: codingPath.queryItemKey, value: nil))
        }
        
        mutating func encode(_ value: Bool) throws {
            let boolValue: String
            switch value {
            case true:
                boolValue = "true"
            case false:
                boolValue = "false"
            }
            encoder.items.append(URLQueryItem(name: codingPath.queryItemKey, value: boolValue))
        }
        
        mutating func encode(_ value: DateComponents) throws {
            let dateComponents = value
            guard (dateComponents.calendar?.identifier ?? Calendar.current.identifier) == .gregorian,
                let year = dateComponents.year, let month = dateComponents.month, let day = dateComponents.day else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Invalid date components"))
            }
            encoder.items.append(URLQueryItem(name: codingPath.queryItemKey, value: "\(year)-\(month)-\(day)"))
        }
        
        mutating func encode<T>(_ value: T) throws where T : Encodable {
            encoder.items.append(URLQueryItem(name: codingPath.queryItemKey, value: "\(value)"))
        }
    }
}

