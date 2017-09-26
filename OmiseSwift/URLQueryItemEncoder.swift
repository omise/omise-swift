import Foundation



let iso8601Formatter = ISO8601DateFormatter()

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
        let keysPath = self + [key] 
        return keysPath.queryItemKey
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


extension URLQueryItemEncoder {
    private func push(_ value: DateComponents, forKey codingPath: [CodingKey]) throws {
        guard (value.calendar?.identifier ?? Calendar.current.identifier) == .gregorian,
            let year = value.year, let month = value.month, let day = value.day else {
                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "Invalid date components"))
        }
        
        items.append(URLQueryItem(name: codingPath.queryItemKey, value: "\(year)-\(month)-\(day)"))
    }
    
    private func push(_ value: String, forKey codingPath: [CodingKey]) throws {
        items.append(URLQueryItem(name: codingPath.queryItemKey, value: value))
    }
    
    private func push(_ value: Date, forKey codingPath: [CodingKey]) throws {
        items.append(URLQueryItem(name: codingPath.queryItemKey, value: iso8601Formatter.string(from: value)))
    }
    
    private func push(_ value: Bool, forKey codingPath: [CodingKey]) throws {
        let boolValue: String
        switch value {
        case true:
            boolValue = "true"
        case false:
            boolValue = "false"
        }
        items.append(URLQueryItem(name: codingPath.queryItemKey, value: boolValue))
    }
    
    private func push(_ value: Int, forKey codingPath: [CodingKey]) throws {
        items.append(URLQueryItem(name: codingPath.queryItemKey, value: "\(value)"))
    }
    
    private func push(_ value: Int8, forKey codingPath: [CodingKey]) throws {
        items.append(URLQueryItem(name: codingPath.queryItemKey, value: "\(value)"))
    }
    
    private func push(_ value: Int16, forKey codingPath: [CodingKey]) throws {
        items.append(URLQueryItem(name: codingPath.queryItemKey, value: "\(value)"))
    }
    
    private func push(_ value: Int32, forKey codingPath: [CodingKey]) throws {
        items.append(URLQueryItem(name: codingPath.queryItemKey, value: "\(value)"))
    }
    
    private func push(_ value: Int64, forKey codingPath: [CodingKey]) throws {
        items.append(URLQueryItem(name: codingPath.queryItemKey, value: "\(value)"))
    }
    
    private func push(_ value: UInt, forKey codingPath: [CodingKey]) throws {
        items.append(URLQueryItem(name: codingPath.queryItemKey, value: "\(value)"))
    }
    
    private func push(_ value: UInt8, forKey codingPath: [CodingKey]) throws {
        items.append(URLQueryItem(name: codingPath.queryItemKey, value: "\(value)"))
    }
    
    private func push(_ value: UInt16, forKey codingPath: [CodingKey]) throws {
        items.append(URLQueryItem(name: codingPath.queryItemKey, value: "\(value)"))
    }
    
    private func push(_ value: UInt32, forKey codingPath: [CodingKey]) throws {
        items.append(URLQueryItem(name: codingPath.queryItemKey, value: "\(value)"))
    }
    
    private func push(_ value: UInt64, forKey codingPath: [CodingKey]) throws {
        items.append(URLQueryItem(name: codingPath.queryItemKey, value: "\(value)"))
    }
    
    private func push(_ value: Double, forKey codingPath: [CodingKey]) throws {
        items.append(URLQueryItem(name: codingPath.queryItemKey, value: "\(value)"))
    }
    
    private func push(_ value: Float, forKey codingPath: [CodingKey]) throws {
        items.append(URLQueryItem(name: codingPath.queryItemKey, value: "\(value)"))
    }
    
    private func push<T: Encodable>(_ value: T, forKey codingPath: [CodingKey]) throws {
        switch value {
        case let value as String:
            try push(value, forKey: codingPath)
            
        case let value as Bool:
            try push(value, forKey: codingPath)
        case let value as Int:
            try push(value, forKey: codingPath)
        case let value as Int8:
            try push(value, forKey: codingPath)
        case let value as Int16:
            try push(value, forKey: codingPath)
        case let value as Int32:
            try push(value, forKey: codingPath)
        case let value as Int64:
            try push(value, forKey: codingPath)
        case let value as UInt:
            try push(value, forKey: codingPath)
        case let value as UInt8:
            try push(value, forKey: codingPath)
        case let value as UInt16:
            try push(value, forKey: codingPath)
        case let value as UInt32:
            try push(value, forKey: codingPath)
        case let value as UInt64:
            try push(value, forKey: codingPath)
            
        case let value as Double:
            try push(value, forKey: codingPath)
        case let value as Float:
            try push(value, forKey: codingPath)
            
        case let value as Date:
            try push(value, forKey: codingPath)
        case let value as DateComponents:
            try push(value, forKey: codingPath)
            
        default:
            try value.encode(to: self)
        }
    }
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
    
}

extension URLQueryItemEncoder {
    fileprivate struct KeyedContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
        let encoder: URLQueryItemEncoder
        let codingPath: [CodingKey]
        
        func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
            encoder.codingPath = codingPath + [key]
            defer { encoder.codingPath.removeAll() }
            try encoder.push(value, forKey: encoder.codingPath)
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
        
        public func encode(_ value: Bool) throws {
            try encoder.push(value, forKey: codingPath)
        }
        
        public func encode(_ value: Int) throws {
            try encoder.push(value, forKey: codingPath)
        }
        
        public func encode(_ value: Int8) throws {
            try encoder.push(value, forKey: codingPath)
        }
        
        public func encode(_ value: Int16) throws {
            try encoder.push(value, forKey: codingPath)
        }
        
        public func encode(_ value: Int32) throws {
            try encoder.push(value, forKey: codingPath)
        }
        
        public func encode(_ value: Int64) throws {
            try encoder.push(value, forKey: codingPath)
        }
        
        public func encode(_ value: UInt) throws {
            try encoder.push(value, forKey: codingPath)
        }
        
        public func encode(_ value: UInt8) throws {
            try encoder.push(value, forKey: codingPath)
        }
        
        public func encode(_ value: UInt16) throws {
            try encoder.push(value, forKey: codingPath)
        }
        
        public func encode(_ value: UInt32) throws {
            try encoder.push(value, forKey: codingPath)
        }
        
        public func encode(_ value: UInt64) throws {
            try encoder.push(value, forKey: codingPath)
        }
        
        public func encode(_ value: String) throws {
            try encoder.push(value, forKey: codingPath)
        }
        
        public func encode(_ value: Float) throws {
            try encoder.push(value, forKey: codingPath)
        }
        
        public func encode(_ value: Double) throws {
            try encoder.push(value, forKey: codingPath)
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
            try encoder.push(value, forKey: codingPath)
        }
    }
}




