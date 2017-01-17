import Foundation


public typealias JSONAttributes = [String: Any]


public protocol APIDataSerializable {
    var json: JSONAttributes { get }
}


func normalizeAttributes(_ attributes: APIDataSerializable, parentPrefix: String? = nil) -> JSONAttributes {
    var result: JSONAttributes = [:]
    
    for (key, value) in attributes.json {
        if let child = value as? APIDataSerializable {
            for (childKey, childAttributes) in normalizeAttributes(child, parentPrefix: stitchKeys(parentPrefix, key: key)) {
                result[childKey] = childAttributes
            }
        } else {
            result[stitchKeys(parentPrefix, key: key)] = value
        }
    }
    
    return result
}

func stitchKeys(_ prefix: String?, key: String) -> String {
    if let p = prefix {
        return "\(p)[\(key)]"
    } else {
        return key
    }
}


func encode(_ attributes: APIDataSerializable) -> [URLQueryItem] {
    return encodeDict(attributes, parentKey: nil)
        .sorted(by: { (item1, item2) in item1.name < item2.name })
}

fileprivate func encodeDict(_ dict: APIDataSerializable, parentKey: String?) -> [URLQueryItem] {
    return dict.json.flatMap(encodePair(parentKey))
}

fileprivate func encodePair(_ parentKey: String?) -> (String, Any?) -> [URLQueryItem] {
    return { (key: String, value: Any?) in
        let nestedKey: String
        if let pkey = parentKey {
            nestedKey = "\(pkey)[\(key)]"
        } else {
            nestedKey = key
        }
        
        if let attributes = value as? APIDataSerializable {
            return encodeDict(attributes, parentKey: nestedKey)
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


func serialize(_ object: APIDataSerializable) throws -> Data {
    return try JSONSerialization.data(withJSONObject: object.json, options: [])
}

func deserialize<TObject: OmiseObject>(_ data: Data) throws -> TObject {
    let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    guard let object = TObject(JSON: jsonObject) else {
        throw OmiseError.unexpected("expected JSON object at top level.")
    }
    
    return object
}


