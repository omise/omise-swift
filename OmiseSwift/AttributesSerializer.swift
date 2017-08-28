import Foundation


public typealias JSONAttributes = [String: Any]


func stitchKeys(_ prefix: String?, key: String) -> String {
    if let p = prefix {
        return "\(p)[\(key)]"
    } else {
        return key
    }
}

func encode(_ attributes: APIJSONQuery) -> [URLQueryItem] {
    return encodeDict(attributes.json, parentKey: nil)
        .sorted(by: { (item1, item2) in item1.name < item2.name })
}

func encodeDict(_ dict: JSONAttributes, parentKey: String?) -> [URLQueryItem] {
    return dict.flatMap(encodePair(parentKey))
}

fileprivate func encodePair(_ parentKey: String?) -> (String, Any?) -> [URLQueryItem] {
    return { (key: String, value: Any?) in
        let nestedKey: String
        if let pkey = parentKey {
            nestedKey = "\(pkey)[\(key)]"
        } else {
            nestedKey = key
        }
        
        if let attributes = value as? JSONAttributes {
            return encodeDict(attributes, parentKey: nestedKey)
        } else if let attributes = value as? [Any] {
            return attributes.map({ URLQueryItem(name: nestedKey + "[]", value: encodeScalar($0)) })
        } else {
            return [URLQueryItem(name: nestedKey, value: encodeScalar(value))]
        }
    }
}

fileprivate func encodeScalar(_ value: Any?) -> String? {
    switch value {
    case let s as String:
        return s
        
    case let d as Date:
        guard let str = DateConverter.convert(fromValue: d) as? String else {
            return nil
        }
        
        return str
        
    case let b as Bool:
        return b ? "true" : "false"
        
    case let n?:
        return "\(n)"
    case nil:
        return nil
    }
}

func deserializeData<TObject: OmiseObject>(_ data: Data) throws -> TObject {
    let jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = .iso8601
    return try jsonDecoder.decode(TObject.self, from: data)
}


