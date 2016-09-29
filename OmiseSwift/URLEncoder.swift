import Foundation

open class URLEncoder {
    open class func encode(_ attributes: JSONAttributes) -> [URLQueryItem] {
        return encodeDict(attributes, parentKey: nil)
            .sorted(by: { (item1, item2) in item1.name < item2.name })
    }
    
    fileprivate class func encodeDict(_ dict: JSONAttributes, parentKey: String?) -> [URLQueryItem] {
        return dict.flatMap(encodePair(parentKey))
    }
    
    fileprivate class func encodePair(_ parentKey: String?) -> (String, Any?) -> [URLQueryItem] {
        return { (key: String, value: Any?) in
            let nestedKey: String
            if let pkey = parentKey {
                nestedKey = "\(pkey)[\(key)]"
            } else {
                nestedKey = key
            }
            
            if let attributes = value as? JSONAttributes {
                return encodeDict(attributes, parentKey: nestedKey)
            } else {
                return [URLQueryItem(name: nestedKey, value: encodeScalar(value))]
            }
        }
    }
    
    fileprivate class func encodeScalar(_ value: Any?) -> String? {
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
}
